# git-diff-reviewer

[![CI & Skill Quality Gate](https://github.com/deadlium/git-diff-reviewer/actions/workflows/ci.yml/badge.svg)](https://github.com/deadlium/git-diff-reviewer/actions/workflows/ci.yml)
[![Auto-Promote Build to Master](https://github.com/deadlium/git-diff-reviewer/actions/workflows/promote-to-master.yml/badge.svg)](https://github.com/deadlium/git-diff-reviewer/actions/workflows/promote-to-master.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Agent Skills: Universal](https://img.shields.io/badge/Agent_Skills-Universal_v1.0-blue.svg)](https://github.com/deadlium/git-diff-reviewer)

> **Universal cross-agent AI engineering review skill.** Transforms messy daily Git diffs, staged changes, and patch files into rigorous code reviews, architectural impact assessments, Conventional Commits, shell-safe ready-to-run Git commands, and release notes.

Designed to work out of the box with **Claude Code**, **OpenAI Codex**, **Google Antigravity**, **OpenBot**, **Cursor**, **Windsurf**, and any agent conforming to the Agent Skills specification.

---

## Why git-diff-reviewer?

AI code generators write code fast, but commits are often vague, untracked, or broken into incoherent pieces. `git-diff-reviewer` brings Senior Staff Engineer rigor to your git workflow:

1. **Evidence-Based Code Review**: Triages findings across 5 standardized severity tiers (`Critical`, `High`, `Medium`, `Low`, `Informational`) citing concrete file lines and data flows.
2. **Runtime & Architecture Impact**: Contrasts *before* versus *after* execution behavior, database migrations, and contract shifts.
3. **Mandatory Daily Commit**: Guarantees a ready-to-copy, multiline, shell-escaped `git commit` command under the exact header `### If you want this as ONE daily commit`.
4. **Smart Split Detection**: Distinguishes coherent daily work from divergent changes that should be committed separately.
5. **Security & Prompt Injection Hardening**: Treats diff contents as untrusted data, refusing embedded override prompts and sanitizing secret leaks.

---

## Review Pipeline Architecture

```
                 [Raw Git Diff / Staged Changes]
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 1. Completeness & Sanity Check  │
               └────────────────┬────────────────┘
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 2. Deep Subsystem Code Review   │
               └────────────────┬────────────────┘
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 3. Conventional Classification  │
               └────────────────┬────────────────┘
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 4. Architecture & State Delta   │
               └────────────────┬────────────────┘
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 5. Issue & Severity Triage      │
               └────────────────┬────────────────┘
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 6. Commit Strategy Evaluation   │
               └────────────────┬────────────────┘
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 7. Ready-to-Copy Shell Command  │
               │ (### If you want this as ONE...│
               └────────────────┬────────────────┘
                                │
                                ▼
               ┌─────────────────────────────────┐
               │ 8. Release Notes & Git Flow     │
               └─────────────────────────────────┘
```

---

## Cross-Agent Installation

### Claude Code
Install as a project skill or user skill:
```bash
# In your repository
mkdir -p .claude/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .claude/skills/git-diff-reviewer
```

### Google Antigravity
Install in your Antigravity workspace skills directory:
```bash
mkdir -p .gemini/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .gemini/skills/git-diff-reviewer
```

### OpenAI Codex
Install in the project-level `.agents/skills` directory:
```bash
mkdir -p .agents/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .agents/skills/git-diff-reviewer
```

### OpenBot
Install in the OpenBot agents skill directory:
```bash
git clone https://github.com/deadlium/git-diff-reviewer.git /Users/deadlium/OpenBot/Agents/<agent-id>/.agents/skills/git-diff-reviewer
```

### Cursor & Windsurf
Clone the repository and reference the skill in your `.cursorrules` or `.windsurfrules`:
```bash
git clone https://github.com/deadlium/git-diff-reviewer.git skills/git-diff-reviewer
```
Add to your rules file:
```
When reviewing Git changes or generating commit messages, follow skills/git-diff-reviewer/SKILL.md.
```

---

## Quickstart & Usage

Simply supply your changes to any supported agent:

```
Review our current git diff and prepare the daily commit.
```

Or pass raw diff output:
```bash
git diff | agent
```

### Example Output

```markdown
# Engineering Review: OAuth2 Token Refresh Rotation

## A. Overview
- **Repository / Module**: `auth-service`
- **Core Purpose**: Introduce sliding-window token rotation with redis invalidation.
- **Primary Type & Scope**: `feat(auth)`
- **Recommended Strategy**: Single Daily Commit

## B. Detailed Change Analysis
...

## C. Change Classification
| Category | Applicable? | Rationale |
| :--- | :---: | :--- |
| `feat` | ✓ | Adds token refresh rotation capability |
| `test` | ✓ | Adds integration tests covering concurrent refresh |

## D. Architecture & Behavioral Impact
- **Previous Behavior**: Static refresh tokens valid until expiry.
- **New Behavior**: Each refresh generates a single-use token pair; reused tokens trigger immediate family revocation.

## E. Issues & Recommendations
No critical, high, or medium issues identified in this changeset.

## F. Commit Strategy
The changes represent a single atomic daily unit of work across auth service and tests.

## G. Commit Output

### If you want this as ONE daily commit

```bash
git commit -m "feat(auth): add OAuth2 refresh token rotation" \
  -m "- Implement token rotation service handling concurrent refreshes safely
- Add sliding window expiration with 30-day absolute ceiling
- Persist hashed tokens in redis cache with transactional invalidation
- Add unit and integration tests covering race conditions"
```

**Short Alternative**:
```bash
git commit -m "feat(auth): add OAuth2 refresh token rotation"
```

## H. Release Notes
### Highlights
- **New Features**: Single-use OAuth2 refresh token rotation with family revocation on reuse.
- **Security & Reliability**: Thread-safe Redis token store with atomic invalidation.
```

---

## Git Branching Model ("God Flow")

This repository strictly enforces the **God Flow**:

```
feat/*, fix/*, docs/*
         │
         │ (PR & CI Validation)
         ▼
       build  (Integration)
         │
         │ (Automated Fast-Forward Promotion on CI Green)
         ▼
      master  (Stable Release)
```

- **`master`**: Production release branch. Only updated automatically via CI promotion.
- **`build`**: Central integration branch. All feature branches branch from and target `build`.
- **Permanent Branch Preservation**: **NEVER delete branches.** Retain all branches permanently for auditability.

---

## Testing & Validation Suite

Run the full automated validation suite locally:

```bash
./scripts/validate-skill.sh
```

Validates:
1. File structure & required reference presence.
2. YAML frontmatter parsing.
3. Mandatory `### If you want this as ONE daily commit` heading.
4. Relative markdown link integrity.
5. Secret and token leak prevention.
6. Execution of 12 behavioral test scenarios (`tests/fixtures/*.diff`).

---

## Directory Structure

```
.
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
│       ├── ci.yml
│       └── promote-to-master.yml
├── scripts/
│   └── validate-skill.sh
├── skills/
│   └── git-diff-reviewer/
│       ├── SKILL.md
│       └── references/
│           ├── agent-compatibility.md
│           ├── conventional-commits.md
│           ├── output-format.md
│           └── review-severity.md
├── tests/
│   ├── fixtures/
│   │   ├── 01-simple-bug-fix.diff
│   │   ├── ...
│   │   └── 12-shell-sensitive-characters.diff
│   └── test-scenarios.py
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── SKILL.md -> skills/git-diff-reviewer/SKILL.md
└── references -> skills/git-diff-reviewer/references
```

---

## License

Released under the [MIT License](LICENSE).
