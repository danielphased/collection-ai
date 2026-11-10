---
name: COMMUNICATION_PROTOCOL
version: 1.0.0
description: Defines how AI engineering agents communicate, collaborate, and hand off work.
---
# COMMUNICATION PROTOCOL
## Purpose
This document standardizes communication between engineering agents.
Every agent communicates using the same structure.
This improves:
- clarity
- traceability
- consistency
- automation
- collaboration

---
# Communication Principles
Every response should be:
- Clear
- Concise
- Honest
- Actionable
- Evidence-based

Never exaggerate.

Never hide uncertainty.

Never claim work was completed unless verified.

---

# Standard Response Format

Every engineering agent MUST return the following sections.

```markdown
## Summary

## Objective

## Decisions

## Work Completed

## Verification

## Risks

## Recommendations

## Next Agent
```

---

# Summary

Describe what was accomplished.

Maximum:

5 concise bullet points.

---

# Objective

Restate the goal.

Include:

- ticket
- feature
- bug
- task

Never assume the next agent remembers context.

---

# Decisions

Record important engineering decisions.

Examples:

- selected implementation approach
- rejected alternatives
- architectural decisions
- assumptions made

---

# Work Completed

List:

- files changed
- modules affected
- services modified
- APIs updated
- documentation written
- tests added

Never omit important modifications.

---

# Verification

Every claim must include evidence.

Possible evidence:

- build passed
- tests passed
- runtime verified
- API returned expected response
- browser validation
- accessibility review
- security review

Never write

"It should work."

Provide proof.

---

# Risks

Document

- assumptions
- technical debt
- limitations
- follow-up work
- known issues

Every project has risk.

Record it.

---

# Recommendations

Provide recommendations only when appropriate.

Examples

Future refactor

Performance improvement

Documentation update

Security review

Architecture review

Do not implement future work.

Only recommend it.

---

# Next Agent

Every response ends with

```text
Next Agent:

<Project Manager>

or

<Software Architect>

or

<Backend Engineer>

or

<Frontend Engineer>

or

<QA Engineer>

or

<Documentation Engineer>

or

<Human>
```

No ambiguity.

---

# Handoff Rules

Every handoff must include

- objective
- current status
- remaining work
- risks
- required verification

The receiving agent should never need to guess.

---

# Escalation

Escalate immediately when

- requirements conflict
- architecture is unclear
- security risk exists
- credentials are required
- project policy is violated
- external dependency blocks progress

Escalation is not failure.

It is responsible engineering.

---

# Questions

Questions should be:

Specific.

Actionable.

Minimal.

Bad

> What should I do?

Good

> The API specification conflicts with the database schema.
> Which source should be treated as authoritative?

---

# Reporting Standards

Use facts.

Avoid opinions unless requested.

Instead of

"This code looks better."

Use

"Removed duplicated validation logic from three services."

---

# Status Values

Tasks may only be reported as

- Not Started
- In Progress
- Blocked
- Ready for Review
- QA Failed
- QA Passed
- Documentation Updated
- Complete

Avoid vague terms such as

Almost Done

Mostly Works

Should Be Fine

---

# Evidence Standards

Every verification should include evidence.

Examples

Build:

✓ npm run build

Tests:

✓ 142 passed

Runtime:

✓ Login verified

API:

✓ POST /api/users returned HTTP 201

Browser:

✓ No console errors

Accessibility:

✓ Keyboard navigation verified

---

# Error Reporting

Errors should contain

Problem

Cause

Impact

Recommendation

Example

```text
Problem

Login fails.

Cause

Incorrect OAuth redirect URI.

Impact

Users cannot authenticate.

Recommendation

Update redirect URI configuration.
```

---

# Engineering Language

Prefer

Implemented

Verified

Validated

Documented

Measured

Reviewed

Avoid

Maybe

Probably

Looks Fine

Should Work

---

# Communication Between Agents

Project Manager

↓

Software Architect

↓

Development

↓

QA

↓

Documentation

↓

Project Manager

Agents may communicate directly when requested by the Project Manager or Architect.

---

# Confidentiality

Never expose

- credentials
- API keys
- tokens
- secrets
- private customer information

If discovered

Escalate immediately.

---

# Completion Checklist

Before sending a response verify:

✓ Summary included

✓ Objective included

✓ Decisions documented

✓ Work listed

✓ Verification included

✓ Risks identified

✓ Recommendations provided

✓ Next Agent identified

If any section is missing

The communication is incomplete.

---

# Final Principle

Communication is part of engineering.

Well-communicated work is easier to review, maintain, extend, and trust.

Every engineering agent is responsible for improving team communication—not just writing code.