# Management Consulting Plugin

Skills for the consulting engagement lifecycle, from problem structuring through implementation and closeout.

> Packaged for OpenAI's Plugin Directory and the [Agent Skills](https://agentskills.io) open standard. The same source works with ChatGPT, Codex, Claude Code, Cowork, Gemini CLI, and [other compatible agents](https://agentskills.io).

Part of [unsol.dev](https://unsol.dev)

## Why this exists

Consulting engagements repeat many of the same mechanics: scoping, stakeholder alignment, analysis, strategy, delivery, and commercials. These skills capture that structure so you can focus on client context and judgment.

## Skills

| Skill | What it covers |
|---|---|
| `strategic-analysis` | Decision framing, causal diagnosis, competing hypotheses, market and competitive analysis |
| `financial-modeling` | Business cases, cost-benefit analysis, ROI/NPV/IRR, sensitivity analysis, scenario modeling |
| `proposal-development` | RFP analysis, proposal writing, SOW creation, pitch decks, oral defense |
| `engagement-setup` | Kickoff design, discovery planning, stakeholder mapping, the first two weeks |
| `engagement-pricing` | Fee structures, rate cards, engagement economics, procurement navigation |
| `implementation-planning` | Phased plans, workstreams, business cases, program recovery |
| `due-diligence` | Commercial, operational, financial, strategic, and technology assessment, integration planning |
| `change-management` | Transition planning, resistance management, adoption measurement |
| `process-excellence` | DMAIC, value stream mapping, root cause analysis, control plans |
| `org-design` | Operating models, structure design, role frameworks, transition planning |
| `project-governance` | Steering committees, stage gates, RACI, risk management, status reporting |
| `client-deliverables` | Executive reports, visual storytelling, editable exhibits, slide design, and artifact review |
| `workshop-facilitation` | Strategy workshops, facilitation design, participant dynamics |
| `thought-leadership` | POVs, white papers, case studies, thesis development |
| `project-closeout` | Handover, knowledge transfer, lessons learned, benefits tracking |
| `writing-style` | Consulting tone, depth calibration, content integrity standards |

## Install

### ChatGPT and Codex

In ChatGPT or Codex, open **Plugins** and search for **Management Consulting**. If it is not listed, use the cross-agent installer below.

### Skills CLI

```bash
npx skills add anotb/management-consulting-plugin
```

The same install works across Claude Code, Codex, Cursor, Gemini CLI, and [other supported agents](https://skills.sh).

### Claude Desktop

Download [`dist/management-consulting.skill`](https://github.com/anotb/management-consulting-plugin/raw/main/dist/management-consulting.skill), then in Claude go to Customize (left nav) > Skills > `+` > Upload a skill. Requires "Code execution and file creation" enabled in Settings > Capabilities.

This installs as a single `management-consulting` skill that routes by topic via an internal dispatcher. To get individual slash commands per skill (`/strategic-analysis`, `/financial-modeling`, etc.), install directly into the skills directory instead:

```bash
# Option A: clone (updates via git pull)
git clone https://github.com/anotb/management-consulting-plugin.git ~/.claude/skills/management-consulting

# Option B: download a snapshot
curl -L https://github.com/anotb/management-consulting-plugin/archive/refs/heads/main.tar.gz | \
  tar -xz -C ~/.claude/skills/ && \
  mv ~/.claude/skills/management-consulting-plugin-main ~/.claude/skills/management-consulting
```

Restart Claude Desktop after either method.

### Claude Code

```bash
claude plugin marketplace add anotb/management-consulting-plugin
claude plugin install management-consulting@anotb-management-consulting-plugin
```

### Cowork

Download the repo as a ZIP, then in Cowork go to Customize > Browse plugins > click `+` and upload. (Organization admins can sync directly from GitHub via Settings > Plugins > Add plugin.)

### Codex without the directory

Codex auto-discovers skills under `.agents/skills/`. The cross-agent installer places them there for you:

```bash
npx skills add anotb/management-consulting-plugin
```

To install manually, copy the individual skill folders (each `skills/<name>/`) into `.agents/skills/` at your repo root, or `~/.agents/skills/` for all projects. Each `SKILL.md` must sit one level down (for example `.agents/skills/strategic-analysis/SKILL.md`).

### Gemini CLI

```bash
gemini skills install https://github.com/anotb/management-consulting-plugin.git
```

### Other agents

Clone into `.agents/skills/` (the cross-platform standard) or the agent's native skills directory.

## Usage

Skills activate automatically when a request matches a consulting workflow. No slash command is required. Describe the work, such as "structure the due diligence for this acquisition," and the relevant skill loads.

You can also invoke a skill directly in Claude Code:

```
/management-consulting:strategic-analysis
/management-consulting:engagement-pricing
```

In Claude Code, [plan mode](https://code.claude.com/docs/en/common-workflows#plan-before-coding) (`shift+tab` twice) can surface missing data, client context, and constraints before work begins.

## Working with the skills

Start with the decision or artifact you need, include the evidence you have, and state the audience and constraints. The skills produce useful drafts with explicit gaps, distinguish observed results from forecasts, and connect recommendations to evidence and decision thresholds. They preserve client templates and agreed scope. Detailed methods load only when relevant. Output length follows the prompt, audience, and task; the skills impose no fixed word, paragraph, framework, or slide counts. Presentation guidance emphasizes compositions that fit the evidence, a coherent visual direction, and review of both individual slides and the whole deck.

All 16 skill names and installation paths remain stable in 2.2.0. The core guidance uses standard Markdown and has no model, connector, or runtime dependency. File creation uses the host's available tools. The optional editable PowerPoint bridge helper uses a caller-supplied PptxGenJS installation; other presentation tools can implement the same exhibit checks.

## Build and verify

```bash
# Claude Desktop: one dispatcher SKILL.md with all topic resources
bash build.sh

# OpenAI: both manifests, all standalone skills and their resources
pwsh -NoProfile -File build-openai.ps1

# Deterministic packaging and exhibit checks (Python standard library; Node 18+)
python3 -m unittest discover -s tests -v
node --test tests/test_consulting_charts.cjs
```

The OpenAI archive is written to `dist/management-consulting-openai.zip`. Both builds exclude local review notes. Desktop bundles preserve nested resources and inline writing guidance from its maintained source. Run behavioral fixtures in `tests/evals.json` independently; assess decisions, arithmetic, evidence, readability, scope, and artifact usability. Exact wording and framework counts are not quality measures.

## Heads up

This plugin produces structured consulting outputs. Everything should be reviewed by someone who knows the client context before it goes near a client.

## License

[MIT](LICENSE)
