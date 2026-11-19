// three-medir.mjs — conta quantas vezes uma cena Three.js desenha (window.__renders) em quatro situações:
//   parado      2 s sem mexer na rolagem, com a cena na tela      → tem de ser 0
//   rolando     a rolagem atravessa a cena em 30 passos            → tem de ser > 0
//   fora        a cena saiu da tela e a rolagem continua           → tem de ser 0
//   reduzir     com "reduzir movimento" ligado, abrir e rolar tudo → 1 (um quadro só)
// e lê o teto de densidade (window.__dpr) numa tela de celular com densidade 3.
// Uso: node three-medir.mjs <url>      Sai 0 com "OK: …", 1 com "FALHA: …".
import { chromium } from 'playwright';
import pw from 'playwright/package.json' with { type: 'json' };

const url = process.argv[2];
if (!url) { console.log('uso: node three-medir.mjs <url>'); process.exit(2); }
const browser = await chromium.launch();
let rc = 0;
const espera = (page, ms) => page.waitForTimeout(ms);
async function abrir(opcoes) {
  const ctx = await browser.newContext({ viewport: { width: 1366, height: 768 }, ...opcoes });
  const page = await ctx.newPage();
  await page.goto(url, { waitUntil: 'load' });
  await page.waitForFunction(() => window.__ready === true, null, { timeout: 15000 });
  return page;
}
const renders = (page) => page.evaluate(() => window.__renders ?? 0);
async function rolar(page, de, ate, passos = 30) {
  for (let i = 0; i <= passos; i++) {
    await page.evaluate((y) => scrollTo(0, y), de + (ate - de) * i / passos);
    await espera(page, 40);
  }
}
try {
  console.log(`Chromium ${browser.version()} (Playwright ${pw.version})`);
  const page = await abrir({});
  const g = await page.evaluate(() => {
    const el = document.getElementById('cena');
    const top = el.getBoundingClientRect().top + scrollY;
    return { top, fimCena: top + el.offsetHeight - innerHeight, fim: document.documentElement.scrollHeight - innerHeight };
  });
  // entra na cena e espera assentar
  await rolar(page, 0, g.top, 10); await espera(page, 500);
  let r0 = await renders(page); await espera(page, 2000);
  const parado = (await renders(page)) - r0;
  r0 = await renders(page); await rolar(page, g.top, g.fimCena);
  const rolando = (await renders(page)) - r0;
  // sai da cena (passa do fim dela), espera o observador perceber, e rola mais sem a cena na tela
  await rolar(page, g.fimCena, g.fim - 200, 10); await espera(page, 500);
  r0 = await renders(page); await rolar(page, g.fim - 200, g.fim, 20);
  const fora = (await renders(page)) - r0;
  await page.context().close();

  const pr = await abrir({ reducedMotion: 'reduce' });
  await rolar(pr, 0, g.fim, 20);
  const reduzir = await renders(pr);
  await pr.context().close();

  const pc = await abrir({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 3, isMobile: true });
  const dpr = await pc.evaluate(() => window.__dpr);
  await pc.context().close();

  console.log(`parado ${parado} · rolando ${rolando} · fora da tela ${fora} · reduzir ${reduzir} · DPR ${String(dpr).replace('.', ',')} (tela com densidade 3)`);
  const falhas = [];
  if (parado > 0) falhas.push(`desenhou ${parado} vezes parado (devia ser 0)`);
  if (rolando === 0) falhas.push('não desenhou nada ao rolar');
  if (fora > 0) falhas.push(`desenhou ${fora} vezes fora da tela (devia ser 0)`);
  if (reduzir !== 1) falhas.push(`com reduzir movimento desenhou ${reduzir} vezes (devia ser 1)`);
  if (dpr > 1.5) falhas.push(`densidade ${dpr} passa do teto de 1,5`);
  if (falhas.length) { falhas.forEach((f) => console.log('FALHA: ' + f)); rc = 1; }
  else console.log(`OK: parado 0 · rolando ${rolando} · fora da tela 0 · reduzir 1 · DPR ${String(dpr).replace('.', ',')}`);
} catch (e) {
  console.log('FALHA: ' + e.message); rc = 1;
} finally {
  await browser.close();
}
process.exit(rc);
