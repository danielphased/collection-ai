---
name: GIT_WORKFLOW
version: 1.0.0
description: Universal Git workflow standards for AI engineering agents.
---

# GIT WORKFLOW

## Purpose

This document defines how engineering agents interact with Git repositories.

Git history is a record of engineering decisions. Keep it clean, accurate, and easy to understand.

---

# Core Principles

- Prefer small, focused commits.
- Keep the repository buildable.
- Never commit secrets.
- Never rewrite shared history unless explicitly instructed.
- Never push automatically.

---

# Branch Strategy

Unless the project specifies otherwise:

main
└── develop
    └── feature/<name>
    └── bugfix/<name>
    └── hotfix/<name>

Project-specific workflows override this standard.

---

# Before Starting Work

- Pull the latest changes (if permitted).
- Confirm the correct branch.
- Ensure the working tree is clean.
- Read project-specific Git guidelines.

---

# During Development

- Commit logical units of work.
- Avoid mixing unrelated changes.
- Keep commits reviewable.
- Do not commit generated files unless required.
- Do not commit temporary debugging changes.

---

# Commit Messages

Use imperative mood.

Examples:

PROJECT-123: Add meeting retry logic

PROJECT-456: Fix OAuth token refresh

PROJECT-789: Update API documentation

A good commit message explains **what** changed and, if necessary, **why**.

---

# Before Committing

Verify:

- Build succeeds
- Tests pass
- Documentation updated if needed
- No secrets or credentials included
- No commented-out code
- No debug logging left behind

---

# Pull Requests

When applicable:

Include:

- Summary
- Motivation
- Testing performed
- Risks
- Related issue/ticket

Keep pull requests focused on a single objective.

---

# Merge Strategy

Prefer:

- Rebase for local cleanup
- Merge or squash according to project standards

Avoid unnecessary merge commits.

---

# Conflict Resolution

When resolving conflicts:

- Understand both changes
- Preserve intent
- Re-run tests
- Verify runtime behavior if affected

Never resolve conflicts blindly.

---

# Releases

Before a release:

- Verify version numbers
- Update changelog
- Ensure release notes are complete
- Confirm QA approval

---

# Prohibited Actions

Never:

- Force push shared branches
- Commit secrets
- Commit passwords or tokens
- Delete history without approval
- Push automatically on behalf of the user

---

# AI Agent Rules

Engineering agents may:

- Create commits when explicitly authorized
- Prepare commit messages
- Review Git history

Engineering agents must not:

- Push to remote repositories without explicit user approval
- Rewrite remote history
- Create releases automatically

---

# Final Checklist

- [ ] Correct branch
- [ ] Clean working tree
- [ ] Build passes
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Commit message follows convention
- [ ] No secrets committed

---

# Final Principle

Git should tell the story of the project.

Every commit should make that story easier to understand.
