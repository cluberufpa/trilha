/* Chrome com zoom nativo e perfil temporário. Rodar com o app local aberto:
   node inst/app/tests/test_layout_planejamento.cjs http://127.0.0.1:4630 */
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');
const destination = path.resolve(__dirname, '../../../outputs/layout-impacto');
const url = process.argv[2] || 'http://127.0.0.1:4630';
fs.mkdirSync(destination, { recursive: true });

async function checkZoom(zoom) {
  const percent = Math.round(zoom * 100);
  const profile = fs.mkdtempSync(path.join(destination, 'chrome-' + percent + '-'));
  fs.mkdirSync(path.join(profile, 'Default'));
  fs.writeFileSync(path.join(profile, 'Default', 'Preferences'), JSON.stringify({
    partition: { default_zoom_level: { x: Math.log(zoom) / Math.log(1.2) } }
  }));
  const browser = await chromium.launchPersistentContext(profile, {
    channel: 'chrome', headless: true, viewport: null, args: ['--window-size=1462,998']
  });
  const page = browser.pages()[0];
  page.setDefaultTimeout(60000);
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  const report = { zoom: percent, screens: [] };
  try {
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 120000 });
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
    async function geometry(screen) {
      const result = await page.evaluate(() => {
        const pane = Array.from(document.querySelectorAll('body > .container-fluid > .tab-content > .tab-pane'))
          .find(el => el.classList.contains('active'));
        const studio = pane?.querySelector('.obs-estudio, .mon-estudio');
        const card = studio?.querySelector('.bslib-card');
        const nav = card?.querySelector('.card-header');
        const toolbar = document.querySelector('.trilha-toolbar').getBoundingClientRect();
        const links = studio && Array.from(studio.querySelectorAll('.nav-link'))
          .filter(el => el.getClientRects().length).map(el => ({
            text: el.textContent.trim(), right: el.getBoundingClientRect().right
          }));
        return {
          overflow: document.documentElement.scrollWidth - innerWidth,
          topGap: nav && nav.getBoundingClientRect().top - toolbar.bottom,
          links, width: innerWidth
        };
      });
      assert.ok(result.overflow <= 1, screen + ': sem rolagem horizontal da página');
      if (result.topGap != null) assert.ok(result.topGap >= 0 && result.topGap <= 24, screen + ': abas próximas à navegação');
      if (result.links) assert.ok(result.links.every(link => link.right <= result.width), screen + ': abas acessíveis');
      report.screens.push({ screen, ...result });
    }

    await open('Planejando sua Pesquisa', 'Estudos de impacto');
    const variant = page.locator('#obs_impacto-tipo_impacto');
    await page.locator('#obs_impacto-analises_previstas input[value="anova_dois_fatores"]').waitFor({ state: 'visible' });
    assert.ok(await page.locator('#obs_impacto-analises_previstas input[value="anova_dois_fatores"]').isChecked());
    await page.locator('#obs_impacto-variante_esquema svg').waitFor({ state: 'visible' });
    const columns = await page.locator('.obs-estudio:visible .obs-tipo-colunas').evaluate(el => {
      const [left, right] = Array.from(el.children).map(c => c.getBoundingClientRect());
      return { left: left.toJSON(), right: right.toJSON() };
    });
    assert.ok(Math.abs(columns.left.top - columns.right.top) < 1);
    assert.ok(columns.left.right < columns.right.left);
    await geometry('Impacto · Tipo');
    await capture('impacto-tipo');

    for (const [value, analysis] of [['ci', 'teste_t_independente'], ['ba', 'teste_t_pareado'], ['baci', 'anova_dois_fatores']]) {
      console.log(percent + '% · variante ' + value);
      await variant.selectOption(value);
      await page.locator('#obs_impacto-analises_previstas input[value="' + analysis + '"]').waitFor({ state: 'visible' });
      assert.ok(await page.locator('#obs_impacto-analises_previstas input[value="' + analysis + '"]').isChecked());
    }
    const studio = page.locator('.obs-estudio:visible');
    console.log(percent + '% · conferir definições');
    await studio.getByRole('tab', { name: 'Definições' }).click();
    await page.locator('#obs_impacto-n_uas').fill('4');
    await page.locator('#obs_impacto-n_referencia').waitFor({ state: 'visible' });
    await studio.getByRole('tab', { name: 'Protocolo e calendário' }).click();
    await page.locator('#obs_impacto-impacto_antes').waitFor({ state: 'visible' });
    await geometry('Impacto · Definições e subabas');
    await capture('impacto-definicoes');
    await studio.getByRole('tab', { name: 'Tabelas de coleta' }).click();
    console.log(percent + '% · conferir ficha');
    await studio.getByRole('tab', { name: 'Campanhas' }).click();
    await page.locator('#obs_impacto-campanhas_impacto table:visible').first().waitFor({ state: 'visible' });
    await geometry('Impacto · Ficha e subabas');
    await capture('impacto-ficha');

    for (const module of ['Transversal comparativo', 'Longitudinal Comparativo', 'Estudo de gradiente', 'Monitoramento']) {
      await open('Planejando sua Pesquisa', module);
      const panel = page.locator('.obs-estudio:visible, .mon-estudio:visible');
      await panel.getByRole('tab', { name: 'Tipo' }).waitFor({ state: 'visible' });
      await geometry(module + ' · Tipo');
      await panel.getByRole('tab', { name: 'Definições' }).click();
      await geometry(module + ' · Definições');
    }
    await open('Planejando sua Pesquisa', 'Estudos de impacto');
    await studio.getByRole('tab', { name: 'Definições' }).click();
    await studio.getByRole('tab', { name: 'Pergunta, sítios e respostas' }).click();
    assert.equal(await page.locator('#obs_impacto-n_uas').inputValue(), '4');
    await studio.getByRole('tab', { name: 'Tipo' }).click();
    assert.equal(await variant.inputValue(), 'baci');
    await capture('impacto-tipo');
    assert.deepEqual(errors, []);
    console.log('OK: layout, variantes, estado e subabas em ' + percent + '%');
    return report;
  } catch (error) {
    await page.screenshot({ path: path.join(destination, 'falha-' + percent + '.png') }).catch(() => {});
    throw error;
  } finally { await browser.close(); }
}

(async () => {
  const reports = [];
  for (const zoom of [1, .75]) reports.push(await checkZoom(zoom));
  fs.writeFileSync(path.join(destination, 'medidas.json'), JSON.stringify(reports, null, 2));
})().catch(error => { console.error(error); process.exitCode = 1; });
