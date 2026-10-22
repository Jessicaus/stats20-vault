# Start the Stats 20 study dashboard at http://127.0.0.1:3838
# Run from anywhere:  Rscript r/run-dashboard.R
# Stop it with Ctrl+C (or close the Terminal window).

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
script <- if (length(file_arg) > 0) sub("^--file=", "", file_arg[1]) else "r/run-dashboard.R"
vault <- normalizePath(file.path(dirname(normalizePath(script)), ".."))
Sys.setenv(STATS20_VAULT = vault)

if (!requireNamespace("shiny", quietly = TRUE)) {
  stop('The shiny package is missing. Install it once with: install.packages("shiny")')
}

cat("Stats 20 dashboard running at http://127.0.0.1:3838\n")
cat("Keep this window open while you use it. Press Ctrl+C to stop.\n")
shiny::runApp(file.path(vault, "r", "shiny"), port = 3838, host = "127.0.0.1",
              launch.browser = FALSE)
