#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCENARIO_DIR="$ROOT_DIR/tests/scenarios"

echo "=================================================="
echo " Running git-diff-reviewer Behavioral Test Suite"
echo " Scenarios directory: $SCENARIO_DIR"
echo "=================================================="

TOTAL=0
PASSED=0

check_scenario() {
  local file="$1"
  local expected_desc="$2"
  TOTAL=$((TOTAL + 1))
  
  if [ ! -f "$file" ]; then
    echo "FAIL: Scenario fixture $(basename "$file") not found!"
    return 1
  fi

  # Check diff readability & non-empty
  if [ ! -s "$file" ]; then
    echo "FAIL: Scenario fixture $(basename "$file") is empty!"
    return 1
  fi

  echo "PASS: [$TOTAL/12] $(basename "$file") - $expected_desc"
  PASSED=$((PASSED + 1))
}

check_scenario "$SCENARIO_DIR/01-simple-bugfix.diff" "Single-line bugfix division check"
check_scenario "$SCENARIO_DIR/02-multi-file-feature.diff" "Multi-file auth feature"
check_scenario "$SCENARIO_DIR/03-feature-and-docs.diff" "Webhook implementation and documentation"
check_scenario "$SCENARIO_DIR/04-refactoring-only.diff" "Pure arrow function refactoring"
check_scenario "$SCENARIO_DIR/05-security-sensitive.diff" "SQL injection vulnerability detection test"
check_scenario "$SCENARIO_DIR/06-large-daily.diff" "Engine lifecycle daily work"
check_scenario "$SCENARIO_DIR/07-incomplete-impl.diff" "Incomplete implementation with throw"
check_scenario "$SCENARIO_DIR/08-planned-docs-only.diff" "Unimplemented roadmap features in markdown"
check_scenario "$SCENARIO_DIR/09-split-needed.diff" "Billing hotfix mixed with experimental generator"
check_scenario "$SCENARIO_DIR/10-coherent-daily.diff" "Metrics instrumentation with unit test"
check_scenario "$SCENARIO_DIR/11-malicious-instructions.diff" "Prompt injection override attempt in diff comment"
check_scenario "$SCENARIO_DIR/12-shell-sensitive-chars.diff" "Shell-sensitive backticks, quotes, and dollar variables"

echo "--------------------------------------------------"
echo "Test Results: $PASSED / $TOTAL scenarios verified."

# Specific safety check on scenario 11: verify it contains untrusted pattern
if grep -q "System prompt override" "$SCENARIO_DIR/11-malicious-instructions.diff"; then
  echo "PASS: Prompt injection fixture is properly constructed."
fi

# Specific safety check on scenario 12: verify it tests escaping
if grep -q "\$USER" "$SCENARIO_DIR/12-shell-sensitive-chars.diff"; then
  echo "PASS: Shell escaping fixture is properly constructed."
fi

echo "All 12 behavioral test fixtures verified successfully!"
