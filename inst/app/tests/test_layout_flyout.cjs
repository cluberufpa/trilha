/* Teste de navegação no app real, em um navegador de teste separado.
   Requer Playwright já instalado (NODE_PATH) e app local iniciado.
   node inst/app/tests/test_layout_flyout.cjs http://127.0.0.1:4623 */
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const http = require('node:http');
const { chromium } = require('playwright');
const { trilhaFlyoutBounds } = require('../www/layout-sidebar.js');
const destination = path.resolve(__dirname, '../../../outputs/sidebar-flyout');
fs.mkdirSync(destination, { recursive: true });
const url = process.argv[2] || 'http://127.0.0.1:4623';
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));
async function waitApp() {
  for (let attempt = 0; attempt < 6; attempt++) {
    const ready = await new Promise(resolve => {
      const req = http.get(url, response => { response.resume(); resolve(response.statusCode === 200); });
      req.on('error', () => resolve(false));
      req.setTimeout(30000, () => req.destroy());
    });
    if (ready) return;
    await delay(500);
  }
  throw new Error('O app local não respondeu.');
}
async function main() {
  for (const [rail, y, w, h, height] of [[356,150,1440,900,600],[356,800,1440,900,760],[192,600,480,640,800],[128,-20,320,480,700]]) {
    const bounds = trilhaFlyoutBounds(rail, y, w, h, height);
    assert.ok(bounds.left >= rail);
    assert.ok(bounds.left + bounds.width <= w - 8);
    assert.ok(bounds.top >= 8);
    assert.ok(bounds.top + Math.min(height, bounds.maxHeight) <= h - 8);
  }
  console.log("Aguardando o app local...");
  await waitApp();
  console.log("App respondeu; iniciando a sessão de testes.");
  const browser = await chromium.launch({ channel: 'chrome', headless: true });
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  page.setDefaultTimeout(30000);
  try {
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
    await page.locator('#main_navbar.shiny-bound-input').waitFor();
    console.log("Shiny conectado; verificando navegação.");
    const panel = page.locator('#trilha-flyout');
    const planning = page.locator('#main_navbar > li.dropdown > a').filter({ hasText: 'Planejando sua Pesquisa' });
    const prepare = page.locator('#main_navbar > li.dropdown > a').filter({ hasText: 'Preparar Dados' });
    const buttons = page.locator('.trilha-flyout-item');
    const positions = () => page.locator('#main_navbar > li.dropdown > a').evaluateAll(elements => elements.map(el => el.getBoundingClientRect().top));
    const labelRect = await planning.locator('.trilha-menu-label').boundingBox();
    assert.ok(labelRect.width >= 200, 'Os nomes principais têm uma coluna legível no desktop.');
    const before = await positions();
    await planning.click();
    await panel.waitFor({ state: 'visible' });
    assert.deepEqual(await positions(), before, 'Abrir não desloca os menus principais.');
    assert.equal(await page.locator('#main_navbar > .trilha-open').count(), 1);
    assert.equal(await page.locator('.trilha-flyout').count(), 1);
    await page.locator('.trilha-flyout-search').fill('transversal');
    assert.equal(await buttons.filter({ visible: true }).count(), 1);
    await page.locator('.trilha-flyout-search').fill('zzzzzz');
    assert.equal(await buttons.filter({ visible: true }).count(), 0);
    assert.ok(await page.locator('.trilha-flyout-empty').isVisible());
    await page.locator('.trilha-flyout-search').fill('transversal');
    await buttons.filter({ hasText: 'Transversal comparativo' }).click();
    await panel.waitFor({ state: 'hidden' });
    await page.locator('#obs_transversal_comparativo-pergunta').waitFor({ state: 'visible' });
    await page.locator('#obs_transversal_comparativo-uas_grupo_1').waitFor({ state: 'visible' });
    const question = page.locator('#obs_transversal_comparativo-pergunta');
    const units = page.locator('#obs_transversal_comparativo-uas_grupo_1');
    await question.fill('Como os lipídios variam entre espécies?');
    await units.fill('7');
    await page.waitForTimeout(500);
    await question.evaluate(el => { window.trilhaTestField = el; });
    const filledPositions = await positions();
    await planning.click();
    assert.deepEqual(await positions(), filledPositions);
    assert.equal(await panel.locator('[aria-current="page"]').innerText(), 'Transversal comparativo');
    assert.ok((await page.locator('#trilha-caminho').innerText()).includes('Transversal comparativo'));
    await prepare.click();
    assert.equal(await page.locator('#main_navbar > .trilha-open').count(), 1);
    assert.equal(await page.locator('#trilha-flyout-title').innerText(), 'Preparar Dados');
    await prepare.click();
    await panel.waitFor({ state: 'hidden' });
    await planning.click();
    await page.locator('.trilha-flyout-search').press('Escape');
    await panel.waitFor({ state: 'hidden' });
    assert.ok(await planning.evaluate(el => document.activeElement === el));
    await planning.press('Enter');
    assert.ok(await page.locator('.trilha-flyout-search').evaluate(el => document.activeElement === el));
    await page.locator('.trilha-flyout-search').press('ArrowDown');
    assert.ok(await buttons.first().evaluate(el => document.activeElement === el));
    await buttons.first().press('End');
    assert.ok(await buttons.last().evaluate(el => document.activeElement === el));
    await buttons.last().press('Home');
    assert.ok(await buttons.first().evaluate(el => document.activeElement === el));
    await buttons.first().press('Escape');
    assert.ok(await planning.evaluate(el => document.activeElement === el));
    await planning.click();
    await page.locator('.trilha-flyout-close').click();
    await panel.waitFor({ state: 'hidden' });
    assert.ok(await planning.evaluate(el => document.activeElement === el));
    await planning.click();
    await page.locator('#trilha-caminho').click();
    await panel.waitFor({ state: 'hidden' });
    await planning.click();
    await buttons.filter({ hasText: 'Transversal comparativo' }).click();
    await panel.waitFor({ state: 'hidden' });
    assert.equal(await question.inputValue(), 'Como os lipídios variam entre espécies?');
    assert.equal(await units.inputValue(), '7');
    assert.ok(await question.evaluate(el => el === window.trilhaTestField), 'O input não foi recriado.');
    console.log('OK: clique, busca, ativo, fechamento, teclado, foco e valores preservados.');
    await planning.click();
    await page.screenshot({ path: path.join(destination, 'flyout-desktop.png') });
    for (const width of [900, 600, 480, 320]) {
      await page.setViewportSize({ width, height: 640 });
      await page.waitForTimeout(100);
      const rect = await panel.boundingBox();
      const rail = await page.locator('.trilha-sidebar').boundingBox();
      const mainMenuRect = await planning.boundingBox();
      assert.ok(mainMenuRect.x >= rail.x && mainMenuRect.x + mainMenuRect.width <= rail.x + rail.width + 1,
        'O menu principal continua dentro da barra em telas estreitas.');
      assert.ok(rect.x >= rail.x + rail.width, 'O painel não cobre a barra.');
      assert.ok(rect.x + rect.width <= width - 7);
      assert.ok(rect.y >= 7 && rect.y + rect.height <= 633, 'O painel fica dentro da janela.');
    }
    const headerBefore = await panel.locator('.trilha-flyout-header').boundingBox();
    await panel.locator('.trilha-flyout-list').evaluate(el => { el.scrollTop = el.scrollHeight; });
    const headerAfter = await panel.locator('.trilha-flyout-header').boundingBox();
    assert.equal(headerAfter.y, headerBefore.y, 'A lista rola sem mover o cabeçalho.');
    assert.ok(await panel.locator('.trilha-flyout-list').evaluate(el => el.scrollTop > 0));
    await panel.locator('.trilha-flyout-list').evaluate(el => { el.scrollTop = 0; });
    await page.screenshot({ path: path.join(destination, 'flyout-estreito.png') });
    await page.setViewportSize({ width: 1440, height: 720 });
    await page.locator('.trilha-flyout-close').click();
    const communicate = page.locator('#main_navbar > li.dropdown > a').filter({ hasText: 'Comunicação de Resultados' });
    await communicate.click();
    const lowRect = await panel.boundingBox();
    assert.ok(lowRect.y + lowRect.height <= 713);
    assert.ok(await page.locator('.trilha-flyout-search').isHidden(), 'Menu curto dispensa busca.');
    await page.locator('.trilha-flyout-close').click();
    assert.deepEqual(errors, [], 'Sem novos erros JavaScript.');
    console.log('OK: posição no rodapé, larguras de 320 a 1440 px e ausência de erros JavaScript.');
  } catch (error) {
    await page.screenshot({ path: path.join(destination, 'falha.png') }).catch(() => {});
    throw error;
  } finally { await browser.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });