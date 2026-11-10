---
name: status-briefing
description: Report work as a short briefing instead of a long recap — a plan before changing anything, then what changed, what the user must do next, and a verified / not verified / guessed mark on every claim. Use when handing work back, writing the final message of a task, summarising a change, or when the user asks for shorter, clearer replies.
version: 1.0.0
---

# Status briefing

The reader wants three things: what changed, what they must do, and how much
of it to trust. Everything else is noise.

## Before a change: the plan

Three to six lines, no more:

- What will change and where (files, services, data).
- The order of the steps.
- What could go wrong and how it will be checked.

Wait for approval when the change is risky, irreversible or larger than asked.

## After the work: the briefing

```
**Changed**
- [VERIFIED] <what changed, in one line>            (how: <command or check>)
- [NOT VERIFIED] <what changed>                     (why not: <reason>)

**Needs you**
- <a decision, a secret to set, a manual step, a review>   (or "Nothing")

**Open**
- [GUESSED] <assumption made, or thing that is stuck>
```

The three marks:

| Mark | Meaning | Rule |
|---|---|---|
| VERIFIED | Ran it, saw the result | Name the command or check |
| NOT VERIFIED | Written or changed, but not run or not observable | Say why, and how the user can check |
| GUESSED | An assumption, an inference, or a blocker | Say what would confirm it |

Colour marks (green, yellow, red) are fine if the user likes them, but keep
the word next to the mark so the meaning does not depend on colour.

## Rules

- Lead with the outcome. No preamble, no repeating the request, no closing offer list.
- One line per item. Details go in the diff, the file or a link, not the message.
- Never mark something VERIFIED from reading code alone. "It should work" is NOT VERIFIED.
- Put failures and skipped steps in the briefing, not below it.
- If nothing is needed from the user, say "Nothing" so they do not have to hunt.
- Run the project's gates first (see the `verify` skill); the briefing reports what they printed.

## Make it the default

Paste this into `CLAUDE.md` (project) or `~/.claude/CLAUDE.md` (all projects):

```markdown
## Response rules
- Before any change, give a short plan.
- After the work, give a briefing: (1) what changed, (2) what I need to do, (3) what is still open.
- Mark each item VERIFIED (ran it), NOT VERIFIED (not run) or GUESSED (assumed or stuck).
- Keep it short. No filler, no repeating my question.
```
