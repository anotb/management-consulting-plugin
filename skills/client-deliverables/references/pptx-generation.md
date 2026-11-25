# PowerPoint generation

Use the available presentation tooling and the client's template. This reference provides exhibit mechanics for code-generated PowerPoint files; it does not require PptxGenJS or replace a host's presentation workflow. Check the installed library's API before extending the example.

## Establish the canvas

Set dimensions, margins, grid, theme fonts, and colors explicitly. Reuse a supplied slide master when tooling supports it. Define a master before referring to its name; an undefined master can silently lose the intended formatting. Keep critical content inside the safe area and reserve space for sources, units, periods, and scenario labels.

Apply [slide design](slide-design.md) before turning the story into coordinates. Reuse typography and layout primitives without routing every slide through one factory composition. The bridge example below demonstrates the helper's API and arithmetic; choose the finished deck's composition from its argument and visual direction.

Design for the actual medium. A projected deck needs larger text and fewer elements than a read-ahead. Reduce content or split an exhibit before shrinking essential labels. Use editable text, tables, charts, and shapes where practical. Raster illustrations are appropriate when editability is not needed. Use the client's fonts when available and check font substitution in the renderer.

## Select an exhibit

| Decision or relationship | Implementation and semantic check |
|---|---|
| Executive summary | Answer and supporting evidence with an explicit decision request. Use the number of sections the argument needs. |
| Trend or comparison | Native line or bar chart with explicit period, units, denominator, and comparable categories. Bars normally start at zero. |
| Bridge or waterfall | Opening total, signed incremental drivers, and reconciled closing total. Changes float from the previous cumulative value. |
| Two-by-two | Define both axes, thresholds, evidence behind placement, and treatment of borderline items. A qualitative map is not a measured scatter plot. |
| Prioritization matrix | Apply feasibility constraints first; disclose weights and subjective scores. Sensitivity matters more than decorative precision. |
| Roadmap or Gantt | Scale positions and widths from dates; show dependencies, milestones, capacity constraints, and baseline versus forecast. Equal-width phase boxes are not a time-scaled schedule. |
| Before and after | Match definitions, periods, cohorts, and units. State what supports causality; do not attribute an observed change automatically to the intervention. |
| KPI or large number | Pair the value with its denominator, timeframe, target or comparator, source, and forecast/actual status. |
| Comparison table | Align numbers and units; disclose missing inputs. Split dense tables by the reader's decision. |
| RACI or governance | Preserve the meaning of accountable, responsible, consulted, and informed; validate decision authority rather than assigning it through a graphic. |
| Status or Harvey balls | Define the scale and add a text value or status label. Unknown is distinct from green; color and fill alone are insufficient. |

## Editable waterfall helper

When the user asks for an editable bridge or waterfall chart and PptxGenJS is available, write the helper below to `consulting-charts.cjs` in the working folder, beside the script that builds the deck. It exports `bridgeSegments(items)` and `addWaterfallChart(pptx, slide, options)`. It creates editable shapes, not a native chart with an embedded data workbook. Retain the input data and rerun after changing values; moving a bar manually does not update the arithmetic.

Each item has a `label` and `kind`: `total`, `change`, or `subtotal`. Start with a finite-valued total. A change contains a signed incremental `value`; a subtotal uses the accumulated value. A later total must reconcile with the accumulated value. The helper rejects inconsistent totals and supports negative opening totals, zero crossings, and zero changes. Convert all values to one display unit first. Colors indicate numeric increases and decreases; reverse their business meaning for measures such as costs where an increase is unfavorable.

<!-- file: consulting-charts.cjs -->
```javascript
'use strict';

// Editable PowerPoint shapes. The caller supplies its installed PptxGenJS instance.
// Keep the arithmetic independent of PowerPoint so it can be verified directly.
function bridgeSegments(items) {
  if (!Array.isArray(items) || items.length < 2) {
    throw new Error('A bridge needs an opening total and at least one other item.');
  }
  let current = 0;
  return items.map((item, index) => {
    if (!item || typeof item.label !== 'string' || !item.label.trim()) {
      throw new Error(`Item ${index} needs a label.`);
    }
    const { kind, value } = item;
    if (!['total', 'change', 'subtotal'].includes(kind) || (index === 0 && kind !== 'total')) {
      throw new Error('Start with a total; subsequent items are change, subtotal, or total.');
    }
    if ((kind !== 'subtotal' || value !== undefined) && !Number.isFinite(value)) {
      throw new Error(`Item ${index} needs a finite value.`);
    }
    let start;
    let end;
    if (index === 0) {
      start = 0;
      end = value;
      current = value;
    } else if (kind === 'change') {
      start = current;
      end = current + value;
      current = end;
    } else {
      const tolerance = 1e-9 * Math.max(1, Math.abs(current), Math.abs(value || 0));
      if (value !== undefined && Math.abs(value - current) > tolerance) {
        throw new Error(`Total "${item.label}" does not reconcile: expected ${current}, received ${value}.`);
      }
      start = 0;
      end = current;
    }
    if (!Number.isFinite(end)) throw new Error('Bridge cumulative value overflowed.');
    return { label: item.label, kind, start, end, low: Math.min(start, end),
      high: Math.max(start, end), value: kind === 'change' ? value : end };
  });
}

function addWaterfallChart(pptx, slide, options) {
  const { items, x, y, w, h, fontFace = 'Arial', fontSize = 14,
    totalColor = '243746', increaseColor = '217A65', decreaseColor = 'B04436',
    textColor = '243746', lineColor = '89949E',
    formatValue = value => String(Number(value.toPrecision(6))) } = options;
  if (![x, y, w, h, fontSize].every(Number.isFinite) || x < 0 || y < 0 ||
      w <= 0 || h <= 0 || fontSize <= 0) {
    throw new Error('Supply a nonnegative origin, positive dimensions, and a positive font size.');
  }
  if (typeof formatValue !== 'function') throw new Error('formatValue must be a function.');
  const segments = bridgeSegments(items);
  const shape = pptx.ShapeType;
  const valueHeight = fontSize / 72 * 1.3;
  const labelHeight = fontSize / 72 * 2.4;
  const gap = 0.08;
  const plotTop = y + valueHeight + gap;
  const plotBottom = y + h - labelHeight - gap;
  if (plotBottom <= plotTop) throw new Error('Chart height leaves no plot area after the labels; enlarge it or reduce the font size.');
  const lower = Math.min(0, ...segments.map(s => s.low));
  const upper = Math.max(0, ...segments.map(s => s.high));
  const range = upper - lower || 1;
  const minimum = lower - range * 0.15;
  const maximum = upper + range * 0.15;
  const yAt = value => plotBottom - (value - minimum) / (maximum - minimum) * (plotBottom - plotTop);
  const step = w / segments.length;
  const barWidth = step * 0.62;
  slide.addShape(shape.line, { x, y: yAt(0), w, h: 0, line: { color: lineColor, width: 0.7 } });
  segments.forEach((segment, index) => {
    const barX = x + index * step + (step - barWidth) / 2;
    const top = yAt(segment.high);
    const bottom = yAt(segment.low);
    const color = segment.kind !== 'change' ? totalColor : segment.value >= 0 ? increaseColor : decreaseColor;
    if (bottom === top) {
      slide.addShape(shape.line, { x: barX, y: top, w: barWidth, h: 0, line: { color, width: 1.5 } });
    } else {
      slide.addShape(shape.rect, { x: barX, y: top, w: barWidth, h: bottom - top,
        line: { color, transparency: 100 }, fill: { color },
        altText: `${segment.label}: ${segment.start} to ${segment.end}` });
    }
    const prefix = segment.kind === 'change' && segment.value > 0 ? '+' : '';
    slide.addText(prefix + formatValue(segment.value), { x: x + index * step, y: top - valueHeight,
      w: step, h: valueHeight, margin: 0, fontFace, fontSize, color: textColor, align: 'center', breakLine: false });
    slide.addText(segment.label, { x: x + index * step, y: y + h - labelHeight,
      w: step, h: labelHeight, margin: 0.02, fontFace, fontSize, color: textColor, align: 'center', valign: 'top' });
    if (index < segments.length - 1) {
      slide.addShape(shape.line, { x: barX + barWidth, y: yAt(segment.end),
        w: step - barWidth, h: 0, line: { color: lineColor, width: 0.7, dashType: 'dash' } });
    }
  });
  return segments;
}

module.exports = { bridgeSegments, addWaterfallChart };
```

Example using a separately installed PptxGenJS package, saved beside `consulting-charts.cjs`:

```javascript
const pptxgen = require('pptxgenjs');
const { addWaterfallChart } = require('./consulting-charts.cjs');

async function main() {
  const pptx = new pptxgen();
  pptx.layout = 'LAYOUT_WIDE';
  pptx.author = 'Example';
  pptx.subject = 'Illustrative bridge, not client results';
  pptx.theme = { headFontFace: 'Arial', bodyFontFace: 'Arial', lang: 'en-US' };
  const slide = pptx.addSlide();
  slide.addText('Illustration: growth lifts revenue from 100 to 120', {
    x: 0.6, y: 0.35, w: 12.1, h: 0.7, fontSize: 28, fontFace: 'Arial',
    color: '243746', margin: 0
  });
  addWaterfallChart(pptx, slide, {
    x: 0.8, y: 1.6, w: 11.6, h: 4.6, fontSize: 18,
    items: [
      { label: 'Opening', kind: 'total', value: 100 },
      { label: 'Growth', kind: 'change', value: 30 },
      { label: 'Churn', kind: 'change', value: -10 },
      { label: 'Closing', kind: 'total', value: 120 }
    ]
  });
  slide.addText('Source: illustrative data. Units: revenue index.', {
    x: 0.6, y: 6.8, w: 12, h: 0.3, fontSize: 12, color: '52616B', margin: 0
  });
  await pptx.writeFile({ fileName: 'illustrative-bridge.pptx' });
}
main().catch(error => { console.error(error); process.exitCode = 1; });
```

The helper does not lay out the whole deck, measure text, or guarantee that long labels fit. Keep category labels short and inspect them at the intended reading size. Supply `formatValue` for currency or percentage formatting without changing the underlying values. Units and percentage-point changes must remain explicit.

## Verify the saved file

Reopen or parse the PPTX and render it with an available PowerPoint-compatible renderer. Inspect every slide for clipping, overlap, substitution, contrast, legibility, source notes, and unintended page elements. Check title claims against underlying data and calculations. For bridges, verify opening plus changes equals closing, each floating bar's start and end, subtotal treatment, and zero crossings. The rectangle's geometry must encode the calculation.

Inspect the deck in the intended application when available, since renderers differ. If only structural checks are possible, state that visual validation remains incomplete. Fix affected slides and render them again before delivering. The [PptxGenJS shape API](https://gitbrent.github.io/PptxGenJS/docs/api-shapes/) documents the optional adapter's primitives.
