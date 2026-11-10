---
name: SECURITY_STANDARDS
version: 1.0.0
description: Universal security standards for every engineering agent, regardless of language, framework, or project.
---

# SECURITY STANDARDS

## Purpose

Security is not a phase.

Security is part of engineering.

Every engineer is responsible for protecting users, data, infrastructure, and intellectual property.

These standards define the minimum security expectations for every implementation.

---

# Security Philosophy

Assume:

- Every input is malicious.
- Every network is hostile.
- Every dependency may contain vulnerabilities.
- Every secret can leak.
- Every permission can be abused.

Design accordingly.

---

# Core Principles

Always

- Validate input
- Sanitize output
- Authenticate users
- Authorize actions
- Encrypt sensitive data
- Log security events
- Follow least privilege

Never trust external systems.

---

# Authentication

Authentication verifies identity.

Requirements

- Strong authentication
- Secure session management
- Token expiration
- Token rotation where applicable
- MFA support when appropriate

Never implement custom authentication without strong justification.

Prefer proven authentication providers.

---

# Authorization

Authentication answers

"Who are you?"

Authorization answers

"What are you allowed to do?"

Every protected action must verify authorization.

Never rely solely on frontend validation.

---

# Least Privilege

Applications should receive only the permissions they require.

Examples

Database

Read/Write only required schemas

Cloud

Minimal IAM permissions

API Keys

Only required scopes

Never grant administrator privileges by default.

---

# Secrets Management

Secrets include

- API Keys
- Passwords
- OAuth Tokens
- Certificates
- JWT Secrets
- Private Keys
- Connection Strings

Secrets must

- Never be hardcoded
- Never be committed
- Never appear in logs
- Never appear in screenshots
- Never appear in documentation

Use secure secret management.

---

# Input Validation

Validate all external input.

Examples

- HTTP requests
- Files
- Environment variables
- CLI arguments
- Third-party APIs
- WebSockets
- Message queues

Reject invalid input early.

---

# Output Encoding

Escape output appropriate to the destination.

Prevent

- Cross Site Scripting (XSS)
- HTML Injection
- Script Injection

Never concatenate HTML using untrusted input.

---

# SQL Safety

Never concatenate SQL strings.

Always use

- Prepared statements
- Parameterized queries
- ORM parameter binding

Review every database query.

---

# Command Execution

Never execute shell commands using user input.

If shell execution is required

Validate

Whitelist

Escape

Review

Prefer avoiding shell execution entirely.

---

# File Handling

Validate

- filename
- extension
- MIME type
- file size

Never trust uploaded filenames.

Never allow unrestricted file execution.

---

# Dependency Security

Before adding a dependency

Review

- maintenance
- license
- vulnerabilities
- community adoption
- necessity

Prefer fewer dependencies.

Update vulnerable packages promptly.

---

# API Security

Every API should

Validate input

Return appropriate status codes

Protect sensitive endpoints

Authenticate

Authorize

Rate limit where appropriate

Log security events

---

# Session Security

Sessions should

Expire

Invalidate on logout

Protect against fixation

Use secure cookies where applicable

Never expose session identifiers.

---

# Logging

Security logs should include

Authentication failures

Authorization failures

Permission changes

Configuration changes

Critical system actions

Never log

Passwords

Tokens

Secrets

Personal information

Sensitive payloads

---

# Encryption

Encrypt sensitive information

At Rest

In Transit

Use modern algorithms.

Do not implement custom cryptography.

---

# Error Messages

Errors should help developers

Without helping attackers.

Avoid

Database stack traces

Internal paths

Secrets

Configuration values

Internal architecture

Expose only necessary information.

---

# Third-Party Services

Review

Authentication

Permissions

Data sharing

Compliance

Availability

Security posture

Do not blindly trust external APIs.

---

# Rate Limiting

Protect endpoints from abuse.

Especially

Authentication

Password reset

Search

Public APIs

Resource-intensive operations

---

# Auditability

Critical actions should be traceable.

Examples

User creation

Permission changes

Financial operations

Configuration updates

Security events

Logs should support incident investigation.

---

# Security Reviews

Review for

Authentication

Authorization

Injection

Secrets

Input validation

Dependency risk

Logging

Configuration

Privilege escalation

Sensitive data exposure

---

# Common Vulnerabilities

Every engineer should actively prevent

- SQL Injection
- XSS
- CSRF
- SSRF
- Command Injection
- Path Traversal
- Open Redirects
- Insecure Deserialization
- Broken Authentication
- Broken Authorization
- Information Disclosure

Review these risks whenever applicable.

---

# Incident Response

If a security issue is discovered

Stop implementation.

Document

Impact

Risk

Recommended mitigation

Escalate immediately.

Never hide security findings.

---

# Self Review Checklist

Before completion

✓ Input validated

✓ Authorization verified

✓ Secrets protected

✓ Sensitive logs removed

✓ Dependencies reviewed

✓ Authentication respected

✓ Secure defaults maintained

✓ No obvious OWASP risks

✓ Security documentation updated where necessary

---

# Final Principle

Security is everyone's responsibility.

The most secure system is not the one with the most security features.

It is the one where secure engineering decisions are made consistently, every day, by every engineer.