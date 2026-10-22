---
course: stats20
type: lecture
week: 2
topics:
  - read-table
  - read-csv
  - write-table
  - write-csv
  - rds
  - na-strings
  - readxl
  - haven
r_files: []
related:
  - "[[Ch 1 - Getting Started]]"
  - "[[Ch 2.5-2.7 - Packages and Help]]"
  - "[[Midterm Review]]"
---

# Ch 2.10: Data Input and Output

Source: `Chapter 2.10_Slides.pdf`, Braun & Murdoch 2.10

**Why plain text (.csv, .txt)?** You can read it yourself, every program can open it, and the format never changes.

## `read.table()`

| Argument | Default | Meaning |
|---|---|---|
| `file` | | a path or URL |
| `text` | | read from a string (e.g. pasted data) |
| `header` | `FALSE` | is the first row variable names? |
| `sep` | `""` (any whitespace) | `","`, `"\t"`, `";"` … |
| `na.strings` | `"NA"` | which values count as missing, e.g. `c("-2", "-100")` |
| `stringsAsFactors` | `FALSE` (R ≥ 4.0) | convert text to factors? |

The result is a **data frame**, which can hold a different type in each column.

```r
read.table(text = "height weight
170 65
-2 70
180 80", header = TRUE, na.strings = "-2")
#>   height weight
#> 1    170     65
#> 2     NA     70
#> 3    180     80
```

### Common mistakes

- **Forgetting `header = TRUE`:** the variable names become row 1 of the data, the columns become `V1, V2, …`, and numeric columns turn into character.
- **Wrong `sep`:** values aren't split. For example, reading `"a,b\n1,2"` with the default sep gives a single column named `a.b` holding `"1,2"`.
- Always look at the file first, then check the result with `head()`.

## Wrapper functions (`read.table` with preset defaults)

| Function | Preset defaults |
|---|---|
| `read.csv()` | `header = TRUE, sep = ",", fill = TRUE` |
| `read.csv2()` | `sep = ";", dec = ","` (European CSV files) |
| `read.delim()` | `sep = "\t", header = TRUE` |
| `read.fwf()` | fixed-width columns (`widths =`) |

## Writing data

```r
parks <- data.frame(name = c("Griffith", "Echo"), acres = c(4310, 29))
write.table(parks, file = "Parks.txt")   # space-separated, row and column names included
#> "name" "acres"
#> "1" "Griffith" 4310
#> "2" "Echo" 29
write.csv(parks, file = "Parks.csv")
#> "","name","acres"          # blank header for the row-names column
#> "1","Griffith",4310
```

- Options: `row.names = FALSE`, `col.names = FALSE`, `sep = ","`.
- A non-data-frame input is coerced to a data frame.
- To read `Parks.txt` back: `read.table("Parks.txt", header = TRUE)`. The header row has one fewer field than the data rows, so R treats the first column as row names.

> [!warning] Row names in CSV files
> `read.csv("Parks.csv")` turns the row names into an extra column named `X`.
> Fix it with `read.csv("Parks.csv", row.names = 1)`, or write the file with `write.csv(..., row.names = FALSE)`.

## .RDS files

```r
saveRDS(object = parks, file = "parks.RDS")
parks2 <- readRDS(file = "parks.RDS")   # exact same object, attributes and all
```

They're binary: fast but not readable by people.

## Other formats (via packages)

- **Excel:** `readxl::read_excel(path, sheet = )` (the instructor's go-to, part of the tidyverse). Alternatives: `xlsx`, `gdata`, `XLConnect`.
- **haven:** `read_spss()` (.sav), `read_dta()` (Stata), `read_sas()` (.sas7bdat), `read_xpt()` (SAS transport files).
- **foreign:** an older alternative.

> [!tip] Exam angle
> Expect to pick the right `header` and `sep` for a given file, explain what goes wrong when they're wrong, and know the `na.strings` and `row.names = 1` fixes.
