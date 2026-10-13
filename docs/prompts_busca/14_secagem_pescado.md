# Busca 14 — curvas de secagem de pescado

Substitui: `secagem_beterraba_gengibre` (D52; Granella 2025, Mendeley Data
10.17632/zkvb73tn79.1, CC BY 4.0; 594 medições em 36 curvas de razão de umidade).
O conjunto é bom, mas é de vegetais, e há muitos estudos de secagem de peixe
(decisão do professor, 13/10/2026). Escrito em 13/10/2026; usa a mesma estrutura
da busca 08. Cole o texto abaixo da linha numa IA com busca na web.

> Já examinados em 13/10/2026 e **não indicados como estão**:
> - Ohijeagbon et al. (2018), *Data in Brief* 18:641–647,
>   [10.1016/j.dib.2018.03.072](https://doi.org/10.1016/j.dib.2018.03.072), CC BY 4.0:
>   bagre-africano (*Clarias gariepinus*) em secador a gás, 80, 100 e 120 °C, a cada
>   60 min. Só 27 pontos, sem réplicas, e a umidade chega a 0,000 (a unidade da
>   tabela diz base seca, a equação do artigo diz base úmida). Serve de reserva.
> - Castillo-Téllez et al., sardinha (Zenodo
>   [10.5281/zenodo.21006853](https://doi.org/10.5281/zenodo.21006853), CC BY 4.0):
>   1787 medições em 28 curvas, mas os arquivos estão sob embargo até 1/1/2027.
>   Reavaliar quando forem liberados.

---

Preciso encontrar **um conjunto de dados real e aberto** para um pacote R
didático de estatística aplicada à pesca e aquicultura, usado por estudantes de
graduação no Brasil. Os dados vão ser traduzidos para o português, arrumados e
redistribuídos dentro do pacote, com crédito à fonte. Por isso a licença e a
estrutura importam tanto quanto o tema.

## O que os dados precisam ensinar

**Regressão não linear em curvas de secagem**: razão de umidade (ou umidade em
base seca) caindo com o tempo até um patamar. O aluno ajusta `nls()` com os
modelos de camada fina mais comuns (Lewis/Newton, Page, Henderson-Pabis,
logarítmico), compara os ajustes e mostra que a temperatura acelera a secagem.

## Estrutura exigida

- **Pescado**: filés, peixe inteiro ou salgado, camarão, lula, mexilhão, alga
  marinha comestível como última opção. Secagem ao sol, solar, estufa, ar quente,
  infravermelho, micro-ondas ou liofilização.
- **Tempo** numa coluna numérica, com unidade dita, e **umidade ou massa** em cada
  instante, da queda até perto do patamar.
- **Pelo menos 3 curvas** de um mesmo desenho (temperaturas, métodos ou
  pré-tratamentos), de preferência **com réplicas**, cada uma com 10 ou mais
  pontos. Ideal: 100 a 800 medições ao todo.
- Os dados brutos por medição, não só os parâmetros dos modelos ajustados.

## Licença e acesso

- Licença aberta nomeada que permita redistribuir com adaptação: CC0, CC BY,
  ODbL, MIT. Não serve "disponível mediante pedido", nem dados só em figura.
- Repositórios a vasculhar: Mendeley Data, Zenodo, Figshare, Dryad, Harvard
  Dataverse, PANGAEA, material suplementar de artigos de acesso aberto (Data in
  Brief, PLOS ONE, Foods, Heliyon, Scientific Data).

## O que devolver

Para cada candidato: referência completa, DOI do artigo e dos dados, licença
conferida na página, link direto do arquivo, espécie e produto, colunas, número
de curvas, de réplicas e de medições, e uma frase sobre o que ele ensina melhor
que a beterraba. Diga o que foi aberto e conferido e o que é inferência. No fim,
recomende um.
