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
(sum(big^2) - 10 * mean(big)^2) / 9            # -> garbage, not 9.17 (-14563.56 in R 4.6; 0 on the slides). Rounding error
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

## ---- Practice midterm style ----
# My own questions in the style of the practice midterm (see course/Practice Midterm Patterns.md)
x <- -3:3
x[x <= 0 | x > 2]                   # -> -3 -2 -1 0 3
x[x < -1 & x > 1]                   # -> integer(0)
c(0, 2, NA) | c(0, NA, NA)          # -> FALSE TRUE NA (0 is FALSE, non-zero is TRUE)
c(0, 3, NA) & c(NA, NA, 0)          # -> FALSE NA FALSE
(1:4 > 2) & c(TRUE, NA)             # -> FALSE FALSE TRUE NA (recycled)
y <- c(1.9, -2, 3)
try((1:5)[y])                       # -> Error: only 0's may be mixed with negative subscripts
c(10, 20, 30, 40, 50)[c(2.7, 1, 4.2)]   # -> 20 10 40 (decimals truncate)
c(FALSE, 2L, 0.5)                   # -> 0.0 2.0 0.5
sum(is.na(c(NA, NaN, 1, NaN)))      # -> 3 (NaN counts as NA)
v <- c(NaN, 2, NA, NA, Inf, NaN, 0, NA, 5, NA)
sum(is.na(v) & !is.nan(v))          # -> 4
{ w <- c("a", "b"); w[length(w) + 2] <- "z"; w }   # -> "a" "b" NA "z"
c(1, 2, 3, 4) * c(1, 10, 100)       # -> 1 20 300 4 + warning
rep(c(5, 7), times = 2)             # -> 5 7 5 7
rep(c(5, 7), each = 2)              # -> 5 5 7 7
-2 + 1:4 * 3                        # -> 1 4 7 10
exp(2)                              # -> 7.389056 (e squared)
2e3                                 # -> 2000
seq_along(c(10, 20, 30))            # -> 1 2 3 (positions, not values)
(2:11)[c(TRUE, FALSE, FALSE)]       # -> 2 5 8 11
matrix(rep(1:3, each = 2), nrow = 2)[2, ]   # -> 1 2 3
B <- matrix(1:9, nrow = 3)
B[c(3, 1), 2]                       # -> 6 4
sales <- c(120, NA, 95, NA, 140, 160)
weekend <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE)
mean(sales, na.rm = TRUE)           # -> 128.75
mean(is.na(sales[!weekend]))        # -> 0.5
mean(is.na(sales[weekend]))         # -> 0
10^400                              # -> Inf (overflow)
print(0.3, digits = 17)             # -> 0.29999999999999999 (stored in binary, approximately)
