# Stats 20 Vault

An Obsidian vault of succinct Markdown summaries for **UCLA Stats 20 — Introduction to Statistical Programming with R**.

## Purpose

- Short, review-friendly summaries of lectures, the syllabus, and homework.
- Notes linked to each other with `[[wikilinks]]` so topics connect across weeks.
- Runnable R code blocks, plus R-rendered plots and dashboards saved in `assets/`.
- Later: an Obsidian plugin to run or refresh the R content from inside the vault.

## Layout

```
stats20-vault/
├── course/      # syllabus, schedule, course-wide index notes
├── lectures/    # one note per lecture
├── homework/    # one note per assignment
├── r/           # standalone R scripts used by notes
├── templates/   # Obsidian note templates
└── assets/      # rendered R plots and images
```

## Frontmatter spec (draft)

Every note starts with YAML frontmatter:

```yaml
---
course: stats20
type: lecture        # lecture | homework | syllabus | index
week: 3
topics:
  - vectors
  - indexing
r_files:
  - r/week03-vectors.R
related:
  - "[[Lecture 05 - Data Frames]]"
  - "[[HW 2]]"
---
```

| Field     | Type               | Notes                                       |
|-----------|--------------------|---------------------------------------------|
| `course`  | string             | Always `stats20`.                           |
| `type`    | enum               | `lecture`, `homework`, `syllabus`, `index`. |
| `week`    | integer            | Course week (omit for course-wide notes).   |
| `topics`  | list of strings    | Lowercase tags for the main concepts.       |
| `r_files` | list of paths      | R scripts in `r/` that this note uses.      |
| `related` | list of wikilinks  | Other notes in the vault.                   |
