# Agent Compatibility & Installation Guide

This document specifies installation paths, discovery mechanisms, verification matrices, and known limitations across leading AI coding agents for `git-diff-reviewer`.

---

## Compatibility Matrix

| AI Agent | Skill Location | Discovery Method | Verification Status | Notes |
| :--- | :--- | :--- | :---: | :--- |
| **Claude Code** | `.claude/skills/git-diff-reviewer/` or `.agents/skills/git-diff-reviewer/` | Automatic project-level skill discovery | Verified ✓ | Supports progressive disclosure and modular reference loading. |
| **OpenAI Codex** | `.agents/skills/git-diff-reviewer/` or `skills/git-diff-reviewer/` | Project skill indexing | Verified ✓ | Evaluates `SKILL.md` frontmatter and instructions. |
| **Google Antigravity** | `.gemini/skills/git-diff-reviewer/` or `skills/git-diff-reviewer/` | Workspace skill registration | Verified ✓ | Native support for Markdown-first agent skills and subagent delegation. |
| **OpenBot** | `.agents/skills/git-diff-reviewer/` | Agent skills discovery | Verified ✓ | Full support for skill loading, shared DB, and git commands. |
| **Cursor** | `.cursorrules` or `.agents/skills/git-diff-reviewer/` | Rules integration | Verified ✓ | Can reference `SKILL.md` directly in prompt or project rules. |
| **Windsurf** | `.windsurfrules` or `skills/git-diff-reviewer/` | Cascades rule indexing | Verified ✓ | Markdown references accessible in cascade context. |

---

## Installation Instructions by Agent

### 1. Claude Code
Install as a project skill in your repository:
```bash
# Option A: In the project .claude/skills directory
mkdir -p .claude/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .claude/skills/git-diff-reviewer

# Option B: In the standard .agents/skills directory
mkdir -p .agents/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .agents/skills/git-diff-reviewer
```

### 2. Google Antigravity
Add to your Antigravity workspace skills directory:
```bash
mkdir -p .gemini/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .gemini/skills/git-diff-reviewer
```

### 3. OpenAI Codex
Add to the project skills directory:
```bash
mkdir -p .agents/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .agents/skills/git-diff-reviewer
```

### 4. OpenBot
Add to your agent or shared skills path:
```bash
mkdir -p ~/.openbot/skills # or .agents/skills
git clone https://github.com/deadlium/git-diff-reviewer.git .agents/skills/git-diff-reviewer
```

### 5. Cursor & Windsurf
Reference `git-diff-reviewer` in your project rules:
```bash
mkdir -p skills/git-diff-reviewer
git clone https://github.com/deadlium/git-diff-reviewer.git skills/git-diff-reviewer
```
Add to `.cursorrules` or `.windsurfrules`:
```
When reviewing Git changes or generating commit messages, follow the instructions in skills/git-diff-reviewer/SKILL.md and output the mandatory daily commit section.
```

---

## Universal Verification Checklist

To verify that the skill is correctly registered in any agent:

1. **Discovery Check**: Ask the agent:
   > "List available skills and describe what git-diff-reviewer does."
   The agent should recognize `git-diff-reviewer` from its YAML frontmatter.

2. **Trigger Check**: Provide a sample diff and say:
   > "Review this diff and prepare our daily commit."
   The agent should produce the 8 standard sections including `### If you want this as ONE daily commit`.

3. **Reference Loading Check**:
   Confirm the agent reads `references/conventional-commits.md` and `references/review-severity.md` when encountering complex commit scopes or severe defects.

---

## Known Limitations

- **Large Diffs**: Diffs exceeding 50,000 characters may hit agent context limits. Agents should analyze files in logical chunks.
- **Binary Files**: Diff reviewers cannot interpret binary assets (images, compiled archives); they should be noted in the change summary as binary additions/modifications without inspecting content.
- **Git Hook Interactions**: Generated commands assume standard git configuration without conflicting pre-commit hook constraints.
