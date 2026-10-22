# Stats 20 midterm practice: predict the output, then run the line to check.
# Covers Ch 1, 2.1-2.8, 2.10. Every "# ->" comment was checked in R 4.x.
# Tip: cover the comments, write your answer on paper (the exam has no computer).

## ---- 2.1-2.2 Basics ----
15 %% 7                     # -> 1
15 %/% 7                    # -> 2
-7 %% 3                     # -> 2
-7 %/% 3                    # -> -3
2^3^2                       # -> 512  (right to left)
-2^2                        # -> -4
5 + 3 * 2^2                 # -> 17
5000 * 1.0025^20            # -> 5256.028
log(100, 10)                # -> 2
log(base = 2, 8)            # -> 3

## ---- 2.3 Vectors ----
mode(c(1, 2, 3, "Bruins"))          # -> "character"
mode(c(1, 2, 3, TRUE, FALSE))       # -> "numeric"
c(1, 2, 3, TRUE, FALSE)             # -> 1 2 3 1 0
mode(c("Go Bruins", TRUE, FALSE))   # -> "character"
seq(10, 0, by = -3)                 # -> 10 7 4 1
seq(0, 1, length.out = 5)           # -> 0.00 0.25 0.50 0.75 1.00
1:5 - 1                             # -> 0 1 2 3 4
1:(5 - 1)                           # -> 1 2 3 4
-1:4                                # -> -1 0 1 2 3 4
1:3^2                               # -> 1 2 3 4 5 6 7 8 9
n <- 0
1:n                                 # -> 1 0
seq_len(n)                          # -> integer(0)
rep(1:3, each = 3)                  # -> 1 1 1 2 2 2 3 3 3
rep(1:3, times = 3:1)               # -> 1 1 1 2 2 3
rep(1:3, times = 3)                 # -> 1 2 3 1 2 3 1 2 3
rep(c(1, 2), each = 2, times = 3)   # -> 1 1 2 2 1 1 2 2 1 1 2 2

x <- c("one", "two", "three", "four", "five")
x[c(-1, -3)]                        # -> "two" "four" "five"
x[-(1:4)]                           # -> "five"
x[0]                                # -> character(0)
x[2.9]                              # -> "two"
x[7]                                # -> NA
try(x[c(-1, 3)])                    # -> Error: only 0's may be mixed with negative subscripts

c(1, 2, 3, 4) + c(10, 20)           # -> 11 22 13 24  (no warning)
c(1, 2, 3) + c(10, 20)              # -> 11 22 13 + warning
matrix(1:12, nrow = 3)[2, ]               # -> 2 5 8 11
matrix(1:12, nrow = 3, byrow = TRUE)[2, ] # -> 5 6 7 8

run_times <- c(51, 40, 57, 34, 47, 50, 50, 56, 41, 38)
sum((run_times - mean(run_times))^2) / (length(run_times) - 1)  # same as var(run_times)
var(run_times)

## ---- 2.4 Data storage ----
typeof(1:3)                         # -> "integer"
typeof(c(1, 2, 3))                  # -> "double"
0.1 + 0.2 == 0.3                    # -> FALSE
big <- 1:10 + 1e10
var(big)                                       # -> 9.166667 (correct)
(sum(big^2) - 10 * mean(big)^2) / 9            # -> 0 (one-pass formula, rounding error)
mean(c(51, NA, 57))                 # -> NA
mean(c(51, NA, 57), na.rm = TRUE)   # -> 54
sum(!is.na(c(51, NA, 57)))          # -> 2
length(NULL)                        # -> 0
c(1, NULL, 2)                       # -> 1 2
0/0                                 # -> NaN
1/0                                 # -> Inf
is.na(NaN)                          # -> TRUE
is.nan(NA)                          # -> FALSE
which(is.na(c(1, NA, 3, NA, Inf, NaN)))  # -> 2 4 6

## ---- 2.8 Logical expressions ----
as.logical(c(0, 1, -2))             # -> FALSE TRUE TRUE
as.logical("abc")                   # -> NA
sum(c(TRUE, FALSE, TRUE, NA), na.rm = TRUE)   # -> 2
mean(c(TRUE, FALSE, TRUE, NA), na.rm = TRUE)  # -> 0.6666667
isTRUE(all.equal(0.1 + 0.2, 0.3))   # -> TRUE
all.equal(1, 1.1)                   # -> "Mean relative difference: 0.1"
all(c(1, 2, 3) == 1:3)              # -> TRUE
identical(c(1, 2, 3), 1:3)          # -> FALSE (double vs integer)
identical(seq(1, 5), 1:5)           # -> TRUE
1:10 > c(3, 7)                      # -> F F F F T F T T T T
NA & FALSE                          # -> FALSE
NA | TRUE                           # -> TRUE
NA & TRUE                           # -> NA
any(c(NA, FALSE))                   # -> NA
all(c(NA, FALSE))                   # -> FALSE
!TRUE & FALSE                       # -> FALSE
1:3 %in% c(2, 5)                    # -> FALSE TRUE FALSE
TRUE || c("not", "evaluated")       # -> TRUE (short-circuit)
FALSE && c("not", "evaluated")      # -> FALSE (short-circuit)
try(TRUE | c("a", "b"))             # -> Error (| evaluates both sides)
try(c(TRUE, FALSE) && TRUE)         # -> Error (&& needs length 1)
