/* site.js — liga os quadros ao motor de rolagem (vendor/motor-rolagem.js) e à chave Parado/Ligado
   (vendor/chave-movimento.js), os dois copiados do site-movimento (ARCKHÉ). Lê window.SITE:
     contrato: true  → marca window.__ready depois de posicionar (?jump=<y>) — é o que os testes esperam;
     reduzir:  true  → com "reduzir movimento" (ou a chave em Parado) o filme vira foto e o texto fica parado.
   Expõe window.__filme (motor) e window.__filmeInfo {dir, count, parado} para o verificar.mjs. */
(function () {
  var OP = window.SITE || { contrato: true, reduzir: true };
  var raiz = document.documentElement;
  var reduzido = matchMedia('(prefers-reduced-motion: reduce)').matches;
  var parado = function () { return OP.reduzir && (reduzido || (window.Movimento && !window.Movimento.mexendo)); };
  var secao = document.querySelector('[data-filme]');
  var batidas = [].slice.call(document.querySelectorAll('.batida'));
  var carregando = document.querySelector('.carregando');
  var VERT = matchMedia('(max-width: 719px) and (orientation: portrait)').matches;
  var base = secao.dataset.quadros || 'frames';

  function alfa(b, p) {
    var i = +b.dataset.in, pk = +b.dataset.peak, o = +b.dataset.out;
    if (p < i || p > o) return 0;
    if (p < pk) return (p - i) / Math.max(1e-4, pk - i);
    if (o > 1.5) return 1;
    return 1 - (p - pk) / Math.max(1e-4, o - pk);
  }
  function batidasEm(p) {
    if (raiz.classList.contains('parado')) return;
    batidas.forEach(function (b) {
      var a = alfa(b, p);
      b.style.opacity = a.toFixed(3);
      b.style.transform = 'translateY(' + ((1 - a) * 18).toFixed(1) + 'px)';
    });
  }
  function aplicarModo() { raiz.classList.toggle('parado', !!parado()); }
  aplicarModo();
  if (window.Movimento) window.Movimento.ao(function () { aplicarModo(); if (filme && !parado()) filme.settle(); });

  function manifesto(dir) {
    return fetch(dir + '/manifest.json').then(function (r) { if (!r.ok) throw r.status; return r.json(); })
      .then(function (m) { m.dir = dir; return m; });
  }
  var filme = null;
  (VERT ? manifesto(base + '-v').catch(function () { VERT = false; return manifesto(base); }) : manifesto(base)).then(function (m) {
    filme = MotionEngine.Scrub({
      canvas: document.getElementById('tela'), driver: secao, count: m.count, fps: m.fps || 24, dpr: 1,
      maxCrop: VERT ? 0.8 : 0.22, bg: '#0c0c10',
      frozen: parado,
      src: function (i) { return m.dir + '/f_' + String(i + 1).padStart(4, '0') + '.jpg'; },
      onProgress: function (p) { batidasEm(p); },
      onLoad: function (f) { if (carregando) carregando.textContent = f < 1 ? Math.round(f * 100) + '%' : ''; }
    });
    window.__filme = filme;
    window.__filmeInfo = { dir: m.dir, count: m.count, parado: !!parado() };
    var posicionar = function () { if (!parado()) filme.settle(); };
    if (OP.contrato) MotionEngine.ready(posicionar);
    else posicionar();
  }).catch(function (e) { console.error('manifest', e); if (OP.contrato) window.__ready = true; });
  batidasEm(0);
})();
