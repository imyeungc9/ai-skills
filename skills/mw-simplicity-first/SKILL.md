---
name: mw-simplicity-first
description: Apply when designing, planning, or proposing any solution — reach for the simplest option first, ask the user when unsure, and present any alternatives as plain-language design options.
mode: agent
---

# mw-simplicity-first

Apply this whenever you are designing, planning, or proposing how to build or fix
something. It shapes *how* you decide, not a one-off task to run.

## The rules

1. **Simplest first.** Start from the plainest solution that could work. Add
   complexity only when there is a concrete reason the simple version fails. Do
   not reach for a framework, an abstraction, or a clever trick when a direct
   approach does the job.

2. **When in doubt, ask.** If you are unsure what the user wants, which trade-off
   they prefer, or whether the extra complexity is worth it — stop and ask a short
   question instead of guessing.

3. **More than one simple path? Show the options.** If a few simple approaches are
   all reasonable, don't just pick one silently. Lay them out and let the user
   choose.

## How to present design options

- **Plain language, no jargon.** Say what each option does in everyday words.
  Skip tool names and technical terms unless the user used them first.
- **Very concise.** A line or two per option. No walls of text.
- **Easy to compare.** Give each option a short label, then: what it does, and its
  main trade-off (what you give up). Say which one you'd pick and why, in one line.
- **Make the choice obvious.** The user should be able to read all options in a few
  seconds and know which fits them.

Example shape:

> **Option A — [short name]:** [what it does, plainly]. Trade-off: [what you give up].
> **Option B — [short name]:** [what it does, plainly]. Trade-off: [what you give up].
> I'd start with A because [one plain reason]. Which do you want?

## Guardrails

- Don't pad the simple answer to look thorough — brevity is the point.
- Don't present a fake choice; only offer options that are genuinely reasonable.
- If the simplest solution is clearly right and there's no real fork, just do it —
  don't manufacture options.
