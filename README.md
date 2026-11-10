# collection-ai

A growing collection of AI building blocks for [Claude Code](https://claude.com/claude-code): **22 subagents**, **11 skills**, **10 engineering standards**, a secrets-protection hook and an MCP server entry.

Everything is plain Markdown plus a few small helper scripts, so you can read it, copy it and change it.

## Install in 30 seconds

Pick one way.

**1. As a Claude Code plugin** (updates with one command, nothing to copy):

```
/plugin marketplace add danielphased/collection-ai
/plugin install collection-ai --marketplace danielphased/collection-ai
```

**2. With the install script** (copies the files into `~/.claude`, no plugin needed; also installs the engineering standards):

```sh
curl -fsSL https://raw.githubusercontent.com/danielphased/collection-ai/main/install.sh | bash
```

Want to look first? Open [`install.sh`](install.sh), or run it from a clone: `git clone https://github.com/danielphased/collection-ai.git && cd collection-ai && ./install.sh`.

**3. By hand:** copy any file from [`agents/`](agents/) into `~/.claude/agents/` or any folder from [`skills/`](skills/) into `~/.claude/skills/`.

Then start a new Claude Code session. Check subagents with `/agents`; skills load automatically when a task matches.

### Script options

| Command | Does |
|---|---|
| `./install.sh --list` | List everything available |
| `./install.sh --third-party` | Other people's skills and plugins (see [below](#third-party-skills-and-plugins)) |
| `./install.sh --all` | This repo's items **and** the third-party ones |
| `./install.sh --agents` / `--skills` / `--engineering` / `--plugins` | Only that kind (combine to pick several) |
| `./install.sh --hooks` | Opt-in: the secrets-protection hook (edits `settings.json` after a backup) |
| `./install.sh --mcp` | Opt-in: MCP servers from `mcp.json` |
| `./install.sh --status` | Compare the repo with what is installed |
| `./install.sh --capture` | From a clone: copy installed copies that differ back into the repo (for your own fork) |
| `./install.sh --only verify,api-design` | Only the names you give (works for third-party too) |
| `./install.sh --project` | Install into `./.claude` (this project only) instead of `~/.claude` |
| `./install.sh --force` | Overwrite items you already have (default: skip them) |
| `./install.sh --dry-run` | Show what would happen, change nothing |
| `./install.sh --uninstall` | Remove what this repo provides (combine with `--only`) |

With no clone, add options after `bash -s --`: `curl -fsSL .../install.sh | bash -s -- --only verify`.

## Contents

- [Subagents](#subagents) · [Skills](#skills) · [Engineering standards](#engineering-standards) · [Hooks and MCP](#hooks-and-mcp-opt-in) · [How to use them](#how-to-use-them) · [Repository layout](#repository-layout) · [Third-party](#third-party-skills-and-plugins) · [Safety](#safety-and-privacy) · [Contributing](#contributing) · [Licence](#licence)

## Subagents

A subagent is a specialist role that Claude Code can hand a task to. Each one has its own instructions, and optionally its own model and a limited toolset.

| Agent | Model | Tools | What it does |
|---|---|---|---|
| [`ai-tech-lead`](agents/ai-tech-lead.md) | opus | all | Principal AI Technical Lead responsible for engineering leadership, technical mentorship, architectural consistency, cross-team coordination, and long-term technical… |
| [`backend-engineer`](agents/backend-engineer.md) | opus | all | Senior Backend Engineer responsible for implementing backend features while preserving architecture, quality, security, and maintainability. |
| [`code-reviewer`](agents/code-reviewer.md) | inherit | 6 tools | Use this agent when you need to conduct comprehensive code reviews focusing on code quality, security vulnerabilities, and best practices. |
| [`codebase-scout`](agents/codebase-scout.md) | haiku | 3 tools | Use this agent for cheap, read-only lookups in the codebase: finding files, symbols, usages, config values and where something is defined or called. Use proactively… |
| [`compliance-auditor`](agents/compliance-auditor.md) | inherit | 12 tools | Use this agent when you need to achieve regulatory compliance, implement compliance controls, or prepare for audits across frameworks like GDPR, HIPAA, PCI DSS, SOC 2,… |
| [`database-engineer`](agents/database-engineer.md) | opus | all | Senior Database Engineer responsible for schema design, migrations, performance, data integrity, and database architecture. |
| [`devops-engineer`](agents/devops-engineer.md) | opus | all | Senior DevOps Engineer responsible for infrastructure, CI/CD, deployment automation, observability, reliability, and platform engineering. |
| [`documentation-engineer`](agents/documentation-engineer.md) | opus | all | Senior Documentation Engineer responsible for keeping technical documentation synchronized with the codebase and preserving engineering knowledge. |
| [`frontend-engineer`](agents/frontend-engineer.md) | opus | all | Senior Frontend Engineer responsible for building accessible, performant, production-quality user interfaces while preserving architecture and user experience. |
| [`growth-marketer`](agents/growth-marketer.md) | sonnet | all | Senior Growth Marketer responsible for low-budget customer acquisition — idea and offer validation, lead magnets, short-video and social content systems, and outreach… |
| [`incident-response-engineer`](agents/incident-response-engineer.md) | opus | all | Senior Incident Response Engineer responsible for production incidents, root cause analysis, operational resilience, and continuous reliability improvements. |
| [`integration-engineer`](agents/integration-engineer.md) | opus | all | Senior Integration Engineer responsible for designing, implementing, and validating integrations between internal systems and third-party services. |
| [`mobile-app-developer`](agents/mobile-app-developer.md) | sonnet | 6 tools | Use this agent when developing iOS and Android mobile applications with focus on native or cross-platform implementation, performance optimization, and platform-specific… |
| [`performance-engineer`](agents/performance-engineer.md) | sonnet | 6 tools | Use this agent when you need to identify and eliminate performance bottlenecks in applications, databases, or infrastructure systems, and when baseline performance… |
| [`project-manager`](agents/project-manager.md) | sonnet | 22 tools | Use this agent when you need to establish project plans, track execution progress, manage risks, control budget/schedule, and coordinate stakeholders across complex… |
| [`qa-engineer`](agents/qa-engineer.md) | opus | all | Senior Quality Assurance Engineer responsible for validating engineering work, enforcing quality gates, and protecting production readiness. |
| [`release-engineer`](agents/release-engineer.md) | opus | all | Senior Release Engineer responsible for coordinating releases, validating deployment readiness, managing versioning, and ensuring safe, repeatable software releases. |
| [`scrum-master`](agents/scrum-master.md) | sonnet | 22 tools | Use when teams need facilitation, process optimization, velocity improvement, or agile ceremony management—especially for sprint planning, retrospectives, impediment… |
| [`security-engineer`](agents/security-engineer.md) | opus | all | Senior Security Engineer responsible for protecting applications, infrastructure, data, and engineering practices through proactive security reviews and threat modeling. |
| [`seo-specialist`](agents/seo-specialist.md) | sonnet | all | Senior SEO Specialist responsible for organic and AI-answer visibility — technical SEO, content pruning, structured data, readiness for AI search engines and off-site… |
| [`software-architect`](agents/software-architect.md) | opus | all | Principal Software Architect responsible for technical direction, architecture governance, system design, and engineering quality across all projects. |
| [`ui-designer`](agents/ui-designer.md) | opus | all | Senior UI Designer responsible for visual direction and design quality — colour systems, typography, layout, dashboards, motion and accessibility — so that interfaces… |

Reading the table:
- **Model**: `opus` / `sonnet` / `haiku` pins the agent to that model; `inherit` uses whatever the main session runs. `codebase-scout` also sets `effort: low`. The [`model-routing`](skills/model-routing/SKILL.md) skill explains how to choose and change these.
- **Tools**: `all` means no restriction; `N tools` means the agent may only use the tools listed in its file.
- `compliance-auditor`, `project-manager` and `scrum-master` use Atlassian (Jira / Confluence) MCP tools, so they need that MCP server connected.
- `seo-specialist`, `growth-marketer` and `ui-designer` name the skills they use when installed (this repo's and some [third-party](#third-party-skills-and-plugins) ones); they work without them. `seo-specialist` needs search data: a connected Search Console tool or an export.

## Skills

A skill is a folder with a `SKILL.md` (instructions plus a one-line description that tells Claude when to use it) and, optionally, reference documents and scripts. Claude loads a skill only when the task matches its description.

| Skill | What it does | Files |
|---|---|---|
| [`color-system`](skills/color-system/SKILL.md) | Turn a palette into a working UI colour system — give each colour one role, apply the 60/30/10 split, check WCAG contrast with the bundled script and store everything as… | 2 |
| [`cross-model-review`](skills/cross-model-review/SKILL.md) | Get a second opinion from a different model before trusting high-risk work — one model plans or builds, a different one audits with fresh context, and they loop until… | 1 |
| [`ios-app-store-release`](skills/ios-app-store-release/SKILL.md) | iOS release engineering — pre-upload checklist for TestFlight/App Store (icon alpha, export compliance keys, privacy manifest and required-reason APIs, entitlements vs… | 1 |
| [`kotlin-engineering`](skills/kotlin-engineering/SKILL.md) | Kotlin engineering standards for production Android development — null safety, immutable state, sealed types, coroutines, structured concurrency, Flow/StateFlow, error… | 1 |
| [`model-routing`](skills/model-routing/SKILL.md) | Pick the cheapest Claude model and effort level that can do each task well, and set it up in Claude Code (/model, /effort, subagent model and effort, opusplan, CLAUDE.md… | 1 |
| [`pre-launch-compliance-check`](skills/pre-launch-compliance-check/SKILL.md) | Pre-launch legal, privacy and honest-design checklist for a web or mobile app, with GDPR points for products that hold personal data (consent, data rights, retention,… | 1 |
| [`seo-content-pruning`](skills/seo-content-pruning/SKILL.md) | Prune and repair low-value pages to lift organic traffic — build a cut list from Search Console, protect pages that have backlinks, give every page one verdict (delete,… | 1 |
| [`short-video-growth-system`](skills/short-video-growth-system/SKILL.md) | Plan a week of short videos that turn viewers into sign-ups without ads — one free tool as the hook, seven one-problem videos filmed in a single batch, a comment keyword… | 1 |
| [`status-briefing`](skills/status-briefing/SKILL.md) | Report work as a short briefing instead of a long recap — a plan before changing anything, then what changed, what the user must do next, and a verified / not verified /… | 1 |
| [`verify`](skills/verify/SKILL.md) | Run the project's own quality gates (lint, typecheck, tests, production build) before saying work is done, fixed or ready. Use before claiming completion, before… | 1 |
| [`vet-third-party-skill`](skills/vet-third-party-skill/SKILL.md) | Check a third-party skill, plugin, MCP server or agent before installing it or adding it to third-party.tsv — find the original source, confirm licence and maintenance,… | 1 |

Notes:
- `verify` runs a project's own checks (lint, type check, tests, build) before work is called done.
- `model-routing`, `status-briefing` and `cross-model-review` are about working with Claude itself: which model does what, how results are reported, and when a second model should audit the first.
- `seo-content-pruning`, `short-video-growth-system` and `color-system` are marketing and design playbooks. `color-system` ships a small script, `scripts/contrast.py` (Python 3, no dependencies), that prints WCAG contrast ratios.
- `pre-launch-compliance-check` is an engineering checklist, **not legal advice**; have a lawyer review real policies.
- `vet-third-party-skill` is the review to run before installing anyone else's skill or adding a row to [`third-party.tsv`](third-party.tsv).
- `ios-app-store-release` is a pre-upload checklist for TestFlight / App Store; `kotlin-engineering` covers Kotlin standards for production Android.

## Engineering standards

Ten documents that set how AI engineering agents work together: authority, lifecycle, quality gates, coding, testing,
security, git and documentation rules. They are project-independent. The installer copies them to
`~/.claude/engineering/`; point an agent or a project `CLAUDE.md` at the ones you want followed.

| Standard | What it sets | Lines |
|---|---|---|
| [`ARCHITECTURE_PRINCIPLES`](engineering/ARCHITECTURE_PRINCIPLES.md) | Defines the architectural principles governing every software project regardless of language, framework, or technology stack. | 517 |
| [`CODING_STANDARDS`](engineering/CODING_STANDARDS.md) | Universal coding standards for all engineering agents regardless of language, framework, or project. | 526 |
| [`COMMUNICATION_PROTOCOL`](engineering/COMMUNICATION_PROTOCOL.md) | Defines how AI engineering agents communicate, collaborate, and hand off work. | 470 |
| [`DEFINITION_OF_DONE`](engineering/DEFINITION_OF_DONE.md) | Defines the minimum quality standard required before any engineering task is considered complete. | 314 |
| [`DOCUMENTATION_STANDARDS`](engineering/DOCUMENTATION_STANDARDS.md) | Universal documentation standards for all AI engineering agents. | 117 |
| [`ENGINEERING_ORGANIZATION`](engineering/ENGINEERING_ORGANIZATION.md) | Shared constitution for every AI engineering agent. | 525 |
| [`ENGINEERING_PRINCIPLES`](engineering/ENGINEERING_PRINCIPLES.md) | Universal engineering principles that govern every AI engineering agent. | 358 |
| [`GIT_WORKFLOW`](engineering/GIT_WORKFLOW.md) | Universal Git workflow standards for AI engineering agents. | 184 |
| [`SECURITY_STANDARDS`](engineering/SECURITY_STANDARDS.md) | Universal security standards for every engineering agent, regardless of language, framework, or project. | 482 |
| [`TESTING_STANDARDS`](engineering/TESTING_STANDARDS.md) | Universal testing standards for all AI engineering agents. | 242 |

## Hooks and MCP (opt-in)

These change your Claude Code configuration, so the installer only touches them when asked.

- **`./install.sh --hooks`** installs [`hooks/protect-secrets.sh`](hooks/protect-secrets.sh) and merges
  [`hooks.json`](hooks.json) into `settings.json` (a dated backup is written first; your own hooks are kept, and running
  it twice adds nothing). The hook blocks Claude's Edit/Write tools on files that usually hold secrets: `.env*` (not
  `.env.example`), keys and certificates, SSH keys, credential files and stores. It does not cover shell commands that
  write files. Override for one session: `CLAUDE_ALLOW_SECRET_EDIT=1 claude`.
- **`./install.sh --mcp`** adds the servers in [`mcp.json`](mcp.json) at user scope through the `claude` CLI. Currently
  `context7` (pinned `@upstash/context7-mcp@4.1.1`, needs `npx`): current library documentation. Library names and your
  questions are sent to Upstash's service; no code is sent.
- Remove either with the same flag plus `--uninstall`.

## How to use them

- **A subagent:** ask for it by name ("use the `security-engineer` agent to review this change") or let Claude pick one from the descriptions.
- **A skill:** mention the topic, or invoke it directly as `/<skill-name>` (for example `/verify`).
- **Customise:** change the `description` line to change *when* something is chosen, and the body to change *how* it behaves. Keep descriptions specific; vague ones trigger too often or never.

## Repository layout

```
collection-ai/
├── agents/                 22 subagent definitions, one .md file each
├── skills/                 11 skills, one folder each (entry point: SKILL.md)
├── engineering/            10 engineering standards
├── hooks/ + hooks.json     secrets-protection hook (opt-in)
├── mcp.json                MCP servers (opt-in)
├── install.sh              the installer described above
├── third-party.tsv         third-party skills and plugins, pinned to exact commits
├── .claude-plugin/         plugin and marketplace manifests (for /plugin install)
├── LICENSE                 MIT
└── README.md               this file
```

## Third-party skills and plugins

These are other people's work that I use too. They are **not stored in this repo**: `install.sh --third-party` downloads each one from its owner's repository at the exact commit listed (so you always get that exact version, even if upstream changes later), and shows the source and licence before installing.

```sh
./install.sh --third-party --list                 # see them all
./install.sh --third-party --dry-run              # preview, change nothing
./install.sh --third-party --only api-design      # one item
./install.sh --all                                # this repo + third-party
```

Skills are copied into `~/.claude/skills`; plugins are installed with the `claude plugin` command (the script prints the `/plugin` commands instead if `claude` is not on your PATH). Skills need `git`. The list lives in [`third-party.tsv`](third-party.tsv); to update one, read the upstream changes and change its commit.

| Skill | What it does | Source | Pinned commit | Licence |
|---|---|---|---|---|
| `agent-harness-construction` | Design and optimize AI agent action spaces, tool definitions, and observation formatting for higher completion rates. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `api-design` | REST API design patterns including resource naming, status codes, pagination, filtering, error responses, versioning, and rate limiting for production APIs. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `backend-patterns` | Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js, Express, and Next.js API routes. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `benchmark` | Use this skill to measure performance baselines, detect regressions before/after PRs, and compare stack alternatives. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `blueprint` | Turn a one-line objective into a step-by-step construction plan for multi-session, multi-agent engineering projects. Each step has a self-contained context brief so a… | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `browser-qa` | Use this skill to automate visual testing and UI interaction verification using browser automation after deploying features. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `config-gc` | Garbage collection for your Claude Code configuration. Periodically scans ~/.claude (skills, memory, hooks, permissions, MCP servers, caches) for redundant, stale,… | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `e2e-testing` | Playwright E2E testing patterns, Page Object Model, configuration, CI/CD integration, artifact management, and flaky test strategies. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `frontend-a11y` | Accessibility patterns for React and Next.js — semantic HTML, ARIA attributes, form labeling, keyboard navigation, focus management, and screen reader support. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `jira-integration` | Use this skill when retrieving Jira tickets, analyzing requirements, updating ticket status, adding comments, or transitioning issues. Provides Jira API patterns via MCP… | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `nestjs-patterns` | NestJS architecture patterns for modules, controllers, providers, DTO validation, guards, interceptors, config, and production-grade TypeScript backends. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `react-patterns` | React 18/19 patterns including hooks discipline, server/client component boundaries, Suspense + error boundaries, form actions, data fetching, state management decision… | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `react-performance` | React and Next.js performance optimization patterns adapted from Vercel Engineering's React Best Practices (https://github.com/vercel-labs/agent-skills). Organizes 70+… | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `react-testing` | React component testing with React Testing Library, Vitest/Jest, MSW for network mocking, accessibility assertions with axe, and the decision boundary between component… | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `security-review` | Use this skill when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features. Provides… | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `team-agent-orchestration` | Run team-based orchestration for agent squads using work items, ownership, agent Kanban, merge gates, and control pane handoffs. | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `d2ef268` | MIT |
| `pr-review-expert` | Use when the user asks to review pull requests, analyze code changes, check for security issues in PRs, or assess code quality of diffs. | [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | `4a3c05b` | MIT |
| `skill-security-auditor` | Security audit and vulnerability scanner for AI agent skills before installation. | [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | `4a3c05b` | MIT |
| `security-pen-testing` | Use when the user asks to perform security audits, penetration testing, vulnerability scanning, OWASP Top 10 checks, or offensive security assessments. Covers static… | [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | `4a3c05b` | MIT |
| `senior-frontend` | Frontend development skill for React, Next.js, TypeScript, and Tailwind CSS applications. | [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | `4a3c05b` | MIT |
| `ui-ux-pro-max` | UI/UX design intelligence for web and mobile. Includes 50+ styles, 161 color palettes, 57 font pairings, 161 product types, 99 UX guidelines, and 25 chart types across… | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | `6ae86f6` | MIT |
| `apple-design` | Apple's approach to interface design and fluid, physical motion, translated for the web. Use when building or reviewing gesture-driven UI, spring animations,… | [emilkowalski/skills](https://github.com/emilkowalski/skills) | `715c180` | MIT |
| `emil-design-eng` | This skill encodes Emil Kowalski's philosophy on UI polish, component design, animation decisions, and the invisible details that make software feel great. | [emilkowalski/skills](https://github.com/emilkowalski/skills) | `715c180` | MIT |
| `web-design-guidelines` | Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against… | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `1a2c79d` | MIT |
| `shadcn` | Manages shadcn components and projects — adding, searching, fixing, debugging, styling, and composing UI, including chat interfaces. Provides project context, component… | [shadcn-ui/ui](https://github.com/shadcn-ui/ui) | `8ab2771` | MIT |
| `unslop` | Turns vibecoded, AI-looking UI into a designed interface with its own character. Finds a direction from the product itself, then fixes spacing, color, icons, copy, type,… | [heydamir/unslop](https://github.com/heydamir/unslop) | `97daa3e` | CC-BY-4.0 |
| `hallmark` | Design skill for websites and new pages that look designed, not generated. Use when the user asks to build or design something new, or names Hallmark. | [Nutlope/hallmark](https://github.com/Nutlope/hallmark) | `7e213cb` | MIT |
| `stack-diagram` | Create cloud-architecture-style diagrams of tech stacks, system architectures, infra layouts, and service topologies — with real brand logos, grouped containers, and… | [caru-ini/stack-diagram](https://github.com/caru-ini/stack-diagram) | `5af3b09` | MIT |
| `geo-optimizer` | Audit and fix a website for AI search visibility (Generative Engine Optimization). Use when asked to check whether a site or page can be found and cited by ChatGPT… | [Auriti-Labs/geo-optimizer-skill](https://github.com/Auriti-Labs/geo-optimizer-skill) | `16a99f9` | MIT |
| `marketing-psychology` | When the user wants to apply psychology to marketing, or asks why buyers behave or value things as they do, or whether a persuasion tactic is honest: biases, mental… | [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | `9d6d7ce` | MIT |

| Plugin | What it does | Source | Licence |
|---|---|---|---|
| `agent-skills` | Production-grade engineering skills for the whole lifecycle: spec, plan, build, verify, review, ship (also adds 4 subagents). | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | MIT |
| `andrej-karpathy-skills` | Behavioural guidelines that reduce common LLM coding mistakes. | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | not stated |
| `claude-code-setup` | Analyses a codebase and recommends Claude Code automations (hooks, subagents, skills, MCP servers). | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | see repo |
| `founder-skill` | Eleven skills that test a business idea before launch: a board, a competitor scout, a panel of simulated buyers, pricing, the offer, a CFO, marketing, brand, operations, a launch plan and the business plan. | [Jakeschincariol/founder-skill](https://github.com/Jakeschincariol/founder-skill) | MIT |
| `seed-skill` | Eleven skills for raising a seed round: competitor scout, investor finder, business plan, pitch deck, outreach drafts (nothing sends without your yes), market size, financial model, pitch coach, term sheet reader, data room and investor updates. | [Jakeschincariol/seed-skill](https://github.com/Jakeschincariol/seed-skill) | MIT |

Things to know before installing some of them:

- **Style skills overlap.** `ui-ux-pro-max`, `unslop` and `hallmark` each pick or change a visual style. Use one per screen: `unslop` to clean up an existing screen, `hallmark` for a new page, `ui-ux-pro-max` to choose a style. Your own brand colours come first (see [`color-system`](skills/color-system/SKILL.md)).
- **`unslop`** is licensed CC BY 4.0: keep the credit to Damir Sokolovsky and the link to the repository if you share or adapt it. It edits UI code, so run it on a branch. Its optional image generation and story video need Playwright, ffmpeg and an image tool, and it asks before any paid generation.
- **`hallmark`** is large (about 190 files, 7 MB). Image generation is opt-in through a `TOGETHER_API_KEY`.
- **`geo-optimizer`** is instructions for the `geo` command-line tool; install that first with `pipx install geo-optimizer-skill` (Python 3.10+). Preview with `geo fix` before using `--apply`.
- **`shadcn`** is for projects that use shadcn/ui (a `components.json` file); it runs `npx shadcn@latest` commands.
- **`web-design-guidelines`** fetches the current rule list from GitHub (`vercel-labs/web-interface-guidelines`) each time it runs, so the rules themselves are not pinned.
- **`stack-diagram`** needs Python 3.9+ and network access to download logos (Playwright for PNG). It can offer to post a diagram to a **public** gallery: say no for anything that shows internal systems.
- **`founder-skill` and `seed-skill`** are plugins, so they follow upstream and are not pinned. Their buyers and boards are simulated: treat results as a first pass, not as demand, and nothing in them is financial or legal advice. `seed-skill` reads public app-store reviews and investor filings over the network.

Anthropic's built-in document skills (PDF, Word, Excel, PowerPoint and similar) are not included.

## Safety and privacy

- Agents and skills are instructions that Claude follows with your permissions. **Read a file before you install it**, and treat anything from this or any other public repo as untrusted until you have. The same goes for `install.sh`: by default it only copies files into the `agents/`, `skills/` and `engineering/` folders, and skips anything that already exists unless you pass `--force`. It edits `settings.json` only with `--hooks` and adds MCP servers only with `--mcp`.
- Nothing in this repo contains credentials, hostnames or customer data; the agents and skills tell Claude never to print or commit secrets. If you find something that looks sensitive, please open an issue.
- Third-party items run with the same permissions as your own. Review what `--dry-run` lists, and remember that a pinned commit is a fixed version, not a security guarantee: read what you install.

## Contributing

This is a personal collection, but issues and suggestions are welcome. A good contribution is a small, focused change to one file, with a clear reason.

## Licence

[MIT](LICENSE) for the content written for this repository. Third-party items listed above keep their own licences.
