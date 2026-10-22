---
course: stats20
type: lecture
week: 1
topics:
  - arithmetic
  - order-of-operations
  - assignment
  - objects
  - functions
  - workspace
r_files: []
related:
  - "[[Ch 1 - Getting Started]]"
  - "[[Ch 2.3 - Vectors]]"
  - "[[Midterm Review]]"
---

# Ch 2.1–2.2: First Steps and Basics

Source: `Chapter 2.1-2.2_Slides.pdf`, Braun & Murdoch 2.1–2.2

## Names and constants

- R is **case-sensitive**: `object`, `OBJECT` and `ObJeCt` are three different names.
- A **syntactic name** uses letters, digits, `.` and `_`. It must start with a letter, or a `.` that isn't followed by a digit. No spaces and no reserved words (`TRUE`, `if`, …).
- **Numeric constants:** `41.65`, `4.165e1` (scientific notation).
- **Character constants** go in quotes: `"statistics"` or `'statistics'`.
- Missing values are written `NA` (see [[Ch 2.4 - Data Storage]]).

## Arithmetic

| Op | Meaning | Example |
|---|---|---|
| `+ - * /` | basic | `7 / 2` → `3.5` |
| `^` | power | `2^3` → `8` |
| `%%` | remainder (mod) | `15 %% 7` → `1` |
| `%/%` | integer division (floor of `a/b`) | `15 %/% 7` → `2` |

**Order of operations** follows PEMDAS, with a few R-specific traps:

```r
2^3^2      #> [1] 512   # ^ is evaluated right to left: 2^(3^2)
-2^2       #> [1] -4    # ^ binds tighter than unary minus
(-2)^2     #> [1] 4
-7 %% 3    #> [1] 2     # the result takes the sign of the divisor
```

- Use `()` or `{}` to group. `[]` is **not** for grouping; it's for indexing.
- When in doubt, add parentheses. It makes code easier to read.

## Objects and assignment

- **Everything in R is an object** (a named storage space). The set of all your objects is the **workspace**, also called the global environment.
- Assign with `<-`. Assignment prints nothing, so type the object's name to see it.

```r
interest_20 <- 1.0025^20   # 0.25% interest, compounded for 20 years
interest_20                #> [1] 1.051206
5000 * interest_20         #> [1] 5256.028
```

- `=` also assigns, but use `<-` (`=` is used for function arguments).
- Common errors: a name that starts with a number (`2x <- 5`) or the wrong case when you recall it (`Interest_20` → *object not found*).
- **Pseudocode / pre-coding:** write the steps in plain English before you write code.

### Masking

```r
pi <- 3    # no error: your pi now *masks* the built-in pi
pi         #> [1] 3
rm(pi)     # remove your version
pi         #> [1] 3.141593
```

## Functions

- A function takes **arguments** and returns an output, e.g. `log(x, base = exp(1))`.
- Typing `log` without parentheses shows its definition. `?log` opens its help page.
- **Default arguments:** `base` defaults to `exp(1)`. Arguments without a default must be supplied.
- **Argument matching:** arguments can be matched by **position** or by **name**. Named arguments are clearer.

```r
log(100)              #> [1] 4.60517   # natural log
log(100, base = 10)   #> [1] 2
log(8, 2)             #> [1] 3         # by position: x = 8, base = 2
log(base = 2, 8)      #> [1] 3         # named + positional
```

- Infix operators are functions too: `` `+`(2, 3) `` → `5` (note the backticks).

## Workspace management

```r
ls()                 # list objects (same as objects())
rm(x)                # remove one object
rm(list = ls())      # remove everything; ls() then shows character(0)
q()                  # quit. It's better to save a script than the workspace image.
```

> [!tip] Exam angle
> Expect to evaluate expressions by hand: `%%`, `%/%`, `^` precedence, `-2^2`, and which names are valid.
