K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
curl -s -o /dev/null -w "%{http_code}\n" https://linnoff88-dev.github.io/arckhe-/kit/site/
node "$K/scripts/verificar.mjs" https://linnoff88-dev.github.io/arckhe-/kit/site/; echo "saída: $?"
