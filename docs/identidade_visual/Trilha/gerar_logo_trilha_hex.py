"""Logo TRilha: o R em destaque (selo) no meio da palavra, com trilha ondulada."""
import math
exec(open("gerar_logo.py").read().split("def logo(")[0])   # reaproveita fontes e funções

SANS_B = TTFont(f"{FONTES}/source-sans-3/files/source-sans-3-latin-600-normal.woff2")

def logo_trilha(cor_nome, cor_slogan, fundo=None, forma="quadrado", cor_r=TEAL, cor_studio="#5B6B78"):
    x0, base, tam = 40, 150, 104
        # 1. a palavra Trilha
    d_t, larg_t = texto(SERIF, "Trilha", x0, base, tam, espaco=-0.005)
    cap = bbox_glifo(SERIF, "T", tam)[3]
    # 2. o R serifado dentro de um círculo da paleta, colado ao nome
    diam = cap + 30
    cx0 = x0 + larg_t + 24
    cy0 = base - cap - 15
    tam_r = tam * 0.84
    bx = bbox_glifo(SERIF_R, "R", tam_r)
    rx = cx0 + (diam - (bx[2] - bx[0])) / 2 - bx[0]
    ry = cy0 + diam / 2 + (bx[3] + bx[1]) / 2
    d_r, _ = texto(SERIF_R, "R", rx, ry, tam_r)
    # hexágono de ponta para cima, centrado onde estava o círculo
    hx, hy, hr = cx0 + diam / 2, cy0 + diam / 2, diam / 2 * 1.1
    vert = [(hx + hr * math.cos(math.radians(a)), hy + hr * math.sin(math.radians(a))) for a in range(-90, 270, 60)]
    selo = '<polygon points="' + " ".join(f"{x:.1f},{y:.1f}" for x, y in vert) + f'" fill="{cor_r}" stroke="{cor_r}" stroke-width="8" stroke-linejoin="round"/>'
    # 3. Studio em sans, mais leve, alinhado à base
    d_ilha, larg_st = texto(SANS, "Studio", cx0 + diam + 24, base, tam * 0.62)
    fim = cx0 + diam * 0.5 - diam * 0.5 * math.sin(math.radians(35)) + 6
    # 4. trilha ondulada: da pergunta (ponto âmbar) ao relatório (ponto final)
    # chegada: meio da aresta inferior esquerda do hexágono, um pouco por fora
    ang = math.radians(30)
    dist = hr * math.cos(math.radians(30)) + 12
    xt = hx - dist * math.sin(ang)
    yt = hy + dist * math.cos(ang)
    xa, xb, ya = x0 + 22, xt, base + 46
    pts = []
    for i in range(81):
        t = i / 80
        x = xa + (xb - xa) * t
        y = ya - 20 * math.sin(math.pi * 2.5 * t) * (1 - 0.35 * t) + (yt - (ya - 13)) * t
        pts.append(f"{x:.1f},{y:.1f}")
    trilha_svg = (f'<polyline points="{" ".join(pts)}" fill="none" stroke="{SEAFOAM}" stroke-width="5" '
                  f'stroke-dasharray="14 10" stroke-linecap="round" stroke-linejoin="round"/>')
    xf, yf = pts[-1].split(",")
    d_s1, larg_1 = texto(SANS_B, "Da pergunta ao relatório,", x0 + 2, base + 108, 32)
    d_s2, larg_2 = texto(SANS_B, "uma só trilha em R", x0 + 2, base + 148, 32)
    d_slogan, larg_s = d_s1 + d_s2, max(larg_1, larg_2)
    largura = max(cx0 + diam * 1.1, x0 + larg_s) + 40
    altura = base + 176
    bg = f'<rect width="100%" height="100%" fill="{fundo}"/>' if fundo else ""
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {largura:.0f} {altura:.0f}" width="{largura:.0f}" height="{altura:.0f}">
<title>Trilha: da pergunta ao relatório, uma só trilha</title>
{bg}
<path d="{d_t}" fill="{cor_nome}"/>
{selo}
<path d="{d_r}" fill="#FFFFFF"/>
{trilha_svg}
<circle cx="{x0+10}" cy="{ya}" r="8" fill="{AMBER}"/>
<path d="{d_slogan}" fill="{cor_slogan}"/>
</svg>'''

def salvar(nome, svg, escala=2):
    open(f"{nome}.svg", "w", encoding="utf-8").write(svg)
    cairosvg.svg2png(bytestring=svg.encode(), write_to=f"{nome}.png", scale=escala)


for forma in ["quadrado"]:
    salvar(f"trilha_hex_claro", logo_trilha(NAVY, TEAL, forma=forma))
    salvar(f"trilha_hex_escuro", logo_trilha("#EAF2F5", SEAFOAM, fundo="#121A21", forma=forma, cor_r=TEAL, cor_studio="#A9B8C2"))
print("ok")
