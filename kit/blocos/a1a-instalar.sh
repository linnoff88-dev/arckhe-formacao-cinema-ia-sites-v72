cd ~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
npm ci --no-audit --no-fund > ${TMPDIR:-/tmp}/npm-sites.log 2>&1; echo "npm ci: $?"
npx playwright install chromium > ${TMPDIR:-/tmp}/pw-sites.log 2>&1; echo "chromium: $?"
npx playwright --version
npm ls --depth=0 | tail -2
ffmpeg -version | head -1 | cut -d' ' -f1-3
