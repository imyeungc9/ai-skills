#!/usr/bin/env python3
"""Render a canonical SKILL.md into per-tool prompt files.

Usage: render.py <SKILL.md> <skill-name> <dist-dir>

Parses YAML-ish frontmatter (name/description/argument-hint/allowed-tools) and
the markdown body, then writes:
  <dist>/<name>.md                 Claude Code command  (frontmatter kept as-is)
  <dist>/cursor/<name>.md          Cursor command       (plain body, no frontmatter)
  <dist>/copilot/<name>.prompt.md  Copilot prompt file  (mode + description frontmatter)

No third-party deps: a tiny frontmatter parser handles the simple key: value
frontmatter these skills use.
"""
import os
import sys


def parse(path):
    with open(path, "r", encoding="utf-8") as fh:
        text = fh.read()
    meta, body = {}, text
    if text.startswith("---"):
        end = text.find("\n---", 3)
        if end != -1:
            block = text[3:end].strip("\n")
            body = text[end + 4 :].lstrip("\n")
            for line in block.splitlines():
                if ":" in line and not line.lstrip().startswith("#"):
                    key, _, val = line.partition(":")
                    meta[key.strip()] = val.strip()
    return meta, body


def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content if content.endswith("\n") else content + "\n")


def main():
    if len(sys.argv) != 4:
        sys.exit("usage: render.py <SKILL.md> <name> <dist-dir>")
    src, name, dist = sys.argv[1], sys.argv[2], sys.argv[3]
    meta, body = parse(src)
    desc = meta.get("description", "").strip()
    arg_hint = meta.get("argument-hint", "").strip()
    tools = meta.get("allowed-tools", "").strip()

    # --- Claude Code command: keep the canonical frontmatter verbatim. ---
    fm = ["---", f"description: {desc}"]
    if arg_hint:
        fm.append(f"argument-hint: {arg_hint}")
    if tools:
        fm.append(f"allowed-tools: {tools}")
    fm.append("---")
    write(os.path.join(dist, f"{name}.md"), "\n".join(fm) + "\n\n" + body)

    # --- Cursor command: plain markdown body (Cursor reads the file as the prompt). ---
    header = f"# {name}\n\n" if not body.lstrip().startswith("#") else ""
    write(os.path.join(dist, "cursor", f"{name}.md"), header + body)

    # --- Copilot prompt file: mode + description frontmatter. ---
    cfm = ["---", "mode: agent"]
    if desc:
        cfm.append(f"description: {desc}")
    cfm.append("---")
    write(
        os.path.join(dist, "copilot", f"{name}.prompt.md"),
        "\n".join(cfm) + "\n\n" + body,
    )


if __name__ == "__main__":
    main()
