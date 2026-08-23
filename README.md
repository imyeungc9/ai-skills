# ai-skills

Reusable, cross-tool AI **skills** — `/slash-command` prompts shared across
**Claude Code**, **Cursor**, and **GitHub Copilot**. Each skill is a single
`skills/<name>/SKILL.md` file. Global skills live here; skills that only make
sense inside one project are checked into that project's own repo instead.

## Skills

| Skill | Invoke | Description |
|-------|--------|-------------|
| `mw-create-skill` | `/mw-create-skill` | Scaffold a new cross-tool skill into this repo and push it. |
| `mw-simplicity-first` | `/mw-simplicity-first` | Prefer the simplest solution first; ask when unsure; offer simple alternatives as plain-language design options. |
| `mw-update-doc-simplicity` | `/mw-update-doc-simplicity` | Rewrite docs (given scope, or the current branch's changed docs) to be simple, jargon-free, concise, and easy to follow. |
| `mw-design-options` | `/mw-design-options` | Lay out a few plain-language design options for a problem (simplest first), with a recommendation and why. |

## Global, with no per-skill install (Claude Code)

Claude Code loads personal skills from `~/.claude/skills/<name>/SKILL.md` in
**every** project, and follows symlinks there. So `setup.sh` points that whole
directory at this repo **once**:

```bash
git clone https://github.com/imyeungc9/ai-skills.git ~/Documents/code/imyeungc9/ai-skills
cd ~/Documents/code/imyeungc9/ai-skills
./setup.sh
```

After that, every skill in this repo is usable as `/<name>` in any project, and
new skills need **no install** — add a folder (or `git pull`) and it's live.
`/mw-create-skill` writes new skills straight into this repo.

## Other tools

Only Claude Code offers "symlink one folder → global everywhere." The others:

- **Copilot** — user-level prompt files are global across workspaces but each
  needs a `.prompt.md` file. `./setup.sh --copilot` symlinks every skill into your
  VS Code user prompts folder (`~/Library/Application Support/Code/User/prompts/`)
  as `<name>.prompt.md`. Re-run it after adding skills, and enable *"Chat: Prompt
  Files"* in VS Code. Per project instead: drop them in `.github/prompts/`.
- **Cursor** — global rules are GUI-only (Settings → Rules). File-based rules and
  commands are per project: `.cursor/rules/*.mdc` (needs frontmatter) or
  `.cursor/commands/*.md`. Copy a skill's body in where you want it.

## Project-specific skills

If a skill only matters inside one codebase, don't put it here — check it into
that project's repo so it travels with the code:

```
<project>/.claude/skills/<name>/SKILL.md      # Claude Code (project scope)
<project>/.cursor/commands/<name>.md          # Cursor
<project>/.github/prompts/<name>.prompt.md    # Copilot
```

## The one-file format

Each `SKILL.md` carries frontmatter every tool tolerates — each reads the keys it
knows and ignores the rest:

```yaml
---
name: mw-create-skill
description: ...              # Claude + Copilot
argument-hint: ...           # Claude
allowed-tools: ...           # Claude
disable-model-invocation: true  # Claude: only run on /invoke, don't auto-fire
mode: agent                 # Copilot
---
```

## Add a skill

Run `/mw-create-skill <name> <what it does>` in Claude Code. It writes
`skills/<name>/SKILL.md`, updates the table above, commits, and pushes. It's live
globally the moment it's written. Set `AI_SKILLS_HOME` if your clone isn't at
`~/Documents/code/imyeungc9/ai-skills`.
