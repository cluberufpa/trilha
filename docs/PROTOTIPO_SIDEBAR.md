# Protótipo local: navegação lateral

Branch: `feat/layout-sidebar`, criada a partir de `main` em 14/10/2026.

## Escopo

A navegação horizontal virou uma barra esquerda em azul-marinho, com menus em acordeão, rolagem própria, caminho do módulo ativo e botão para recolher a barra. Os nomes, agrupamentos e links existentes continuam disponíveis. O Transversal comparativo é o piloto conferido; os demais módulos ainda precisam de avaliação de layout.

Os painéis continuam sendo os mesmos `nav_panel` do bslib. O JavaScript controla apenas a abertura visual dos menus e acompanha o evento real de seleção de aba. Abrir/recolher um menu não envia inputs ao servidor. A troca de módulos mantém a estratégia existente: os painéis e seus servidores são criados uma vez por sessão, e a navegação alterna a visibilidade. Não há novo `renderUI` nem chamada de módulo nessa camada.

Não foram alterados campos, IDs, abas, regras, cálculos, fichas ou exportadores do Transversal. Variantes, UA-conjunto e Código R ficam para a etapa própria descrita em `PLANO_VARIANTES.md`. Nenhum arquivo foi movido, pacote atualizado ou mudança publicada no remoto. Os arquivos não rastreados que já existiam foram preservados.

## Executar

No R/RStudio, com a pasta TRILHA como diretório de trabalho:

```r
shiny::runApp("inst/app", launch.browser = TRUE)
```

Abra **Planejando sua Pesquisa → Transversal comparativo**. O botão de três barras, no cabeçalho, recolhe e reabre a navegação lateral.

A sessão de validação usou `127.0.0.1:4622`. O ambiente começou com locale `C` e não conseguiu ler arquivos UTF-8. Para esse caso específico, antes de abrir o app foi usado:

```r
Sys.setlocale("LC_ALL", "Portuguese_Brazil.utf8")
```

Isso ajusta somente a sessão R. O protótipo não altera a configuração regional do computador.

## Verificação realizada

- Sintaxe de `app.R` e `git diff --check`: sem erro.
- Comparação das expressões R com a base `main`: declarações dos menus, agrupamentos, corpos dos painéis e função `server` idênticos. Mudaram a marca, o cabeçalho e os estilos de navegação.
- No navegador, seleção do Transversal com recolhimento automático; caminho e menu ativo corretos; reabertura reconhece o módulo selecionado.
- Abertura de Planejamento seguida de Preparar Dados deixa apenas o último menu expandido, sem trocar o módulo central.
- Pergunta preenchida, 7 UAs no primeiro grupo e nome da primeira resposta permaneceram após abrir/recolher menus e recolher/reabrir a barra.
- O resumo reativo das Definições refletiu a alteração para 27 UAs e 54 unidades físicas. A seleção da aba Desenho funcionou; a figura ainda não havia terminado de aparecer na última captura de conferência.
- Sem erro JavaScript registrado na consulta ao console após os ajustes. Havia avisos de depreciação do componente de datas existente.
- `test_ficha_planejamento.R` e `test_observacional_impacto.R`: todas as verificações chegaram aos respectivos resumos OK. Os processos R devolveram status 1, inclusive na repetição isolada da ficha; portanto, esses resumos não foram tratados como uma execução integral com saída limpa.
- `test_transversal_saidas.R`: passou pelas verificações e geração de Excel, Word e desenhos nos cenários de um fator, UAs diferentes e dois fatores; falhou mais adiante no cenário de estações, em `all(coleta_estacoes$pool == 1L)`, compatível com a falha prévia informada. O arquivo do módulo não foi modificado.

## Limitações para a revisão

Não foi executada uma nova suíte completa; a suíte anterior do usuário não foi usada como evidência. A renderização final da figura, todas as abas, downloads pelo navegador, troca para outro módulo e retorno, navegação por teclado e telas pequenas ainda precisam de conferência. A barra tem rolagem independente; algumas telas antigas podem exigir recolhê-la para ganhar largura.

A ferramenta de navegador foi interrompida por reinício do ambiente, e a retomada falhou ao criar o ambiente de segurança do processo (`HRESULT 0x80070020`). Por isso não foi possível salvar a captura de tela final. O app foi inspecionado visualmente durante os testes; isso não equivale a uma certificação de todos os módulos.

## Arquivos do protótipo

- `inst/app/app.R`: marca, cabeçalho, carregamento dos recursos e retirada dos estilos horizontais.
- `inst/app/www/layout-sidebar.css`: aparência, rolagem e largura da barra.
- `inst/app/www/layout-sidebar.js`: acordeão, identificação do ativo e recolhimento da barra.
- `docs/PROTOTIPO_SIDEBAR.md`: execução, evidências e limites desta etapa.
## Ajuste dos grupos laterais (14/10/2026)

A pedido do autor, a barra agora apresenta três títulos com separadores:

- **Pesquisa:** Planejando sua Pesquisa, Preparar Dados e Explorar e Visualizar.
- **Análises:** Frequências e Proporções, Testes Paramétricos, Testes Não Paramétricos, Regressões Lineares e MLG, Regressão Não Linear, Séries Temporais, Estatística Multivariada e Mapear e Analisar.
- **Aprender e comunicar:** Laboratório de Conceitos e Comunicação de Resultados.

São títulos visuais, sem exigir um clique adicional. Ajuda e Sobre continuam disponíveis. O ajuste não altera o espaço vertical do cabeçalho central, o acordeão, os links ou o estado dos módulos.

Verificação desta mudança: sintaxe R válida, comparação das declarações da UI com o commit anterior confirma apenas três novos títulos e preservação de todos os demais argumentos, e `git diff --check` sem erros. A ferramenta de navegador continuou falhando ao iniciar; a aparência desta atualização ainda não foi conferida no navegador.