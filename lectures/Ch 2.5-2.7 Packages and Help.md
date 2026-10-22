---
course: STATS 20
type: lecture
chapter: "2.5-2.7"
week: 4
topics: [packages, CRAN, GitHub, library, search path, "::", help, vignettes, base graphics]
functions: [install.packages, library, search, "::", "?", "??", help, help.search, hist, plot, curve]
r_files: []
related: ["[[Ch 2.10 Data Input and Output]]", "[[Ch 2.1-2.2 First Steps and Basics]]"]
on_midterm: true
source: Chapter 2.5-2.7_Slides.pdf
---

# Ch 2.5-2.7 Packages and Help

> [!summary] In one line
> **Install** a package once per computer, **load** it with `library()` in every session, and use `?` when you're stuck.

## Key ideas
- A **package** is a bundle of functions, data and documentation. A **library** is the folder where installed packages live.
- **Base packages** (`base`, `stats`, `graphics`, `datasets`) load automatically. The **tidyverse** is a meta-package containing many packages.
- **CRAN** is the main repository: `install.packages("readxl")` (quotes required). Quality control is light.
- **GitHub:** `devtools::install_github("username/repo")`.
- **In R Markdown:** don't leave a bare `install.packages()` in a chunk. Comment it out, use `eval=FALSE`, or add `repos = "http://cran.us.r-project.org"`.
- `library(readxl)` loads it (quotes optional). It errors if the package isn't installed. Reload it every new session.
- `search()` shows the **search path**. `.GlobalEnv` comes first, then the most recently loaded package. If two packages have the same function name, **the one loaded last wins** (it masks the other).
- `pkg::fun()` uses one function without loading the whole package, or gets around masking.

## Getting help
| Code | Use |
| --- | --- |
| `?log` or `help(log)` | Help page for a function you know |
| `??regression` or `help.search("regression")` | Fuzzy search when you don't know the name |
| `library(help = "readxl")` | Overview of a package |
| Vignettes | Worked examples for a package (look on CRAN or GitHub) |

## Base graphics preview (more in Ch 3)
- `hist(x)` for a histogram of one numeric variable
- `plot(x, y)` for a scatterplot of two variables
- `curve(x^2, from = -2, to = 2)` to draw a math function

## Exam traps
- Install happens **once**; `library()` happens **every session**.
- `library(okaystat)` after `library(goodmodel)` means `resid()` comes from `okaystat`.
- Assigning `pi <- 3` in your workspace masks `base::pi`, because `.GlobalEnv` is searched first.

## Links
- Course map: [[Stats 20 Course Map]]
- Previous: [[Ch 2.8 Logical Expressions]] · Next: 2.9 Data frames and lists (not on the midterm)
