---
course: stats20
type: lecture
week: 3
topics:
  - floating-point
  - rounding-error
  - typeof
  - variance
  - special-values
  - NA
r_files: []
related:
  - "[[Ch 2.3 - Vectors]]"
  - "[[Ch 2.8 - Logical Expressions]]"
  - "[[Midterm Review]]"
---

# Ch 2.4: Data Storage in R

Source: `Chapter 2.4_Slides.pdf`, Braun & Murdoch 2.4

## Numbers are stored approximately

- R uses **floating point** (binary scientific notation) with **double precision**: 53 bits, about 15–17 significant decimal digits.
- Even 0.1 can't be stored exactly in binary, so small **rounding errors** appear.

```r
0.1 + 0.2 == 0.3                  #> [1] FALSE
print(0.1 + 0.2, digits = 17)     #> [1] 0.30000000000000004
```

- The fix is in [[Ch 2.8 - Logical Expressions]]: compare with `round()` or `all.equal()`, not `==`.

## `typeof()` vs `mode()`

| Value | `typeof()` (how it's stored) | `mode()` |
|---|---|---|
| `1` | `"double"` | `"numeric"` |
| `1L`, `1:3` | `"integer"` | `"numeric"` |
| `"a"` | `"character"` | `"character"` |
| `TRUE` | `"logical"` | `"logical"` |

- "numeric" means the same as "double". Integers are stored separately but act like numbers. The `L` suffix makes an integer.

## One-pass vs two-pass variance

- **Two-pass** (the standard formula): compute $\bar x$ first, then $\sum (x_i - \bar x)^2$, all divided by $n-1$.
- **One-pass:** $s^2 = \frac{1}{n-1}\left(\sum x_i^2 - n\bar x^2\right)$. It's cheaper but **numerically unstable** when the mean is large compared with the variance.

```r
first_ten <- 1:10
one_pass <- function(x) (sum(x^2) - length(x) * mean(x)^2) / (length(x) - 1)
var(first_ten + 1e10)        #> [1] 9.166667   # correct: adding a constant doesn't change the variance
one_pass(first_ten + 1e10)   # garbage (0 or even negative): the huge terms lose precision
```

> [!important] Lesson: don't use the one-pass formula in practice.

## Special values

| Value | Meaning | Examples | Mode |
|---|---|---|---|
| `NA` | missing or unknown ("not available") | `x[11]` on a length-10 vector | logical by default (coerced as needed) |
| `NULL` | does not exist. It's not a vector, and its length is 0. | `c(1, NULL, 2)` → `1 2` | `"NULL"` |
| `NaN` | "not a number" (indeterminate) | `0/0`, `sqrt(-1)` (warning), `NaN + 1` | numeric |
| `Inf` / `-Inf` | infinity | `1/0`, `-1/0`, `10^310` (overflow) | numeric |

- `Inf - Inf` → `NaN`.
- `NA` means a value exists but is unknown. `NULL` means there's no value at all.

### Handling `NA`

```r
rt <- c(51, 40, 57, NA, 34)
mean(rt)                #> [1] NA
mean(rt, na.rm = TRUE)  #> [1] 45.5
```

### Testing for special values

```r
v <- c(1, NA, 3, NaN, Inf)
is.na(v)        #> [1] FALSE  TRUE FALSE  TRUE FALSE   # NaN also counts as NA!
is.nan(v)       #> [1] FALSE FALSE FALSE  TRUE FALSE
is.infinite(v)  #> [1] FALSE FALSE FALSE FALSE  TRUE
is.null(NULL)   #> [1] TRUE
```

### Sample size when there are NAs

```r
x <- c(1, 2, 3, NA, 5)
length(x)          #> [1] 5    # counts the NA
sum(!is.na(x))     #> [1] 4    # the true n
```

> [!tip] Exam angle
> Know which special value each expression gives, that `is.na(NaN)` is `TRUE`, and why the one-pass variance fails.
