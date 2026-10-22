---
course: stats20
type: lecture
week: 1
topics:
  - vectors
  - coercion
  - factors
  - sequences
  - rep
  - sample
  - indexing
  - matrices
  - recycling
  - vectorization
  - summary-statistics
r_files: []
related:
  - "[[Ch 2.1-2.2 - First Steps and Basics]]"
  - "[[Ch 2.4 - Data Storage]]"
  - "[[Ch 2.8 - Logical Expressions]]"
  - "[[Midterm Review]]"
---

# Ch 2.3: Vectors

Source: `Chapter 2.3_Slides.pdf`, Braun & Murdoch 2.3. This is the **biggest midterm topic**.

## Vectors and modes

- A **vector** is an ordered collection of values. A single value (scalar) is a vector of length 1.
- Build one with `c()` and count its elements with `length()` (that's *n* for a sample).
- A vector holds **one type** only: **logical**, **numeric** or **character**. Check it with `mode()`.

### Coercion hierarchy: `logical < numeric < character`

When types are mixed, everything is converted to the **highest** type present.

```r
mode(c(1, 2, 3, "Bruins"))       #> [1] "character"
mode(c(1, 2, 3, TRUE, FALSE))    #> [1] "numeric"
c(1, TRUE, FALSE)                #> [1] 1 1 0      # TRUE → 1, FALSE → 0
c("a", TRUE, 1)                  #> [1] "a"    "TRUE" "1"
```

### Factors

- **Factors** store categorical data with a fixed set of **levels**. Levels are sorted alphabetically by default.
- They can behave in surprising ways. It's often better to keep data as character and convert to a factor only when needed.

```r
f <- factor(c("lo", "hi", "hi", "mid"))
f        #> [1] lo  hi  hi  mid
         #> Levels: hi lo mid
```

## Sequences

| Call | Output |
|---|---|
| `seq(1, 10, by = 3)` | `1 4 7 10` |
| `seq(10, 0, by = -3)` | `10 7 4 1` (stops before passing `to`) |
| `seq(0, 1, length.out = 5)` | `0.00 0.25 0.50 0.75 1.00`, step = (to − from)/(length.out − 1) |
| `seq(from = 2, by = 0.5, length.out = 4)` | `2.0 2.5 3.0 3.5` |
| `seq(5)` | `1 2 3 4 5` |
| `1:5`, `5:1` | step of ±1 |

Ways to get `0 2 4 6 8 10`: `seq(0, 10, by = 2)`, `seq(0, 10, 2)`, `seq(0, 10, length.out = 6)`, `seq(from = 0, by = 2, length.out = 6)`, `2 * (0:5)`.

> [!warning] Colon precedence
> `:` is evaluated **before** `*`, `-` and `+`, but **after** `^` and unary minus.
> `1:3*2` → `2 4 6` · `1:3^2` → `1 2 … 9` · `10-1:3` → `9 8 7` · `-1:2` → `-1 0 1 2`

### `seq_len()` and `seq_along()`

```r
seq_len(3)                    #> [1] 1 2 3
seq_along(c("a", "b", "c"))   #> [1] 1 2 3   # 1 to length of the input
# They differ from 1:n when n = 0:
1:0          #> [1] 1 0        # counts down. This is a common loop bug.
seq_len(0)   #> integer(0)
```

## Repetition with `rep()`

```r
rep(c(1, 2, 3), times = 2)          #> [1] 1 2 3 1 2 3      # whole vector repeated
rep(c(1, 2, 3), times = c(3, 2, 1)) #> [1] 1 1 1 2 2 3      # each element its own count
rep(c(1, 2, 3), each = 2)           #> [1] 1 1 2 2 3 3      # each element repeated
rep(1:3, each = 2, times = 2)       #> [1] 1 1 2 2 3 3 1 1 2 2 3 3   # each first, then times
```

- `times` can be a vector the same length as `x`. `each` must be a single number.
- When you use both, `each` is applied **first**. Writing it as two lines is clearer.

## Random sampling with `sample()`

`sample(x, size = length(x), replace = FALSE)`

```r
sample(1:5)                                   # a permutation of 1 to 5
sample(1:6, size = 4, replace = TRUE)         # roll a die 4 times
sample(c("H", "T"), size = 10, replace = TRUE)# flip a coin 10 times
sample(1:51, size = 6)                        # SuperLotto: no repeats
c(sample(1:47, 5), sample(1:27, 1))           # SuperLotto Plus + Mega Ball
sample(1:6, 10, replace = TRUE) + sample(1:6, 10, replace = TRUE)  # sum of two dice, 10 rolls
```

Use `set.seed()` to make the results reproducible.

## Indexing (subsetting) with `[]`

> [!important] R indexes from **1**, not 0 (unlike Python).

```r
x <- c("one","two","three","four","five","six","seven","eight","nine","ten")
x[5]          #> [1] "five"
x[c(3, 1)]    #> [1] "three" "one"         # order follows the indices
x[-1]         # everything except element 1
x[-(1:4)]     #> "five" ... "ten"
x[-1:4]       # ERROR: this means c(-1, 0, 1, 2, 3, 4), which mixes signs
x[c(-1, 3)]   # ERROR: can't mix positive and negative indices
x[-1][2]      #> [1] "three"               # drop element 1 first, then take element 2
x[0]          #> character(0)
x[c(0, 2)]    #> [1] "two"                 # a 0 index is ignored
x[2.9]        #> [1] "two"                 # decimals are truncated toward 0
x[]           # everything
x[11]         #> [1] NA                    # out of bounds gives NA, not an error
```

### Assigning into vectors

```r
y <- 1:5
y[2] <- 20;  y            #> [1]  1 20  3  4  5
y[c(1, 5)] <- 0;  y       #> [1]  0 20  3  4  0
newvec[1] <- 5            # ERROR: object 'newvec' not found
newvec <- numeric(3); newvec[1] <- 5; newvec   #> [1] 5 0 0
```

- To initialize empty vectors: `numeric(n)` gives `0`s, `character(n)` gives `""`s, `logical(n)` gives `FALSE`s.

## Matrices (brief)

```r
m <- matrix(1:12, nrow = 3, ncol = 4)   # filled column by column (default)
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    4    7   10
#> [2,]    2    5    8   11
#> [3,]    3    6    9   12
matrix(1:12, nrow = 3, byrow = TRUE)    # filled row by row: 1 2 3 4 / 5 6 7 8 / ...
m[2, 3]   #> [1] 8       # [row, column]
m[2, ]    #> [1]  2  5  8 11   # a blank index means all columns
```

`array()` handles 3 or more dimensions. It's **not tested**.

## Vector arithmetic, recycling and vectorization

- Operations are **element-wise**: `c(1,2,3) * c(4,5,6)` → `4 10 18`. This is not linear algebra.
- With a scalar, the scalar is applied to every element: `running_times / 60`.
- **Recycling:** the shorter vector is repeated to match the longer one.

```r
1:6 + c(10, 20)   #> [1] 11 22 13 24 15 26     # 6 is a multiple of 2: no warning
1:5 + c(10, 20)   #> [1] 11 22 13 24 15        # Warning: longer object length is not a multiple...
```

- **Warning vs error:** with a warning the code still ran. With an error it did not.
- **Vectorization:** functions apply to each element: `sqrt(c(9,16,25))` → `3 4 5`.

## Summary statistics

`mean`, `median`, `sd`, `var`, `sum`, `min`, `max`, `range`, `length`, `summary`, `quantile`

```r
running_times <- c(51, 40, 57, 34, 47, 50, 50, 56, 41, 38)
mean(running_times)   #> [1] 46.4
median(running_times) #> [1] 48.5
var(running_times)    #> [1] 60.71111
```

### Coding the variance by hand

$s^2 = \frac{1}{n-1}\sum_{i=1}^n (x_i - \bar x)^2$

```r
n    <- length(running_times)
xbar <- mean(running_times)
sum((running_times - xbar)^2) / (n - 1)   #> [1] 60.71111  (same as var())
```

> [!tip] Exam angle
> Practice predicting the output of `rep`, `seq`, `:` precedence, negative and zero indices, coercion, and recycling. See [[Midterm Review]].
