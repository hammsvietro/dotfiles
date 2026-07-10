---
name: org-summary
description: Produce a brief, scannable Emacs Org-mode summary — standup notes, status recaps, keynote bullets, or any "summarize/recap this in org" request. Use when the user asks for an org-mode summary, org bullet points, or notes to read aloud or skim.
---

# Org-mode summary

Output one Org-mode document and nothing else — no preamble, no closing note.

## Format
- Headings `*` / `**` only; nesting two levels deep at most.
- Every bullet starts with a `*bold*` keyword lead, then a short fragment.
- Fragments over sentences — drop articles and filler.
- One idea per bullet; group related bullets under a heading.

## Content
- Lead with what was done / decided / built — outcomes, not process.
- Keywords carry the point; the speaker fills the rest in aloud.
- Scale to the ask: a one-minute talk → ~3 headings, terse; a deep recap → more.

## Shape
```
#+TITLE: <topic>

** <Section>
- *Keyword* — short fragment
- *Keyword* — short fragment
```
