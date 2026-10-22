---
course: stats20
type: lecture
week: 4
topics:
  - packages
  - cran
  - library
  - search-path
  - help
  - base-graphics
r_files: []
related:
  - "[[Ch 2.10 - Data Input and Output]]"
  - "[[Ch 2.1-2.2 - First Steps and Basics]]"
  - "[[Midterm Review]]"
---

# Ch 2.5–2.7: Packages, Libraries and Help

Source: `Chapter 2.5-2.7_Slides.pdf`, Braun & Murdoch 2.5–2.7

## Packages

- A **package** is a bundle of functions, data and documentation. It's stored in a **library**, which is just a folder of installed packages.
- **Base packages** (`base`, `stats`, `graphics`, `datasets`) load automatically.
- The **tidyverse** is a "mega-package" that bundles many packages (`tidyverse_packages()` lists them).

```r
install.packages("tidyverse")          # from CRAN. Once per computer.
library(tidyverse)                     # every new session. Errors if not installed.
devtools::install_github("user/repo")  # from GitHub
install.packages("boot", repos = "http://cran.us.r-project.org")  # needed inside a knitted Rmd
```

- **Install once, load every session.**
- Keep `install.packages()` out of knitted files. Comment it out, use `eval=FALSE`, or set `repos=`.
- `suppressWarnings(library(...))` hides the startup warnings.
- CRAN does only minimal quality control, so a package may not work as advertised.

## Search path and masking

```r
search()   #> ".GlobalEnv" "package:stats" "package:graphics" ...
```

- R looks for a name in **this order**, starting with the **Global Environment**.
- A package loaded **later** goes **earlier** in the path. After `library(goodmodel)` then `library(okaystat)`, `resid()` comes from **okaystat**.
- Use `pkg::fun()` to call a function directly without loading the package, to choose between two functions with the same name, or to get around masking.

## Getting help

| Command | Use |
|---|---|
| `?log`, `help(log)` | help page for a function you know |
| `??"regression"`, `help.search("regression")` | fuzzy search when you don't know the name |
| `library(help = "stats")` | overview of an installed package |
| Vignettes | worked examples for a package (on CRAN or GitHub) |

**Order to try:** the help docs, then a vignette or companion site, then Google or Stack Overflow, then AI (only when it's allowed).

## Base graphics preview (more in Ch 3)

```r
hist(running_times)                  # histogram of one numeric variable
plot(cars$speed, cars$dist)          # scatterplot of two variables
curve(x^2, from = -2, to = 2)        # plot a mathematical function
```

> [!note] Section 2.9 (names, `$`, `class()`, lists, the apply family) is **not on the midterm**.

> [!tip] Exam angle
> Know install vs `library()`, that `::` doesn't need `library()`, and which package's function wins when two have the same name.
