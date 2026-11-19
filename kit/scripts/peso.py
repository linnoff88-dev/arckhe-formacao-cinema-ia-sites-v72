#!/usr/bin/env python3
"""peso.py — quanto a página pesa para quem visita, e se cabe no orçamento.

Uso:  python3 peso.py <pasta-do-site> [--orcamento MB] [--inicial MB]

Cada visitante baixa UM filme: o horizontal (frames/) no computador ou o vertical (frames-v/) no
celular em pé. Por isso o peso sai por visitante:
  computador / celular  tudo o que essa pessoa baixa se rolar o filme inteiro
  primeira pintura      o que chega antes do 1º quadro aparecer: HTML, CSS, JS, fontes, imagens e o
                        quadro 1 (o motor do kit pinta o quadro 1 assim que ele chega)
  rascunho              primeira pintura + 1 quadro a cada 8 (o motor baixa esses primeiro, para
                        qualquer ponto da rolagem já ter um quadro perto)
Vídeo (.mp4/.webm) entra no total, não na primeira pintura (com preload="none" só baixa ao tocar).
--orcamento MB: teto para o maior dos dois visitantes; --inicial MB: teto para a primeira pintura do
mais pesado. Fora do teto = código 1. Não mede rede nem Core Web Vitals (isso é da Formação inemaSEO).
"""
import os
import re
import sys

QUADRO = re.compile(r"(^|/)(frames(-v)?)/f_(\d+)\.(jpg|jpeg|webp|avif)$")
TIPOS = [("vídeo", re.compile(r"\.(mp4|webm|mov)$")), ("js", re.compile(r"\.m?js$")),
         ("html/css", re.compile(r"\.(html|css|json)$")), ("fontes", re.compile(r"\.(woff2?|ttf|otf)$")),
         ("imagens", re.compile(r"\.(jpg|jpeg|png|webp|avif|svg|gif)$"))]


def mb(b):
    return f"{b / 1e6:.2f}".replace(".", ",")


def num(v):
    return str(v).replace(".", ",")


def main():
    args = sys.argv[1:]
    if not args or args[0].startswith("-"):
        print(__doc__.strip())
        return 2
    raiz = args[0]
    orc = float(args[args.index("--orcamento") + 1].replace(",", ".")) if "--orcamento" in args else None
    ini = float(args[args.index("--inicial") + 1].replace(",", ".")) if "--inicial" in args else None
    por_tipo, comum, video = {}, 0, 0
    filme = {"frames": [0, 0, 0], "frames-v": [0, 0, 0]}  # tudo, quadro 1, 1 em 8
    for d, subdirs, fs in os.walk(raiz):
        subdirs[:] = [s for s in subdirs if s != "node_modules" and not s.startswith(".")]
        for f in fs:
            cam = os.path.relpath(os.path.join(d, f), raiz).replace(os.sep, "/")
            tam = os.path.getsize(os.path.join(d, f))
            m = QUADRO.search(cam)
            if m:
                pasta, n = m.group(2), int(m.group(4))
                tipo = "quadros" if pasta == "frames" else "quadros-v"
                filme[pasta][0] += tam
                if n == 1:
                    filme[pasta][1] += tam
                if (n - 1) % 8 == 0:
                    filme[pasta][2] += tam
            else:
                tipo = next((t for t, rx in TIPOS if rx.search(cam)), "outros")
                if tipo == "vídeo":
                    video += tam
                else:
                    comum += tam
            por_tipo[tipo] = por_tipo.get(tipo, 0) + tam
    print("PESO: " + " · ".join(f"{t} {mb(b)}" for t, b in sorted(por_tipo.items(), key=lambda x: -x[1])) + " (MB)")
    vis = {}
    for nome, pasta in (("computador", "frames"), ("celular", "frames-v")):
        if filme[pasta][0] or nome == "computador":
            tudo, q1, r8 = filme[pasta]
            vis[nome] = (comum + video + tudo, comum + q1, comum + r8)
            print(f"{nome}: tudo {mb(vis[nome][0])} MB · primeira pintura {mb(vis[nome][1])} MB · rascunho (1 em 8) {mb(vis[nome][2])} MB")
    pior = max(vis.values(), key=lambda v: v[0])
    rc = 0
    if ini is not None:
        p1 = max(v[1] for v in vis.values())
        ok = p1 <= ini * 1e6
        print(f"primeira pintura {mb(p1)} MB · teto {num(ini)} MB: {'DENTRO' if ok else 'ACIMA'}")
        rc |= not ok
    if orc is not None:
        ok = pior[0] <= orc * 1e6
        print(f"visitante mais pesado {mb(pior[0])} MB · orçamento {num(orc)} MB: {'DENTRO do orçamento' if ok else 'ACIMA do orçamento'}")
        rc |= not ok
    return int(rc)


if __name__ == "__main__":
    sys.exit(main())
