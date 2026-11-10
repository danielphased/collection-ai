---
name: cross-model-review
description: Get a second opinion from a different model before trusting high-risk work — one model plans or builds, a different one audits with fresh context, and they loop until every finding is resolved. Use for auth, payments, personal data, migrations, security fixes and other changes where a wrong answer is expensive; not for routine edits.
version: 1.0.0
---

# Cross-model review

A model reviewing its own work is grading its own homework: it shares the
blind spots that produced the mistake. A different model, with fresh context
and a brief to disagree, catches more. It also costs more, so use it only
where a miss is expensive.

## When

Use it for: authentication and authorisation, payments and billing, personal
data handling, database migrations, security fixes, public API contracts,
anything hard to roll back.

Skip it for: copy changes, styling, renames, tests for existing behaviour,
prototypes.

## The loop

```
1. Author   writes the plan                      (PLAN.md or a message)
2. Auditor  reviews the plan                     → findings
3. Author   answers every finding: fix or rebut with evidence
4. Author   builds
5. Auditor  reviews the diff against the plan    → findings
6. Repeat 3–5 until no blocking finding remains, at most three rounds
```

Unresolved after three rounds, or the two disagree on a blocking finding:
stop and put both positions in front of the user. Do not let the author
overrule the auditor on a security or data finding.

## Setting it up in Claude Code

The auditor must differ from the author in **model** and start with **fresh context**.

| Author | Auditor |
|---|---|
| Main session on `sonnet` | A review subagent run on `opus` |
| Main session on `opus` | A review subagent run on the strongest other tier available, or on `sonnet` at high effort when nothing else is |
| A build subagent | A different review subagent with another `model:` in its frontmatter |

Use a read-only reviewer (for example the `code-reviewer` or
`security-engineer` agent, with the model set for that invocation). See the
`model-routing` skill for how a subagent's model is chosen.

A model from **another vendor** gives the most independent opinion. Do that
only when the user already has that tool installed and has agreed that this
code may be sent to that provider; check contracts and data rules first, and
never send secrets or personal data.

## What the auditor gets

Give it only: the requirement, the plan, the diff, and the commands to run
the tests. Do not give it the author's reasoning or chat history.

Brief:

```
You are auditing work you did not write. Assume it contains mistakes.
Check it against the requirement and the plan. For each finding give:
severity (BLOCKER / SHOULD FIX / NOTE), file:line, what breaks, and a
concrete failing case. Do not approve to be agreeable; say "no findings"
only after checking: inputs and validation, authorisation on every path,
error and rollback paths, data written and data exposed, concurrency,
and what the tests do not cover.
```

## Rules

- Findings need evidence (`file:line` and a failing case). A finding without a case is a NOTE.
- The author fixes or rebuts each finding explicitly; silence is not a resolution.
- The auditor does not edit the code. If it would rather rewrite, it says what and why.
- Run the project's gates after the last round (see the `verify` skill).
- Record the outcome in the pull request: rounds, blockers found, what was left open.
- This is not a replacement for human review of high-risk changes.
