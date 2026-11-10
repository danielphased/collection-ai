# collection-ai

A growing collection of AI building blocks for [Claude Code](https://claude.com/claude-code): **18 subagents** and **3 skills** (more kinds of tools, such as webhooks, may follow).

Everything is plain Markdown plus a few small helper scripts, so you can read it, copy it and change it.

## Install in 30 seconds

Pick one way.

**1. As a Claude Code plugin** (updates with one command, nothing to copy):

```
/plugin marketplace add danielphased/collection-ai
/plugin install collection-ai --marketplace danielphased/collection-ai
```

**2. With the install script** (copies the files into `~/.claude`, no plugin needed):

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
| `./install.sh --agents` / `--skills` / `--plugins` | Only that kind (combine to pick several) |
| `./install.sh --only verify,api-design` | Only the names you give (works for third-party too) |
| `./install.sh --project` | Install into `./.claude` (this project only) instead of `~/.claude` |
| `./install.sh --force` | Overwrite items you already have (default: skip them) |
| `./install.sh --dry-run` | Show what would happen, change nothing |
| `./install.sh --uninstall` | Remove what this repo provides (combine with `--only`) |

With no clone, add options after `bash -s --`: `curl -fsSL .../install.sh | bash -s -- --only verify`.

## Contents

- [Subagents](#subagents) · [Skills](#skills) · [How to use them](#how-to-use-them) · [Repository layout](#repository-layout) · [Third-party](#third-party-skills-and-plugins) · [Safety](#safety-and-privacy) · [Contributing](#contributing) · [Licence](#licence)

## Subagents

A subagent is a specialist role that Claude Code can hand a task to. Each one has its own instructions, and optionally its own model and a limited toolset.

| Agent | Model | Tools | What it does |
|---|---|---|---|
| [`ai-tech-lead`](agents/ai-tech-lead.md) | opus | all | Principal AI Technical Lead responsible for engineering leadership, technical mentorship, architectural consistency, cross-team coordination, and long-term technical… |
| [`backend-engineer`](agents/backend-engineer.md) | opus | all | Senior Backend Engineer responsible for implementing backend features while preserving architecture, quality, security, and maintainability. |
| [`code-reviewer`](agents/code-reviewer.md) | inherit | 6 tools | Use this agent when you need to conduct comprehensive code reviews focusing on code quality, security vulnerabilities, and best practices. |
| [`compliance-auditor`](agents/compliance-auditor.md) | inherit | 12 tools | Use this agent when you need to achieve regulatory compliance, implement compliance controls, or prepare for audits across frameworks like GDPR, HIPAA, PCI DSS, SOC 2,… |
| [`database-engineer`](agents/database-engineer.md) | opus | all | Senior Database Engineer responsible for schema design, migrations, performance, data integrity, and database architecture. |
| [`devops-engineer`](agents/devops-engineer.md) | opus | all | Senior DevOps Engineer responsible for infrastructure, CI/CD, deployment automation, observability, reliability, and platform engineering. |
| [`documentation-engineer`](agents/documentation-engineer.md) | opus | all | Senior Documentation Engineer responsible for keeping technical documentation synchronized with the codebase and preserving engineering knowledge. |
| [`frontend-engineer`](agents/frontend-engineer.md) | opus | all | Senior Frontend Engineer responsible for building accessible, performant, production-quality user interfaces while preserving architecture and user experience. |
| [`incident-response-engineer`](agents/incident-response-engineer.md) | opus | all | Senior Incident Response Engineer responsible for production incidents, root cause analysis, operational resilience, and continuous reliability improvements. |
| [`integration-engineer`](agents/integration-engineer.md) | opus | all | Senior Integration Engineer responsible for designing, implementing, and validating integrations between internal systems and third-party services. |
| [`mobile-app-developer`](agents/mobile-app-developer.md) | sonnet | 6 tools | Use this agent when developing iOS and Android mobile applications with focus on native or cross-platform implementation, performance optimization, and platform-specific… |
| [`performance-engineer`](agents/performance-engineer.md) | sonnet | 6 tools | Use this agent when you need to identify and eliminate performance bottlenecks in applications, databases, or infrastructure systems, and when baseline performance… |
| [`project-manager`](agents/project-manager.md) | sonnet | 22 tools | Use this agent when you need to establish project plans, track execution progress, manage risks, control budget/schedule, and coordinate stakeholders across complex… |
| [`qa-engineer`](agents/qa-engineer.md) | opus | all | Senior Quality Assurance Engineer responsible for validating engineering work, enforcing quality gates, and protecting production readiness. |
| [`release-engineer`](agents/release-engineer.md) | opus | all | Senior Release Engineer responsible for coordinating releases, validating deployment readiness, managing versioning, and ensuring safe, repeatable software releases. |
| [`scrum-master`](agents/scrum-master.md) | sonnet | 22 tools | Use when teams need facilitation, process optimization, velocity improvement, or agile ceremony management—especially for sprint planning, retrospectives, impediment… |
| [`security-engineer`](agents/security-engineer.md) | opus | all | Senior Security Engineer responsible for protecting applications, infrastructure, data, and engineering practices through proactive security reviews and threat modeling. |
| [`software-architect`](agents/software-architect.md) | opus | all | Principal Software Architect responsible for technical direction, architecture governance, system design, and engineering quality across all projects. |

Reading the table:
- **Model**: `opus` / `sonnet` pins the agent to that model; `inherit` uses whatever the main session runs.
- **Tools**: `all` means no restriction; `N tools` means the agent may only use the tools listed in its file.
- `compliance-auditor`, `project-manager` and `scrum-master` use Atlassian (Jira / Confluence) MCP tools, so they need that MCP server connected.

## Skills

A skill is a folder with a `SKILL.md` (instructions plus a one-line description that tells Claude when to use it) and, optionally, reference documents and scripts. Claude loads a skill only when the task matches its description.

| Skill | What it does | Files |
|---|---|---|
| [`ios-app-store-release`](skills/ios-app-store-release/SKILL.md) | iOS release engineering — pre-upload checklist for TestFlight/App Store (icon alpha, export compliance keys, privacy manifest and required-reason APIs, entitlements vs… | 1 |
| [`kotlin-engineering`](skills/kotlin-engineering/SKILL.md) | Kotlin engineering standards for production Android development — null safety, immutable state, sealed types, coroutines, structured concurrency, Flow/StateFlow, error… | 1 |
| [`verify`](skills/verify/SKILL.md) | Run the project's own quality gates (lint, typecheck, tests, production build) before saying work is done, fixed or ready. Use before claiming completion, before… | 1 |

Notes:
- `verify` runs a project's own checks (lint, type check, tests, build) before work is called done.
- `ios-app-store-release` is a pre-upload checklist for TestFlight / App Store; `kotlin-engineering` covers Kotlin standards for production Android.

## How to use them

- **A subagent:** ask for it by name ("use the `security-engineer` agent to review this change") or let Claude pick one from the descriptions.
- **A skill:** mention the topic, or invoke it directly as `/<skill-name>` (for example `/verify`).
- **Customise:** change the `description` line to change *when* something is chosen, and the body to change *how* it behaves. Keep descriptions specific; vague ones trigger too often or never.

## Repository layout

```
collection-ai/
├── agents/                 18 subagent definitions, one .md file each
├── skills/                 3 skills, one folder each (entry point: SKILL.md)
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

| Plugin | What it does | Source | Licence |
|---|---|---|---|
| `agent-skills` | Production-grade engineering skills for the whole lifecycle: spec, plan, build, verify, review, ship (also adds 4 subagents). | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | MIT |
| `andrej-karpathy-skills` | Behavioural guidelines that reduce common LLM coding mistakes. | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | not stated |
| `claude-code-setup` | Analyses a codebase and recommends Claude Code automations (hooks, subagents, skills, MCP servers). | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | see repo |

Anthropic's built-in document skills (PDF, Word, Excel, PowerPoint and similar) are not included.

## Safety and privacy

- Agents and skills are instructions that Claude follows with your permissions. **Read a file before you install it**, and treat anything from this or any other public repo as untrusted until you have. The same goes for `install.sh`: it only copies files into the `agents/` and `skills/` folders, and skips anything that already exists unless you pass `--force`.
- Nothing in this repo contains credentials, hostnames or customer data; the agents and skills tell Claude never to print or commit secrets. If you find something that looks sensitive, please open an issue.
- Third-party items run with the same permissions as your own. Review what `--dry-run` lists, and remember that a pinned commit is a fixed version, not a security guarantee: read what you install.

## Contributing

This is a personal collection, but issues and suggestions are welcome. A good contribution is a small, focused change to one file, with a clear reason.

## Licence

[MIT](LICENSE) for the content written for this repository. Third-party items listed above keep their own licences.
