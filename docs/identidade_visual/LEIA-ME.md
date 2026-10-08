# Identidade visual da CatalyseR

**Nome:** CatalyseR
**Slogan:** Da pergunta ao relatório, uma só trilha
**Ideia:** o catalisador não muda o destino, abre outro caminho até ele. A CatalyseR é um caminho alternativo para aprender estatística e fazer pesquisa.

## Arquivos

| Arquivo | Uso |
|---|---|
| `catalyser_logo_claro.svg/.png` | Logo principal (fundo branco ou claro: livro, slides, relatórios). Fundo transparente. |
| `catalyser_logo_escuro.svg/.png` | Fundo escuro (tela de abertura do app, se necessário). |
| `catalyser_icone.svg/.png` | Ícone do app (selo com o R e trilha de pegadas). |
| `gerar_logo.py` | Script que gera todos os arquivos (texto convertido em curvas). |

## Elementos

- Ponto âmbar: a pergunta (início da trilha).
- Pegadas: o percurso, passo a passo.
- Selo com o R: o relatório (chegada), colado ao nome para ler como uma só palavra.

## Cores (Ocean Gradient)

Navy `#0F3B5F` (nome) · Teal `#2E7D8F` (selo e slogan) · Seafoam `#62B6B7` (pegadas) · Amber `#E89B3C` (ponto de partida)

## Fontes

Source Serif 4 (nome e R) e Source Sans 3 (slogan), ambas livres (SIL OFL). Nos SVG o texto já está em curvas.

## Regenerar

Requer Python com `fonttools`, `brotli` e `cairosvg`, e as fontes de `@fontsource/source-serif-4` e `@fontsource/source-sans-3` (npm) em `node_modules/`. Rodar `python gerar_logo.py`.
