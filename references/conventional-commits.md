# Conventional Commits Reference Specification

This document details the commit taxonomy and rules enforced by the `git-diff-reviewer` skill, adhering to the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) standard.

---

## 1. Primary Types

| Type | Intent & Scope | When to Use |
| :--- | :--- | :--- |
| `feat` | New feature or capability | User-facing or API additions that introduce new functionality. |
| `fix` | Bug fix | Addresses a defect, regression, exception, or incorrect behavior. |
| `refactor` | Code restructuring | Modifies code without altering outward behavior or adding tests. |
| `perf` | Performance improvement | Algorithmic optimization, query tuning, caching, or memory optimization. |
| `test` | Test suite changes | Adding, updating, or fixing unit, integration, or e2e tests. |
| `docs` | Documentation | Documentation files (`.md`), inline JSDoc/docstrings, tutorials, or guides. |
| `style` | Formatting & styling | Whitespace, formatting, semi-colons; no code logic alteration. |
| `chore` | Maintenance tasks | Dependency updates, tooling changes, gitignore adjustments. |
| `build` | Build system | Changes affecting npm/pip/cargo, bundling, or build configurations. |
| `ci` | CI/CD pipelines | GitHub Actions workflows, test scripts, automated release pipelines. |
| `revert` | Reverting changes | Reverts a previous commit. |

---

## 2. Standard Scopes

Scopes provide contextual categorization for the modified module. Recommended scopes include:
- `core`: Central engine, primitives, base classes.
- `api`: HTTP/REST/gRPC endpoints, routing, controllers.
- `auth`: Authentication, JWT, RBAC, OAuth.
- `ui`: User interface, layouts, styles, web components.
- `db`: Database schemas, migrations, ORM models.
- `workflow`: CI/CD automation, GitHub workflows, release actions.
- `skill`: AI agent skill definitions, prompts, references.
- `cli`: Command-line tools, arguments, flags, terminal outputs.
- `config`: Configuration files, environment variables, settings.

---

## 3. Breaking Changes

If a change introduces backward-incompatible modifications:
1. Append an exclamation mark (`!`) before the colon:
   `feat(api)!: migrate auth endpoints to v2 signature`
2. Include a `BREAKING CHANGE:` footer in the commit body describing what broke and migration steps.

---

## 4. Structuring Commit Bodies

- Subject line: imperative mood, lowercase, no period, maximum 72 characters.
- Body lines: implementation-focused bullet points (`- `) explaining *what* was done and *why*.
- Mention architectural impact and configuration changes explicitly.
- **Never** repeat the subject line inside the body.
- **Never** include unverified claims (e.g. claiming a test passed without evidence).
