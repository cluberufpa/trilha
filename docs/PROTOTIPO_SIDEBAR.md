# Protótipo local: navegação lateral com flyout

Branch de trabalho: `feat/layout-sidebar`. Ajustes locais realizados em 14/10/2026; nada publicado no remoto.

## Comportamento atual

Os menus principais permanecem na barra, organizados em Pesquisa, Análises e Aprender e comunicar. Um clique abre um único painel flutuante à direita; outro menu troca o conteúdo, e repetir o clique fecha o painel. Selecionar um módulo (inclusive o já ativo), clicar fora, usar o botão de fechar ou pressionar Esc também fecha. O menu ativo, a indicação “Em uso” e o caminho do módulo são preservados.

O painel tem largura preferida de 348 px, reduzida conforme o espaço disponível. Seu topo acompanha o menu acionado e é corrigido para caber na janela; redimensionamento e rolagem da barra recalculam a posição. Cabeçalho e rodapé ficam separados da lista, que tem rolagem própria. Menus com oito ou mais módulos oferecem busca local pelo nome, ignorando maiúsculas e acentos; grupos sem resultados ficam ocultos durante a busca.

Enter ou Espaço abre/fecha o menu; seta direita/baixo entra no painel. Setas, Home/End e Tab permitem percorrer os controles, e Esc devolve o foco ao botão de origem. O painel é não modal: a área central e os outros menus continuam acessíveis.

Em larguras de até 480 px, a barra usa ícones para deixar espaço para o painel. Os nomes completos permanecem nos rótulos acessíveis, nos tooltips e no cabeçalho do flyout; o destaque do menu ativo permanece visível. Nas demais larguras, continuam os nomes e a indicação do módulo na barra.

## Preservação dos módulos

A UI continua usando os mesmos painéis `nav_panel` e servidores. Os links originais ficam ocultos na navbar, preservando `data-value`, a seleção de abas e o binding `main_navbar` do Shiny. O flyout contém atalhos que acionam esses links; os campos dos módulos não são movidos, removidos ou recriados.

O painel é anexado ao corpo da página com posição fixa e camada 1040. Assim, os contêineres de rolagem da barra não o cortam. Ele sobrepõe parte do conteúdo central, começando depois da borda direita da barra, sem deslocar o layout. A regra responsiva do tema que deslocava a lista principal para fora da barra foi corrigida.

Não foram alterados nomes, agrupamentos internos, campos, IDs, abas, regras, cálculos, fichas ou exportadores dos módulos. Variantes, UA-conjunto e Código R continuam para a etapa própria de `PLANO_VARIANTES.md`. Nenhum arquivo foi movido ou dependência de produção acrescentada. O trabalho local não rastreado que já existia foi preservado.

## Executar e revisar

No R/RStudio, com TRILHA como diretório de trabalho:

```r
shiny::runApp("inst/app", launch.browser = TRUE)
```

Reinicie o app para carregar esta versão da UI. Os endereços de CSS e JavaScript foram versionados para evitar cópias antigas em cache. O botão de três barras continua recolhendo/reabrindo a própria sidebar e fecha o flyout, se estiver aberto.

A sessão de teste separada usou `http://127.0.0.1:4623`. Neste ambiente, foi necessário ajustar somente a sessão R antes da execução:

```r
Sys.setlocale("LC_ALL", "Portuguese_Brazil.utf8")
```

O protótipo não muda a configuração regional do computador.

## Validação desta mudança

O teste `inst/app/tests/test_layout_flyout.cjs` foi executado contra o app real em uma sessão isolada do Chrome já instalado, usando o Playwright disponível no ambiente de desenvolvimento. Terminou com status 0.

Foi verificado:

- abertura por clique sem mudar as posições dos menus principais;
- um único painel, troca de menu e fechamento no clique repetido;
- busca com resultado e sem resultado, e destaque do módulo ativo;
- fechamento por seleção, clique externo, botão e Esc;
- seleção repetida do Transversal já ativo;
- Enter, setas, Home/End e retorno do foco ao menu de origem;
- preservação da pergunta preenchida e de 7 UAs no primeiro grupo do Transversal; o mesmo elemento de input permaneceu no DOM;
- posição dentro da janela em larguras de 320, 480, 600, 900 e 1440 px, sem cobrir a barra;
- menus principais dentro da barra também em janelas estreitas;
- posição de menu próximo ao rodapé e ausência de busca em menu curto;
- rolagem da lista sem deslocar o cabeçalho;
- ausência de erros JavaScript na sessão de teste.

A sintaxe JavaScript e `git diff --check` passaram. A comparação das expressões R confirmou menus, corpos dos painéis e servidor preservados; a UI também foi gerada. Essa verificação R apresentou os resumos OK, mas o subprocesso voltou a devolver status 1 após eles, como nas verificações anteriores deste ambiente; esse resultado não foi tratado como saída limpa de teste R. A sessão Shiny real foi inicializada e usada pelo teste de interação.

Capturas de conferência: `outputs/sidebar-flyout/flyout-desktop.png` e `outputs/sidebar-flyout/flyout-estreito.png`, inspecionadas visualmente. A ferramenta de navegador interativo continuou com erro ao iniciar; a validação foi concluída por teste automatizado em navegador separado.

Para repetir o teste, com o app já iniciado e Playwright disponível no `NODE_PATH`:

```text
node inst/app/tests/test_layout_flyout.cjs http://127.0.0.1:4623
```

Ele é separado da suíte R oficial e não instala pacotes ou navegadores.

## Limites

Esta etapa valida a navegação e sua integração com o Transversal. Não certifica o conteúdo ou os downloads de todos os módulos, dispositivos de toque ou todos os leitores de tela. A suíte R completa não foi repetida; as falhas prévias relatadas em `test_transversal_saidas.R`, gradiente e longitudinal não foram alteradas nem usadas como falhas novas desta navegação. Avaliar os layouts internos dos demais módulos continua sendo uma etapa própria.

## Arquivos da mudança

- `inst/app/app.R`: versão dos recursos de navegação.
- `inst/app/www/layout-sidebar.css`: sidebar, flyout e adaptação de largura.
- `inst/app/www/layout-sidebar.js`: atalhos, busca, posição, seleção e foco.
- `inst/app/tests/test_layout_flyout.cjs`: teste de interação no app local.
- `docs/PROTOTIPO_SIDEBAR.md`: escopo, execução, validação e limites.