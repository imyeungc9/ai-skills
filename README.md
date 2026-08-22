# ai-skills

Portable AI **skills** — reusable `/slash-command` prompts that work the same way
across **Claude Code**, **Cursor**, and **GitHub Copilot**. Each skill is written
once as a canonical `SKILL.md` and materialized into each tool's native format, so
you can version them in git and reuse them on any machine.

## Skills

| Skill | Invoke | Description |
|-------|--------|-------------|
| `mw-create-skill` | `/mw-create-skill` | Scaffold a new cross-tool skill into this repo, install it, and push it. |

## Layout

```
skills/<name>/SKILL.md   Canonical source: frontmatter (name, description,
                         argument-hint, allowed-tools) + instruction body.
skills/<name>/dist/      Generated, tool-specific files (created by install.sh):
    <name>.md                  Claude Code command
    cursor/<name>.md           Cursor command
    copilot/<name>.prompt.md   Copilot prompt file
install.sh               Builds dist/ for every skill and links Claude commands.
scripts/render.py        Frontmatter -> per-tool renderer (no dependencies).
```

## Install

From a fresh clone:

```bash
git clone https://github.com/imyeungc9/ai-skills.git
cd ai-skills
./install.sh                 # build all skills; ./install.sh <name> for one
```

`install.sh` symlinks each Claude command into `~/.claude/commands/`, so
`/<name>` works in any Claude Code session immediately.

### Cursor

Cursor resolves commands per project. Point a project at the generated files once:

```bash
mkdir -p /path/to/project/.cursor/commands
ln -sf "$PWD/skills/mw-create-skill/dist/cursor/mw-create-skill.md" \
       /path/to/project/.cursor/commands/mw-create-skill.md
```

Then run `/mw-create-skill` in Cursor's chat.

### GitHub Copilot

Copilot reads prompt files from `.github/prompts/` in a workspace (enable
*"Chat: Prompt Files"* in VS Code settings):

```bash
mkdir -p /path/to/project/.github/prompts
ln -sf "$PWD/skills/mw-create-skill/dist/copilot/mw-create-skill.prompt.md" \
       /path/to/project/.github/prompts/mw-create-skill.prompt.md
```

Then run `/mw-create-skill` in Copilot Chat.

## Add a skill

Use the meta-skill: run `/mw-create-skill <name> <what it does>` in any of the
three tools. It writes the canonical `SKILL.md`, runs `install.sh`, updates this
table, and pushes. Set `AI_SKILLS_HOME` to point at your clone if it is not at
`~/Documents/code/ai-skills`.
