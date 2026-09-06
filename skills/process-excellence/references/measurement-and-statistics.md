# Measurement, process mining, and statistical methods

## Baseline and flow measures

Define the population, sample method, sample size, observation period, and treatment of missing or unfinished work. Show a distribution or useful percentiles when an average hides tails. Stratify by meaningful case types without selecting only favorable cases. Confirm measurement consistency before comparing before and after.

Takt time is available production time divided by customer demand over the same period. Compare effective capacity with demand, accounting for parallel resources, uptime, rework, and product mix. Cycle time at one station exceeding takt can signal a constraint, but capacity and routing determine the bottleneck.

For a stable flow with matching boundaries and consistent time units, Little's Law relates average work in progress, throughput, and flow time. State applicability and avoid applying steady-state averages to a transient buildup without qualification. A reduction in queue time may improve service without releasing equivalent labor hours.

## Event logs and process mining

At minimum identify a case ID, event/activity, timestamp, and event meaning. Where available use lifecycle state, resource, attributes, and outcome. Check duplicates, event ordering, inconsistent time zones, missing starts/ends, reopened cases, and incomplete observation windows.

Report major path variants, case duration, waiting, rework, and deviations from the intended process. Investigate whether a deviation is an error, a legitimate exception, or a useful workaround. Conformance to a flawed procedure is not the same as business performance.

## Capability

Before interpreting conventional Cp/Cpk, establish appropriate specification limits, process stability, measurement quality, sufficient representative data, and a suitable distributional method. Conventional normal-distribution formulas do not make arbitrary data normal. A one-sided service deadline does not justify inventing a lower specification limit.

For suitable two-sided limits, `Cp = (USL-LSL)/(6σ)` and `Cpk = min((USL-μ)/(3σ), (μ-LSL)/(3σ))`. Define how within-process variation is estimated. Report uncertainty and use an appropriate nonnormal or attribute method where warranted. If the data cannot support capability inference, report observed performance and a measurement plan instead.

Primary reference: [NIST process capability](https://www.itl.nist.gov/div898/handbook/pmc/section1/pmc16.htm), checked September 5, 2026. Consult the applicable method before making a statistical claim.

## Control charts

Select a chart for the measurement and sampling structure: subgroup variable data may use X-bar/R or X-bar/S; individual variable observations may use I-MR when appropriate; proportions defective may use p charts with suitable limits; defect counts require attention to opportunity or exposure. A c chart assumes comparable opportunity; varying exposure may require a u chart or another suitable model.

Check assumptions, subgrouping, independence, sample-size variation, and data quality. Derive control limits from the baseline behavior, not the customer specification. Define which signals trigger investigation and who responds. Investigate special causes before changing the whole process or recalculating limits to hide a signal.

## Causal and financial validation

Compare like periods and populations. Consider seasonality, case mix, staffing, concurrent changes, and learning before attributing a result to an intervention. An observed improvement can be useful while its causal attribution remains uncertain.

Use a pilot or controlled comparison proportionate to operational risk. Track quality, throughput, and workload as well as speed. Distinguish recurring savings, one-time cash release, capacity, and service improvement; the same working-capital release cannot recur every year without a further reduction in the underlying balance.
