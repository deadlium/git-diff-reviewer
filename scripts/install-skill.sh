#!/usr/bin/env bash
set -euo pipefail

SKILL_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-all}"

echo "=================================================="
echo " git-diff-reviewer Universal Skill Installer"
echo " Source: $SKILL_SRC"
echo " Target: $TARGET"
echo "=================================================="

install_claude() {
  echo "-> Installing for Claude Code..."
  mkdir -p "$HOME/.claude/skills"
  ln -sfn "$SKILL_SRC" "$HOME/.claude/skills/git-diff-reviewer"
  echo "   [OK] Linked to ~/.claude/skills/git-diff-reviewer"
}

install_codex() {
  echo "-> Installing for OpenAI Codex..."
  mkdir -p "$HOME/.codex/skills"
  ln -sfn "$SKILL_SRC" "$HOME/.codex/skills/git-diff-reviewer"
  echo "   [OK] Linked to ~/.codex/skills/git-diff-reviewer"
}

install_antigravity() {
  echo "-> Installing for Google Antigravity..."
  mkdir -p "$HOME/.gemini/antigravity-cli/skills"
  ln -sfn "$SKILL_SRC" "$HOME/.gemini/antigravity-cli/skills/git-diff-reviewer"
  echo "   [OK] Linked to ~/.gemini/antigravity-cli/skills/git-diff-reviewer"
}

install_openbot() {
  echo "-> Installing for OpenBot..."
  mkdir -p "$HOME/.agents/skills"
  ln -sfn "$SKILL_SRC" "$HOME/.agents/skills/git-diff-reviewer"
  echo "   [OK] Linked to ~/.agents/skills/git-diff-reviewer"
}

case "$TARGET" in
  claude)
    install_claude
    ;;
  codex)
    install_codex
    ;;
  antigravity)
    install_antigravity
    ;;
  openbot)
    install_openbot
    ;;
  all)
    install_claude
    install_codex
    install_antigravity
    install_openbot
    ;;
  *)
    echo "Usage: $0 [claude|codex|antigravity|openbot|all]"
    exit 1
    ;;
esac

echo ""
echo "Installation completed successfully!"
