# Revisão independente — Sites cARCKHÉtográficos (19/10/2026)

Revisor: subagente que não escreveu o curso, com o BRIEF, o CURRICULO, a AUDITORIA e a PESQUISA da formação. Ele só leu os arquivos (não editou nada) e conferiu o kit com `resolver-kit.py --conferir`.

## 1ª leitura: 7,5/10

**Graves:**
1. As abas "Erro comum" mostravam só a saída, sem o bloco que a gerou (a1d, a3c, a4b, a7b), e três práticas mandavam rodar esse bloco.
2. A saída a8b (página publicada) era provisória e estava com o selo "real".
3. O verificar.mjs depende de ganchos do kit (`[data-filme]`, `#tela`, `window.__filme`, `__filmeInfo`), mas o prompt da Lane A dizia que ele conferia qualquer página feita pela skill.
4. O peso do Three.js (2,12 MB, arquivos brutos) era comparado ao filme, que não comprime.

**Menores:** 1,53 contra 1,54 MB; "duas skills (aula 3)"; faixa de -q:v desencontrada; Node 20.10+; versão do Kling; caminho de skills do Codex; nomes de bloco no PLANO; primeira pintura é um teto.

**Correções feitas:**
1. Os quatro blocos de erro viraram blocos copiáveis, e as práticas passaram a citar o bloco pelo nome.
2. A saída a8b foi capturada contra a URL do Pages depois do push.
3. O prompt manda partir de kit/site e manter os ganchos. A página feita do zero confere com o verify.js da skill.
4. O a4a passou a medir o gzip -9 (415.205 bytes). O texto dá 2,12 MB brutos e 0,42 MB com gzip, sem comparar com o filme.
5. Todos os menores foram corrigidos.

## 2ª leitura: 8,5/10

Os graves 1, 3 e 4 estão resolvidos e o resolver dá 32/32. O grave 2 fica resolvido com a captura depois da publicação.

NOTA FINAL: 8,5/10
