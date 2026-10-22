---
course: STATS 20
type: lecture
chapter: "2.8"
week: 3
topics: [logical vectors, coercion, relational operators, all.equal, any, all, identical, logical indexing, which, boolean operators, NA logic, short-circuit]
functions: [as.logical, as.numeric, as.character, "==", "!=", round, all.equal, isTRUE, any, all, identical, which, "&", "|", "!", "&&", "||", "%in%"]
r_files: ["r/midterm-practice.R"]
related: ["[[Ch 2.3 Vectors]]", "[[Ch 2.4 Data Storage]]"]
on_midterm: true
reviewed: false
source: Chapter 2.8_Slides.pdf
---

# Ch 2.8 Logical Expressions

> [!summary] In one line
> Comparisons make TRUE/FALSE vectors. You can count them, combine them with `&` `|` `!`, and use them to subset data.

## On the practice midterm
- **Parallel vectors (free response):** a condition on one vector picks elements of another: `dates[is.na(pm)]`.
- **Proportions and counts (free response):** `mean(cond)` is a proportion and `sum(cond)` is a count. Compare groups with `mean(is.na(v[group]))` vs `mean(is.na(v[!group]))`.
- **Complete cases (free response):** `sum(!is.na(a) & !is.na(b))`.
- **`|` and `&` on numeric vectors (MC):** numbers are coerced to logical first, **0 → FALSE and any non-zero → TRUE**, then the NA rules apply. `c(0, 2, NA) | c(0, NA, NA)` is `FALSE TRUE NA`.
- **Logical subsetting (MC):** `x[x < 0 | x > 0]` drops only the zeros, and `x[x < 0 & x > 0]` is empty (`integer(0)`).
- **NA inside a condition (MC):** `x[!is.na(y) & y > 0]`. The `!is.na(y)` part turns NA positions into `FALSE`, but an NA in `x` itself still comes through as `NA`.
- **Logical recycling with NA (MC):** `(1:4 > 2) & c(TRUE, NA)` is `FALSE FALSE TRUE NA`.
- Worked examples: [[Practice Midterm Patterns]].

## Key ideas
- **Coercion to logical:** any non-zero number becomes `TRUE`, `0` becomes `FALSE`, and most text becomes `NA` (except `"TRUE"`, `"T"`, `"true"` and similar).
- **Counting:** `sum(cond)` is the number of TRUEs and `mean(cond)` is the proportion. Add `na.rm = TRUE` if there are NAs.
- **Relational operators:** `==` `!=` `<` `>` `<=` `>=`. They're vectorized and recycle like arithmetic. `=` is assignment, not comparison.
- **Floating point:** don't trust `==` on computed decimals. Use `round(x, digits)` or `isTRUE(all.equal(a, b))`.
- `any()` is TRUE if at least one is TRUE. `all()` is TRUE only if every one is TRUE.
- `identical(a, b)` needs an exact match, **including type** (integer vs double).
- **Logical indexing:** `x[x > 40]` keeps elements where the condition is TRUE. `which(cond)` gives their positions; usually you can skip it and index directly.
- **Boolean operators** (vectorized): `&` (and: both true), `|` (or: at least one true), `!` (not). They match set intersection, union and complement.
- `&&` and `||` are **not vectorized** (length 1 only; longer is an error since R 4.3.0) and **short-circuit** (stop once the answer is known).

## NA logic
Rule: if swapping the NA for TRUE or for FALSE would change the answer, the answer is `NA`.

| A | B | `A & B` | `A \| B` |
| --- | --- | --- | --- |
| TRUE | NA | NA | TRUE |
| FALSE | NA | FALSE | NA |
| NA | NA | NA | NA |

`!NA` is `NA`. The professor provides the full truth table on exams.

## Exam traps
- `0.1 + 0.2 == 0.3` is `FALSE`. `isTRUE(all.equal(0.1 + 0.2, 0.3))` is `TRUE`.
- `all.equal(1, 1.1)` returns a message (`"Mean relative difference: 0.1"`), not `FALSE`. Wrap it in `isTRUE()`.
- `all(c(1, 2, 3) == 1:3)` is `TRUE` but `identical(c(1, 2, 3), 1:3)` is `FALSE`. Use `1L` to write an integer.
- `1:10 > c(3, 7)` recycles: it compares 1>3, 2>7, 3>3, 4>7, and so on.
- `TRUE | c("a", "b")` is an **error** (both sides evaluated). `TRUE || c("a", "b")` is `TRUE` (right side never evaluated). `FALSE || c("a", "b")` is an **error**.
- `FALSE && "anything"` is `FALSE`. `TRUE && "text"` is an error.

## Predict the output
> [!question]- `as.logical(c(0, 1, -2))`
> `FALSE TRUE TRUE`

> [!question]- `sum(c(TRUE, FALSE, TRUE, NA), na.rm = TRUE)` and `mean(...)` of the same
> `2` and `0.6666667`

> [!question]- `NA & FALSE`, `NA | TRUE`, `NA & TRUE`
> `FALSE`, `TRUE`, `NA`

> [!question]- `any(c(NA, TRUE))`, `any(c(NA, FALSE))`, `all(c(NA, TRUE))`, `all(c(NA, FALSE))`
> `TRUE`, `NA`, `NA`, `FALSE`

> [!question]- `x <- 1:10; x[x > 3 & x < 7]`
> `4 5 6`

> [!question]- `!TRUE & FALSE`
> `FALSE` (`!` applies to `TRUE` first)

> [!question]- `1:3 %in% c(2, 5)`
> `FALSE TRUE FALSE`

## Links
- Course map: [[Stats 20 Course Map]]
- Previous: [[Ch 2.4 Data Storage]] · Next: [[Ch 2.5-2.7 Packages and Help]]
