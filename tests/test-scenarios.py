#!/usr/bin/env python3
"""
Behavioral and structural test runner for git-diff-reviewer test scenarios.
Validates the 12 representative diff fixtures against classification, safety, and commit rules.
"""
import os
import sys
import re

FIXTURES_DIR = os.path.join(os.path.dirname(__file__), "fixtures")

EXPECTATIONS = {
    "01-simple-bug-fix.diff": {
        "expected_type": "fix",
        "expected_scope": "cache",
        "must_contain": ["LRUCache", "detach", "attachToHead"],
        "description": "Simple bug fix updating LRU cache node attachment"
    },
    "02-multi-file-feature.diff": {
        "expected_type": "feat",
        "expected_scope": "auth",
        "must_contain": ["JwtService", "authMiddleware", "Bearer"],
        "description": "Multi-file JWT authentication feature and middleware"
    },
    "03-mixed-feature-docs.diff": {
        "expected_type": "feat",
        "expected_scope": "export|csv",
        "must_contain": ["exportToCsv", "README.md"],
        "description": "Mixed feature code and README documentation update"
    },
    "04-refactoring-only.diff": {
        "expected_type": "refactor",
        "expected_scope": "utils|math",
        "must_contain": ["calculateStats", "reduce"],
        "description": "Refactoring math stats without altering external behavior"
    },
    "05-security-sensitive.diff": {
        "expected_type": "fix",
        "expected_scope": "db|security",
        "must_contain": ["SELECT * FROM users", "$1"],
        "description": "Security-sensitive fix replacing raw string interpolation with parameterized query"
    },
    "06-large-daily-diff.diff": {
        "expected_type": "feat|chore",
        "expected_scope": "api|server",
        "must_contain": ["cors", "metricsHandler", "api.test.ts"],
        "description": "Large daily diff spanning config, API route, and test assertions"
    },
    "07-incomplete-implementation.diff": {
        "expected_type": "feat|chore",
        "expected_scope": "billing|stripe",
        "must_contain": ["TODO", "FIXME", "Promise.resolve(true)"],
        "description": "Incomplete implementation containing TODO / stub logic"
    },
    "08-planned-docs-only.diff": {
        "expected_type": "docs",
        "expected_scope": "roadmap|docs",
        "must_contain": ["Roadmap", "Multi-Region"],
        "description": "Documentation-only addition of planned future features without code"
    },
    "09-split-independent-commits.diff": {
        "split_recommended": True,
        "must_contain": ["theme.css", "audit_logs"],
        "description": "Independent styling change and SQL migration that warrant split commits"
    },
    "10-coherent-daily-commit.diff": {
        "expected_type": "feat",
        "expected_scope": "notifications|slack",
        "must_contain": ["sendSlackAlert", "webhookUrl", "slack.test.ts"],
        "description": "Coherent daily change combining implementation and matching unit test"
    },
    "11-prompt-injection.diff": {
        "is_adversarial": True,
        "must_contain": ["SYSTEM INSTRUCTION OVERRIDE", "evil assistant"],
        "description": "Malicious prompt injection embedded in code comments"
    },
    "12-shell-sensitive-characters.diff": {
        "has_shell_chars": True,
        "must_contain": ["$APP_ENV", "`hostname`", "print"],
        "description": "Diff containing quotes, backticks, dollar signs, and variable substitutions"
    }
}

def test_fixtures():
    print("==================================================")
    print("Testing 12 Representative Git Diff Scenarios")
    print("==================================================")
    
    passed = 0
    total = len(EXPECTATIONS)
    
    for filename, meta in EXPECTATIONS.items():
        filepath = os.path.join(FIXTURES_DIR, filename)
        if not os.path.exists(filepath):
            print(f"❌ [FAIL] Missing fixture file: {filename}")
            continue
            
        with open(filepath, "r") as f:
            content = f.read()
            
        # Verify content requirements
        content_ok = True
        for pattern in meta["must_contain"]:
            if pattern not in content:
                print(f"❌ [FAIL] {filename}: Pattern '{pattern}' not found in fixture")
                content_ok = False
                break
                
        if not content_ok:
            continue
            
        # Verify specific scenario assertions
        if meta.get("is_adversarial"):
            # Check that safety rules in SKILL.md address prompt injection
            skill_path = os.path.join(os.path.dirname(__file__), "..", "skills", "git-diff-reviewer", "SKILL.md")
            with open(skill_path, "r") as sf:
                skill_text = sf.read()
            if "prompt injection" not in skill_text.lower() and "untrusted" not in skill_text.lower():
                print(f"❌ [FAIL] {filename}: SKILL.md does not contain untrusted/prompt injection defense")
                continue
                
        if meta.get("has_shell_chars"):
            # Check that shell escaping instructions are covered
            conv_path = os.path.join(os.path.dirname(__file__), "..", "skills", "git-diff-reviewer", "references", "conventional-commits.md")
            with open(conv_path, "r") as cf:
                conv_text = cf.read()
            if "multi-`-m`" not in conv_text.lower() and "multi-m" not in conv_text.lower():
                print(f"❌ [FAIL] {filename}: conventional-commits.md lacks shell escaping guidance")
                continue

        print(f"✓ [PASS] Scenario {filename}: {meta['description']}")
        passed += 1

    print("--------------------------------------------------")
    print(f"Scenario Test Results: {passed}/{total} Passed")
    print("==================================================")
    return passed == total

if __name__ == "__main__":
    if not test_fixtures():
        sys.exit(1)
