---
name: ARCHITECTURE_PRINCIPLES
version: 1.0.0
description: Defines the architectural principles governing every software project regardless of language, framework, or technology stack.
---

# ARCHITECTURE PRINCIPLES

## Purpose

Architecture exists to make software easier to understand, extend, test, and maintain.

Every engineering decision should improve the long-term health of the system.

Architecture is a product, not a byproduct.

---

# Primary Goals

Every architecture should optimize for:

- Maintainability
- Simplicity
- Testability
- Scalability
- Reliability
- Security
- Observability
- Extensibility

Not every project requires maximum scalability.

Every project requires maintainability.

---

# Guiding Philosophy

Code should evolve.

Architecture should endure.

Optimize for the next five years—not the next sprint.

---

# Architectural Hierarchy

Business Requirements

↓

Domain Model

↓

Architecture

↓

Implementation

↓

Infrastructure

Technology serves architecture.

Architecture serves the business.

---

# Core Principles

## Separation of Concerns

Every component should have one responsibility.

Examples

UI

↓

Presentation

↓

Business Logic

↓

Persistence

↓

Infrastructure

Avoid mixing concerns.

---

## Single Responsibility

Every module should answer one question:

"What is this responsible for?"

If the answer contains "and"

It probably has two responsibilities.

---

## High Cohesion

Keep related functionality together.

A module should naturally belong together.

Avoid unrelated utilities.

---

## Low Coupling

Dependencies should be minimized.

Changes in one module should not ripple throughout the system.

Prefer interfaces over concrete implementations.

---

# Dependency Rule

Dependencies point inward.

Business logic should not depend on

Frameworks

Databases

Cloud Providers

UI Frameworks

Libraries

Instead

Infrastructure depends on business logic.

Never the opposite.

---

# Composition Over Inheritance

Prefer

Small reusable components.

Avoid deep inheritance trees.

Composition produces more flexible systems.

---

# Domain First

The business domain is the center of the application.

Frameworks are implementation details.

Never allow framework limitations to define business architecture.

---

# Module Boundaries

Modules communicate through

Public interfaces.

Never through internal implementation.

Respect boundaries.

Do not bypass abstractions.

---

# API Design

Public APIs should be

Stable

Predictable

Documented

Versioned when appropriate

Backward compatible whenever practical.

---

# State Management

Minimize shared mutable state.

Prefer

Explicit state

Immutable data

Clear ownership

Hidden state creates hidden bugs.

---

# Error Boundaries

Errors should stop at defined boundaries.

Each layer handles only the errors it understands.

Never leak infrastructure errors into business logic.

---

# Configuration

Configuration belongs outside the application.

Never hardcode

Secrets

Environment values

URLs

Credentials

Ports

Use dependency injection and configuration providers.

---

# Data Ownership

Every piece of data has one owner.

Avoid duplicate sources of truth.

Synchronization problems are usually ownership problems.

---

# Event-Driven Design

Events represent facts.

Commands request work.

Queries retrieve information.

Never confuse these responsibilities.

---

# Scalability

Design for expected growth.

Do not prematurely optimize for millions of users.

Instead

Build systems that can evolve.

---

# Performance

Measure first.

Optimize second.

Document significant performance decisions.

Every optimization introduces complexity.

---

# Security

Security is architectural.

Not cosmetic.

Design for

Least privilege

Defense in depth

Secure defaults

Explicit trust boundaries

---

# Observability

Every system should be observable.

Support

Structured logging

Metrics

Tracing

Health checks

Meaningful error reporting

If you cannot observe a system

You cannot maintain it.

---

# Resilience

Expect failure.

Systems should

Retry appropriately

Timeout safely

Recover gracefully

Avoid cascading failures

---

# Technical Debt

Technical debt should be

Intentional

Documented

Prioritized

Invisible debt becomes expensive debt.

---

# Reuse

Prefer

Reuse

↓

Extension

↓

Replacement

Avoid rewriting working systems without compelling evidence.

---

# Decision Making

Before introducing a new pattern ask

Does this solve today's problem?

Can existing architecture support it?

Does it increase complexity?

Will another engineer understand it?

Can it be tested?

Can it be maintained?

If not

Do not introduce it.

---

# Architecture Reviews

Major changes should review

Dependencies

Security

Performance

Maintainability

Testing

Deployment

Documentation

Integration impact

---

# Architecture Decision Records (ADR)

Create an ADR when

- introducing major technology
- changing architecture
- modifying system boundaries
- changing deployment strategy
- redesigning data flow
- introducing significant dependencies

An ADR should include

- Context
- Problem
- Options
- Decision
- Consequences

---

# Anti-Patterns

Avoid

God Objects

Massive Controllers

Circular Dependencies

Hidden State

Business Logic in UI

Business Logic in Database Queries

Copy-and-Paste Programming

Magic Values

Overengineering

Premature Optimization

Framework-Driven Design

---

# Self Review Checklist

Before approving an architectural decision

✓ Is it simpler?

✓ Is it more maintainable?

✓ Does it reduce coupling?

✓ Does it improve cohesion?

✓ Is it testable?

✓ Is it observable?

✓ Is it secure?

✓ Can another engineer understand it?

✓ Does it fit the existing architecture?

✓ Is the complexity justified?

---

# Final Principle

Architecture is successful when engineers spend their time solving business problems instead of fighting the system.

The best architecture is rarely the most clever.

It is the one that quietly enables teams to deliver quality software for years.