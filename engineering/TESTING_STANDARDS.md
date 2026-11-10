---
name: TESTING_STANDARDS
version: 1.0.0
description: Universal testing standards for all AI engineering agents.
---

# TESTING STANDARDS

## Purpose

Testing provides objective evidence that software behaves as expected.
Every engineering change must include an appropriate level of verification.

Testing is part of implementation—not an optional follow-up activity.

---

# Testing Philosophy

Objectives, in order:

1. Prevent regressions
2. Validate requirements
3. Increase confidence
4. Enable safe refactoring
5. Document expected behavior

A feature without verification is incomplete.

---

# Testing Pyramid

Prefer this order:

1. Unit Tests
2. Integration Tests
3. End-to-End Tests
4. Manual Verification

Favor many fast tests and fewer slow tests.

---

# Unit Tests

Unit tests should:

- Test one behavior
- Be deterministic
- Avoid external dependencies
- Run quickly
- Clearly express intent

Avoid testing implementation details.

---

# Integration Tests

Integration tests verify collaboration between components.

Examples:

- API ↔ Database
- Service ↔ Repository
- Frontend ↔ Backend
- Authentication flow

---

# End-to-End Tests

E2E tests validate complete user workflows.

Typical scenarios:

- Login
- CRUD operations
- Checkout
- File upload
- Settings
- Critical business workflows

---

# Manual Verification

Manual testing complements automation.

Verify:

- Visual appearance
- Browser behavior
- Console errors
- Network requests
- Accessibility
- Edge cases

---

# Bug Fixes

Every bug fix should include a regression test whenever practical.

A bug fixed without a regression test may return.

---

# Test Data

Test data should be:

- Predictable
- Isolated
- Minimal
- Repeatable

Never depend on production data.

---

# Mocking

Mock only external boundaries:

- Third-party APIs
- Payment providers
- Email
- File storage
- External services

Avoid excessive mocking of internal business logic.

---

# Performance

Performance testing is required when changes may affect:

- Database queries
- Rendering
- API latency
- Memory usage
- Large datasets

Measure before optimizing.

---

# Security Testing

Review for:

- Authentication
- Authorization
- Input validation
- Injection
- Sensitive data exposure

---

# Accessibility Testing

Frontend changes should verify:

- Keyboard navigation
- Focus order
- Semantic HTML
- Screen reader compatibility
- Color contrast

---

# Build Verification

Before completion:

- Build succeeds
- Tests pass
- Lint passes (where applicable)
- No unexpected warnings

---

# Runtime Verification

Do not rely on compilation alone.

Execute the feature and verify:

- Expected behavior
- Correct API responses
- No console errors
- No runtime exceptions

---

# Definition of Passing

A change is considered tested when:

- Requirements verified
- Automated tests pass
- Runtime behavior confirmed
- No critical regressions identified

---

# Agent Responsibilities

Developers:
- Write and maintain tests.

QA:
- Independently validate behavior.
- Challenge assumptions.
- Verify evidence.

Project Manager:
- Ensure testing is included in delivery.

---

# Testing Checklist

- [ ] Acceptance criteria covered
- [ ] Unit tests added or updated
- [ ] Integration tests reviewed
- [ ] Runtime verification completed
- [ ] Regression risk assessed
- [ ] QA evidence recorded

---

# Final Principle

Testing builds confidence.

Confidence enables change.

Well-tested software evolves faster, safer, and with fewer surprises.
