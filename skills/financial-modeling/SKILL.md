---
name: financial-modeling
description: "Build auditable financial models and business cases for investment, valuation, cost-benefit, and build-versus-buy decisions. Use for cash-flow projections, NPV, IRR, ROI, payback, TCO, break-even, and sensitivity analysis."
license: MIT
metadata:
  category: problem-solving
  version: "2.2.0"
  author: Anot
---

# Financial Modeling

Build the financial evidence for the user's decision. Work at the requested scope: checking a calculation, comparing investments, constructing a workbook, or valuing a business. Preserve supplied assumptions, horizons, conventions, and approved decisions; challenge a material inconsistency explicitly.

## Establish the model basis

Use provided data first. Identify missing drivers and continue portions they do not block. Ask when a missing input prevents a defensible result; otherwise show a disclosed assumption, range, or symbolic formula. Keep hypothetical examples separate from client estimates. Never invent costs, forecasts, benchmarks, or evidence for a benefit.

For the model being built, define relevant conventions: currency and units, valuation date, cash-flow timing, horizon, baseline, inflation treatment, taxes, financing, working capital, and terminal value. Compare options on the same basis. Historical actuals, supplied forecasts, sourced estimates, and unsupported placeholders remain distinguishable.

Maintain one source for each assumption. Record its value, unit, period, basis, source, and limitation in a register when the model's size warrants one; for a short calculation, put the assumptions beside the result. Treat a management forecast as a forecast even if it arrives in a polished workbook.

## Model the incremental economics

Calculate cash flows relative to the stated baseline. Include continuing the current course or deferral when relevant, without reopening an approved choice just to add an option. Avoid counting the same benefit as labor savings, productivity, and revenue uplift. Separate time released, usable capacity, realized cash savings, and additional output.

Use [cash-flow and return conventions](references/cash-flow-conventions.md) for calculations and [technology and TCO economics](references/technology-and-tco.md) for build-versus-buy, automation, or AI investments. Use [valuation and uncertainty methods](references/valuation-and-risk.md) only when DCF, scenario probabilities, Monte Carlo, EVA, MIRR, or options are relevant.

Use available calculation tools for material arithmetic. Show formulas and enough intermediate results to reproduce the answer. In a workbook, link outputs to inputs, keep assumptions separate from formulas, label units and periods, and make scenarios update the model consistently. Recalculate where tools allow and inspect the saved output; disclose if formula results could not be refreshed.

## Test the decision

Test funding feasibility separately from investment return. A positive NPV does not solve an interim cash shortfall. Examine payment timing, committed financing, capacity, and other hard constraints before recommending approval.

Find the inputs that can change the recommendation and vary them over plausible ranges. Show the break-even or switching threshold. Do not mechanically apply ±10%, increase discount rates because data is missing, or assign probabilities without a basis. Preserve conflicting sources and show their decision effect. Distinguish scenario assumptions from forecasts and avoid counting the same risk in both cash-flow haircuts and discount-rate adjustments without explaining why.

## Present and verify

Lead with the recommendation, investment, financial result, funding requirement, and principal limitation. Report only metrics that help this decision. Use compact numeric tables and explain assumptions beside them. State the downside being accepted and what would change the choice. Where essential evidence is absent, a conditional decision or deferral can be the supported answer.

Check signs, units, timing, totals, baseline treatment, cost and benefit overlap, terminal assumptions, and sensitivity direction. For file requests, deliver the working artifact and a concise explanation of how to change its assumptions. Do not claim independent verification or audit assurance beyond the checks performed.
