#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT
SKILL_DIR="$REPO_ROOT/skills/git-diff-reviewer"
ERRORS=0

echo "=================================================="
echo "Running Skill Validation Suite for git-diff-reviewer"
echo "=================================================="

# 1. Check Required Files
echo "[1/6] Checking required file presence..."
REQUIRED_FILES=(
  "skills/git-diff-reviewer/SKILL.md"
  "skills/git-diff-reviewer/references/conventional-commits.md"
  "skills/git-diff-reviewer/references/review-severity.md"
  "skills/git-diff-reviewer/references/output-format.md"
  "skills/git-diff-reviewer/references/agent-compatibility.md"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [[ -f "$REPO_ROOT/$file" ]]; then
    echo "  ✓ Found $file"
  else
    echo "  ❌ Missing required file: $file"
    ERRORS=$((ERRORS + 1))
  fi
done

# 2. Check SKILL.md Frontmatter
echo "[2/6] Validating SKILL.md YAML frontmatter..."
SKILL_FILE="$SKILL_DIR/SKILL.md"
if grep -q "^---" "$SKILL_FILE" &&    grep -q "^name: git-diff-reviewer" "$SKILL_FILE" &&    grep -q "^description:" "$SKILL_FILE"; then
  echo "  ✓ Valid YAML frontmatter found (name and description present)"
else
  echo "  ❌ Invalid or missing YAML frontmatter in SKILL.md"
  ERRORS=$((ERRORS + 1))
fi

# 3. Check Mandatory Section Header
echo "[3/6] Verifying mandatory daily commit heading..."
MANDATORY_HEADING="### If you want this as ONE daily commit"
if grep -qF "$MANDATORY_HEADING" "$SKILL_FILE" &&    grep -qF "$MANDATORY_HEADING" "$SKILL_DIR/references/output-format.md"; then
  echo "  ✓ Mandatory section heading present in SKILL.md and output-format.md"
else
  echo "  ❌ Mandatory section '$MANDATORY_HEADING' missing in SKILL.md or output-format.md"
  ERRORS=$((ERRORS + 1))
fi

# 4. Check Markdown Relative Links
echo "[4/6] Checking internal Markdown reference links..."
python3 - << 'PYEOF'
import os
import re
import sys

repo = os.environ.get("REPO_ROOT")
skill_dir = os.path.join(repo, "skills", "git-diff-reviewer")
errors = 0

for root, _, files in os.walk(skill_dir):
    for f in files:
        if f.endswith(".md"):
            filepath = os.path.join(root, f)
            with open(filepath, "r") as fh:
                text = fh.read()
            # find all [label](target.md)
            matches = re.findall(r'\[([^\]]+)\]\(([^)]+\.md)\)', text)
            for label, target in matches:
                if target.startswith("http://") or target.startswith("https://"):
                    continue
                # resolve target relative to current file dir
                resolved = os.path.normpath(os.path.join(os.path.dirname(filepath), target))
                if not os.path.exists(resolved):
                    print(f"  ❌ Broken link in {f}: '{target}' -> {resolved}")
                    errors += 1

if errors > 0:
    sys.exit(1)
else:
    print("  ✓ All internal markdown links resolve successfully")
PYEOF

if [[ $? -ne 0 ]]; then
  ERRORS=$((ERRORS + 1))
fi

# 5. Security and Leak Checks
echo "[5/6] Performing security audit and secret leak checks..."
# Check for accidental committed secrets like actual AWS keys or private keys
if grep -rE "(AKIA[0-9A-Z]{16}|ghp_[0-9a-zA-Z]{36}|-----BEGIN RSA PRIVATE KEY-----)" "$REPO_ROOT" --exclude-dir=".git" --exclude-dir="node_modules" --exclude="validate-skill.sh" --exclude="ci.yml" >/dev/null 2>&1; then
  echo "  ❌ Real secret pattern detected in repository!"
  ERRORS=$((ERRORS + 1))
else
  echo "  ✓ No unencrypted secrets or access tokens detected"
fi

# 6. Run Scenario Test Suite
echo "[6/6] Executing 12 representative test scenarios..."
export REPO_ROOT
python3 "$REPO_ROOT/tests/test-scenarios.py"

echo "--------------------------------------------------"
if [[ $ERRORS -eq 0 ]]; then
  echo "✓ All skill validation checks passed successfully!"
  exit 0
else
  echo "❌ Skill validation failed with $ERRORS error(s)."
  exit 1
fi
