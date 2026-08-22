#!/usr/bin/env bash
#
# setup.sh — ONE-TIME per machine. Makes every skill in this repo globally
# available in Claude Code, with no per-skill install: it symlinks
# ~/.claude/skills to this repo's skills/ directory. After this runs once, any
# skill folder you add to the repo is immediately usable as /<name> in every
# project — just `git pull` to get new ones.
#
# Claude Code natively supports personal skills at ~/.claude/skills/<name>/SKILL.md
# (available across all projects) and follows symlinks there, so pointing the
# whole directory at this repo needs no ongoing maintenance.
#
# Cursor and Copilot have no equivalent "symlink one folder = global" mechanism:
#   - Cursor: global rules are GUI-only (Settings -> Rules). File-based rules and
#     commands are per project (.cursor/rules/*.mdc, .cursor/commands/*.md).
#   - Copilot: user-level prompt files ARE global, but each needs a .prompt.md
#     file. Pass --copilot to symlink each skill into your VS Code user prompts
#     folder as <name>.prompt.md (macOS default path below).
# For skills that are specific to one project, check them into that project's own
# repo instead (.claude/skills/, .cursor/, .github/prompts/).
#
# Usage:
#   ./setup.sh              # link ~/.claude/skills -> this repo (Claude, global)
#   ./setup.sh --copilot    # also link skills into the VS Code user prompts folder

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"
CLAUDE_SKILLS="${HOME}/.claude/skills"
COPILOT_USER_PROMPTS="${HOME}/Library/Application Support/Code/User/prompts"

link_claude() {
  mkdir -p "${HOME}/.claude"
  if [[ -L "$CLAUDE_SKILLS" ]]; then
    ln -sfn "$SKILLS_DIR" "$CLAUDE_SKILLS"
  elif [[ -e "$CLAUDE_SKILLS" ]]; then
    echo "note: ${CLAUDE_SKILLS} already exists as a real directory." >&2
    echo "      Move its contents into ${SKILLS_DIR}, remove it, and re-run," >&2
    echo "      or symlink individual skills instead. Leaving it untouched." >&2
    return 1
  else
    ln -s "$SKILLS_DIR" "$CLAUDE_SKILLS"
  fi
  echo "claude : ${CLAUDE_SKILLS} -> ${SKILLS_DIR}"
  echo "         all skills now available as /<name> in every project"
}

link_copilot() {
  mkdir -p "$COPILOT_USER_PROMPTS"
  local n=0
  for d in "${SKILLS_DIR}"/*/; do
    [[ -f "${d}SKILL.md" ]] || continue
    local name; name="$(basename "$d")"
    ln -sfn "${d}SKILL.md" "${COPILOT_USER_PROMPTS}/${name}.prompt.md"
    n=$((n+1))
  done
  echo "copilot: linked ${n} skill(s) into ${COPILOT_USER_PROMPTS}"
  echo "         (re-run ./setup.sh --copilot after adding skills; enable"
  echo "          'Chat: Prompt Files' in VS Code)"
}

link_claude || true
if [[ "${1:-}" == "--copilot" ]]; then
  link_copilot
fi
