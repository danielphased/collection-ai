---
name: CODING_STANDARDS
version: 1.0.0
description: Universal coding standards for all engineering agents regardless of language, framework, or project.
---

# CODING STANDARDS

## Purpose

This document defines the minimum coding standards expected from every engineering agent.

Consistency is more important than personal preference.

All code should be understandable by another engineer without additional explanation.

---

# Philosophy

Write code for humans first.

Computers execute code once.

Engineers read it hundreds of times.

Optimize for readability.

---

# General Principles

Every change should be:

- Correct
- Simple
- Maintainable
- Testable
- Secure
- Consistent

Avoid clever code.

Prefer obvious code.

---

# Simplicity

Always prefer

Simple

↓

Readable

↓

Efficient

↓

Clever

Complexity requires justification.

---

# Naming

Names should describe intent.

Good

```text
calculateInvoiceTotal()
```

Bad

```text
calc()
```

Good

```text
customerEmail
```

Bad

```text
x
```

Avoid abbreviations unless universally understood.

---

# Functions

Functions should

- Do one thing
- Be easy to understand
- Have descriptive names
- Minimize side effects
- Be independently testable

Avoid large functions.

If a function requires scrolling, consider refactoring.

---

# Classes

Classes should have one responsibility.

Avoid

God Objects

Massive Controllers

Large Services

Favor composition over inheritance.

---

# Files

Files should have a clear purpose.

Avoid

- Multiple unrelated responsibilities
- Mixed concerns
- Utility dumping grounds

Organize by domain whenever possible.

---

# Comments

Good code minimizes comments.

Use comments to explain

WHY

not

WHAT

Avoid

```text
Increment i
```

Prefer

```text
Required because the third-party API expects a one-based index.
```

Remove obsolete comments.

---

# Dead Code

Never leave

Unused methods

Unused variables

Commented code

Experimental code

Temporary debugging

Delete it.

Version control preserves history.

---

# Logging

Logs should be

Useful

Actionable

Structured

Never log

Passwords

Tokens

Secrets

Personal information

Sensitive business data

---

# Error Handling

Never ignore errors.

Avoid

```text
catch {}

catch(Exception)

return null
```

Errors should provide

Cause

Context

Recovery information

---

# Configuration

Configuration belongs outside code.

Avoid hardcoded

URLs

Passwords

Ports

API Keys

Connection Strings

Environment-specific values

---

# Dependencies

Before adding a dependency ask

Can existing code solve this?

Is the dependency maintained?

Is it secure?

Is it worth the complexity?

Prefer fewer dependencies.

---

# Duplication

Avoid duplicate logic.

When duplication appears

Extract carefully.

Do not create abstractions prematurely.

---

# APIs

Public interfaces should be

Stable

Predictable

Documented

Validated

Backward compatible whenever practical.

---

# Data Validation

Validate

At boundaries.

Never trust

User input

Network responses

Third-party APIs

External files

Validate early.

---

# Security

Security is not optional.

Always

Validate input

Escape output

Protect secrets

Use least privilege

Review authentication

Review authorization

---

# Performance

Prefer readable code first.

Optimize after

Measurement

Profiling

Evidence

Never optimize based on assumptions.

---

# Concurrency

Shared state should be minimized.

Review

Race conditions

Deadlocks

Async failures

Retries

Timeouts

Concurrency bugs are difficult to diagnose.

Design carefully.

---

# Database

Queries should

Be efficient

Use indexes appropriately

Avoid unnecessary round trips

Avoid N+1 patterns

Review transactions carefully.

---

# Frontend

UI should

Remain responsive

Handle loading states

Handle empty states

Handle error states

Remain accessible

Work on supported devices

---

# Backend

Business logic belongs in services.

Controllers should coordinate.

Repositories should persist.

Avoid mixing responsibilities.

---

# Testing

Every meaningful change should be verified.

Tests should be

Readable

Reliable

Independent

Repeatable

Avoid brittle tests.

---

# Refactoring

Refactor when

Readability improves

Duplication decreases

Maintainability increases

Do not refactor unrelated code during feature work.

---

# Code Reviews

Before requesting review ask

Can another engineer understand this?

Would I approve this change?

Does this introduce technical debt?

Is there a simpler solution?

Self-review first.

---

# Documentation

If behavior changes

Update documentation.

Code and documentation should evolve together.

---

# Engineering Checklist

Before considering work complete

✓ Requirements understood

✓ Scope respected

✓ Naming consistent

✓ Functions focused

✓ No dead code

✓ Logging appropriate

✓ Errors handled

✓ Tests executed

✓ Documentation updated

✓ Security reviewed

✓ Performance considered

✓ Self-review completed

---

# Golden Rule

Leave the codebase better than you found it.

Every commit should improve the long-term health of the project, even if only slightly.

Professional engineers optimize for the next engineer—not just the next build.