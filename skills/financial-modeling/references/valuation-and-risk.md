# Valuation and uncertainty methods

## DCF and discount rates

Choose a forecast horizon that makes operating drivers and a defensible steady state visible. Forecast revenue, margins, taxes, reinvestment, and working capital from operating assumptions. Explain the transition from management's case to any adjusted case.

For perpetual growth, terminal value at the end of the forecast is `FCF_(n+1)/(r-g)` with `r > g`, a sustainable reinvestment policy, and consistent units. For an exit multiple, state the financial metric, comparable set, date, and why the multiple is appropriate. Discount terminal value back to the valuation date and show how much of total value it represents. Do not add terminal value when the user explicitly excludes it.

Preserve a supplied discount rate. If a rate must be developed, establish the relevant cash flow, currency, funding mix, cost of equity and after-tax debt, and risk assumptions from current sources. An industry or technology label does not determine the rate. Missing evidence is not a reason to round a rate upward. Show a sensitivity range grounded in the uncertainties and avoid duplicating the same risk in both flows and the rate.

## Scenarios and sensitivity

One-variable sensitivity identifies drivers; coherent scenarios test joint conditions such as delayed rollout with higher support costs. Define the causal assumptions for upside, base, and downside. Test the range that could change the decision, rather than a fixed percentage for every input. Show the switching threshold and whether it lies inside a credible range.

Use probability-weighted NPV only when scenario definitions and probability weights have a defensible basis. Weights must be nonnegative and sum to one. If probabilities are unknown, present unweighted scenarios; a label such as “directional” does not supply missing evidence. Distinguish uncertainty about an input from variability across cases or time.

## Advanced methods, only when useful

**MIRR:** compound positive cash flows at an explicit reinvestment rate and discount negative cash flows at an explicit finance rate. State the period count and assumptions. IRR is mathematically a root of NPV; it does not itself model what happens to intermediate receipts. MIRR can make an assumed reinvestment policy explicit, but does not cure a poor forecast.

**EVA:** `NOPAT - capital charge`, where the charge is cost of capital × consistently defined invested operating capital. Define the operating assets and non-interest-bearing operating liabilities included, and whether capital is beginning or average capital. Do not compare units only on absolute EVA when their sizes differ; inspect return on invested capital and the value spread as well.

**Real options:** identify a feasible right to expand, defer, abandon, or switch; its exercise cost, decision date, evidence trigger, and available capacity. Value it only with a justified method and inputs. Otherwise describe the flexibility and its decision implications without assigning an invented premium.

**Monte Carlo:** use when distributions add decision value and inputs can be defended. Specify distributions, dependencies/correlations, seed for reproducibility, and structural assumptions. Test convergence and plausibility. Report tail outcomes, probability of breaching a relevant constraint, and drivers of variance. Simulation precision does not imply the inputs are known accurately. A few transparent scenarios may be more informative than thousands of draws from invented distributions.
