/* Chrome com zoom nativo e perfil temporário. Rodar com o app local aberto:
   node inst/app/tests/test_layout_impacto_abas.cjs http://127.0.0.1:4632 */
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');
const destination = path.resolve(__dirname, '../../../outputs/layout-impacto-abas');
const url = process.argv[2] || 'http://127.0.0.1:4632';
fs.mkdirSync(destination, { recursive: true });

async function checkZoom(zoom) {
  const percent = Math.round(zoom * 100);
  const profile = fs.mkdtempSync(path.join(destination, 'chrome-' + percent + '-'));
  fs.mkdirSync(path.join(profile, 'Default'));
  fs.writeFileSync(path.join(profile, 'Default', 'Preferences'), JSON.stringify({
    partition: { default_zoom_level: { x: Math.log(zoom) / Math.log(1.2) } }
  }));
  const browser = await chromium.launchPersistentContext(profile, {
    channel: 'chrome', headless: true, viewport: null, args: ['--window-size=1462,898']
  });
  const page = browser.pages()[0];
  page.setDefaultTimeout(60000);
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  const report = { zoom: percent, screens: [] };
  try {
    // O carregamento inicial dos pacotes do R pode levar alguns segundos.
    const deadline = Date.now() + 60000;
    for (;;) {
      try {
        await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 120000 });
        break;
      } catch (error) {
        if (!error.message.includes('ERR_CONNECTION_REFUSED') || Date.now() >= deadline) throw error;
        await page.waitForTimeout(500);
      }
    }
    await page.locator('#main_navbar.shiny-bound-input').waitFor();
    await page.evaluate(() => document.fonts.ready);
    assert.ok(Math.abs(await page.evaluate(() => devicePixelRatio) - zoom) < .001);
    const session = await browser.newCDPSession(page);
    async function open(menu, module) {
      console.log(percent + '% · abrir ' + module);
      await page.locator('#main_navbar > li.dropdown > a').filter({ hasText: menu }).click();
      await page.locator('.trilha-flyout-item').filter({ hasText: module }).click();
    }
    async function capture(name) {
      const size = await page.evaluate(() => ({
        width: Math.round(innerWidth * devicePixelRatio), height: Math.round(innerHeight * devicePixelRatio)
      }));
      const shot = await session.send('Page.captureScreenshot', {
        format: 'png', fromSurface: true, captureBeyondViewport: false,
        clip: { x: 0, y: 0, ...size, scale: 1 }
      });
      fs.writeFileSync(path.join(destination, name + '-' + percent + '.png'), Buffer.from(shot.data, 'base64'));
    }
    await open('Planejando sua Pesquisa', 'Estudos de impacto');
    const studio = page.locator('.obs-estudio:visible');
    const main = page.locator('#obs_impacto-etapas');
    const defs = page.locator('#obs_impacto-definicoes_impacto');
    assert.deepEqual((await main.locator(':scope > li > a').allTextContents()).map(s=>s.trim()),
      ['Tipo', 'Definições', 'Desenho', 'Tabelas de coleta', 'Resumo']);
    await studio.getByRole('tab', {name:'Definições'}).click();
    assert.deepEqual((await defs.locator(':scope > li > a').allTextContents()).map(s=>s.trim()),
      ['Pergunta, sítios e respostas','Protocolo e calendário','Metodologia','Modelo e cuidados']);
    for (const [name, ready, shot] of [
      ['Pergunta, sítios e respostas','#obs_impacto-var_nome_2','pergunta'],
      ['Protocolo e calendário','#obs_impacto-impacto_antes','protocolo'],
      ['Metodologia','#obs_impacto-texto_metodologia_artigo p','metodologia'],
      ['Modelo e cuidados','#obs_impacto-card_modelo_estatistico pre','modelo']
    ]) {
      console.log(percent + '% · ' + name);
      await defs.getByRole('tab', {name}).click();
      await page.locator(ready).first().waitFor({state:'visible'});
      await page.evaluate(() => document.fonts.ready);
      const measure = await studio.locator('.obs-planejamento-grade:visible').evaluate(grid => {
        const columns = Array.from(grid.children).map(el => el.getBoundingClientRect().toJSON());
        const controls = Array.from(grid.querySelectorAll('input:not([type="hidden"]), textarea, select'))
          .filter(el=>el.getClientRects().length).map(el=>el.getBoundingClientRect().toJSON());
        const internalScroll = Array.from(grid.querySelectorAll('.obs-card-interno, .obs-impacto-coluna'))
          .filter(el=>['scroll','auto'].includes(getComputedStyle(el).overflowY) && el.scrollHeight > el.clientHeight+2).length;
        return {columns, controls, internalScroll, viewport:{width:innerWidth,height:innerHeight},
          pageOverflow:document.documentElement.scrollWidth-innerWidth};
      });
      assert.equal(measure.columns.length,2);
      assert.ok(Math.abs(measure.columns[0].top-measure.columns[1].top)<1);
      assert.ok(measure.columns[0].right < measure.columns[1].left);
      assert.equal(measure.internalScroll,0);
      assert.ok(measure.pageOverflow<=1);
      assert.ok(measure.controls.every(r=>r.right <= measure.viewport.width+1));
      if(zoom===.75) assert.ok(Math.max(...measure.columns.map(r=>r.bottom)) <= measure.viewport.height+80,
        name+': conteúdo usual próximo à área visível');
      report.screens.push({screen:name,...measure});
      await capture(shot);
    }
    console.log(percent + '% · preencher campos e conferir atualizações');
    const values = {
      pergunta:'A clorofila mudou após a intervenção?',
      n_uas:'4', n_referencia:'2', coluna_unidade:'ponto', var_nome_1:'clorofila', var_unidade_1:'mg/m3'
    };
    await defs.getByRole('tab',{name:'Pergunta, sítios e respostas'}).click();
    // Os nomes das colunas ficam recolhidos; abrir antes de preencher.
    await page.locator('#obs_impacto-coluna_unidade').locator('xpath=ancestor::details').locator('summary').click();
    for(const [id,value] of Object.entries(values)) await page.locator('#obs_impacto-'+id).fill(value);
    await defs.getByRole('tab',{name:'Protocolo e calendário'}).click();
    const protocol = {impacto_subamostras:'2',impacto_antes:'2',impacto_depois:'3',
      impacto_criterios:'Referências fora da pluma.',impacto_protocolo:'Duas amostras de água por visita.',
      impacto_covariaveis:'Chuva e salinidade.'};
    for(const [id,value] of Object.entries(protocol)) await page.locator('#obs_impacto-'+id).fill(value);
    await defs.getByRole('tab',{name:'Metodologia'}).click();
    await page.locator('#obs_impacto-impacto_registro').fill('Plano revisado antes da coleta.');
    const method = page.locator('#obs_impacto-texto_metodologia_artigo');
    await page.waitForFunction(()=>{
      const text=document.querySelector('#obs_impacto-texto_metodologia_artigo').textContent;
      return text.includes('5 campanhas') && text.includes('2 subamostras') && text.includes('Plano revisado antes da coleta.');
    });
    for(const text of ['6 sítios','Referências fora da pluma.','Chuva e salinidade.']) assert.ok((await method.innerText()).includes(text));
    await defs.getByRole('tab',{name:'Modelo e cuidados'}).click();
    await page.waitForFunction(()=>document.querySelector('#obs_impacto-card_modelo_estatistico').textContent.includes('| ponto'));
    await main.locator('a').filter({hasText:'Desenho'}).click();
    await page.locator('#obs_impacto-desenho_observacional img[src]').waitFor({state:'visible'});
    console.log(percent + '% · desenho e tabelas');
    await studio.getByRole('tab',{name:'Tabelas de coleta'}).click();
    await page.waitForFunction(()=>document.querySelector('#obs_impacto-badge_total_uas').textContent.includes('60 linhas'));
    await page.locator('#obs_impacto-tabela_tidy_coleta table:visible').first().waitFor({state:'visible'});
    const headers=await page.locator('#obs_impacto-tabela_tidy_coleta').innerText();
    assert.ok(headers.includes('ponto') && headers.includes('clorofila'));
    await capture('tabelas');
    await main.locator('a').filter({hasText:'Resumo'}).click();
    await page.locator('#obs_impacto-resumo_observacional_tabela table').waitFor({state:'visible'});
    assert.ok((await page.locator('#obs_impacto-resumo_observacional_tabela').innerText()).includes('60'));
    await studio.getByRole('tab',{name:'Definições'}).click();
    await defs.getByRole('tab',{name:'Pergunta, sítios e respostas'}).click();
    for(const [id,value] of Object.entries(values)) assert.equal(await page.locator('#obs_impacto-'+id).inputValue(),value);
    await defs.getByRole('tab',{name:'Protocolo e calendário'}).click();
    for(const [id,value] of Object.entries(protocol)) assert.equal(await page.locator('#obs_impacto-'+id).inputValue(),value);
    await defs.getByRole('tab',{name:'Metodologia'}).click();
    assert.equal(await page.locator('#obs_impacto-impacto_registro').inputValue(),'Plano revisado antes da coleta.');
    assert.deepEqual(errors, []);
    console.log('OK: quatro subabas, duas colunas, atualizacoes e valores preservados em ' + percent + '%');
    return report;
  } catch (error) {
    await page.screenshot({ path: path.join(destination, 'falha-' + percent + '.png') }).catch(() => {});
    throw error;
  } finally { await browser.close(); }
}

(async () => {
  const reports = [];
  for (const zoom of [.75, 1]) reports.push(await checkZoom(zoom));
  fs.writeFileSync(path.join(destination, 'medidas.json'), JSON.stringify(reports, null, 2));
})().catch(error => { console.error(error); process.exitCode = 1; });
