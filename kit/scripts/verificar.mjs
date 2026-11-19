// verificar.mjs — abre a página num Chromium sem tela e confere o filme da rolagem pelo contrato de teste:
//   ?jump=<y> posiciona a rolagem antes de tudo; window.__ready diz "já posicionei e desenhei".
// Uso: node verificar.mjs <url> [--celular] [--reduzir]
//   (padrão)   1366×768: rolagem em 0 %, 50 % e 100 % do trilho → quadro esperado e tela pintada
//   --celular  390×844, celular em pé: confere que a página escolheu o filme vertical (frames-v)
//   --reduzir  com "reduzir movimento" ligado no sistema: o filme tem de ficar parado (mesmo quadro)
// Sai 0 com "OK: …"; 1 com "FALHA: …". Não chama modelo nem serviço pago.
import { chromium } from 'playwright';
import pw from 'playwright/package.json' with { type: 'json' };

const args = process.argv.slice(2);
const url = args.find((a) => !a.startsWith('--'));
const CEL = args.includes('--celular');
const RED = args.includes('--reduzir');
if (!url) { console.log('uso: node verificar.mjs <url> [--celular] [--reduzir]'); process.exit(2); }

const tela = CEL ? { width: 390, height: 844 } : { width: 1366, height: 768 };
const browser = await chromium.launch();
let rc = 0;
try {
  const ctx = await browser.newContext({
    viewport: tela, deviceScaleFactor: CEL ? 2 : 1, isMobile: CEL, hasTouch: CEL,
    reducedMotion: RED ? 'reduce' : 'no-preference',
  });
  const page = await ctx.newPage();
  const erros = [];
  page.on('pageerror', (e) => erros.push(e.message));
  console.log(`Chromium ${browser.version()} (Playwright ${pw.version}) · ${tela.width}×${tela.height}${RED ? ' · reduzir movimento' : ''}`);

  // Abre na posição y e espera o contrato: __ready verdadeiro e o canvas com o 1º desenho.
  async function abrir(y) {
    const u = new URL(url); u.searchParams.set('jump', String(Math.round(y)));
    await page.goto(u.href, { waitUntil: 'load' });
    try {
      await page.waitForFunction(() => window.__ready === true, null, { timeout: 15000 });
    } catch {
      throw new Error('a página não marcou window.__ready em 15 s (falta o contrato ?jump + __ready)');
    }
    await page.waitForFunction(() => document.getElementById('tela')?.dataset.pronto === '1', null, { timeout: 15000 })
      .catch(() => { throw new Error('o canvas não desenhou nenhum quadro em 15 s'); });
    await page.waitForTimeout(300);
    return page.evaluate(() => {
      // reduz o canvas para 64×36 e pega o ponto mais claro: tela "pintada" = algo acima do preto do fundo
      const c = document.getElementById('tela');
      const mini = Object.assign(document.createElement('canvas'), { width: 64, height: 36 });
      const g = mini.getContext('2d');
      g.drawImage(c, 0, 0, 64, 36);
      const d = g.getImageData(0, 0, 64, 36).data;
      let max = 0;
      for (let i = 0; i < d.length; i += 4) max = Math.max(max, 0.2126 * d[i] + 0.7152 * d[i + 1] + 0.0722 * d[i + 2]);
      const f = window.__filme;
      return { quadro: Math.round(f.frame), pintada: max > 30, info: window.__filmeInfo,
        transborda: document.documentElement.scrollWidth > innerWidth + 1 };
    });
  }

  const geo = await (async () => {
    await page.goto(url, { waitUntil: 'load' });
    return page.evaluate(() => {
      const el = document.querySelector('[data-filme]');
      const top = el.getBoundingClientRect().top + scrollY;
      return { top, span: el.offsetHeight - innerHeight, fim: document.documentElement.scrollHeight - innerHeight };
    });
  })();

  const pontos = [0, 0.5, 1];
  const lidos = [];
  for (const p of pontos) {
    // parado, o trilho encolhe: rola pela página inteira para provar que o quadro não muda
    const y = geo.span > 0 ? geo.top + p * geo.span : p * geo.fim;
    lidos.push({ p, ...(await abrir(y)) });
  }
  const info = lidos[0].info;
  console.log(`quadros: ${info.count} (${info.dir}/)`);
  for (const l of lidos) console.log(`rolagem ${Math.round(l.p * 100)}% → quadro ${l.quadro} · ${l.pintada ? 'tela pintada' : 'tela preta'}`);
  console.log(`transbordo horizontal: ${lidos.some((l) => l.transborda) ? 'sim' : 'não'}`);
  if (erros.length) console.log(`erro de JS: ${erros[0]}`);

  const falhas = [];
  if (lidos.some((l) => !l.pintada)) falhas.push('tela preta numa das posições');
  if (lidos.some((l) => l.transborda)) falhas.push('a página transborda na horizontal');
  if (erros.length) falhas.push('erro de JavaScript na página');
  if (CEL && info.dir !== 'frames-v') falhas.push(`no celular em pé a página usou ${info.dir}/, não o filme vertical (frames-v/)`);
  const quadros = lidos.map((l) => l.quadro);
  if (RED) {
    if (new Set(quadros).size > 1) falhas.push(`com reduzir movimento o filme ainda anda (quadro ${quadros.join(' → ')})`);
    else console.log(`reduzir movimento: parado (quadro ${quadros[0]} em 0%, 50% e 100%)`);
  } else {
    const esperado = pontos.map((p) => Math.round(p * (info.count - 1)));
    const fora = lidos.filter((l, i) => Math.abs(l.quadro - esperado[i]) > 2);
    if (fora.length) falhas.push(`quadro fora do esperado em ${fora.map((l) => Math.round(l.p * 100) + '%').join(', ')} (esperava ${esperado.join(', ')})`);
  }
  if (CEL && !falhas.length) console.log(`celular: ${info.dir} (filme vertical) · ${tela.width}×${tela.height}`);
  if (falhas.length) { falhas.forEach((f) => console.log('FALHA: ' + f)); rc = 1; }
  else console.log(`OK: ${pontos.length} de ${pontos.length} posições`);
} catch (e) {
  console.log('FALHA: ' + e.message); rc = 1;
} finally {
  await browser.close();
}
process.exit(rc);
