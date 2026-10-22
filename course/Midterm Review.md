---
course: STATS 20
type: review
exam: midterm
date: 2026-10-27
covers: ["[[Ch 1 Getting Started]]", "[[Ch 2.1-2.2 First Steps and Basics]]", "[[Ch 2.3 Vectors]]", "[[Ch 2.4 Data Storage]]", "[[Ch 2.5-2.7 Packages and Help]]", "[[Ch 2.8 Logical Expressions]]", "[[Ch 2.10 Data Input and Output]]"]
r_files: ["r/midterm-practice.R"]
---

# Midterm Review

> [!important] Tuesday, October 27 · in class · pencil and paper · 30% of your grade
> Not on it: Section 2.9 (lists, apply, data frames in depth). The Boolean truth table is provided.

## Study order (about 3 hours)
1. [[Ch 2.3 Vectors]]: biggest section, most "predict the output" material
2. [[Ch 2.8 Logical Expressions]]: NA logic, `&` vs `&&`, `identical` vs `all`
3. [[Ch 2.4 Data Storage]]: special values, rounding, one-pass variance
4. [[Ch 2.1-2.2 First Steps and Basics]]: `%%`, `%/%`, order of operations, argument matching
5. [[Ch 2.10 Data Input and Output]]: `header`, `sep`, row names
6. [[Ch 2.5-2.7 Packages and Help]] and [[Ch 1 Getting Started]]: quick read
7. Work through `r/midterm-practice.R` on paper first, then run it to check.

## The 15 traps most likely to show up
1. Coercion hierarchy: **logical < numeric < character**. `c(1, TRUE)` is `1 1`.
2. Indexing starts at **1**. `x[0]` is empty and `x[length(x) + 1]` is `NA`.
3. Can't mix positive and negative indices: `x[c(-1, 3)]` is an error.
4. `-1:4` is not `-(1:4)`. `:` beats `*` and `-` but not `^`.
5. `1:0` is `1 0`, while `seq_len(0)` is empty.
6. `rep(x, times = k)` repeats the whole vector; `rep(x, each = k)` repeats each element. With both, `each` runs first.
7. Recycling is silent when the lengths are multiples, and warns when they aren't.
8. `matrix()` fills **by column** unless `byrow = TRUE`.
9. `-7 %% 3` is `2`; `-7 %/% 3` is `-3`.
10. `0.1 + 0.2 == 0.3` is `FALSE`. Use `isTRUE(all.equal())` or `round()`.
11. `identical(c(1, 2, 3), 1:3)` is `FALSE` (double vs integer).
12. `NA`: unknown, length 1. `NULL`: nothing, length 0. `NaN`: 0/0. `Inf`: 1/0. `is.na(NaN)` is `TRUE`.
13. NA logic: `NA & FALSE` is `FALSE` and `NA | TRUE` is `TRUE`; everything else with NA is `NA`.
14. `&&` and `||` take length 1 only and short-circuit. `TRUE || "x"` is `TRUE`; `TRUE | "x"` is an error.
15. `read.table()` defaults to `header = FALSE` and whitespace `sep`; `read.csv()` defaults to `header = TRUE, sep = ","`.

## Mixed practice
> [!question]- `x <- c(5, 10, 15, 20); x[x > 8 & x != 15]`
> `10 20`

> [!question]- `y <- c(2, NA, 6); sum(y > 1)` and `sum(y > 1, na.rm = TRUE)`
> `NA` and `2`

> [!question]- `z <- 1:6; z[c(TRUE, FALSE)]`
> `1 3 5` (the logical index is recycled)

> [!question]- `length(c(NA, NULL, NaN))`
> `2`

> [!question]- `v <- numeric(3); v[5] <- 1; v`
> `0 0 0 NA 1` (assigning past the end extends the vector and fills the gap with NA)

## Links
- [[Dashboard]]: live quiz and progress tracker (start it first)
- [[Stats 20 Course Map]]
