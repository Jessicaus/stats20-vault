---
course: STATS 20
type: lecture
chapter: "2.1-2.2"
week: 1
topics: [arithmetic, order of operations, objects, assignment, functions, arguments, workspace]
functions: ["%%", "%/%", "<-", rm, ls, objects, log, exp, q]
r_files: ["r/midterm-practice.R"]
related: ["[[Ch 2.3 Vectors]]", "[[Ch 2.8 Logical Expressions]]"]
on_midterm: true
reviewed: false
source: Chapter 2.1-2.2_Slides.pdf
---

# Ch 2.1-2.2 First Steps and Basics

> [!summary] In one line
> R is a calculator that stores results in named **objects**, and everything you do is a **function call**.

## Key ideas
- R is **case-sensitive**: `x`, `X` and `ObJeCt` are different names.
- **Names** use letters, numbers, `.` and `_`. They must start with a letter (or a dot not followed by a number). No spaces.
- **Constants:** numbers (`41.65`, `4.165e1`), characters in quotes (`"statistics"`), and missing values `NA`.
- **Order of operations** is PEMDAS. When in doubt, add `()`. Square brackets `[]` are for indexing, not grouping.
- **Assignment** uses `<-` (name on the left). `=` works but `<-` is preferred. Assigning prints nothing; type the name to see the value.
- **Pseudocode / pre-coding:** write the steps in plain English before you code.
- **Masking:** assigning to a built-in name (like `pi <- 3`) hides the built-in one. `rm(pi)` brings it back.
- **Functions** take **arguments** and return a value. Arguments match **by position or by name**. Arguments with defaults (like `base = exp(1)` in `log`) can be left out.
- Operators are functions too: `` `+`(2, 3) `` is `5`.
- **Workspace (global environment):** all your objects. `ls()` or `objects()` lists them, `rm(x)` deletes one, and `rm(list = ls())` deletes everything (shows `character(0)` after).
- `q()` quits. It's better to save your script than the workspace image.

## Functions and syntax
| Code | Meaning | Output |
| --- | --- | --- |
| `15 %% 7` | Remainder (mod) | `1` |
| `15 %/% 7` | Integer division (floor of 15/7) | `2` |
| `2^3^2` | Exponents go right to left: 2^(3^2) | `512` |
| `-2^2` | Exponent before negation | `-4` |
| `log(100, 10)` | Positional: x = 100, base = 10 | `2` |
| `log(base = 2, 8)` | Named argument first, then positional | `3` |
| `log(8)` | Default base is e | `2.079442` |

## Worked example: compound interest
0.25% per year compounded annually for 20 years on $5000:
```r
interest_20 <- 1.0025^20       # growth factor over 20 years
5000 * interest_20             # final balance
## [1] 5256.028
```

## Exam traps
- `2var <- 5` is an error (names can't start with a number).
- `Interest_20` is not `interest_20`. Wrong case gives `Error: object not found`.
- `-7 %% 3` is `2` and `-7 %/% 3` is `-3` (R floors toward negative infinity).
- `x = 5` inside a function call sets an argument. It doesn't create `x` in your workspace.

## Predict the output
> [!question]- `5 + 3 * 2^2`
> `17`. Exponent, then multiply, then add.

> [!question]- `(5 + 3) * 2^2`
> `32`

> [!question]- `pi <- 3; pi * 2; rm(pi); pi * 2`
> `6`, then `6.283185` once the mask is removed.

## Links
- Course map: [[Stats 20 Course Map]]
- Previous: [[Ch 1 Getting Started]] · Next: [[Ch 2.3 Vectors]]
