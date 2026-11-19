// cenas-modelo.mjs — ensaio SEM modelo do filmarca: grava cada cena do roteiro.json como cena-modelo
// (os modelos prontos do próprio filmarca: abertura, titulo, numero, print, lista, cta), no lugar do passo
// "cenas", que pede ao modelo da sua assinatura para animar cada cena. Assim o render roda sem gastar nada.
// Uso: node cenas-modelo.mjs <pasta-do-filmarca> <pasta-do-filme>
//   a pasta do filme precisa de marca.json (do "filmarca dna") e roteiro.json (escrito por você ou pelo "roteiro").
import fs from 'node:fs';
import path from 'node:path';

const [fm, filme] = process.argv.slice(2).map((p) => p && path.resolve(p));
if (!fm || !filme) { console.log('uso: node cenas-modelo.mjs <pasta-do-filmarca> <pasta-do-filme>'); process.exit(2); }
const { MODELOS } = await import(path.join(fm, 'src/modelos.mjs'));
const { prepararAssets } = await import(path.join(fm, 'src/projeto.mjs'));
const roteiro = JSON.parse(fs.readFileSync(path.join(filme, 'roteiro.json'), 'utf8'));
const marca = JSON.parse(fs.readFileSync(path.join(filme, 'marca.json'), 'utf8'));
prepararAssets(filme);
const pasta = path.join(filme, 'cenas');
fs.mkdirSync(pasta, { recursive: true });
let total = 0;
for (const c of roteiro.cenas) {
  if (!(c.tipo in MODELOS)) { console.log(`FALHA: ${c.id} tem tipo "${c.tipo}"; os modelos são ${Object.keys(MODELOS).join(', ')}`); process.exit(1); }
  if (c.midia && !fs.existsSync(path.join(filme, c.midia))) { console.log(`FALHA: ${c.id} usa ${c.midia}, que não existe (rode o "dna" antes)`); process.exit(1); }
  const cena = { ...c, origem: 'modelo', versao: 1 };
  fs.writeFileSync(path.join(pasta, `${c.id}.v1.json`), JSON.stringify(cena, null, 2));
  fs.writeFileSync(path.join(pasta, `${c.id}.json`), JSON.stringify(cena, null, 2));
  total += c.duracao;
}
console.log(`cenas-modelo: ${roteiro.cenas.length} cenas · ${total.toFixed(1).replace('.', ',')} s · marca ${marca.nome} · logo ${marca.logo ?? 'nenhum'}`);
