---
course: stats20
type: lecture
week: 0
topics:
  - rstudio
  - rmarkdown
  - working-directory
  - comments
r_files: []
related:
  - "[[Ch 2.1-2.2 - First Steps and Basics]]"
  - "[[Ch 2.10 - Data Input and Output]]"
  - "[[Stats 20 Index]]"
---

# Ch 1: Getting Started

Source: `Chapter 1_Slides.pdf`, Braun & Murdoch Ch 1

## Key ideas

- **Statistical programming** means writing code to help with statistical analysis. It sits between general programming and point-and-click statistical software.
- **R** is free and open source (it grew out of S), built for data analysis, and uses a command line. That makes it more flexible than menu-based tools like SPSS.
- **RStudio panes:**
  1. **Top left:** the script or .Rmd file. Run a line with `Ctrl/Cmd + Enter`.
  2. **Bottom left:** the console, where R runs commands and prints output.
  3. **Top right:** the environment, which lists the objects you've created.
  4. **Bottom right:** the Plots, Packages and Help tabs.
- **Base R** comes with built-in datasets such as `cars` and `pressure`, which are handy for testing code.

## Console basics

```r
1 + 1
#> [1] 2      # [1] is the index of the first element shown
```

- An **incomplete command** (e.g. `1 +`) gives a `+` prompt. Finish it or press **Esc**.
- `#` starts a **comment**. Comments are **required** in this class and support pseudocoding.

## R Markdown (.Rmd)

- Mixes text with R **chunks**. **Knit** to HTML (the default), PDF or Word.
- `eval=FALSE` in a chunk header shows the code without running it.
- Keep lines short: code past the faint margin line may be cut off in the knitted file.
- **If it won't knit:**
  1. An error in your code stops knitting.
  2. Knitting to PDF needs LaTeX. Run `tinytex::install_tinytex()`.
  3. As a fallback, knit to HTML, open it in a browser and print to PDF.

## Working directory

```r
getwd()                              # where R is currently looking
setwd("C:/Users/me/stats20")         # use forward slashes!
read.csv("automobile.csv")           # after setwd(), the file name alone is enough
```

- RStudio shortcut: **Session → Set Working Directory → Choose Directory** (`Ctrl+Shift+H`).
- Keep your data, figures and .Rmd files in the same folder.
- In an .Rmd file stored elsewhere, `setwd()` must be repeated in each chunk.

> [!tip] Exam angle
> Low priority for a pencil-and-paper exam. Know what `getwd()` and `setwd()` do, that `#` makes a comment, and that `+` means the command is incomplete.
