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
