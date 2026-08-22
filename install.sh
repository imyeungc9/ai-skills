#!/usr/bin/env bash
#
# install.sh — materialize canonical skills into per-tool formats and wire them
# into the tools installed on this machine.
#
# Usage:
#   ./install.sh                 # build + install every skill under skills/
#   ./install.sh mw-create-skill # build + install just one skill
#
# For each skill it generates, under skills/<name>/dist/:
#   <name>.md          -> Claude Code command   (also symlinked to ~/.claude/commands/)
#   cursor/<name>.md   -> Cursor command
#   copilot/<name>.prompt.md -> GitHub Copilot prompt file
#
# Claude commands are installed globally (~/.claude/commands) so /<name> works in
# any Claude Code session. Cursor and Copilot resolve their prompt files per
# project, so copy or symlink the generated dist files into a project's
# .cursor/commands and .github/prompts when you want them there (see README).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CMD_DIR="${HOME}/.claude/commands"

build_one() {
  local name="$1"
  local src="${REPO_ROOT}/skills/${name}/SKILL.md"
  if [[ ! -f "$src" ]]; then
    echo "error: no SKILL.md for '${name}' at ${src}" >&2
    return 1
  fi
  local dist="${REPO_ROOT}/skills/${name}/dist"
  mkdir -p "${dist}/cursor" "${dist}/copilot"

  python3 "${REPO_ROOT}/scripts/render.py" "$src" "$name" "$dist"

  mkdir -p "$CLAUDE_CMD_DIR"
  ln -sf "${dist}/${name}.md" "${CLAUDE_CMD_DIR}/${name}.md"
  echo "installed: ${name}"
  echo "  claude : ${CLAUDE_CMD_DIR}/${name}.md -> ${dist}/${name}.md"
  echo "  cursor : ${dist}/cursor/${name}.md"
  echo "  copilot: ${dist}/copilot/${name}.prompt.md"
}

main() {
  if [[ $# -ge 1 ]]; then
    build_one "$1"
  else
    for d in "${REPO_ROOT}"/skills/*/; do
      [[ -f "${d}SKILL.md" ]] && build_one "$(basename "$d")"
    done
  fi
}

main "$@"
