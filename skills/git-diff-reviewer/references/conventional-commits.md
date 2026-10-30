# Conventional Commits Specification & Formatting Guide

This guide establishes the rules for drafting Conventional Commits within the `git-diff-reviewer` skill. All generated commit messages must comply with the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) standard.

---

## 1. Commit Structure

A Conventional Commit message consists of a **Header**, an optional **Body**, and an optional **Footer**:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### 1.1 Header Grammar
- **Type**: Mandatory lowercase token indicating the purpose of the change.
- **Scope**: Optional noun enclosed in parentheses indicating the affected codebase module.
- **Breaking Change Indicator**: An optional exclamation mark (`!`) placed immediately before the colon (e.g., `feat(api)!: redesign authentication endpoints`).
- **Description**: Concise summary in the imperative mood, lower-case, no trailing period, maximum 72 characters (ideally <= 50 characters).

### 1.2 Body
- Detailed explanation of **what** changed and **why** (never just repeating the subject).
- Formatted as concise, implementation-focused bullet points.
- Explains architectural motivations, trade-offs, and runtime behavior changes.

### 1.3 Footers
- Breaking changes indicator: `BREAKING CHANGE: <explanation of breaking change and migration guide>`.
- References: `Fixes #123`, `Closes PROJ-456`.
- Co-authors: `Co-authored-by: Name <email@example.com>`.

---

## 2. Commit Type Taxonomy

| Type | Intent | When to Use |
| :--- | :--- | :--- |
| `feat` | New feature | Introduces new functionality for users or external consumers. |
| `fix` | Bug fix | Patches a defect, crash, logic error, or regression. |
| `refactor` | Code refactoring | Modifies internal structure without changing external behavior or adding features. |
| `perf` | Performance improvement | Code change that improves execution speed, memory footprint, or bundle size. |
| `test` | Testing | Adds missing test suites, mocks, fixtures, or corrects existing tests. |
| `docs` | Documentation | Documentation updates, README additions, inline code docstrings. |
| `style` | Formatting | Whitespace, linting, semicolons, cosmetic adjustments (no code logic changes). |
| `chore` | Maintenance | Routine maintenance, dependency bumps, tooling updates, configuration tweaks. |
| `build` | Build system | Changes to build scripts, webpack/vite configs, external build dependencies. |
| `ci` | Continuous Integration | Changes to CI workflows, GitHub Actions, Dockerfiles, testing pipelines. |
| `revert` | Revert commit | Reverts a previous commit (`revert: feat(auth): rollback oauth changes`). |

### 2.1 Primary Type Selection Rule
When a daily diff includes mixed modifications (e.g., feature code + tests + documentation):
1. **Feature priority**: If the diff introduces substantive new capability, use `feat`.
2. **Fix priority**: If the primary purpose is fixing a bug, use `fix`.
3. **Refactor priority**: If the behavior remains unchanged, use `refactor`.
4. Document the secondary changes (docs, tests, chores) inside the commit body bullets.

---

## 3. Scope Guidelines

Scopes provide instant organizational context. Use consistent lowercase nouns reflecting project modules:

- **Core & Backend**: `core`, `api`, `auth`, `db`, `models`, `services`, `storage`, `queue`
- **Frontend & UI**: `ui`, `components`, `views`, `styles`, `state`, `router`, `assets`
- **Infrastructure**: `config`, `deps`, `docker`, `ci`, `repo`, `scripts`, `env`
- **Documentation**: `docs`, `readme`, `examples`, `spec`
- **Skills & Agents**: `skill`, `prompts`, `references`, `evals`

*Rule*: Do not invent overly narrow scopes like `feat(fix-button-color-on-hover)`. Prefer `feat(ui): update hover contrast for primary button`.

---

## 4. Shell-Safe Git Command Construction

Commit messages frequently contain characters that Bash/Zsh interpret as special operators: double quotes (`"`), backticks (``` ` ```), dollar signs (`$`), single quotes (`'`), and exclamation marks (`!`).

### 4.1 The Multi-`-m` Pattern (Recommended)
Splitting the subject and body into separate `-m` arguments avoids newline escaping issues across shells:

```bash
git commit -m "feat(auth): add OAuth2 refresh token rotation" \
  -m "- Implement token rotation service handling concurrent refreshes safely
- Add sliding window expiration with 30-day absolute ceiling
- Persist hashed tokens in redis cache with transactional invalidation
- Add unit and integration tests covering race conditions"
```

### 4.2 Escape Rules for Quoting
- **Double quotes in message body**: Escape with backslash `\"` when using double-quoted `-m "..."`.
- **Dollar signs (`$`)**: Must be escaped as `\$` inside double quotes to prevent shell variable substitution (e.g., `Update \$PATH handling`).
- **Backticks (`` ` ``)**: Must be escaped as `\` or single-quoted to avoid executing subshells.
- **Exclamation marks (`!`)**: In interactive Zsh/Bash, unescaped `!` triggers history expansion. Use single quotes or escape as `\!`.

---

## 5. Anti-Patterns to Strictly Avoid

1. **Vague descriptions**:
   - ❌ `fix: update code`
   - ❌ `feat: misc changes from today`
   - ✅ `fix(parser): prevent infinite recursion on nested JSON arrays`

2. **Repeating subject in body**:
   - ❌ First line of body repeats the subject line verbatim.
   - ✅ Body immediately dives into implementation details, rationales, and trade-offs.

3. **Hallucinated claims**:
   - ❌ Claiming tests were added or passed when no test files appear in the diff.
   - ❌ Inventing issue numbers (e.g., `Closes #999`) without evidence in the diff or prompt.

4. **Co-Author Trailers**:
   - Only add `Co-authored-by: Name <email>` when explicitly requested by the user or evidenced in the branch collaboration context.
