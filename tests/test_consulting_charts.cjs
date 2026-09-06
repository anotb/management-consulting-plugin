'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { bridgeSegments, addWaterfallChart } = require('../skills/client-deliverables/scripts/consulting-charts.cjs');
const total = (label, value) => ({ label, value, kind: 'total' });
const change = (label, value) => ({ label, value, kind: 'change' });

test('bridge changes float from cumulative totals', () => {
  const result = bridgeSegments([total('Open', 100), change('Growth', 30), change('Churn', -10), total('Close', 120)]);
  assert.deepEqual(result.map(s => [s.start, s.end]), [[0, 100], [100, 130], [130, 120], [0, 120]]);
});
test('negative opening, crossing zero, subtotal and zero change', () => {
  const result = bridgeSegments([total('Open', -10), change('Recovery', 30), {label: 'Subtotal', kind: 'subtotal'}, change('Flat', 0), change('Loss', -40), total('Close', -20)]);
  assert.deepEqual(result.map(s => [s.low, s.high]), [[-10, 0], [-10, 20], [0, 20], [20, 20], [-20, 20], [-20, 0]]);
});
test('invalid inputs and nonreconciling totals fail', () => {
  for (const items of [[], [change('Open', 10), total('End', 10)], [total('Open', 1), total('End', 3)], [total('Open', NaN), change('Next', 1)], [total('Open', 0), change('', 1)], [total('Open', 1), change('Next', Infinity)], [total('Open', 1), {label:'Other',kind:'subtotal',value:2}]]) {
    assert.throws(() => bridgeSegments(items));
  }
});
test('floating point reconciliation tolerates arithmetic roundoff', () => {
  assert.doesNotThrow(() => bridgeSegments([total('Open', 0.1), change('Change', 0.2), total('Close', 0.3)]));
});
test('shape geometry encodes increases, declines and connectors within the chart box', () => {
  const shapes = [], texts = [];
  const slide = { addShape: (type, opts) => shapes.push({type, ...opts}), addText: (text, opts) => texts.push({text, ...opts}) };
  const pptx = { ShapeType: {line:'line',rect:'rect'} };
  addWaterfallChart(pptx, slide, {x:1,y:1,w:10,h:5,items:[total('Open',100),change('Growth',30),change('Churn',-10),total('Close',120)]});
  const bars = shapes.filter(s => s.type === 'rect');
  assert.equal(bars.length, 4);
  assert.ok(Math.abs((bars[0].y - bars[1].y) - bars[1].h) < 1e-9);
  assert.ok(Math.abs(bars[1].y - bars[2].y) < 1e-9);
  assert.ok(Math.abs(bars[3].y - (bars[2].y + bars[2].h)) < 1e-9);
  assert.equal(texts[2].text, '+30');
  assert.equal(texts[4].text, '-10');
  for (const s of [...shapes,...texts]) {
    assert.ok(s.x >= 1 && s.y >= 1 && s.x+s.w <= 11+1e-9 && s.y+s.h <= 6+1e-9);
  }
});
test('all-zero bridge draws finite zero lines and rejects unusable layouts', () => {
  const shapes = [];
  const slide = {addShape: (type, opts) => shapes.push(opts), addText: () => {}};
  const pptx = {ShapeType:{line:'line',rect:'rect'}};
  const options = {x:0,y:0,w:3,h:2,items:[total('Open',0),total('Close',0)]};
  addWaterfallChart(pptx, slide, options);
  assert.ok(shapes.every(s => [s.x,s.y,s.w,s.h].every(Number.isFinite)));
  assert.throws(() => addWaterfallChart(pptx, slide, {...options, h:0.5}));
  assert.throws(() => addWaterfallChart(pptx, slide, {...options, w:0}));
  assert.throws(() => addWaterfallChart(pptx, slide, {...options, fontSize:100}));
  assert.doesNotThrow(() => addWaterfallChart(pptx, slide, {...options, w:1.5}));
});
