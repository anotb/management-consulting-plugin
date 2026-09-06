# Cash-flow and return conventions

## Comparable cash flows

State the currency, valuation date, period length, and whether flows occur at period start, end, or actual dates. Model costs as negative and receipts as positive. Include initial investment at time zero. Use incremental flows against the baseline; exclude sunk costs from a forward choice while disclosing relevant constraints they created.

Distinguish capex, operating expenses, depreciation, tax effects, working-capital investment, and financing. An increase in operating working capital consumes cash; its release supplies cash. Do not assume recovery at the horizon without a basis. Avoid deducting capex again from free cash flows already defined after capex.

Match nominal flows to a nominal rate and real flows to a real rate in the same currency. Match cash flow to the relevant capital provider: unlevered free cash flow and WACC for enterprise value, equity cash flow and cost of equity for equity value. Financing receipts are not operating benefits. For acquisition equity value, bridge from enterprise value using the relevant debt, cash, and other agreed adjustments once.

## Metrics

| Metric | Calculation | Qualification |
|---|---|---|
| NPV | `sum(CF_t / (1+r)^t)` including time zero | Use a rate matching the flows and period. Many spreadsheet NPV functions assume the first argument flow is at period 1, so add time-zero cash separately. For actual dates use an appropriate dated calculation. |
| IRR | Rate solving NPV = 0 | Nonconventional cash flows can have multiple or no solutions. Inspect sign changes and check the root. Compare mutually exclusive investments using incremental NPV and constraints, not the largest IRR alone. |
| Net ROI | `(benefits - costs) / costs` over the specified period | Define included costs and whether values are discounted. Do not confuse it with `benefits / costs`, the benefit-cost multiple. A zero denominator makes the ratio undefined. |
| Simple payback | First time cumulative undiscounted cash flow recovers the outlay | State if not recovered within the horizon. Interpolate within a period only if the assumed receipt pattern supports it; a year-end receipt does not arrive monthly. |
| Discounted payback | First time cumulative discounted flow becomes nonnegative | It may differ materially from simple payback. Neither captures value after recovery. |
| Break-even volume | Fixed cost / unit contribution margin | Use consistent periods and a positive contribution margin. Check capacity, product mix, and whether price or variable costs change with volume. |
| Annualized TCO | Equivalent annual cost using a stated rate and life, or undiscounted average cost | Label which method is used. A simple average is not a discounted equivalent annual amount. |

For uneven receipts, terminal proceeds, and partial-period costs, explicit dated cash flows are preferable to hidden approximations. If the requested horizon excludes terminal value, honor it and explain that the result is limited to that horizon.

## Cash and model checks

Build a funding schedule at the time resolution needed to expose shortfalls. Gross spending authorization, net cash consumption, and peak funding need are different measures. Do not assume future receipts finance earlier payments or that uncommitted financing is available.

Reconcile opening cash + receipts - payments to closing cash by period. Reconcile benefit and cost subtotals to net cash flow and scenario outputs to the same assumption set. Test zero benefits, delayed benefits, and a meaningful downside where relevant. In spreadsheets, flag missing inputs, invalid rates, undefined ratios, broken references, inconsistent units, and unrecalculated formula caches rather than displaying misleading zeroes.
