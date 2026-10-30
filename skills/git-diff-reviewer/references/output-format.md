# Standardized Review Output Format

This document defines the canonical Markdown layout that `git-diff-reviewer` produces for every comprehensive Git change review.

---

## Output Template Structure

Each comprehensive review should follow these eight numbered sections:

```markdown
# Engineering Review: <Short Change Summary>

## A. Overview
- **Repository / Module**: `<project-or-module-name>`
- **Core Purpose**: <1-2 sentences on what this changeset accomplishes>
- **Key Modifications**: <Bulleted list of main highlights>
- **Primary Type & Scope**: `<type>(<scope>)`
- **Recommended Strategy**: `Single Daily Commit` OR `Split into N Commits`

## B. Detailed Change Analysis
### `<subsystem-or-file-path>`
- **What Changed**: <Detailed explanation of code additions/removals>
- **Technical Rationale**: <Why this change was implemented>
- **Runtime & Ergonomic Effect**: <How execution behavior or developer experience shifts>
- **Limitations & Edge Cases**: <Identified boundaries or caveats>

## C. Change Classification
| Category | Applicable? | Rationale |
| :--- | :---: | :--- |
| `feat` | ✓ / — | <Reason for inclusion or exclusion> |
| `fix` | ✓ / — | <Reason for inclusion or exclusion> |
| `refactor` | ✓ / — | <Reason for inclusion or exclusion> |
| `perf` | ✓ / — | <Reason for inclusion or exclusion> |
| `test` | ✓ / — | <Reason for inclusion or exclusion> |
| `docs` | ✓ / — | <Reason for inclusion or exclusion> |
| `style` | ✓ / — | <Reason for inclusion or exclusion> |
| `chore` | ✓ / — | <Reason for inclusion or exclusion> |
| `build` | ✓ / — | <Reason for inclusion or exclusion> |
| `ci` | ✓ / — | <Reason for inclusion or exclusion> |

**Primary Selection**: `<type>(<scope>)` — <Short justification>

## D. Architecture & Behavioral Impact
- **Previous Behavior**: <How the system behaved prior to this change>
- **New Behavior**: <How the system behaves after this change>
- **State & Data Changes**: <Database schema updates, memory state, cache keys, IPC changes>
- **Contract & API Shifts**: <Public interfaces, signatures, REST/gRPC endpoints>
- **Remaining / Planned Work**: <Items noted in comments, TODOs, or docs not yet implemented in code>

## E. Issues & Recommendations
*(If no issues found, state: "No critical, high, or medium issues identified in this changeset.")*

#### [<SEVERITY>] <Issue Title>
- **File / Location**: `<file_path>:<line>`
- **Type**: Confirmed Defect | Potential Risk | Recommendation
- **Evidence**: `<relevant diff lines or snippet>`
- **Impact**: <Runtime or system impact>
- **Recommended Action**: <Concrete fix>

## F. Commit Strategy
- **Assessment**: <Explain whether this diff should be 1 unified commit or split>
- **Reasoning**: <Why the changeset represents a single logical unit of daily work OR why distinct concerns should be separated>
*(If splitting is recommended, provide the staging and commit commands for each logical commit here).*

## G. Commit Output

### If you want this as ONE daily commit

```bash
git commit -m "<type>(<scope>): <concise subject line>" \
  -m "- <Implementation detail 1>
- <Implementation detail 2>
- <Implementation detail 3>
- <Architecture / rationale note>"
```

**Short Alternative**:
```bash
git commit -m "<type>(<scope>): <concise subject line>"
```

## H. Release Notes
### Highlights (<version-or-date>)
- **New Features**:
  - <Bullet points of user-facing or API-facing capabilities>
- **Fixes & Hardening**:
  - <Bullet points of patched defects or resilience upgrades>
- **Developer Experience & Tooling**:
  - <Internal improvements, test suites, build configs>
```

---

## Strict Rules for Review Output

1. **Mandatory Daily Commit Heading**:
   The exact heading `### If you want this as ONE daily commit` must appear in every review without alteration.
2. **Never Fabricate Numbers or Claims**:
   If benchmark data or test pass counts are not present in the diff, do not make up statements like "improves performance by 40%".
3. **Shell Escaping**:
   Ensure all bash blocks use valid multi-`-m` commands with properly escaped quotes and variables.
