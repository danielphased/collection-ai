---
name: verify
description: Run the project's own quality gates (lint, typecheck, tests, production build) before saying work is done, fixed or ready. Use before claiming completion, before committing, before handing work to QA, or when asked to "verify", "check everything" or "make sure it builds".
---

# Verify before claiming done

"Tests pass" is not "it works". Run the same gates CI runs, including a real
production build, and report exactly what ran and what it printed.

## 1. Find the project's gates

Read, in this order, and use what the project defines instead of guessing:

1. `CLAUDE.md` / `README` / `CONTRIBUTING` — documented check or verify commands.
2. CI config (`.github/workflows/*`, `.gitlab-ci.yml`, `Jenkinsfile`) — the steps a PR must pass.
3. Build manifests:

| Stack | Typical gates |
|---|---|
| Node (`package.json`) | `lint`, `typecheck`/`tsc --noEmit`, `test` (non-watch, e.g. `vitest run`), `build`, plus any `check:*` / `audit` scripts |
| Python (`pyproject.toml`) | `ruff`/`flake8`, `mypy`, `pytest` |
| Rust (`Cargo.toml`) | `cargo fmt --check`, `cargo clippy -- -D warnings`, `cargo test` |
| Go (`go.mod`) | `go vet ./...`, `go test ./...`, `go build ./...` |
| Android (Gradle) | `./gradlew lint test assembleRelease` |
| iOS (Xcode / xcodegen) | regenerate project if `project.yml` exists, then `xcodebuild test` / `build` |

Use the package manager the lockfile implies (npm / pnpm / yarn / bun).
Never run test runners in watch mode.

## 2. Run them

- Run cheap gates first (lint, typecheck), then tests, then the production build.
- Run the production build even when tests pass: dev/test transforms often skip
  steps (minification, message precompilation, tree-shaking) that only fail in prod.
- Scope to the changed package in a monorepo, but run the full build for that package.
- Do not "fix" a gate by weakening it (skipping tests, adding ignores, lowering
  thresholds). If a gate fails for reasons unrelated to the change, report it.

## 3. Check the running thing when it matters

For deployed or runtime changes, confirm the running version (commit SHA, build
number, health endpoint) and the observable behaviour, not just that a command succeeded.

## 4. Report

List each gate as PASS / FAIL / NOT RUN with the command and the key output line.
Say "not verified" for anything you could not run. Only say "done" when every
relevant gate passed.
