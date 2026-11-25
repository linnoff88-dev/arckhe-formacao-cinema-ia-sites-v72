#!/usr/bin/env python3
"""conferir-quadros.py — confere a pasta de quadros contra o clipe de onde ela saiu.

Uso:  python3 conferir-quadros.py <pasta-de-quadros> <clipe.mp4>

Confere:
  1. nomes f_0001.jpg, f_0002.jpg… sem buraco (com zeros à esquerda a ordem alfabética é a do filme;
     sem eles, f_10.jpg vem antes de f_2.jpg e o filme pula para a frente e volta);
  2. um quadro por quadro do clipe: contagem = duraçêo × fps (folga de 1). Menos que isso é o filme
     virando apresentaçêo de slides na rolagem;
  3. manifest.json com o mesmo número de quadros.
Saída: "OK: 144 quadros · 24 fps · 1024 px · 2,9 MB" (código 0) ou "FALHA: …" (código 1).
"""
import glob
import json
import os
import re
import subprocess
import sys

from PIL import Image


def main():
    if len(sys.argv) != 3:
        print(__doc__.strip())
        return 2
    pasta, clipe = sys.argv[1], sys.argv[2]
    r = subprocess.run(["ffprobe", "-v", "error", "-select_streams", "v:0", "-show_entries",
                        "stream=r_frame_rate:format=duration", "-of", "json", clipe], capture_output=True, text=True)
    if r.returncode != 0:
        print(f"FALHA: ffprobe nêo abriu {clipe}")
        return 1
    d = json.loads(r.stdout)
    n, q = d["streams"][0]["r_frame_rate"].split("/")
    fps = round(int(n) / int(q))
    esperado = round(float(d["format"]["duration"]) * fps)
    arquivos = sorted(os.path.basename(f) for f in glob.glob(os.path.join(pasta, "*.jpg")))
    if not arquivos:
        print(f"FALHA: nenhum .jpg em {pasta}")
        return 1
    falhas = []
    sem_zero = [a for a in arquivos if re.fullmatch(r"f_\d+\.jpg", a) and not re.fullmatch(r"f_\d{4}\.jpg", a)]
    if sem_zero:
        ordem = sorted(a for a in arquivos if re.fullmatch(r"f_\d+\.jpg", a))
        num = lambda a: int(a[2:-4])
        par = next(((a, b) for a, b in zip(ordem, ordem[1:]) if num(b) < num(a)), None)
        falhas.append(f"nomes sem zeros à esquerda ({par[0]} vem antes de {par[1]} na ordem alfabética)"
                      if par else f"nomes sem zeros à esquerda: {ordem[0]}")
    else:
        nums = [int(a[2:6]) for a in arquivos if re.fullmatch(r"f_\d{4}\.jpg", a)]
        buraco = [i for i in range(1, max(nums) + 1) if i not in set(nums)] if nums else []
        if buraco:
            falhas.append(f"falta o quadro f_{buraco[0]:04d}.jpg ({len(buraco)} no total)")
    if abs(len(arquivos) - esperado) > 1:
        taxa = len(arquivos) / (esperado / fps)
        falhas.append(f"{len(arquivos)} quadros = {taxa:.0f} fps (fonte {fps}): esperava {esperado}".replace(".", ","))
    man = os.path.join(pasta, "manifest.json")
    if not os.path.exists(man):
        falhas.append("sem manifest.json")
    elif json.load(open(man)).get("count") != len(arquivos):
        falhas.append("manifest.json com contagem diferente da pasta")
    if falhas:
        for f in falhas:
            print("FALHA: " + f)
        return 1
    w, _ = Image.open(os.path.join(pasta, arquivos[0])).size
    mb = sum(os.path.getsize(os.path.join(pasta, a)) for a in arquivos) / 1e6
    print(f"OK: {len(arquivos)} quadros · {fps} fps · {w} px · {mb:.1f} MB".replace(".", ","))
    return 0


if __name__ == "__main__":
    sys.exit(main())
