---
name: DOCUMENTATION_STANDARDS
version: 1.0.0
description: Universal documentation standards for all AI engineering agents.
---

# DOCUMENTATION STANDARDS

## Purpose
Documentation is a first-class engineering deliverable. It preserves knowledge, accelerates onboarding, and supports long-term maintenance.

## Principles
- Accurate
- Concise
- Discoverable
- Versioned
- Actionable
- Maintained alongside the code

Never document behavior that has not been verified.

## Ownership
- Documentation Engineer: consistency and quality
- Developers: behavior changes
- Architect: architecture docs and ADRs
- Project Manager: planning documentation work
- QA: verify documentation when required

## Documentation Types

### README
Document:
- Purpose
- Setup
- Configuration
- Build
- Testing
- Running
- Contributing

### Architecture
Maintain:
- System overview
- Components
- Data flow
- External integrations
- Deployment
- Module boundaries

### API Documentation
Include:
- Endpoints
- Authentication
- Requests
- Responses
- Errors
- Examples

### ADRs
Create for:
- Major architectural decisions
- New technologies
- Significant dependencies
- Infrastructure changes

Template:
- Context
- Problem
- Options
- Decision
- Consequences

### Runbooks
Cover:
- Deployment
- Rollback
- Incident response
- Recovery
- Monitoring

### Changelog
Track:
- Features
- Bug fixes
- Breaking changes
- Security fixes
- Migration notes

## Synchronization
Documentation must stay synchronized with implementation.
Outdated documentation is worse than missing documentation.

## Writing Guidelines
Use:
- Clear headings
- Consistent terminology
- Short paragraphs
- Practical examples

Avoid:
- Marketing language
- Ambiguous wording
- Unverified claims

## Review Checklist
- Documentation updated
- Technically accurate
- Matches implementation
- Links verified
- Examples validated
- Ownership identified

## Definition of Complete
Documentation is complete when another engineer can successfully understand, build, operate, and extend the system using the available documentation.

## Final Principle
Documentation is part of the product, not an afterthought.
