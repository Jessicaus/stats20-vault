---
course: STATS 20
type: lecture
chapter: "2.10"
week: 2
topics: [read.table, read.csv, header, sep, na.strings, write.table, write.csv, row names, RDS, readxl, haven]
functions: [read.table, read.csv, read.csv2, read.delim, read.fwf, write.table, write.csv, readRDS, saveRDS, head, str]
r_files: []
related: ["[[Ch 1 Getting Started]]", "[[Ch 2.4 Data Storage]]", "[[Ch 2.5-2.7 Packages and Help]]"]
on_midterm: true
reviewed: false
source: Chapter 2.10_Slides.pdf
---

# Ch 2.10 Data Input and Output

> [!summary] In one line
> Read data in with `read.table()` / `read.csv()` (getting `header` and `sep` right), write it out with `write.table()` / `write.csv()`, and save R objects with RDS.

## Key ideas
- **Plain text files** (.csv, .txt) are human-readable, open anywhere, and don't change between versions.
- `read.table(file, header = FALSE, sep = "")` returns a **data frame**.
  - `header = TRUE` if the first row has column names.
  - `sep = ""` (default) means any whitespace. Use `","` for commas and `"\t"` for tabs.
  - `text = "..."` reads pasted text instead of a file.
  - `na.strings = c("-2", "-100")` turns those codes into `NA`.
- `read.csv()` is a **wrapper** for `read.table()` with `header = TRUE, sep = ",", fill = TRUE`.
- Other wrappers: `read.csv2()` (`sep = ";"`, `dec = ","`), `read.delim()` (tabs), `read.fwf()` (fixed widths).
- `stringsAsFactors` defaults to `FALSE` in R 4.0 and later.
- **Always check the import:** `head(df)`, `str(df)`, `dim(df)`.
- `write.table(x, file = "Parks.txt")` includes row and column names and separates with spaces. Change with `row.names = FALSE`, `col.names = FALSE`, `sep = ","`.
- `write.csv(x, file = "Parks.csv")` adds a blank-headed row-name column. Reading it back gives an extra column; fix with `row.names = FALSE` when writing, or `read.csv(..., row.names = 1)` when reading.
- **RDS** stores one R object exactly (binary, fast, not human-readable): `saveRDS(object = df, file = "df.RDS")` and `df <- readRDS("df.RDS")`.
- Other formats need packages: **readxl** (Excel, `sheet =`), **haven** (`read_spss`, `read_dta`, `read_sas`, `read_xpt`), and the older **foreign**.

## Exam traps
- Leaving out `header = TRUE` turns the column names into the first data row, and every column becomes character.
- The wrong `sep` jams each row into one column (or splits it wrongly).
- Files save to the **working directory** unless you give a path. See [[Ch 1 Getting Started]].
- If you pass a vector to `write.table()`, it gets coerced into a data frame.

## Predict the output
> [!question]- How do you read `Parks.txt` (written by `write.table` with defaults) back in?
> `read.table("Parks.txt", header = TRUE)`. The row names come back as row names because the header row has one fewer field.

> [!question]- File: first line `name;score`, then lines like `Ana;3,5`. Which function?
> `read.csv2()`, which uses semicolons and decimal commas.

## Links
- Course map: [[Stats 20 Course Map]]
- Previous: [[Ch 2.3 Vectors]] · Next: [[Ch 2.4 Data Storage]]
