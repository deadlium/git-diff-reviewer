# Output Format & Review Templating Reference

All comprehensive engineering reviews produced by `git-diff-reviewer` must adhere to the standardized structure documented below.

---

## Standard Output Skeleton

```markdown
# Engineering Review: <Project Name or Core Area>

## A. Overview
- **Primary Type & Scope**: `<type>(<scope>)`
- **Summary**: <1-3 concise sentences summarizing purpose and approach>
- **Recommended Strategy**: <Single daily commit | Multi-commit split>

## B. Detailed Change Analysis
### `<file-path-or-subsystem-1>`
- **Nature of Change**: <Added | Modified | Removed | Renamed>
- **What Changed**: <Technical explanation of modifications>
- **Technical Impact**: <Behavioral change, caller consequences, state shifts>
- **Limitations / Concerns**: <Missing checks, edge cases, TODOs>

## C. Change Classification
| Conventional Type | Applicable? | Evidence & Impacted Files |
| :--- | :---: | :--- |
| `feat` | Yes / No | ... |
| `fix` | Yes / No | ... |
| `refactor` | Yes / No | ... |
| `perf` | Yes / No | ... |
| `test` | Yes / No | ... |
| `docs` | Yes / No | ... |
| `chore`/`build`/`ci` | Yes / No | ... |

*Primary Classification*: `<type>(<scope>)` — <Rationale for primary selection>

## D. Architecture and Behavior Impact
- **Previous Implementation**: <How the code operated previously>
- **New Implementation**: <How the code operates now>
- **System Delta & Incomplete Work**: <Side effects, follow-up items>

## E. Issues and Recommendations
- **[CRITICAL]**: <Issue description, evidence, and remediation>
- **[HIGH]**: <Issue description, evidence, and remediation>
- **[MEDIUM]**: <Issue description, evidence, and remediation>
- **[LOW]**: <Issue description, evidence, and remediation>
- **[INFORMATIONAL]**: <Architecture observations>
*(If no issues found, state: "No critical or high severity defects observed.")*

## F. Commit Strategy
<Analysis justifying a single daily commit or recommending a split into discrete logical commits. If recommending a split, provide staging commands and messages for each chunk.>

### If you want this as ONE daily commit

```bash
git commit -m "<type>(<scope>): <concise imperative subject under 72 chars>" -m "- <Bullet 1: Main implementation feature>
- <Bullet 2: Specific logic or architectural adjustment>
- <Bullet 3: Edge cases handled or error resilience added>
- <Bullet 4: Documentation, tests, or config updates>"
```

**Short alternative**:
```bash
git commit -m "<type>(<scope>): <concise imperative subject under 72 chars>"
```

## G. Release Notes
- **New Features**: <Summary of new features>
- **Fixes**: <Summary of bug fixes>
- **Breaking Changes**: <None or details>
- **Internal / DX**: <Refactors, tooling, dependencies>
```
