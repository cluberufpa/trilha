/* Validação visual no Chrome instalado, com zoom nativo em perfil temporário.
   Não altera preferências do navegador pessoal nem emula zoom por CSS.
   Requer o mesmo Playwright de desenvolvimento do teste de flyout. */
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');
const destination = path.resolve(__dirname, '../../../outputs/sidebar-preparacao-exploracao');
const url = process.argv[2] || 'http://127.0.0.1:4625';
fs.mkdirSync(destination, { recursive: true });

function contrast(foreground, background) {
  const luminance = color => {
    const rgb = color.match(/[\d.]+/g).slice(0, 3).map(Number).map(c => {
      const s = c / 255; return s <= .04045 ? s / 12.92 : ((s + .055) / 1.055) ** 2.4;
    });
    return rgb[0] * .2126 + rgb[1] * .7152 + rgb[2] * .0722;
  };
  const a = luminance(foreground), b = luminance(background);
  return (Math.max(a, b) + .05) / (Math.min(a, b) + .05);
}

async function checkZoom(zoom) {
  const percent = Math.round(zoom * 100);
  const profile = fs.mkdtempSync(path.join(destination, 'chrome-' + percent + '-'));
  fs.mkdirSync(path.join(profile, 'Default'));
  // A partição padrão do Chrome usa a chave x; o nível é logarítmico.
  fs.writeFileSync(path.join(profile, 'Default', 'Preferences'), JSON.stringify({
    partition: { default_zoom_level: { x: Math.log(zoom) / Math.log(1.2) } }
  }));
  const browser = await chromium.launchPersistentContext(profile, {
    channel: 'chrome', headless: true, viewport: null, args: ['--window-size=1462,998']
  });
  const page = browser.pages()[0];
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  const report = { zoom: percent, menus: [], windows: [] };
  page.setDefaultTimeout(30000);
  try {
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
    await page.locator('#main_navbar.shiny-bound-input').waitFor();
    await page.evaluate(() => document.fonts.ready);
    async function checkSidebar() {
      const result = await page.locator('.trilha-sidebar').evaluate(rail => {
        const viewport = rail.querySelector('.navbar-collapse');
        const groups = []; const rows = []; const headings = [];
        let heading;
        for (const item of rail.querySelector('#main_navbar').children) {
          const section = item.querySelector('.trilha-menu-section');
          if (section) {
            heading = section;
            groups.push({title:section.textContent.toLocaleUpperCase('pt-BR'), menus:[]});
            const style = getComputedStyle(section);
            headings.push({font:style.fontFamily,size:style.fontSize,color:style.color,
              weight:style.fontWeight,spacing:style.letterSpacing,
              margin:style.margin,padding:style.padding});
          }
          const link = item.querySelector(':scope > a');
          if (!link || !heading) continue;
          const label = link.querySelector('.trilha-menu-label');
          if (!label) continue;
          const icon = link.querySelector('i');
          const rect = link.getBoundingClientRect();
          const textRect = label.getBoundingClientRect();
          const style = getComputedStyle(link);
          groups.at(-1).menus.push(label.textContent);
          rows.push({name:label.textContent,indent:icon.getBoundingClientRect().left-heading.getBoundingClientRect().left,
            left:rect.left,right:rect.right,arrowRight:rect.right-parseFloat(style.paddingRight),
            textWidth:textRect.width,scrollWidth:label.scrollWidth,
            lines:textRect.height/parseFloat(getComputedStyle(label).lineHeight)});
        }
        return {groups,headings,rows,rail:rail.getBoundingClientRect().toJSON(),
          overflow:viewport.scrollWidth-viewport.clientWidth};
      });
      assert.deepEqual(result.groups.map(group=>group.title),
        ['PESQUISA','PREPARAÇÃO E EXPLORAÇÃO','ANÁLISES','APRENDER E COMUNICAR']);
      assert.deepEqual(result.groups[0].menus,['Planejando sua Pesquisa']);
      assert.deepEqual(result.groups[1].menus,['Preparar Dados','Explorar e Visualizar']);
      assert.deepEqual(result.headings[1],result.headings[2],'O novo título usa o mesmo estilo dos grupos.');
      assert.ok(result.overflow<=1,'Sem rolagem horizontal na sidebar.');
      for (const row of result.rows) {
        assert.ok(row.indent>=6 && row.indent<=8,'Recuo de ícone e menu: '+row.name);
        assert.ok(row.lines<=1.05 && row.scrollWidth<=row.textWidth+1,'Nome completo em uma linha: '+row.name);
        assert.ok(row.left>=result.rail.left && row.right<=result.rail.right,'Seleção dentro da coluna.');
        assert.ok(Math.abs(row.arrowRight-result.rows[0].arrowRight)<1,'Setas alinhadas à direita.');
      }
      return result;
    }
    report.sidebar = await checkSidebar();
    const session = await browser.newCDPSession(page);
    const { windowId } = await session.send('Browser.getWindowForTarget');
    const dimensions = () => page.evaluate(() => ({
      width: innerWidth, height: innerHeight, outerWidth, outerHeight,
      devicePixelRatio, visualScale: visualViewport.scale
    }));
    report.initial = await dimensions();
    assert.ok(Math.abs(report.initial.devicePixelRatio - zoom) < .001, 'Zoom nativo confirmado.');
    assert.equal(report.initial.visualScale, 1, 'Sem zoom de pinça.');
    assert.ok(Math.abs(report.initial.width * zoom - 1440) < 2);
    assert.ok(Math.abs(report.initial.height * zoom - 900) < 2);
    const menus = page.locator('#main_navbar > li.dropdown > a');
    const planning = menus.filter({ hasText: 'Planejando sua Pesquisa' });
    const regression = menus.filter({ hasText: 'Regressões Lineares e MLG' });
    const panel = page.locator('#trilha-flyout');
    const buttons = panel.locator('.trilha-flyout-item');
    async function capture(name) {
      // Captura a superfície da janela. O caminho padrão do Playwright pode
      // acrescentar área vazia ao confundir pixels CSS e físicos no zoom 75%.
      const size = await page.evaluate(() => ({ width: Math.round(innerWidth * devicePixelRatio), height: Math.round(innerHeight * devicePixelRatio) }));
      const screenshot = await session.send('Page.captureScreenshot', {
        format: 'png', fromSurface: true, captureBeyondViewport: false,
        clip: { x: 0, y: 0, ...size, scale: 1 }
      });
      fs.writeFileSync(path.join(destination, name), Buffer.from(screenshot.data, 'base64'));
    }
    await planning.click();
    await buttons.filter({ hasText: 'Transversal comparativo' }).click();
    await page.locator('.obs-estudio:visible').getByRole('tab', {name:'Definições'}).click();
    const question = page.locator('#obs_transversal_comparativo-pergunta');
    const units = page.locator('#obs_transversal_comparativo-uas_grupo_1');
    await units.waitFor({ state: 'visible', timeout: 120000 });
    await question.fill('Verificação do estado no zoom ' + percent);
    await units.fill('7');
    await question.evaluate(el => { window.trilhaZoomField = el; });

    async function checkGeometry() {
      const geometry = await panel.evaluate(el => {
        const origin = document.querySelector('#main_navbar > .trilha-open > a').getBoundingClientRect();
        const rect = el.getBoundingClientRect();
        return { left: rect.left, right: rect.right, top: rect.top, bottom: rect.bottom, width: rect.width,
          arrowY: rect.top + parseFloat(el.style.getPropertyValue('--trilha-pointer-y')),
          anchorY: origin.top + origin.height / 2,
          railRight: document.querySelector('.trilha-sidebar').getBoundingClientRect().right,
          viewportWidth: innerWidth, viewportHeight: innerHeight };
      });
      assert.ok(geometry.left - 8 >= geometry.railRight - 1, 'Ponta não cobre a barra.');
      assert.ok(geometry.right <= geometry.viewportWidth - 7);
      assert.ok(geometry.top >= 7 && geometry.bottom <= geometry.viewportHeight - 7);
      assert.ok(Math.abs(geometry.arrowY - geometry.anchorY) < 1, 'Ponta acompanha o centro do menu.');
      return geometry;
    }
    for (let index = 0; index < await menus.count(); index++) {
      const origin = menus.nth(index);
      const before = await menus.evaluateAll(els => els.map(el => el.getBoundingClientRect().top));
      await origin.click();
      assert.deepEqual(await menus.evaluateAll(els => els.map(el => el.getBoundingClientRect().top)), before);
      const geometry = await checkGeometry();
      const content = await panel.evaluate(el => {
        const list = el.querySelector('.trilha-flyout-list');
        const style = getComputedStyle(el);
        const group = el.querySelector('.trilha-flyout-group');
        return { background: style.backgroundColor, color: style.color,
          groupColor: group && getComputedStyle(group).color,
          overflow: list.scrollWidth - list.clientWidth,
          entries: Array.from(el.querySelectorAll('.trilha-flyout-item')).map(button => {
            const text = button.querySelector('span'); const icon = button.querySelector('i');
            return { name: text.textContent, height: text.getBoundingClientRect().height,
              lineHeight: parseFloat(getComputedStyle(text).lineHeight),
              padding: parseFloat(getComputedStyle(button).paddingLeft),
              textX: text.getBoundingClientRect().left, iconWidth: icon?.getBoundingClientRect().width };
          }) };
      });
      assert.equal(content.background, 'rgb(18, 62, 91)');
      assert.ok(contrast(content.color, content.background) >= 4.5);
      if (content.groupColor) assert.ok(contrast(content.groupColor, content.background) >= 4.5);
      assert.ok(content.overflow <= 1, 'Nomes completos sem corte horizontal.');
      for (const entry of content.entries) {
        assert.ok(entry.height <= entry.lineHeight + 1, entry.name + ' em uma linha.');
        assert.equal(entry.padding, 20);
        if (entry.iconWidth) assert.equal(entry.iconWidth, 20);
        assert.ok(Math.abs(entry.textX - content.entries[0].textX) < 1);
      }
      const originals = await origin.evaluate(el => Array.from(el.parentElement.querySelectorAll(".dropdown-menu a[data-bs-toggle='tab']")).map(a => a.textContent.replace(/\s+/g, ' ').trim()));
      assert.deepEqual(content.entries.map(entry => entry.name), originals);
      report.menus.push({ title: await page.locator('#trilha-flyout-title').innerText(), geometry, options: content.entries.length,
        contrast: contrast(content.color, content.background), groupContrast: content.groupColor && contrast(content.groupColor, content.background) });
      await page.keyboard.press('Escape');
      assert.ok(await origin.evaluate(el => document.activeElement === el));
    }
    for (const [width, height] of [[1440, 900], [1280, 720], [1024, 640]]) {
      await session.send('Browser.setWindowBounds', { windowId, bounds: { width: width + 22, height: height + 98 } });
      await page.waitForTimeout(200);
      await regression.click();
      await checkSidebar();
      const geometry = await checkGeometry();
      const sidebar = await page.locator('.trilha-sidebar').evaluate(el => {
        const list = el.querySelector('.navbar-collapse'); const link = el.querySelector('#main_navbar > li.dropdown > a');
        return { width: el.getBoundingClientRect().width, scrollHeight: list.scrollHeight, height: list.clientHeight,
          itemHeight: link.getBoundingClientRect().height, padding: parseFloat(getComputedStyle(link).paddingTop),
          font: parseFloat(getComputedStyle(link).fontSize), icon: parseFloat(getComputedStyle(link.querySelector('i')).fontSize) };
      });
      assert.ok(sidebar.width >= 290 && sidebar.width <= 310);
      if (height >= 720) assert.ok(sidebar.scrollHeight <= sidebar.height + 1, 'Todos os menus cabem.');
      const labels = await page.locator('.trilha-menu-label').evaluateAll(els => els.map(el => ({ width: el.getBoundingClientRect().width, scrollWidth: el.scrollWidth })));
      assert.ok(labels.every(label => label.scrollWidth <= label.width + 1));
      report.windows.push({ physicalContent: { width, height }, dimensions: await dimensions(), sidebar, panel: geometry });
      if (width === 1280) await capture('regressoes-' + percent + '.png');
      await page.keyboard.press('Escape');
    }
    await planning.click();
    await page.locator('.trilha-flyout-search').fill('transversal');
    assert.equal(await buttons.filter({ visible: true }).count(), 1);
    await buttons.filter({ hasText: 'Transversal comparativo' }).click();
    assert.equal(await question.inputValue(), 'Verificação do estado no zoom ' + percent);
    assert.equal(await units.inputValue(), '7');
    assert.ok(await question.evaluate(el => el === window.trilhaZoomField));
    // Menu em uso diferente do aberto, como na referência do autor.
    await menus.filter({ hasText: 'Séries Temporais' }).click();
    await buttons.filter({ hasText: 'Visualizar e suavizar' }).click();
    await session.send('Browser.setWindowBounds', { windowId, bounds: { width: 1302, height: 818 } });
    await page.waitForTimeout(200);
    await planning.click();
    await checkGeometry();
    assert.ok(await planning.evaluate(el => el.parentElement.classList.contains('trilha-open') && !el.parentElement.classList.contains('trilha-active-menu')));
    await capture('planejamento-' + percent + '.png');
    await page.locator('.trilha-flyout-close').click();
    await planning.click(); await page.locator('#trilha-caminho').click();
    assert.ok(await panel.isHidden());
    await planning.click(); await buttons.filter({ hasText: 'Transversal comparativo' }).click();
    assert.equal(await question.inputValue(), 'Verificação do estado no zoom ' + percent);
    assert.equal(await units.inputValue(), '7');
    assert.ok(await question.evaluate(el => el === window.trilhaZoomField));
    assert.deepEqual(errors, []);
    console.log('OK: Chrome ' + percent + '%, 13 menus, contraste, hierarquia, ponta e estado.');
    return report;
  } catch (error) {
    await page.screenshot({ path: path.join(destination, 'falha-zoom-' + percent + '.png') }).catch(() => {});
    throw error;
  } finally { await browser.close(); }
}
(async () => {
  const reports = [];
  for (const zoom of [1, .75]) reports.push(await checkZoom(zoom));
  fs.writeFileSync(path.join(destination, 'medidas-zoom.json'), JSON.stringify(reports, null, 2));
})().catch(error => { console.error(error); process.exitCode = 1; });
