---
name: model-routing
description: Pick the cheapest Claude model and effort level that can do each task well, and set it up in Claude Code (/model, /effort, subagent model and effort, opusplan, CLAUDE.md routing rules). Use when splitting work across models or subagents, when usage limits or cost are a concern, when writing or editing a subagent definition, or when asked which model to use for a task.
version: 1.0.0
---

# Model routing

Do not send every task to the most expensive model. Route each task to the
cheapest tier that does it well, and raise the effort level before raising the
tier. Spend the strong models where a mistake is expensive.

Project-specific rules (which agents exist, budget limits) belong in the project's own CLAUDE.md — follow them when present.

## 1. Classify the task

| Task | Tier | Effort | Why |
|---|---|---|---|
| Search the codebase, look up a file, list usages | `haiku` | low | Mechanical; volume matters more than judgement |
| Renames, boilerplate, formatting, simple config | `haiku` | low | Same |
| Build a well-specified feature, write tests, standard UI | `sonnet` | medium | The default for most building |
| UI that needs taste, refactors across modules | `opus` (or `sonnet` at high) | medium–high | Judgement and long context |
| Auth, payments, personal data, migrations | `opus` | high–xhigh | **Never route these to a cheap tier** |
| Hard bugs, root-cause analysis | `opus` | high–max | Reasoning depth pays for itself |
| Code review of risky changes | `opus` | high | A reviewer weaker than the author misses things |
| Feature planning, architecture, security audit | strongest available (`best`) | high–xhigh | A wrong plan is the most expensive mistake |

Aliases (`haiku`, `sonnet`, `opus`, `best`) resolve to the current version of
each tier; the account decides which tiers are available. Run `/model` to see
what this session can use. Do not quote prices from memory: check the pricing
page when cost numbers matter.

## 2. Apply it in Claude Code

| Scope | How |
|---|---|
| This session | `/model sonnet`, `/effort high` (`/model` alone opens the picker) |
| At startup | `claude --model opus --effort high` |
| Plan with a strong model, build with a cheaper one | `/model opusplan` |
| Default for a user or project | `"model": "sonnet"` and `"effortLevel": "high"` in `settings.json` (`effortLevel` does not accept `max`; use `/effort max` for that) |
| One subagent | `model:` and `effort:` in the agent file's frontmatter |
| Fallback for all subagents | `CLAUDE_CODE_SUBAGENT_MODEL` environment variable |

A subagent's model is resolved in this order: the model passed for that one
invocation, the `model` in its frontmatter (`inherit` = the main session's
model), `CLAUDE_CODE_SUBAGENT_MODEL`, then the main session's model.

Subagent frontmatter example:

```markdown
---
name: codebase-scout
description: Cheap read-only search of the codebase. Use proactively for lookups.
tools: Read, Grep, Glob
model: haiku
effort: low
---
```

## 3. Put the rules where Claude reads them

Add a short block to the project's `CLAUDE.md` so routing happens without being asked:

```markdown
## Model routing
- Search, lookups, renames, boilerplate -> codebase-scout (haiku)
- Building from an approved plan -> sonnet
- Auth, payments, personal data, migrations, risky reviews -> opus, high effort
- Planning, architecture, security audits -> strongest available model
- Never use a cheap tier for anything that touches auth, payments or user data.
```

In this collection, `codebase-scout` is the cheap tier, most engineering roles
are pinned to `opus`, and `code-reviewer` and `compliance-auditor` inherit the
session's model. Change the `model:` line in an agent file to re-route it.

## 4. Rules

- Raise effort before raising tier; drop a tier only for work that is truly mechanical.
- If a cheap tier fails the same task twice, escalate one tier instead of retrying.
- Keep risky work on a strong tier even when the change looks small.
- Give a cheap subagent a narrow task and a limited toolset; it should report, not decide.
- Measure before claiming savings: compare tokens or cost on the same task, not on impressions.
- For high-risk changes, pair this with the `cross-model-review` skill.
