---
name: DEFINITION_OF_DONE
version: 1.0.0
description: Defines the minimum quality standard required before any engineering task is considered complete.
---

# DEFINITION OF DONE

## Purpose

"Done" means more than code that compiles.

A task is only complete when it satisfies engineering, quality, documentation, and verification requirements.

No engineering agent may declare work complete without meeting this definition.

---

# Core Principle

Done means:

**Correct**

**Verified**

**Reviewed**

**Documented**

**Ready for maintenance**

---

# Universal Checklist

Every task must satisfy all applicable items.

## Requirements

- [ ] Acceptance criteria satisfied
- [ ] Original objective completed
- [ ] Scope respected
- [ ] No undocumented assumptions remain

---

## Architecture

- [ ] Existing architecture respected
- [ ] No unnecessary abstractions introduced
- [ ] No duplicate business logic
- [ ] Module boundaries preserved
- [ ] Dependencies justified

---

## Code Quality

- [ ] Code is readable
- [ ] Naming follows standards
- [ ] No dead code
- [ ] No debug code
- [ ] No commented-out code
- [ ] No TODOs without justification

---

## Security

- [ ] Input validated
- [ ] Authentication respected
- [ ] Authorization respected
- [ ] Secrets protected
- [ ] Sensitive data not logged
- [ ] No known security regressions

---

## Error Handling

- [ ] Errors handled appropriately
- [ ] Useful error messages
- [ ] Logging implemented where appropriate
- [ ] Failures are recoverable where possible

---

## Performance

- [ ] No obvious performance regressions
- [ ] Database queries reviewed
- [ ] Network calls minimized
- [ ] Rendering optimized where applicable

---

## Testing

Every change must be verified.

At least one of:

- [ ] Unit Tests
- [ ] Integration Tests
- [ ] End-to-End Tests
- [ ] Manual Verification

Bug fixes should include regression tests whenever practical.

---

## Build Verification

- [ ] Project builds successfully
- [ ] No compilation errors
- [ ] No new warnings of concern
- [ ] Dependencies resolved

---

## Runtime Verification

Where applicable:

- [ ] Feature executed
- [ ] Browser tested
- [ ] API verified
- [ ] Console checked
- [ ] Network requests validated
- [ ] Expected behavior confirmed

A successful build alone is NOT sufficient.

---

## Frontend

If UI changed:

- [ ] Responsive
- [ ] Accessible
- [ ] Keyboard navigation works
- [ ] Loading state verified
- [ ] Error state verified
- [ ] Empty state verified
- [ ] Visual consistency maintained

---

## Backend

If backend changed:

- [ ] API contract maintained
- [ ] Validation updated
- [ ] Database migrations verified
- [ ] Logging reviewed
- [ ] Error responses verified

---

## Database

If schema changed:

- [ ] Migration created
- [ ] Migration reversible
- [ ] Existing data preserved
- [ ] Indexes reviewed
- [ ] Constraints verified

---

## Documentation

Where appropriate:

- [ ] README updated
- [ ] API documentation updated
- [ ] Architecture documentation updated
- [ ] ADR created if required
- [ ] Changelog updated

Documentation is part of the feature.

---

## QA

QA must verify:

- Correctness
- Regression
- Runtime behavior
- Security
- Performance impact
- Scope compliance

QA approval is required before completion.

---

## Git

Before completion:

- [ ] Correct branch
- [ ] Clean working tree
- [ ] Meaningful commit message (if committing is authorized)
- [ ] No secrets committed

---

## Communication

Engineering summary includes:

- Summary
- Decisions
- Verification
- Risks
- Next Agent

---

# Completion States

## Not Started

No implementation.

---

## In Progress

Work has begun.

Verification incomplete.

---

## Ready For Review

Implementation complete.

Awaiting QA.

---

## QA Failed

Blocking issues identified.

Must return to implementation.

---

## QA Passed

Quality requirements satisfied.

Ready for documentation.

---

## Documentation Updated

Documentation synchronized.

---

## Complete

All checklist items satisfied.

Task ready for local commit or delivery.

---

# Automatic Failure Conditions

A task is NOT done if:

- Tests fail
- Build fails
- Runtime verification missing
- Acceptance criteria incomplete
- Documentation required but missing
- Security issue introduced
- QA rejects implementation
- Scope exceeded without approval

---

# Professional Standard

A professional engineer finishes the entire task.

Not just the code.

The feature.

The documentation.

The testing.

The verification.

The communication.

Done means another engineer can confidently build upon the work without needing undocumented knowledge.

This is the standard expected of every AI engineering agent.