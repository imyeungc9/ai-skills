# ai-skills

Portable AI **skills** — reusable `/slash-command` prompts that work the same way
across **Claude Code**, **Cursor**, and **GitHub Copilot**. Each skill is a single
`SKILL.md` file; installing it just **symlinks** that one file into each tool's
prompt directory. There are no generated copies — edit `SKILL.md` and every tool
picks up the change at once.

## Skills

| Skill | Invoke | Description |
|-------|--------|-------------|
| `mw-create-skill` | `/mw-create-skill` | Scaffold a new cross-tool skill into this repo, install it, and push it. |

## How one file serves three tools

Each `SKILL.md` has YAML frontmatter that every tool tolerates — each reads the
keys it knows and ignores the rest:

```yaml
---
name: mw-create-skill
description: ...        # Claude + Copilot
argument-hint: ...      # Claude
allowed-tools: ...      # Claude
mode: agent            # Copilot
---
```

The installer symlinks that file (under the filename each tool expects) into:

| Tool | Link | Scope |
|------|------|-------|
| Claude Code | `~/.claude/commands/<name>.md` | global |
| Cursor | `<project>/.cursor/commands/<name>.md` | per project |
| Copilot | `<project>/.github/prompts/<name>.prompt.md` | per project |

## Layout

```
skills/<name>/SKILL.md   The one and only file for the skill.
install.sh               Symlinks skills into each tool's prompt dir.
```

## Install

From a fresh clone:

```bash
git clone https://github.com/imyeungc9/ai-skills.git
cd ai-skills
./install.sh                       # link every skill's Claude command globally
./install.sh mw-create-skill       # just one skill
./install.sh --project /path/to/proj          # also link Cursor + Copilot there
./install.sh --project /path/to/proj mw-create-skill
```

`/<name>` then works in each tool. (Copilot also needs the *"Chat: Prompt Files"*
setting enabled in VS Code.) Because the links point back into this clone, keep
the clone in place; `git pull` updates every linked skill everywhere.

## Add a skill

Run `/mw-create-skill <name> <what it does>` in any of the three tools. It writes
`skills/<name>/SKILL.md`, runs `install.sh`, updates the table above, and pushes.
Set `AI_SKILLS_HOME` if your clone is not at `~/Documents/code/ai-skills`.
