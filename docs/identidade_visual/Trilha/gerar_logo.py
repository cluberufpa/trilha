"""Gera a logo da CatalyseR com texto convertido em curvas."""
import math
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
import cairosvg

FONTES = "node_modules/@fontsource"
SERIF = TTFont(f"{FONTES}/source-serif-4/files/source-serif-4-latin-600-normal.woff2")
SERIF_R = TTFont(f"{FONTES}/source-serif-4/files/source-serif-4-latin-700-normal.woff2")
SANS = TTFont(f"{FONTES}/source-sans-3/files/source-sans-3-latin-400-normal.woff2")

NAVY, TEAL, SEAFOAM, AMBER = "#0F3B5F", "#2E7D8F", "#62B6B7", "#E89B3C"


def texto(fonte, s, x, y, tam, espaco=0.0):
    """Converte uma frase em um único path SVG; devolve (d, largura)."""
    gs = fonte.getGlyphSet()
    cmap = fonte.getBestCmap()
    upm = fonte["head"].unitsPerEm
    esc = tam / upm
    pen = SVGPathPen(gs)
    cx = x
    for ch in s:
        nome = cmap[ord(ch)]
        tp = TransformPen(pen, (esc, 0, 0, -esc, cx, y))
        gs[nome].draw(tp)
        cx += gs[nome].width * esc + espaco * tam
    return pen.getCommands(), cx - x - espaco * tam


def bbox_glifo(fonte, ch, tam):
    """Caixa do glifo (xmin, ymin, xmax, ymax) em px, eixo y para cima."""
    g = fonte["glyf"] if "glyf" in fonte else None
    from fontTools.pens.boundsPen import BoundsPen
    gs = fonte.getGlyphSet()
    bp = BoundsPen(gs)
    gs[fonte.getBestCmap()[ord(ch)]].draw(bp)
    esc = tam / fonte["head"].unitsPerEm
    return [v * esc for v in bp.bounds]


def pegada(x, y, ang, lado, esc, cor):
    """Uma pegada (sola + calcanhar) apontando na direção do caminho."""
    return (
        f'<g transform="translate({x:.1f} {y:.1f}) rotate({ang:.1f}) '
        f'translate(0 {lado * 6 * esc:.1f}) scale({esc:.2f})" fill="{cor}">'
        f'<path d="M-2 -4.6 C4 -6.2 11 -4.4 11 0 C11 4.4 4 6.2 -2 4.6 C-4.5 3.8 -4.5 -3.8 -2 -4.6Z"/>'
        f'<ellipse cx="-9.5" cy="0" rx="4" ry="3.7"/></g>'
    )


def trilha(p0, p1, p2, n, t0=0.12, t1=0.97, esc0=0.8, esc1=1.15, cores=None):
    """Pegadas alternadas ao longo de uma curva quadrática."""
    out = []
    for i in range(n):
        t = t0 + (t1 - t0) * i / (n - 1)
        x = (1 - t) ** 2 * p0[0] + 2 * t * (1 - t) * p1[0] + t ** 2 * p2[0]
        y = (1 - t) ** 2 * p0[1] + 2 * t * (1 - t) * p1[1] + t ** 2 * p2[1]
        dx = 2 * (1 - t) * (p1[0] - p0[0]) + 2 * t * (p2[0] - p1[0])
        dy = 2 * (1 - t) * (p1[1] - p0[1]) + 2 * t * (p2[1] - p1[1])
        ang = math.degrees(math.atan2(dy, dx))
        lado = -1 if i % 2 == 0 else 1
        esc = esc0 + (esc1 - esc0) * i / (n - 1)
        cor = cores[i] if cores else SEAFOAM
        out.append(pegada(x, y, ang, lado, esc, cor))
    return "\n".join(out)


def logo(cor_nome, cor_slogan, fundo=None):
    x0, base, tam = 40, 150, 104
    d_nome, larg = texto(SERIF, "Catalyse", x0, base, tam, espaco=-0.005)
    cap = bbox_glifo(SERIF, "C", tam)[3]          # altura da maiúscula
    # selo colado ao nome: um pouco mais alto que a maiúscula
    gs = SERIF.getGlyphSet()
    adv_e = gs[SERIF.getBestCmap()[ord('e')]].width * tam / SERIF['head'].unitsPerEm
    tinta_dir = x0 + larg - adv_e + bbox_glifo(SERIF, 'e', tam)[2]
    sx, lado_selo = tinta_dir + 4, cap + 30
    sy = base - cap - 15
    tam_r = tam * 0.98
    bx = bbox_glifo(SERIF_R, "R", tam_r)
    rx_txt = sx + (lado_selo - (bx[2] - bx[0])) / 2 - bx[0]
    ry_txt = sy + (lado_selo + (bx[3] - bx[1])) / 2 - bx[3] + (bx[3] - bx[1]) - (bx[3] - bx[1]) + bx[3] - bx[3]
    ry_txt = sy + lado_selo / 2 + (bx[3] + bx[1]) / 2
    d_r, _ = texto(SERIF_R, "R", rx_txt, ry_txt, tam_r)

    # trilha: parte do ponto âmbar sob o "C" e sobe até o canto do selo
    p0 = (x0 + 10, base + 52)
    p2 = (sx + 6, sy + lado_selo + 30)
    p1 = (x0 + larg * 0.72, base + 92)
    n = 11
    cores = [SEAFOAM] * (n - 2) + [TEAL, TEAL]
    passos = trilha(p0, p1, p2, n, t0=0.07, t1=0.97, esc0=1.0, esc1=1.35, cores=cores)

    d_slogan, larg_s = texto(SANS, "Da pergunta ao relatório, uma só trilha", x0 + 2, base + 140, 33)
    largura = max(sx + lado_selo, x0 + larg_s) + 40
    altura = base + 168
    bg = f'<rect width="100%" height="100%" fill="{fundo}"/>' if fundo else ""
    return largura, altura, f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {largura:.0f} {altura:.0f}" width="{largura:.0f}" height="{altura:.0f}">
<title>CatalyseR: da pergunta ao relatório, uma só trilha</title>
{bg}
<path d="{d_nome}" fill="{cor_nome}"/>
<rect x="{sx:.1f}" y="{sy:.1f}" width="{lado_selo:.1f}" height="{lado_selo:.1f}" rx="{lado_selo*0.2:.1f}" fill="{TEAL}"/>
<path d="{d_r}" fill="#FFFFFF"/>
<circle cx="{p0[0]:.1f}" cy="{p0[1]:.1f}" r="7.5" fill="{AMBER}"/>
{passos}
<path d="{d_slogan}" fill="{cor_slogan}"/>
</svg>'''


def icone():
    L = 512
    tam_r = 330
    bx = bbox_glifo(SERIF_R, "R", tam_r)
    rx_txt = (L - (bx[2] - bx[0])) / 2 - bx[0]
    ry_txt = 300 + 0 * bx[3]
    ry_txt = 222 + (bx[3] + bx[1]) / 2
    d_r, _ = texto(SERIF_R, "R", rx_txt, ry_txt, tam_r)
    p0, p1, p2 = (100, 430), (260, 462), (420, 372)
    passos = trilha(p0, p1, p2, 5, t0=0.2, t1=1.0, esc0=2.4, esc1=2.9,
                    cores=["#A9DCDC"] * 5)
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {L} {L}" width="{L}" height="{L}">
<title>CatalyseR</title>
<rect width="{L}" height="{L}" rx="104" fill="{TEAL}"/>
<path d="{d_r}" fill="#FFFFFF"/>
<circle cx="{p0[0]}" cy="{p0[1]}" r="15" fill="{AMBER}"/>
{passos}
</svg>'''


def salvar(nome, svg, escala=2):
    open(f"{nome}.svg", "w", encoding="utf-8").write(svg)
    cairosvg.svg2png(bytestring=svg.encode(), write_to=f"{nome}.png", scale=escala)


_, _, claro = logo(NAVY, TEAL)
salvar("catalyser_logo_claro", claro)
_, _, escuro = logo("#EAF2F5", SEAFOAM, fundo="#121A21")
salvar("catalyser_logo_escuro", escuro)
salvar("catalyser_icone", icone(), escala=1)
print("ok")
