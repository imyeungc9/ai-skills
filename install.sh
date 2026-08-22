#!/usr/bin/env bash
#
# install.sh — install skills by SYMLINKING each canonical skills/<name>/SKILL.md
# into the locations Claude Code, Cursor, and Copilot read from. Nothing is
# copied or generated: there is one file per skill, and editing it updates every
# tool at once. The single SKILL.md carries frontmatter every tool tolerates
# (Claude reads description/argument-hint/allowed-tools; Copilot reads mode +
# description; Cursor ignores frontmatter).
#
# Usage:
#   ./install.sh                      # link every skill's Claude command globally
#   ./install.sh <name>               # link just that skill (Claude, global)
#   ./install.sh --project <dir>      # also link every skill into a project's
#                                     #   Cursor + Copilot dirs
#   ./install.sh --project <dir> <name>
#
# Link names per tool (all point at the same SKILL.md):
#   ~/.claude/commands/<name>.md                     Claude Code   (global)
#   <project>/.cursor/commands/<name>.md             Cursor        (per project)
#   <project>/.github/prompts/<name>.prompt.md       Copilot       (per project)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CMD_DIR="${HOME}/.claude/commands"

PROJECT=""
if [[ "${1:-}" == "--project" ]]; then
  [[ -n "${2:-}" ]] || { echo "error: --project needs a directory" >&2; exit 1; }
  mkdir -p "$2"
  PROJECT="$(cd "$2" && pwd)"
  shift 2
fi

link_one() {
  local name="$1"
  local src="${REPO_ROOT}/skills/${name}/SKILL.md"
  if [[ ! -f "$src" ]]; then
    echo "error: no SKILL.md for '${name}' at ${src}" >&2
    return 1
  fi

  mkdir -p "$CLAUDE_CMD_DIR"
  ln -sf "$src" "${CLAUDE_CMD_DIR}/${name}.md"
  echo "linked: ${name}"
  echo "  claude : ${CLAUDE_CMD_DIR}/${name}.md"

  if [[ -n "$PROJECT" ]]; then
    mkdir -p "${PROJECT}/.cursor/commands" "${PROJECT}/.github/prompts"
    ln -sf "$src" "${PROJECT}/.cursor/commands/${name}.md"
    ln -sf "$src" "${PROJECT}/.github/prompts/${name}.prompt.md"
    echo "  cursor : ${PROJECT}/.cursor/commands/${name}.md"
    echo "  copilot: ${PROJECT}/.github/prompts/${name}.prompt.md"
  fi
}

if [[ $# -ge 1 ]]; then
  link_one "$1"
else
  for d in "${REPO_ROOT}"/skills/*/; do
    [[ -f "${d}SKILL.md" ]] && link_one "$(basename "$d")"
  done
fi
