# Review Severity Guidelines

This guide establishes the objective classification criteria used by `git-diff-reviewer` to grade discovered issues and recommendations.

---

## 1. Severity Levels

### [CRITICAL]
- **Definition**: Catastrophic defects, severe security vulnerabilities, data corruption, or immediate system crash conditions.
- **Criteria**:
  - Remote code execution, unauthenticated privilege escalation, SQL/command injection.
  - Hardcoded production secrets or private keys in tracked files.
  - Data loss bugs, dropping tables, uncontrolled infinite loops locking threads.
- **Action**: Must be blocked from merging immediately.

### [HIGH]
- **Definition**: Significant functional defect or security risk that breaks core user workflows or contracts.
- **Criteria**:
  - Unhandled exceptions in primary execution paths.
  - Broken API contract or unhandled null/undefined dereference in normal runtime.
  - Concurrency race conditions leading to corrupted state.
  - Missing authentication/authorization checks on non-public endpoints.
- **Action**: Requires remediation before proceeding to production.

### [MEDIUM]
- **Definition**: Non-fatal issues, missing edge-case handling, performance bottlenecks, or test omissions.
- **Criteria**:
  - Missing validation on secondary user inputs.
  - Absence of automated tests for newly introduced business logic.
  - Unoptimized nested database queries or memory retention.
  - Inadequate error reporting hiding the root cause.
- **Action**: Should be addressed prior to release or scheduled in immediate follow-up.

### [LOW]
- **Definition**: Minor defects, code cleanliness concerns, or documentation discrepancies.
- **Criteria**:
  - Dead code, unused imports, typos in user-facing strings or logs.
  - Inconsistent formatting or naming violating project conventions.
  - Outdated docstrings or inaccurate README snippets.
- **Action**: Can be addressed during routine cleanup.

### [INFORMATIONAL]
- **Definition**: Contextual observations, architectural notes, and future enhancement suggestions.
- **Criteria**:
  - Suggestions for future refactoring.
  - Observations on system behavior changes.
  - Notes on external dependency lifecycle.
