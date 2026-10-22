---
course: STATS 20
type: review
exam: midterm
date: 2026-10-27
related: ["[[Midterm Review]]", "[[Stats 20 Course Map]]", "[[Dashboard]]"]
r_files: ["r/midterm-practice.R"]
---

# Practice Midterm Patterns

> [!summary] What the practice midterm tells us
> The exam is mostly **writing short R code by hand** for small data problems, plus **predict-the-output** multiple choice and a few **"explain why"** answers that need class vocabulary. Every question below is my own, written to match the style. The real practice exam stays in `sources/` and isn't shared, per course rules.

## Format
- **65 minutes, 100 points**, pencil and paper, no computer.
- **About 5 free-response problems (around 80 points).** You write code directly on the page.
- **Multiple choice for the rest, about 2 points each.** Mostly "what does this output?" or "which code does X?" The practice version has extra MC for practice.
- **Only functions from class are allowed.** A list of allowed functions is printed at the end of the exam. Outside functions get no credit.
- Section 2.9 isn't on it. In the practice exam, Ch 1, 2.5–2.7 and 2.10 (reading files, packages, help) barely show up. The weight is on **2.3, 2.4 and 2.8**.

## How detailed your answers need to be
| Question type | What they want | How much to write |
| --- | --- | --- |
| Write code | Code that does the task, **stored in the object name they give you** | 1–3 lines. Use the vectors they define; don't retype the data. |
| Implement a formula | The formula in R from given objects | First define the pieces (`n`, `p_hat`, `p0`, means, sds), then one line for the statistic. You don't have to compute the number. |
| Interpret a statistic | Yes/no plus one reason | 1–2 sentences. A test statistic far from 0 (beyond about ±2) is evidence against the null. |
| Explain an output | Why R printed that | 1–2 sentences that **name the concept**: floating point, base 2 vs base 10, approximate storage, rounding error, overflow to `Inf`, coercion, recycling. |
| Pseudocode | The steps the code takes | A numbered list of plain-English steps, one per operation, in order. No R syntax needed. |
| Rewrite messy code | Clean, commented code | Descriptive names, `<-` not `=`, one step per line, no built-in names reused, no unused objects, a comment on every fix. Fix at least the number they ask for. |
| Multiple choice | One letter | Work it out on scrap paper element by element. Watch for errors and warnings as answer choices. |

## Free-response patterns

### Pattern 1: Parallel vectors with missing values (Ch 2.4, 2.8)
Several vectors of the same length, where element *i* of each describes the same day or person. Practice data:
```r
day     <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
sales   <- c(120, NA, 95, NA, 140, 160)   # cups sold
temp    <- c(18, 21, NA, 19, 23, NA)      # degrees C
weekend <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE)
```
(a) Store the days with missing sales in `missing_sales_days`. (b) Mean sales ignoring NAs. (c) Is sales data more often missing on weekends or weekdays? (d) How many days have both sales and temp recorded?

> [!example]- Answers
> ```r
> missing_sales_days <- day[is.na(sales)]        # "Tue" "Thu"
> mean(sales, na.rm = TRUE)                      # 128.75
> prop_missing_weekend <- mean(is.na(sales[weekend]))    # 0
> prop_missing_weekday <- mean(is.na(sales[!weekend]))   # 0.5
> prop_missing_weekday > prop_missing_weekend    # TRUE: weekdays miss more
> sum(!is.na(sales) & !is.na(temp))              # 2 (Mon and Fri)
> ```
> Key moves: index one vector with a condition on another, `mean()` of a logical vector is a proportion, and `sum()` of a logical vector is a count.

### Pattern 2: Subset by group, then a two-sample statistic (Ch 2.3, 2.8)
```r
height <- c(160, 172, 165, 180, 158, 175)
group  <- c("A", "B", "A", "B", "A", "B")
```
(a) Make `height_A` and `height_B`. (b) Compute t = (x̄₁ − x̄₂) / √(s₁²/n₁ + s₂²/n₂). (c) t comes out to about −4.69. Is there evidence the means differ?

> [!example]- Answers
> ```r
> height_A <- height[group == "A"]
> height_B <- height[group == "B"]
> mean_A <- mean(height_A); mean_B <- mean(height_B)
> sd_A <- sd(height_A);     sd_B <- sd(height_B)
> n_A <- length(height_A);  n_B <- length(height_B)
> t_stat <- (mean_A - mean_B) / sqrt(sd_A^2 / n_A + sd_B^2 / n_B)   # -4.690416
> ```
> If the groups sit in blocks (say the first 50 are A, the next 50 are B), positions work too: `height[1:50]` and `height[51:100]`.
> (c) Yes. |t| = 4.69 is far beyond 2, so a difference this large would be very unlikely if the true means were equal. That's evidence against "no difference".

### Pattern 3: Count NA but not NaN, then a one-proportion z (Ch 2.4)
```r
v <- c(NaN, 2, NA, NA, Inf, NaN, 0, NA, 5, NA)
```
(a) Store the number of NAs (not NaNs) in `n_NAs`. (b) Count the values that are not NA. (c) Write code for z = (p̂ − p₀) / √(p₀(1 − p₀)/n) testing whether the proportion of NAs is 0.25.

> [!example]- Answers
> ```r
> n_NAs <- sum(is.na(v) & !is.nan(v))   # 4. is.na() is also TRUE for NaN, so remove those
> length(v) - n_NAs                     # 6
> n <- length(v)
> p_hat <- n_NAs / n
> p0 <- 0.25
> z_obs <- (p_hat - p0) / sqrt(p0 * (1 - p0) / n)   # 1.095445
> ```

### Pattern 4: Floating point explanations (Ch 2.4, 2.8)
`grams <- c(250, 1300, 75)`
(a) Convert to kilograms with scientific notation. (b) Printed to 20 decimal places, is `0.3` exactly `0.30000000000000000000`? (c) Why can `a * (b / c) / b == a / c` give `FALSE` for some elements? (d) What is `10^400`, and why?

> [!example]- Model answers
> - (a) `kg <- grams * 1e-3`. `1e-3` means 1 × 10⁻³. Don't confuse it with `exp(-3)`, which is e⁻³.
> - (b) No. It prints `0.29999999999999998890`. We write numbers in **base 10**, but R stores them in **binary (base 2) floating point**. 0.3 has no finite binary expansion, so R keeps the **closest approximation** (about 15–17 significant digits).
> - (c) Each operation on an approximated number adds a tiny **rounding error**. Doing the steps in a different order gives slightly different stored values, and `==` needs an exact match. Use `round()` or `isTRUE(all.equal())`.
> - (d) `Inf`. Mathematically it's a finite (huge) number, but it's bigger than the largest double R can store (about 1.8 × 10³⁰⁸), so it **overflows** to `Inf`.

### Pattern 5: Pseudocode and cleaning up messy code (Ch 2.1–2.4)
A classmate's working but messy code for a standard deviation:
```r
mean <- c(4, 8, 6, 2)
S=sum(mean)/length(mean); d = mean-S
Out = sqrt(sum(d^2)/(length(mean)-1)) * 1
k = 2
Out
```
(a) Write pseudocode. (b) Rewrite it cleanly, commenting each fix. (c) In one sentence, why use this two-pass approach instead of (Σxᵢ² − n·x̄²)/(n − 1)?

> [!example]- Answers
> **(a) Pseudocode**
> 1. Store the data values.
> 2. Add up the values and divide by how many there are to get the mean.
> 3. Subtract the mean from every value to get the deviations.
> 4. Square the deviations and add them up.
> 5. Divide by n − 1 to get the variance, then take the square root.
> 6. Print the result.
>
> **(b) Clean version**
> ```r
> # Data values (fix: don't name an object "mean"; it masks the mean() function)
> values <- c(4, 8, 6, 2)
> # Sample size (fix: compute once with a clear name)
> n <- length(values)
> # Sample mean (fix: use <- instead of =, and one step per line instead of ;)
> values_mean <- sum(values) / n
> # Deviations from the mean (fix: descriptive name instead of d)
> deviations <- values - values_mean
> # Sample variance, two-pass formula
> values_var <- sum(deviations^2) / (n - 1)
> # Standard deviation (fix: removed the pointless "* 1")
> values_sd <- sqrt(values_var)
> # (fix: removed k, which was never used)
> values_sd   # 2.581989, same as sd(values)
> ```
> **(c)** The one-pass formula subtracts two huge, nearly equal numbers when the values are large, so rounding error can wipe out the answer (it can even go negative). The two-pass formula avoids that.

## Multiple-choice traps
| Trap | Practice-style example | Answer | Read |
| --- | --- | --- | --- |
| Logical subsetting with `\|` and `&` | `x <- -3:3; x[x <= 0 \| x > 2]` | `-3 -2 -1 0 3` | [[Ch 2.8 Logical Expressions]] |
| Impossible condition | `x[x < -1 & x > 1]` | `integer(0)` | [[Ch 2.8 Logical Expressions]] |
| `\|` on numbers with NA | `c(0, 2, NA) \| c(0, NA, NA)` | `FALSE TRUE NA` | [[Ch 2.8 Logical Expressions]] |
| `&` on numbers with NA | `c(0, 3, NA) & c(NA, NA, 0)` | `FALSE NA FALSE` | [[Ch 2.8 Logical Expressions]] |
| Logical recycling with NA | `(1:4 > 2) & c(TRUE, NA)` | `FALSE FALSE TRUE NA` | [[Ch 2.8 Logical Expressions]] |
| Indexing with your own values | `y <- c(1.9, -2, 3); (1:5)[y]` | **Error** (mixed signs) | [[Ch 2.3 Vectors]] |
| Decimal indices truncate | `c(10, 20, 30, 40, 50)[c(2.7, 1, 4.2)]` | `20 10 40` | [[Ch 2.3 Vectors]] |
| Coercion | `c(FALSE, 2L, 0.5)` | `0.0 2.0 0.5` | [[Ch 2.3 Vectors]] |
| NaN counts as NA | `sum(is.na(c(NA, NaN, 1, NaN)))` | `3` | [[Ch 2.4 Data Storage]] |
| Valid names | `.x2`, `my.var_2` are valid. `2fast`, `.2fast`, `_x`, `my var` are not. | | [[Ch 2.1-2.2 First Steps and Basics]] |
| Extending a vector | `w <- c("a", "b"); w[length(w) + 2] <- "z"; w` | `"a" "b" NA "z"` | [[Ch 2.3 Vectors]] |
| Recycling with a warning | `c(1, 2, 3, 4) * c(1, 10, 100)` | `1 20 300 4` + warning | [[Ch 2.3 Vectors]] |
| `rep` times vs each | `rep(c(5, 7), times = 2)` vs `rep(c(5, 7), each = 2)` | `5 7 5 7` vs `5 5 7 7` | [[Ch 2.3 Vectors]] |
| Balanced random groups | Exactly 10 in "A" and 10 in "B" | `sample(rep(c("A", "B"), each = 10))` | [[Ch 2.3 Vectors]] |
| `:` vs `*` precedence | `-2 + 1:4 * 3` equals `-2 + ((1:4) * 3)` | `1 4 7 10` | [[Ch 2.3 Vectors]] |
| `exp()` vs `e` notation | `exp(2)` vs `2e3` | e² ≈ `7.389056` vs `2000` | [[Ch 2.1-2.2 First Steps and Basics]] |
| `seq_along` gives positions | `seq_along(c(10, 20, 30))` | `1 2 3` | [[Ch 2.3 Vectors]] |
| Which seq matches | `seq(2, 11, by = 3)` vs `(2:11)[c(TRUE, FALSE, FALSE)]` | both `2 5 8 11` | [[Ch 2.3 Vectors]] |
| Building a matrix | `matrix(rep(1:3, each = 2), nrow = 2)` | every row is `1 2 3` | [[Ch 2.3 Vectors]] |
| Matrix indexing in reverse | `B <- matrix(1:9, nrow = 3); B[c(3, 1), 2]` | `6 4` | [[Ch 2.3 Vectors]] |

All of these are also in the **Practice midterm style** section of the [[Dashboard]] quiz.

## Links
- [[Midterm Review]] · [[Stats 20 Course Map]] · [[Dashboard]]
