/* Chrome com zoom nativo e perfil temporário. Rodar com o app local aberto:
   node inst/app/tests/test_layout_transversal_abas.cjs http://127.0.0.1:4634 */
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');
const destination = path.resolve(__dirname, '../../../outputs/layout-transversal-abas');
const url = process.argv[2] || 'http://127.0.0.1:4634';
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
  page.on('pageerror', error => { errors.push(error.stack || error.message); console.error(error.stack || error.message); });
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
    await open('Planejando sua Pesquisa', 'Transversal comparativo');
    const prefix = '#obs_transversal_comparativo-';
    const studio = page.locator('.obs-estudio-transversal:visible');
    const main = page.locator(prefix+'etapas');
    const defs = page.locator(prefix+'definicoes_transversal');
    assert.deepEqual((await main.locator(':scope > li > a').allTextContents()).map(s=>s.trim()),
      ['Tipo','Definições','Desenho','Tabelas de coleta','Resumo']);
    await studio.locator('.obs-planejamento-grade:visible').waitFor();
    await capture('tipo');
    await main.locator('a').filter({hasText:'Definições'}).click();
    assert.deepEqual((await defs.locator(':scope > li > a').allTextContents()).map(s=>s.trim()),
      ['Pergunta, grupos e respostas','Protocolo e amostragem','Metodologia','Modelo e cuidados']);
    for(const [name,ready,shot] of [
      ['Pergunta, grupos e respostas',prefix+'var_nome_2','pergunta'],
      ['Protocolo e amostragem',prefix+'uas_grupo_5','protocolo'],
      ['Metodologia',prefix+'texto_metodologia_artigo p','metodologia'],
      ['Modelo e cuidados',prefix+'card_modelo_estatistico p','modelo']
    ]) {
      console.log(percent+'% · '+name);
      await defs.getByRole('tab',{name}).click();
      await page.locator(ready).first().waitFor({state:'visible'});
      const measure = await studio.evaluate(root=>{
        const text = Array.from(root.querySelectorAll('.obs-metodologia-duas-colunas')).find(el=>el.getClientRects().length);
        const grid = Array.from(root.querySelectorAll('.obs-planejamento-grade')).find(el=>el.getClientRects().length);
        const region = grid || text;
        const columns = grid ? Array.from(grid.children).map(el=>el.getBoundingClientRect().toJSON()) :
          [...new Set(Array.from(text.querySelectorAll('p')).map(el=>Math.round(el.getBoundingClientRect().left)))];
        const controls = Array.from(region.querySelectorAll('input:not([type="hidden"]), textarea, select'))
          .filter(el=>el.getClientRects().length).map(el=>el.getBoundingClientRect().toJSON());
        const internalScroll = Array.from(region.querySelectorAll('.obs-card-interno, .obs-coluna-bloco'))
          .filter(el=>['auto','scroll'].includes(getComputedStyle(el).overflowY) && el.scrollHeight>el.clientHeight+2).length;
        return {columns,controls,internalScroll,columnCount:text ? getComputedStyle(text).columnCount : null,
          bottom:region.getBoundingClientRect().bottom,viewport:{width:innerWidth,height:innerHeight},
          overflow:document.documentElement.scrollWidth-innerWidth};
      });
      assert.equal(measure.columns.length,2,name+': duas colunas');
      if(measure.columnCount) assert.equal(measure.columnCount,'2');
      else assert.ok(Math.abs(measure.columns[0].top-measure.columns[1].top)<1);
      assert.equal(measure.internalScroll,0);
      assert.ok(measure.overflow<=1,'Página sem rolagem horizontal');
      assert.ok(measure.controls.every(c=>c.right<=measure.viewport.width+1));
      if(zoom===.75) assert.ok(measure.bottom<=measure.viewport.height+80,name+': preenchimento usual próximo à área visível');
      report.screens.push({screen:name,...measure});
      await capture(shot);
    }
    console.log(percent+'% · conferir campos e atualizações');
    await defs.getByRole('tab',{name:'Pergunta, grupos e respostas'}).click();
    const question = {pergunta:'A salinidade difere entre os habitats?',fator_nome:'habitat',fator_niveis:'Manguezal, Praia',
      var_nome_1:'salinidade',var_unidade_1:'PSU'};
    for(const [id,value] of Object.entries(question)) await page.locator(prefix+id).fill(value);
    await defs.getByRole('tab',{name:'Protocolo e amostragem'}).click();
    const protocol={local_periodo:'Estuário do Caeté, setembro de 2027',criterios_coleta:'Estações elegíveis em cada habitat.',
      procedimentos_coleta:'Coletar água na mesma fase de maré.',unidade_item:'garrafa de água',
      espacamento_minimo_m:'200',justificativa_espacamento:'Distância definida no estudo-piloto.'};
    for(const [id,value] of Object.entries(protocol)) await page.locator(prefix+id).fill(value);
    // A identificação do item atualiza a tabela dinâmica antes de preencher seus números.
    await page.waitForFunction(()=>{
      const table=document.querySelector('#obs_transversal_comparativo-ui_amostra_categorias');
      return table.textContent.includes('garrafa de água') && table.querySelectorAll('tbody tr').length===2;
    });
    const sample={uas_grupo_1:'3',uas_grupo_2:'4',pool_grupo_1:'2',pool_grupo_2:'1'};
    for(const [id,value] of Object.entries(sample)) {
      await page.locator(prefix+id).fill(value);
      await page.locator(prefix+id).press('Tab');
    }
    await page.locator(prefix+'registrar_coordenadas').check();
    await page.locator(prefix+'precisao_gps_m').waitFor({state:'visible'});
    await defs.getByRole('tab',{name:'Metodologia'}).click();
    await page.waitForFunction(()=>{
      const text=document.querySelector('#obs_transversal_comparativo-texto_metodologia_artigo').textContent;
      return text.includes('7 unidades amostrais') && text.includes('Estações elegíveis em cada habitat.');
    });
    const method=await page.locator(prefix+'texto_metodologia_artigo').innerText();
    for(const value of [protocol.local_periodo,protocol.procedimentos_coleta,protocol.justificativa_espacamento]) assert.ok(method.includes(value));
    await main.locator('a').filter({hasText:'Desenho'}).click();
    await page.locator(prefix+'esquema_transversal img[src]').waitFor({state:'visible'});
    await main.locator('a').filter({hasText:'Tabelas de coleta'}).click();
    await page.waitForFunction(()=>document.querySelector('#obs_transversal_comparativo-badge_total_uas').textContent.includes('7 UAs'));
    await page.locator(prefix+'tabela_tidy_coleta table:visible').first().waitFor();
    await page.waitForFunction(()=>{
      const root=document.querySelector('#obs_transversal_comparativo-tabela_tidy_coleta');
      return root.querySelectorAll('.dataTables_scrollBody tbody tr').length===7 &&
        root.textContent.includes('Manguezal') && root.textContent.includes('Mostrando 1 a 7 de 7');
    });
    const table = await page.locator(prefix+'tabela_tidy_coleta').innerText();
    for(const col of ['habitat','salinidade','latitude_wgs84']) assert.ok(table.includes(col));
    assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1));
    await capture('tabelas');
    await main.locator('a').filter({hasText:'Resumo'}).click();
    await page.waitForFunction(()=>document.querySelector('#obs_transversal_comparativo-resumo_transversal_intro').textContent.includes('7 UAs'));
    assert.ok((await page.locator(prefix+'resumo_transversal_intro').innerText()).includes('10 unidades físicas'));
    await capture('resumo');
    await main.locator('a').filter({hasText:'Definições'}).click();
    await defs.getByRole('tab',{name:'Pergunta, grupos e respostas'}).click();
    for(const [id,value] of Object.entries(question)) assert.equal(await page.locator(prefix+id).inputValue(),value);
    await page.locator(prefix+'usar_fator2').check();
    await page.locator(prefix+'fator2_nome').fill('epoca');
    await page.locator(prefix+'fator2_niveis').fill('Seca, Chuvosa');
    await defs.getByRole('tab',{name:'Protocolo e amostragem'}).click();
    await page.locator(prefix+'uas_combinacao_4').waitFor({state:'visible'});
    for(const [id,value] of Object.entries(protocol)) assert.equal(await page.locator(prefix+id).inputValue(),value);
    assert.ok(await page.locator(prefix+'registrar_coordenadas').isChecked());
    for(let i=1;i<=4;i++) await page.locator(prefix+'uas_combinacao_'+i).fill(String(i+1));
    await main.locator('a').filter({hasText:'Tabelas de coleta'}).click();
    await page.waitForFunction(()=>document.querySelector('#obs_transversal_comparativo-badge_total_uas').textContent.includes('14 UAs'));
    await page.waitForFunction(()=>{
      const root=document.querySelector('#obs_transversal_comparativo-tabela_tidy_coleta');
      return root.textContent.includes('epoca') && root.textContent.includes('Chuvosa') &&
        root.textContent.includes('Mostrando 1 a 10 de 14');
    });
    await main.locator('a').filter({hasText:'Definições'}).click();
    await defs.getByRole('tab',{name:'Protocolo e amostragem'}).click();
    for(let i=1;i<=4;i++) assert.equal(await page.locator(prefix+'uas_combinacao_'+i).inputValue(),String(i+1));
    assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1));
    await capture('protocolo-dois-fatores');
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
