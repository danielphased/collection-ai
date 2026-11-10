---
description: Kotlin engineering standards for production Android
  development — null safety, immutable state, sealed types, coroutines,
  structured concurrency, Flow/StateFlow, error handling and testing. Use
  when writing or reviewing Kotlin code.
name: kotlin-engineering
version: 1.1.0
---

# Kotlin Engineering

## Purpose

Provide production Kotlin engineering practices for Android
applications, including appliance and dedicated-device apps.

Project-specific rules (architecture, branches, ticket keys, device models) belong in the project's own CLAUDE.md or .claude/ — follow them when present.

## Scope

Covers:

-   Kotlin language features
-   null safety
-   immutable data
-   sealed classes/interfaces
-   data classes
-   generics
-   extension functions
-   collections
-   exceptions
-   coroutines
-   structured concurrency
-   Flow
-   StateFlow
-   cancellation
-   concurrency safety
-   testability

## Core Rules

1.  Prefer immutable state.
2.  Use structured concurrency.
3.  Never launch unmanaged coroutines.
4.  Respect cancellation.
5.  Keep UI state explicit.
6.  Avoid global mutable state.
7.  Prefer small, composable functions.
8.  Keep domain logic independent of Android UI classes where practical.
9.  Do not swallow exceptions.
10. Do not use nullable values to hide invalid states when a stronger
    type is practical.

## Coroutines

-   Use the appropriate lifecycle-aware scope.
-   Never use `GlobalScope` for application work.
-   Propagate cancellation.
-   Distinguish expected failures from programming errors.
-   Keep blocking work off the main thread.
-   Verify dispatcher choices for I/O and CPU-heavy work.

## Flow

Use `Flow`/`StateFlow` for observable state where appropriate.

Avoid collecting the same source repeatedly without a lifecycle reason.

State exposed to UI should be stable and explicit.

## Error Handling

Errors must be:

-   classified
-   observable
-   actionable
-   tested

Security failures must not be converted into generic success states.

## Concurrency

Pay particular attention to shared state such as:

-   room/device state
-   authentication state
-   WebView/native bridge state
-   media state
-   enrollment state
-   reboot/recovery state

Race conditions in security-sensitive flows are release blockers until
understood.

## Verification

Kotlin changes should include appropriate:

-   unit tests
-   coroutine tests
-   state tests
-   error-path tests
-   static analysis
-   build verification

## Handoff

Report concurrency decisions, lifecycle assumptions, tests performed,
and any unverified behavior.
