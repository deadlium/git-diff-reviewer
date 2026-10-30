# Contributing to git-diff-reviewer

Welcome! We are excited to collaborate with open-source contributors and AI skill developers.

## The Git Flow ("God Flow")

We follow a strict, automated branching and release flow:

```
feature/<topic> / fix/<topic>
           │
           │ (Pull Request & CI Quality Gate)
           ▼
         build  (Integration Branch)
           │
           │ (Automated Fast-Forward Promotion on CI Success)
           ▼
        master  (Stable Production Branch)
```

### Critical Rules
1. **`master`** is our production-ready, stable branch. Never commit or push directly to `master`.
2. **`build`** is our central integration branch. All feature, fix, and documentation branches originate from `build`.
3. **NEVER Delete Any Branch**:
   - Branches are permanent historical artifacts in this repository.
   - Do **NOT** run `git branch -d` or delete branches upon PR merge. GitHub PRs must be merged without deleting head branches.
4. **Automated Promotion**:
   - When a Pull Request merges into `build`, our automated GitHub Actions workflow validates all test scenarios. Upon passing, `build` is automatically promoted into `master`.

---

## Local Development & Validation

Before submitting a Pull Request, verify your changes locally:

```bash
# 1. Check out build and create your feature branch
git checkout build
git checkout -b feat/my-improvement

# 2. Make your edits

# 3. Run the automated skill validation suite
./scripts/validate-skill.sh
```

All 6 validation phases (including the 12 scenario test fixtures and markdown link resolver) must pass with 0 errors.

---

## Commit Message Conventions

We strictly enforce [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/):
- `feat(<scope>): <description>`
- `fix(<scope>): <description>`
- `docs(<scope>): <description>`
- `refactor(<scope>): <description>`
- `test(<scope>): <description>`
- `chore(<scope>): <description>`
