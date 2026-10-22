---
course: STATS 20
type: lecture
chapter: "2.3"
week: 1
topics: [vectors, modes, coercion, factors, sequences, rep, sample, indexing, matrices, recycling, vectorization, summary statistics]
functions: [c, length, mode, factor, seq, seq_len, seq_along, rep, sample, numeric, character, logical, matrix, array, mean, sd, var, sum]
r_files: ["r/midterm-practice.R"]
related: ["[[Ch 2.4 Data Storage]]", "[[Ch 2.8 Logical Expressions]]"]
on_midterm: true
source: Chapter 2.3_Slides.pdf
---

# Ch 2.3 Vectors

> [!summary] In one line
> A vector is an ordered set of values of **one type**. R indexes from 1, applies arithmetic element by element, and recycles the shorter vector.

## Key ideas
- **Vector** = the basic R object. A single number is a vector of length 1. In stats terms, one vector is one variable and each element is one observation.
- `c()` combines values. `length()` counts elements (often your *n*).
- **One type per vector.** Types: numeric, character, logical. Mixed types get **coerced** up the hierarchy **logical < numeric < character**. `TRUE` becomes `1`, `FALSE` becomes `0`.
- **Factors** store categorical data with fixed **levels**. They behave oddly, so keep data as character and convert when needed.
- **Indexing starts at 1** (not 0 like Python).
- **Vectorization:** functions like `sqrt()`, `log()` and `^` apply to every element at once.
- **Recycling:** with two vectors of different lengths, the shorter one repeats. No warning if the longer length is a multiple of the shorter; a warning if it isn't.
- **Matrices:** `matrix(data, nrow, ncol, byrow = FALSE)` fills **by column** by default. Index with `m[row, col]`; a blank means "all".

## Sequences and repeats
| Code | Output |
| --- | --- |
| `seq(1, 10, by = 3)` | `1 4 7 10` |
| `seq(10, 0, by = -3)` | `10 7 4 1` (stops before passing `to`) |
| `seq(0, 1, length.out = 5)` | `0.00 0.25 0.50 0.75 1.00` (step = (to − from)/(length − 1)) |
| `seq(from = 0, by = 2, length.out = 6)` | `0 2 4 6 8 10` |
| `-2:5` | `-2 -1 0 1 2 3 4 5` |
| `seq_len(4)` / `seq_along(c("a","b"))` | `1 2 3 4` / `1 2` |
| `rep(3, times = 4)` | `3 3 3 3` |
| `rep(c(1, 2), times = 3)` | `1 2 1 2 1 2` (whole vector repeated) |
| `rep(1:3, each = 2)` | `1 1 2 2 3 3` (each element repeated) |
| `rep(c(1, 2), times = c(4, 3))` | `1 1 1 1 2 2 2` (times can be a vector) |
| `rep(1:3, times = 3:1)` | `1 1 1 2 2 3` |
| `rep(c(1, 2), each = 2, times = 3)` | `1 1 2 2 1 1 2 2 1 1 2 2` (each first, then times) |

## Indexing with `[]`
Using `x <- c("one", "two", "three", "four", "five")`:

| Code | Output | Rule |
| --- | --- | --- |
| `x[5]` | `"five"` | Positive index picks |
| `x[c(3, 1)]` | `"three" "one"` | Order follows the index |
| `x[-1]` | everything but `"one"` | Negative index drops |
| `x[-(1:4)]` | `"five"` | Note `-1:4` is `-1 0 1 2 3 4`, which is different |
| `x[0]` | `character(0)` | Empty vector |
| `x[2.9]` | `"two"` | Decimals are truncated toward 0 |
| `x[7]` | `NA` | Out of range gives NA, not an error |
| `x[]` | all of `x` | Blank means everything |
| `x[c(-1, 3)]` | **Error** | Can't mix positive and negative |
| `x[2] <- "TWO"` | changes element 2 | Assignment by index |
| `new[1] <- 5` | **Error** if `new` doesn't exist | Create it first, e.g. `new <- numeric(3)` |

`numeric(3)`, `character(3)` and `logical(3)` make empty vectors of `0`, `""` and `FALSE`.

## Random vectors
```r
sample(1:6, size = 4, replace = TRUE)    # roll a die 4 times
sample(c("H", "T"), 10, replace = TRUE)  # flip a coin 10 times
sample(1:51, 6)                          # SuperLotto: no repeats (replace = FALSE default)
c(sample(1:47, 5), sample(1:27, 1))      # SuperLotto Plus: 5 numbers + Mega
sample(1:6, 10, replace = TRUE) + sample(1:6, 10, replace = TRUE)  # sum of two dice, 10 rolls
```
`sample(x)` with no size gives a random **permutation** of `x`.

## Summary statistics
`sum`, `mean`, `median`, `var`, `sd`, `min`, `max`, `range`, `length`, `summary`, `quantile`.

Sample variance by hand (the **two-pass** formula, which you should use):
```r
x <- c(51, 40, 57, 34, 47, 50, 50, 56, 41, 38)   # Marvin's run times
sum((x - mean(x))^2) / (length(x) - 1)           # same as var(x)
```

## Exam traps
- `mode(c(1, 2, 3, TRUE, FALSE))` is `"numeric"` and the values are `1 2 3 1 0`.
- `mode(c("Go Bruins", TRUE, FALSE))` is `"character"` and `TRUE` becomes `"TRUE"`.
- The colon binds tighter than `*` and `-` but not `^`: `1:5 - 1` is `0 1 2 3 4`, `1:(5 - 1)` is `1 2 3 4`, and `1:3^2` is `1:9`.
- `n <- 0; 1:n` is `1 0`, but `seq_len(n)` is `integer(0)`. That's why loops use `seq_len()` and `seq_along()`.
- `rep(c(1, 2), each = c(3, 4))` only uses the first value of `each` (warning). Use `times = c(3, 4)` instead.
- `c(1, 2, 3, 4) + c(10, 20)` is `11 22 13 24` with no warning. `c(1, 2, 3) + c(10, 20)` still runs but warns.
- R's `*` between vectors is element by element, not a dot product.

## Predict the output
> [!question]- `mode(c(1, 2, 3, "Bruins", TRUE, FALSE))`
> `"character"`

> [!question]- `matrix(1:12, nrow = 3)[2, ]`
> `2 5 8 11` (filled by column, so row 2 is 2, 5, 8, 11)

> [!question]- `matrix(1:12, nrow = 3, byrow = TRUE)[2, ]`
> `5 6 7 8`

> [!question]- `x <- c(3, 0, 4); x^2`
> `9 0 16`

> [!question]- Three ways to make `0 2 4 6 8 10` with `seq()`
> `seq(0, 10, by = 2)`, `seq(0, 10, length.out = 6)`, `seq(from = 0, by = 2, length.out = 6)`

## Links
- Course map: [[Stats 20 Course Map]]
- Previous: [[Ch 2.1-2.2 First Steps and Basics]] · Next: [[Ch 2.10 Data Input and Output]]
- Rounding problems with variance: [[Ch 2.4 Data Storage]]
