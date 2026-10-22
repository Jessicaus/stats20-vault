---
course: STATS 20
type: lecture
chapter: "2.4"
week: 3
topics: [floating point, rounding error, integer vs double, one-pass variance, NA, NULL, NaN, Inf]
functions: [typeof, mode, is.na, is.nan, is.null, is.infinite, var]
r_files: ["r/midterm-practice.R"]
related: ["[[Ch 2.3 Vectors]]", "[[Ch 2.8 Logical Expressions]]"]
on_midterm: true
source: Chapter 2.4_Slides.pdf
---

# Ch 2.4 Data Storage

> [!summary] In one line
> R stores numbers approximately, so tiny rounding errors happen. Missing or impossible values have special codes: `NA`, `NULL`, `NaN` and `Inf`.

## Key ideas
- **Floating point:** numbers are stored in binary scientific notation with about 15–17 significant digits (**double precision**). Even `0.1` can't be stored exactly.
- **Integer vs double:** `"numeric"` means double. `1:3` gives integers; `c(1, 2, 3)` gives doubles. `typeof()` shows the storage type and `mode()` shows the general mode.
- **Rounding errors add up.** `0.1 + 0.2 == 0.3` is `FALSE`.
- **Variance formulas:**
  - Two-pass: s² = Σ(xᵢ − x̄)² / (n − 1). Compute the mean first, then the deviations. **Stable. Use this one.**
  - One-pass: s² = (Σxᵢ² − n·x̄²) / (n − 1). Cheaper, but when the values are huge relative to their spread, both terms are huge and the difference is lost to rounding.

## Special values
| Value | Meaning | Mode | Example |
| --- | --- | --- | --- |
| `NA` | Exists but unknown or missing | logical (coerces to others) | a skipped day in the data |
| `NULL` | Doesn't exist at all | `NULL`, length 0 | `c(1, NULL, 2)` is `1 2` |
| `NaN` | Not a number (indeterminate) | numeric | `0/0`, `sqrt(-1)` (warning) |
| `Inf` / `-Inf` | Infinite or too big (> ~1e308) | numeric | `1/0`, `10^310` |

Testing for them: `is.na()`, `is.nan()`, `is.null()`, `is.infinite()`.
- `is.na(NaN)` is `TRUE` (NaN counts as missing)
- `is.nan(NA)` is `FALSE`

## Missing values in practice
```r
times <- c(51, NA, 57)
mean(times)                  # NA
mean(times, na.rm = TRUE)    # 54
length(times)                # 3 (counts the NA)
sum(!is.na(times))           # 2 (the real n)
```

## Exam traps
- `x[11]` on a length-10 vector is `NA`, not an error.
- `identical(c(1, 2, 3), 1:3)` is `FALSE` because double isn't integer. See [[Ch 2.8 Logical Expressions]].
- With `x <- 1:10 + 1e10`, `var(x)` is `9.166667`, but the one-pass formula gives garbage: `0` on the slides, `-14563.56` when run in R 4.6. A variance can never be 0 (unless all values match) or negative, so this is rounding error. Use the two-pass formula.
- `NA` is "unknown", `NULL` is "nothing". Adding `NULL` to a vector adds nothing; adding `NA` adds an element.

## Predict the output
> [!question]- `typeof(1:3)` and `typeof(c(1, 2, 3))`
> `"integer"` and `"double"`. `mode()` of both is `"numeric"`.

> [!question]- `which(is.na(c(1, NA, 3, NA, Inf, NaN)))`
> `2 4 6`

> [!question]- `length(NULL)` and `length(NA)`
> `0` and `1`

## Links
- Course map: [[Stats 20 Course Map]]
- Previous: [[Ch 2.10 Data Input and Output]] · Next: [[Ch 2.8 Logical Expressions]]
