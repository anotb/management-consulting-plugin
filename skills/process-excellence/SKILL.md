---
name: process-excellence
description: "Diagnose and improve business processes using evidence, flow analysis, Lean, and appropriate statistical methods. Use for bottlenecks, cycle time, defects, cost, process mining, DMAIC plans, and control design."
license: MIT
metadata:
  category: engagement-delivery
  version: "2.2.0"
  author: Anot
---

# Process Excellence

Find the cause of an operating problem and design an improvement that works for the whole process. Use Lean, Six Sigma, or a simpler diagnostic according to the question and evidence. A narrow analysis does not require producing every DMAIC artifact.

Establish boundaries, customer requirement, decision, available data, and the user's requested output. Work from the supplied baseline and definitions. If data is incomplete, provide a provisional diagnosis or measurement plan with limitations; do not invent a baseline or require real-world sign-offs before drafting. Execution gates and controlled rollout still matter where the operational risk requires them.

## Measure the work as it happens

Define the start and end event, unit of work, eligible cases, period, and whether time includes waiting, nonbusiness hours, rework, and incomplete cases. Separate touch time from elapsed time. Inspect missing events, duplicates, time zones, selection bias, and open cases before trusting averages.

Map the flow, decisions, queues, handoffs, and exceptions from evidence. SIPOC can establish boundaries; value-stream mapping can expose waiting and inventory. Use the mapping depth that helps the decision. Do not infer a bottleneck solely from the longest average duration when parallel capacity, batch size, or demand differs.

Use [measurement and statistical methods](references/measurement-and-statistics.md) for event logs, capability, control charts, and flow measures. Apply statistical tools only when their assumptions and data are suitable. Unknown performance is not a sigma level.

## Test causes and design improvements

Use observation, process data, interviews, Pareto analysis, fishbone, and repeated why questions to generate testable explanations. Distinguish a suspected cause from a verified cause. “Human error” may hide a design or control issue; an external cause should not be discarded merely because the team cannot control it.

Assess waiting, rework, unnecessary movement, excess work, inventory, redundant processing, and unused capabilities in context. Do not remove a control or apparently non-value-adding step without understanding its purpose and obligation. Check downstream effects and constraints before optimizing one step.

Compare feasible changes by impact, cost, service risk, adoption, and reversibility. For material changes, define a pilot, baseline comparison, success criterion, and stop or rollback trigger. For low-risk improvements, verification can be proportionate rather than a ceremonial gate.

## Quantify without double counting

Build the financial effect from volumes, time, rates, quality, and actual cost changes. Separate released labor capacity from reduced spending. Increased throughput produces revenue only if demand and downstream capacity permit it; use incremental contribution and cash where appropriate. Keep service quality, risk, and nonfinancial outcomes visible when they are the reason for the change.

State the period and included costs for ROI and payback. Calculate net ROI as `(benefits-costs)/costs` over that period; show implementation, ongoing costs, and the benefit ramp. Do not count the same improvement as labor savings and redeployed capacity simultaneously.

## Sustain and deliver

Define operating ownership, revised standard work, monitoring, and a response when performance deteriorates. Control limits describe observed process variation; specification limits describe requirements. Do not substitute one for the other.

Deliver the analysis, improvement plan, map, or control design requested. Explain the evidence, remaining uncertainty, recommended change, expected effect, and what would disprove the diagnosis. For actual implementation, confirm training, ownership, support, and relevant approvals through the existing operating process. Do not report a pilot or improvement as completed when only a plan was drafted.
