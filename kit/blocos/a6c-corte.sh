K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a6; SM=$E/site-movimento/skill/site-movimento/scripts
# um clipe com corte escondido no meio: a lente no estúdio escuro e, de repente, no fundo claro
bash "$K/scripts/clipe.sh" "$K/exemplos/lente.jpg" "$E/a.mp4" 2 1.0 1.1
bash "$K/scripts/clipe.sh" "$K/exemplos/lente-clara.jpg" "$E/b.mp4" 2 1.1 1.2
ffmpeg -v error -y -i "$E/a.mp4" -i "$E/b.mp4" -filter_complex "[0:v][1:v]concat=n=2:v=1[v]" -map "[v]" -c:v libx264 -crf 18 "$E/c3.mp4"
python3 "$SM/cortes.py" "$E/c3.mp4" | sed "s#$E/##"; echo "saída: ${PIPESTATUS[0]}"
