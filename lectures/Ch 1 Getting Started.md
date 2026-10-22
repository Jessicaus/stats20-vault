---
course: STATS 20
type: lecture
chapter: "1"
week: 0
topics: [RStudio, R Markdown, working directory, comments, knitting]
functions: [getwd, setwd, read.csv, "#"]
r_files: []
related: ["[[Ch 2.1-2.2 First Steps and Basics]]", "[[Ch 2.10 Data Input and Output]]"]
on_midterm: true
reviewed: false
source: Chapter 1_Slides.pdf
---

# Ch 1 Getting Started

> [!summary] In one line
> Set up R and RStudio, write code in R Markdown, and tell R which folder your files live in.

## On the practice midterm
- Not tested directly. The style rules from this chapter (**comments are required**, readable beats clever) are what the "rewrite messy code" question grades. See [[Practice Midterm Patterns]].

## Key ideas
- **Statistical programming** means writing code to do statistical analysis. R is free, open source, and built for data analysis (it grew out of S / S-PLUS).
- **RStudio panes:** script editor (top left) · console (bottom left) · environment (top right) · plots, packages and help (bottom right).
- **Run a line:** Ctrl+Enter (Windows) or Cmd+Enter (Mac).
- **R Markdown (`.Rmd`)** mixes text with R code *chunks*. "Knitting" turns it into HTML, PDF or Word.
- **Console prompts:** `>` means ready. `+` means the last command is incomplete (finish it, or press Esc).
- `[1]` in front of output is the **index** of the first element on that line.
- `#` starts a **comment**. Comments are required in this class.
- **Working directory:** the folder R reads from and saves to. Check it with `getwd()` and set it with `setwd("path/with/forward/slashes")`, or use Session > Set Working Directory > Choose Directory (Ctrl+Shift+H).
- The faint vertical line in the editor marks roughly where the page ends. Code past it may be cut off in the knitted file, so break long lines.
- Base R ships with practice datasets like `cars` and `pressure`.

## Functions and syntax
| Function | What it does |
| --- | --- |
| `getwd()` | Show the current working directory |
| `setwd("C:/Users/me/stats20")` | Set it (use forward slashes) |
| `read.csv("automobile.csv")` | Read a file from the working directory |
| `eval=FALSE` in a chunk header | Show the code but don't run it when knitting |

## Exam traps
- Windows paths copied from Explorer use backslashes. In R you need forward slashes `/` (or doubled `\\`).
- If knitting fails, it's usually (1) an error in a chunk or (2) LaTeX missing for PDF. Fix: `tinytex::install_tinytex()`, or knit to HTML and print to PDF.
- In R Markdown, if the `.Rmd` file isn't in the same folder as the data, every chunk that reads data needs the `setwd()` line.

## Predict the output
> [!question]- `1 + 1`
> `[1] 2`. The `[1]` is the index of the first element, not part of the answer.

> [!question]- You type `1 +` and press Enter. What does the console show?
> A `+` prompt, meaning R is waiting for you to finish the command.

## Links
- Course map: [[Stats 20 Course Map]]
- Next: [[Ch 2.1-2.2 First Steps and Basics]]
