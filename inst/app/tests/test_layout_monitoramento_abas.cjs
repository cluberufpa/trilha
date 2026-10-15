/* Com a Trilha local aberta: node inst/app/tests/test_layout_monitoramento_abas.cjs [URL] */
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');
const destination = path.resolve(__dirname, '../../../outputs/layout-monitoramento-abas');
const url = process.argv[2] || 'http://127.0.0.1:4635';
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
    const deadline=Date.now()+120000;
    for(;;) {
      try { await page.goto(url,{waitUntil:'domcontentloaded',timeout:120000}); break; }
      catch(error) {
        if(!error.message.includes('ERR_CONNECTION_REFUSED')||Date.now()>=deadline) throw error;
        await page.waitForTimeout(500);
      }
    }
    await page.locator('#main_navbar.shiny-bound-input').waitFor();
    await page.evaluate(()=>document.fonts.ready);
    assert.ok(Math.abs(await page.evaluate(()=>devicePixelRatio)-zoom)<.001);
    const session = await browser.newCDPSession(page);
    async function capture(name) {
      const size=await page.evaluate(()=>({width:Math.round(innerWidth*devicePixelRatio),height:Math.round(innerHeight*devicePixelRatio)}));
      const shot=await session.send('Page.captureScreenshot',{format:'png',fromSurface:true,captureBeyondViewport:false,
        clip:{x:0,y:0,...size,scale:1}});
      fs.writeFileSync(path.join(destination,name+'-'+percent+'.png'),Buffer.from(shot.data,'base64'));
    }
    const prefix='#monitoramento-';
    const studio=page.locator('.mon-estudio:visible');
    const main=page.locator(prefix+'abas');
    const defs=page.locator(prefix+'definicoes');
    const tab=name=>main.locator(':scope > li > a').filter({hasText:name}).click();
    const sub=name=>defs.locator(':scope > li > a').filter({hasText:name}).click();
    async function edit(id,value,selector=prefix+id) {
      const date=id==='inicio'||id==='fim';
      if(date) {
        await page.locator(prefix+id+'.shiny-date-input.shiny-bound-input').waitFor();
        // O calendário atualiza a data selecionada no evento de teclado.
        await page.locator(selector).fill(value.slice(0,-1));
        await page.locator(selector).press(value.at(-1));
      } else await page.locator(selector).fill(value);
      await page.locator(selector).press('Tab');
      await page.waitForFunction(([id,value,date])=>{
        const values=Shiny.shinyapp.$inputValues;
        return String(values[date?id+':shiny.date':id])===value;
      },['monitoramento-'+id,value,date]);
    }
    async function geometry(name,usual=false) {
      const measure=await studio.evaluate(root=>{
        const grid=Array.from(root.querySelectorAll('.mon-definicoes')).find(el=>el.getClientRects().length);
        const columns=Array.from(grid.children).map(el=>el.getBoundingClientRect().toJSON());
        const controls=Array.from(grid.querySelectorAll('input:not([type="hidden"]),select,textarea,button'))
          .filter(el=>el.getClientRects().length).map(el=>el.getBoundingClientRect().toJSON());
        return {columns,controls,bottom:grid.getBoundingClientRect().bottom,
          overflow:document.documentElement.scrollWidth-innerWidth,viewport:{width:innerWidth,height:innerHeight},
          internalScroll:Array.from(grid.querySelectorAll('.mon-card,.mon-coluna'))
            .filter(el=>['auto','scroll'].includes(getComputedStyle(el).overflowY)&&el.scrollHeight>el.clientHeight+2).length};
      });
      assert.equal(measure.columns.length,2,name+': duas colunas principais');
      assert.ok(Math.abs(measure.columns[0].top-measure.columns[1].top)<1,name+': alinhamento pelo topo');
      assert.ok(measure.overflow<=1,name+': página sem rolagem horizontal');
      assert.equal(measure.internalScroll,0);
      assert.ok(measure.controls.every(c=>c.right<=measure.viewport.width+1&&c.left>=0),name+': controles inteiros');
      if(usual&&zoom===.75) assert.ok(measure.bottom<=measure.viewport.height+40,name+': cabe no preenchimento usual');
      report.screens.push({screen:name,...measure});
    }
    console.log(percent+'% · abrir Monitoramento');
    await page.locator('#main_navbar > li.dropdown > a').filter({hasText:'Planejando sua Pesquisa'}).click();
    await page.locator('.trilha-flyout-item').filter({hasText:'Monitoramento'}).click();
    assert.deepEqual((await main.locator(':scope > li > a').allTextContents()).map(s=>s.trim()),
      ['Tipo','Definições','Desenho','Tabelas de coleta','Resumo']);
    await geometry('Tipo');
    await capture('tipo');
    await tab('Definições');
    assert.deepEqual((await defs.locator(':scope > li > a').allTextContents()).map(s=>s.trim()),
      ['Tempo e calendário','Locais, esforço e respostas','Metodologia','Modelo e cuidados']);
    // A metodologia funciona antes de visitar a subaba de locais e respostas.
    await sub('Metodologia');
    await page.waitForFunction(()=>{
      const text=document.querySelector('#monitoramento-metodologia').textContent;
      return text.includes('48 registros previstos') && text.includes('captura_kg');
    });
    for(const [name,ready,shot] of [
      ['Tempo e calendário',prefix+'inicio','tempo'],
      ['Locais, esforço e respostas',prefix+'medida_nome_1','locais'],
      ['Metodologia',prefix+'metodologia p','metodologia'],
      ['Modelo e cuidados','.mon-modelo','modelo']
    ]) {
      console.log(percent+'% · '+name);
      await sub(name);
      await studio.locator(ready).first().waitFor({state:'visible'});
      await geometry(name,true);
      await capture(shot);
    }
    console.log(percent+'% · conferir registros e saídas');
    await sub('Tempo e calendário');
    await page.locator(prefix+'frequencia input[value="diaria"]').check();
    await page.locator(prefix+'inicio.shiny-date-input input').waitFor({state:'visible'});
    await edit('inicio','2027-03-01',prefix+'inicio input');
    await edit('fim','2027-03-05',prefix+'fim input');
    await edit('horario','06h, na preamar');
    await page.locator(prefix+'hora_real input[value="sim"]').check();
    await page.locator(prefix+'data_real').check();
    console.log(percent+'% · datas e registros preenchidos');
    await sub('Locais, esforço e respostas');
    await edit('local_1','Porto');
    await edit('local_2','Praia');
    await page.locator(prefix+'add_local').click();
    await page.locator(prefix+'local_3').waitFor({state:'visible'});
    await edit('local_3','Canal');
    await page.locator(prefix+'add_local').click();
    await page.locator(prefix+'local_4').waitFor({state:'visible'});
    await page.locator(prefix+'rem_local_4').click();
    await page.locator(prefix+'local_4').waitFor({state:'detached'});
    await page.locator(prefix+'tem_esforco input[value="sim"]').check();
    await page.locator(prefix+'indice_1').waitFor({state:'visible'});
    await edit('unidade_esforco','viagens');
    await page.locator(prefix+'responsavel').check();
    console.log(percent+'% · locais e esforço preenchidos');
    await edit('medida_coluna_1','captura_total');
    await page.locator(prefix+'indice_1').check();
    await page.locator(prefix+'add_medida').click();
    await page.locator(prefix+'medida_nome_2').waitFor({state:'visible'});
    await edit('medida_nome_2','temperatura');
    await edit('medida_unidade_2','°C');
    await edit('medida_coluna_2','temp_c');
    await page.locator(prefix+'add_medida').click();
    await page.locator(prefix+'medida_nome_3').waitFor({state:'visible'});
    await page.locator(prefix+'rem_medida_3').click();
    await page.locator(prefix+'medida_nome_3').waitFor({state:'detached'});
    assert.equal(await page.locator(prefix+'medida_coluna_2').inputValue(),'temp_c');
    assert.ok(await page.locator(prefix+'indice_1').isChecked());
    await geometry('Locais e respostas preenchidos');
    await capture('locais-preenchidos');
    await sub('Metodologia');
    await page.waitForFunction(()=>document.querySelector('#monitoramento-metodologia').textContent.includes('15 registros previstos'));
    const method=await page.locator(prefix+'metodologia').innerText();
    for(const text of ['Porto','Canal','captura_total','temp_c','viagens']) assert.ok(method.includes(text));
    await tab('Desenho');
    const imageReady=id=>page.waitForFunction(id=>{
      const img=document.querySelector('#monitoramento-'+id+' img');return img?.complete&&img.naturalWidth>0;
    },id);
    await imageReady('desenho');
    const drawing=await page.locator(prefix+'desenho img').getAttribute('src');
    await capture('desenho');
    const views=page.locator(prefix+'vistas_desenho');
    await views.getByRole('tab',{name:'Calendário anual',exact:true}).click();
    await imageReady('calendario');
    assert.equal(await page.locator(prefix+'ano_calendario').inputValue(),'2027');
    await capture('calendario');
    await views.getByRole('tab',{name:'Visitas por local',exact:true}).click();
    await imageReady('desenho_locais');
    await capture('visitas');
    const tableCount=count=>page.waitForFunction(count=>{
      const root=document.querySelector('#monitoramento-tabela');
      const table=root?.querySelector('.dataTables_scrollBody table');
      return table&&jQuery.fn.dataTable.isDataTable(table)&&jQuery(table).DataTable().rows().count()===count;
    },count);
    await tab('Tabelas de coleta');
    await tableCount(15);
    const table=await page.locator(prefix+'tabela').innerText();
    for(const col of ['data_real','hora','responsavel','captura_total','temp_c','esforco_viagens','captura_total_por_viagens']) assert.ok(table.includes(col));
    await page.locator(prefix+'tabela .paginate_button.next').click();
    await page.waitForFunction(()=>document.querySelector('#monitoramento-tabela .dataTables_info').textContent.includes('13 a 15'));
    await capture('tabelas');
    assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1));
    await tab('Resumo');
    await page.waitForFunction(()=>document.querySelector('#monitoramento-resumo').textContent.includes('5 datas × 3 locais = 15 linhas'));
    await page.locator(prefix+'resumo_tabela table').waitFor({state:'visible'});
    await capture('resumo');
    await tab('Definições');
    await sub('Tempo e calendário');
    assert.equal(await page.locator(prefix+'inicio input').inputValue(),'2027-03-01');
    assert.equal(await page.locator(prefix+'fim input').inputValue(),'2027-03-05');
    assert.equal(await page.locator(prefix+'horario').inputValue(),'06h, na preamar');
    assert.ok(await page.locator(prefix+'data_real').isChecked());
    assert.ok(await page.locator(prefix+'hora_real input[value="sim"]').isChecked());
    await edit('fim','2027-03-31',prefix+'fim input');
    await page.locator(prefix+'frequencia input[value="quinzenal"]').check();
    await sub('Locais, esforço e respostas');
    for(const [id,value] of Object.entries({local_1:'Porto',local_2:'Praia',local_3:'Canal',
      medida_nome_1:'captura',medida_unidade_1:'kg',medida_coluna_1:'captura_total',
      medida_nome_2:'temperatura',medida_unidade_2:'°C',medida_coluna_2:'temp_c'})) {
      assert.equal(await page.locator(prefix+id).inputValue(),value);
    }
    assert.ok(await page.locator(prefix+'responsavel').isChecked());
    await sub('Metodologia');
    await page.waitForFunction(()=>document.querySelector('#monitoramento-metodologia').textContent.includes('6 registros previstos'));
    await tab('Desenho');
    await views.getByRole('tab',{name:'Estrutura da série',exact:true}).click();
    await page.waitForFunction(old=>document.querySelector('#monitoramento-desenho img')?.getAttribute('src')!==old,drawing);
    await imageReady('desenho');
    await tab('Tabelas de coleta');
    await tableCount(6);
    await tab('Resumo');
    await page.waitForFunction(()=>document.querySelector('#monitoramento-resumo').textContent.includes('2 datas × 3 locais = 6 linhas'));
    assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1));
    assert.deepEqual(errors,[]);
    console.log('OK: quatro subabas, duas colunas, inclusão/exclusão e atualizações em '+percent+'%');
    return report;
  } catch(error) {
    await page.screenshot({path:path.join(destination,'falha-'+percent+'.png')}).catch(()=>{});
    throw error;
  } finally {await browser.close();}
}
(async()=>{
  const reports=[];
  for(const zoom of [.75,1]) reports.push(await checkZoom(zoom));
  fs.writeFileSync(path.join(destination,'medidas.json'),JSON.stringify(reports,null,2));
})().catch(error=>{console.error(error);process.exitCode=1;});
