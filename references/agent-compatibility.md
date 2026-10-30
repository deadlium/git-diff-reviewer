# Cross-Agent Compatibility Guide

The `git-diff-reviewer` skill adheres strictly to the universal [Agent Skills](https://agentskills.io/) standard. It is runtime-neutral and functions across all major AI agent environments without requiring proprietary SDKs or binary dependencies.

---

## 1. Claude Code

Claude Code discovers skills placed in either project-level or user-level directories.

### Project-level installation
Place the skill into your project's `.claude/skills/` directory:
```bash
mkdir -p .claude/skills
ln -s /path/to/git-diff-reviewer .claude/skills/git-diff-reviewer
```

### Global installation
Place the skill in your user config directory:
```bash
mkdir -p ~/.claude/skills
ln -s /path/to/git-diff-reviewer ~/.claude/skills/git-diff-reviewer
```

Claude Code will automatically discover `SKILL.md`, read the YAML frontmatter, and invoke the skill when git diff or commit review requests are detected.

---

## 2. OpenAI Codex

OpenAI Codex reads skills and system instructions from workspace skill configurations:

### Project installation
Add to `.codex/skills/`:
```bash
mkdir -p .codex/skills
cp -r /path/to/git-diff-reviewer .codex/skills/git-diff-reviewer
```

Codex parses the YAML description and triggers progressive disclosure of `SKILL.md` when reviewing git diffs.

---

## 3. Google Antigravity

Antigravity natively supports workspace skills in `.gemini/skills/` and global skills in `~/.gemini/antigravity-cli/skills/`:

### Workspace installation
```bash
mkdir -p .gemini/skills
ln -s /path/to/git-diff-reviewer .gemini/skills/git-diff-reviewer
```

### Global CLI installation
```bash
mkdir -p ~/.gemini/antigravity-cli/skills
ln -s /path/to/git-diff-reviewer ~/.gemini/antigravity-cli/skills/git-diff-reviewer
```

Antigravity auto-indexes the skill from `SKILL.md` frontmatter and displays it in active capabilities.

---

## 4. OpenBot

OpenBot natively indexes agent skills in `~/.agents/skills/` or within individual agent workspaces:

### Shared library installation
```bash
mkdir -p ~/.agents/skills
ln -s /path/to/git-diff-reviewer ~/.agents/skills/git-diff-reviewer
```

### Agent-specific installation
Inside an agent's directory:
```bash
mkdir -p .agents/skills
ln -s /path/to/git-diff-reviewer .agents/skills/git-diff-reviewer
```

---

## 5. Cursor & Windsurf

For Cursor and Windsurf, reference the skill from `.cursorrules` or `.windsurfrules`:
```markdown
# Git Diff Reviewer Rules
When reviewing git diffs, preparing commit messages, or analyzing unstaged changes, strictly follow the rules defined in ./SKILL.md and output the mandatory section:
### If you want this as ONE daily commit
```

---

## 6. Compatibility Verification Matrix

| Agent Runtime | Discovery Mechanism | Skill Parsing | Reference Loading | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Claude Code** | `.claude/skills/` | YAML Frontmatter | Relative Markdown links | Verified |
| **OpenAI Codex** | `.codex/skills/` | Standard Prompting | File read | Verified |
| **Google Antigravity** | `.gemini/skills/` | Native Skill Index | Native link resolution | Verified |
| **OpenBot** | `.agents/skills/` | Native Skill Index | Tool / File lookup | Verified |
| **Cursor / Windsurf** | Workspace rule links | System Prompt | Context window | Verified |
