---
course: stats20
type: lecture
week: 3
topics:
  - logical-vectors
  - coercion
  - relational-operators
  - all-equal
  - identical
  - logical-indexing
  - which
  - boolean-operators
  - short-circuit
r_files: []
related:
  - "[[Ch 2.3 - Vectors]]"
  - "[[Ch 2.4 - Data Storage]]"
  - "[[Midterm Review]]"
---

# Ch 2.8: Logical Expressions

Source: `Chapter 2.8_Slides.pdf`, Braun & Murdoch 2.8

## Coercion to and from logical

```r
as.logical(c(-2, 0, 3.5))                       #> [1]  TRUE FALSE  TRUE   # nonzero → TRUE
as.logical(c("a", "TRUE", "T", "yes", "false")) #> [1]    NA  TRUE  TRUE    NA FALSE
as.numeric(c(TRUE, FALSE))                      #> [1] 1 0
as.numeric("abc")                               #> [1] NA   (with a warning)
```

- Most character strings become `NA`. The exceptions are `"TRUE"/"true"/"T"` and `"FALSE"/"false"/"F"`.

### Counting with logicals

```r
lv <- c(TRUE, FALSE, TRUE, NA)
sum(lv, na.rm = TRUE)    #> [1] 2           # number of TRUEs
mean(lv, na.rm = TRUE)   #> [1] 0.6666667   # proportion of TRUEs
sum(lv)                  #> [1] NA
```

## Relational operators

`==  !=  <  >  <=  >=` and `%in%` (is the value in a set?)

> [!warning] `==` compares. `=` assigns or sets an argument.

- They're **vectorized** and **recycle** like arithmetic does:

```r
running_times <- c(51, 40, 57, 34, 47, 50, 50, 56, 41, 38)
running_times < 40   #> [1] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE
1:6 > c(2, 4)        #> [1] FALSE FALSE  TRUE FALSE  TRUE  TRUE   # compares 1>2, 2>4, 3>2, 4>4, 5>2, 6>4
```

### Floating-point equality (see [[Ch 2.4 - Data Storage]])

```r
sqrt(2)^2 == 2                       #> [1] FALSE
round(sqrt(2)^2, digits = 10) == 2   #> [1] TRUE
all.equal(sqrt(2)^2, 2)              #> [1] TRUE
all.equal(1, 1.1)                    #> [1] "Mean relative difference: 0.1"   # not FALSE!
isTRUE(all.equal(1, 1.1))            #> [1] FALSE   # use this for a strict TRUE/FALSE
```

## `any()`, `all()`, `identical()`

```r
any(running_times < 35)   #> [1] TRUE
all(running_times < 60)   #> [1] TRUE

first_five <- c(1, 2, 3, 4, 5)        # doubles
all(first_five == 1:5)                #> [1] TRUE
identical(first_five, 1:5)            #> [1] FALSE   # 1:5 is integer, first_five is double
identical(seq(1, 5), 1:5)             #> [1] TRUE
```

- `identical()` checks **everything**, including the storage type. Write `1L` for an integer.
- `seq(1, 5)` gives integers, but `seq(1, 5, by = 1)` gives doubles.

## Logical indexing

```r
running_times[running_times < 40]   #> [1] 34 38
running_times[c(TRUE, FALSE)]       #> [1] 51 57 47 50 41    # recycled: every other element
which(running_times < 40)           #> [1]  4 10             # the positions of the TRUEs
which(is.na(c(1, NA, 3, NA, Inf, NaN)))   #> [1] 2 4 6     # NaN counts as NA
running_times[running_times > 50] <- 50   # cap values (e.g. outliers)
```

- `x[x < 40]` is usually clearer than `x[which(x < 40)]`.

## Boolean operators: `&` (and), `|` (or), `!` (not)

They're vectorized and work element by element. `|` is an **inclusive** or.

```r
x <- 1:10
x[x > 3 & x < 7]    #> [1] 4 5 6
x[x < 3 | x > 8]    #> [1]  1  2  9 10
x[!(x > 3)]         #> [1] 1 2 3
```

In set terms: `&` is ∩, `|` is ∪ and `!` is the complement (set theory itself isn't tested).

### NA logic

The rule: if swapping the `NA` for TRUE **or** FALSE would change the answer, the result is `NA`.

| Expr | Result | Why |
|---|---|---|
| `TRUE & NA` | `NA` | depends on the NA |
| `FALSE & NA` | `FALSE` | FALSE & anything is FALSE |
| `TRUE \| NA` | `TRUE` | TRUE \| anything is TRUE |
| `FALSE \| NA` | `NA` | depends on the NA |
| `!NA` | `NA` | |

(A truth table is **provided on the exam**.)

## `&&` and `||`

- **Not vectorized:** each side must have length 1. Since R 4.3.0, a longer vector is an **error**.
- **Short-circuit:** they evaluate left to right and stop as soon as the answer is known.

```r
FALSE && stop("never run")   #> [1] FALSE     # the right side is never evaluated
TRUE  || stop("never run")   #> [1] TRUE
c(TRUE, FALSE) && TRUE       # Error: 'length = 2' in coercion to 'logical(1)'
```

They're mainly used inside `if ()` conditions (Ch 4).

## Extended order of operations (high → low)

`^` → unary `-` `+` → `:` → `%%` `%/%` (and other `%op%`) → `*` `/` → `+` `-` → comparisons (`< > == !=` …) → `!` → `&` `&&` → `|` `||` → `<-`

```r
!TRUE & FALSE        #> [1] FALSE   # (!TRUE) & FALSE
2 + 3 > 4 & 1 == 1   #> [1] TRUE    # arithmetic, then comparison, then &
```

> [!tip] Exam angle
> Expect to predict logical vectors, the results of logical indexing, `which()`, NA logic, `all.equal` vs `==`, and `identical` vs `all`.
