# Stats 20 live study dashboard (Shiny)
# Start it with:  Rscript r/run-dashboard.R   (or double-click "Start Dashboard.command")
# Then open http://127.0.0.1:3838, or the Dashboard note in Obsidian.

library(shiny)

# The default macOS (quartz) PNG device can fail while the page is still sizing itself; cairo is sturdier.
if (capabilities("cairo")) options(bitmapType = "cairo")

# ---- Paths --------------------------------------------------------------
# runApp() sets the working directory to this folder (r/shiny), so the vault is two levels up.
vault <- Sys.getenv("STATS20_VAULT", unset = "")
if (vault == "") vault <- normalizePath(file.path(getwd(), "..", ".."), mustWork = FALSE)
lectures_dir  <- file.path(vault, "lectures")
practice_file <- file.path(vault, "r", "midterm-practice.R")
if (!dir.exists(lectures_dir)) stop("Can't find the lectures folder at ", lectures_dir)

midterm_date <- as.Date("2026-10-27")

col_done  <- "#2E8B57"
col_todo  <- "#C9CED6"
col_main  <- "#2F5D8A"
col_alt   <- "#D9822B"
col_faint <- "#8A8F98"

# ---- Helpers: frontmatter -----------------------------------------------
frontmatter_range <- function(lines) {
  ends <- which(lines == "---")
  if (length(ends) < 2 || ends[1] != 1) return(NULL)
  c(ends[1], ends[2])
}

read_note <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  rng <- frontmatter_range(lines)
  get <- function(key) {
    if (is.null(rng)) return("")
    hit <- grep(paste0("^", key, ":"), lines[rng[1]:rng[2]], value = TRUE)
    if (length(hit) == 0) "" else gsub('^"|"$', "", trimws(sub("^[^:]+:", "", hit[1])))
  }
  list(path = path,
       title = sub("\\.md$", "", basename(path)),
       chapter = get("chapter"),
       reviewed = tolower(get("reviewed")) == "true")
}

chapter_key <- function(ch) {
  vapply(strsplit(sub("-.*$", "", ch), ".", fixed = TRUE), function(p) {
    p <- suppressWarnings(as.numeric(p))
    if (is.na(p[1])) return(Inf)
    p[1] * 100 + if (length(p) > 1) p[2] else 0
  }, 0)
}

load_notes <- function() {
  files <- list.files(lectures_dir, pattern = "\\.md$", full.names = TRUE)
  notes <- lapply(files, read_note)
  notes[order(chapter_key(vapply(notes, `[[`, "", "chapter")))]
}

# Change only the "reviewed:" line in a note's frontmatter (add it if missing).
write_reviewed <- function(path, value) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  rng <- frontmatter_range(lines)
  if (is.null(rng)) return(FALSE)
  new_line <- paste0("reviewed: ", if (value) "true" else "false")
  idx <- grep("^reviewed:", lines[rng[1]:rng[2]])
  if (length(idx) > 0) {
    i <- rng[1] - 1 + idx[1]
    if (identical(lines[i], new_line)) return(TRUE)
    lines[i] <- new_line
  } else {
    lines <- append(lines, new_line, after = rng[2] - 1)
  }
  con <- file(path, open = "w", encoding = "UTF-8")
  on.exit(close(con))
  writeLines(lines, con)
  TRUE
}

# ---- Helpers: run code like the console ----------------------------------
run_like_console <- function(code, env) {
  warnings <- character(0)
  out <- tryCatch({
    withCallingHandlers({
      exprs <- parse(text = code)
      printed <- character(0)
      for (e in exprs) {
        res <- withVisible(eval(e, env))
        if (res$visible) printed <- c(printed, capture.output(print(res$value)))
      }
      printed
    }, warning = function(w) {
      call <- conditionCall(w)
      warnings <<- c(warnings, if (is.null(call)) conditionMessage(w)
                     else paste0("In ", paste(deparse(call), collapse = " "), " :\n  ",
                                 conditionMessage(w)))
      invokeRestart("muffleWarning")
    })
  }, error = function(e) {
    call <- conditionCall(e)
    paste0("Error", if (!is.null(call)) paste0(" in ", paste(deparse(call), collapse = " ")),
           " : ", conditionMessage(e))
  })
  if (length(warnings) > 0) {
    out <- c(out, if (length(warnings) == 1) "Warning message:" else "Warning messages:", warnings)
  }
  if (length(out) == 0) "(no output)" else paste(out, collapse = "\n")
}

# ---- Helpers: parse the practice script ----------------------------------
# Split a line into code and comment, ignoring # inside quotes.
split_comment <- function(line) {
  chars <- strsplit(line, "")[[1]]
  quote <- ""
  for (i in seq_along(chars)) {
    ch <- chars[i]
    if (quote != "") {
      if (ch == quote && (i == 1 || chars[i - 1] != "\\")) quote <- ""
    } else if (ch %in% c('"', "'")) {
      quote <- ch
    } else if (ch == "#") {
      return(c(trimws(substr(line, 1, i - 1)), trimws(substr(line, i + 1, nchar(line)))))
    }
  }
  c(trimws(line), "")
}

# try(expr) prints errors to the console instead of returning them; show the bare code instead.
unwrap_try <- function(code) {
  if (grepl("^try\\(.*\\)$", code)) substr(code, 5, nchar(code) - 1) else code
}

parse_practice <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  section <- "General"
  setup <- list()
  qs <- list()
  for (line in lines) {
    if (grepl("^## ----", line)) {
      section <- trimws(gsub("^## -+|-+$", "", line))
      setup[[section]] <- character(0)
      next
    }
    parts <- split_comment(line)
    code <- parts[1]
    if (code == "") next
    if (grepl("^[A-Za-z_.][A-Za-z0-9_.]*\\s*<-", code)) {
      setup[[section]] <- c(setup[[section]], code)
      next
    }
    expected <- sub("^->\\s*", "", parts[2])
    qs[[length(qs) + 1]] <- list(section = section, code = unwrap_try(code),
                                 expected = if (expected == "") "(no answer written; run it to see)" else expected,
                                 setup = setup[[section]])
  }
  qs
}

questions <- parse_practice(practice_file)
sections <- unique(vapply(questions, `[[`, "", "section"))

# ---- Helpers: drawing ------------------------------------------------------
tile_row <- function(values, y, fill, x0 = 0, text_col = "white", cex = 1.1) {
  for (i in seq_along(values)) {
    x <- x0 + (i - 1)
    rect(x, y - 0.35, x + 0.9, y + 0.35, col = fill[i], border = "white", lwd = 2)
    text(x + 0.45, y, values[i], col = text_col, cex = cex, font = 2)
  }
}

parse_nums <- function(s) {
  s <- trimws(s)
  if (s == "") return(numeric(0))
  vals <- suppressWarnings(as.numeric(trimws(strsplit(s, ",")[[1]])))
  vals
}

fmt <- function(v) format(v, drop0trailing = TRUE, trim = TRUE)

# ---- UI ------------------------------------------------------------------
css <- "
body { background: #ffffff; color: #222; font-size: 15px; }
.container-fluid { max-width: 900px; }
h2.app-title { font-size: 22px; font-weight: 700; margin: 14px 0 4px; }
.subtle { color: #6b7079; }
.big-stat { font-size: 20px; font-weight: 700; }
.code-box { font-family: Menlo, Consolas, monospace; font-size: 18px; background: #f4f6f9;
            border-left: 4px solid #2F5D8A; padding: 12px 14px; border-radius: 4px; margin: 10px 0; }
pre.console { font-size: 14px; background: #1f2430; color: #e6e6e6; border: none; }
.answer { background: #fff7ec; border-left: 4px solid #D9822B; padding: 8px 12px; border-radius: 4px; }
.score { font-size: 16px; font-weight: 600; }
.nav-tabs { margin-bottom: 14px; }
.btn { margin: 2px 4px 2px 0; }
.warn { color: #B8433E; font-weight: 600; }
.ok { color: #2E8B57; font-weight: 600; }
"

ui <- fluidPage(
  tags$head(tags$style(HTML(css)), tags$title("Stats 20 Dashboard")),
  h2("Stats 20 study dashboard", class = "app-title"),
  div(class = "subtle", textOutput("countdown", inline = TRUE)),
  tabsetPanel(
    id = "tabs",
    tabPanel("Progress",
      br(),
      div(class = "big-stat", textOutput("progress_text", inline = TRUE)),
      p(class = "subtle", "Ticking a box saves reviewed: true in that note's properties."),
      uiOutput("review_boxes"),
      plotOutput("progress_plot", height = "320px")
    ),
    tabPanel("Predict the output",
      br(),
      fluidRow(
        column(6, selectInput("q_section", "Section", choices = c("All", sections))),
        column(6, div(style = "margin-top: 28px", class = "score", textOutput("score_text")))
      ),
      div(class = "subtle", textOutput("q_position")),
      uiOutput("q_setup"),
      div(class = "code-box", textOutput("q_code")),
      textInput("q_guess", "Your guess", placeholder = "What does R print?", width = "100%"),
      actionButton("q_reveal", "Reveal", class = "btn-primary"),
      actionButton("q_next", "Next"),
      actionButton("q_random", "Random"),
      uiOutput("q_result")
    ),
    tabPanel("Vectors lab",
      br(),
      h4("Recycling"),
      fluidRow(
        column(6, textInput("vx", "x", "1, 2, 3, 4")),
        column(6, textInput("vy", "y", "10, 20"))
      ),
      uiOutput("recycle_msg"),
      plotOutput("recycle_plot", height = "260px"),
      hr(),
      h4("rep() playground"),
      fluidRow(
        column(4, textInput("rep_x", "x", "1:3")),
        column(4, textInput("rep_times", "times (blank = leave out)", "")),
        column(4, textInput("rep_each", "each (blank = leave out)", "2"))
      ),
      div(class = "code-box", textOutput("rep_call")),
      verbatimTextOutput("rep_out"),
      h4("seq() playground"),
      fluidRow(
        column(3, textInput("seq_from", "from", "0")),
        column(3, textInput("seq_to", "to", "10")),
        column(3, textInput("seq_by", "by", "")),
        column(3, textInput("seq_len", "length.out", "5"))
      ),
      div(class = "code-box", textOutput("seq_call")),
      verbatimTextOutput("seq_out")
    ),
    tabPanel("Variance trap",
      br(),
      p("Every value in 1:10 gets the same shift added. Shifting doesn't change the spread, so the right variance is always ",
        strong("9.166667"), "."),
      sliderInput("shift_pow", "Shift = 10 to the power of", min = 0, max = 12, value = 8,
                  step = 0.5, width = "100%"),
      tableOutput("var_table"),
      plotOutput("var_plot", height = "380px")
    )
  )
)

# ---- Server --------------------------------------------------------------
server <- function(input, output, session) {

  output$countdown <- renderText({
    invalidateLater(60 * 60 * 1000)
    d <- as.numeric(midterm_date - Sys.Date())
    if (d > 1) paste(d, "days until the midterm (Tue Oct 27)")
    else if (d == 1) "1 day until the midterm (Tue Oct 27)"
    else if (d == 0) "Midterm is today. Good luck!"
    else "The midterm is done."
  })

  # -- Progress: re-read the notes whenever any file changes on disk
  notes <- reactivePoll(1500, session,
    checkFunc = function() {
      f <- list.files(lectures_dir, pattern = "\\.md$", full.names = TRUE)
      paste(f, file.mtime(f), collapse = "|")
    },
    valueFunc = load_notes)

  output$review_boxes <- renderUI({
    n <- isolate(notes())
    checkboxGroupInput("reviewed", NULL,
                       choices = setNames(vapply(n, `[[`, "", "path"), vapply(n, `[[`, "", "title")),
                       selected = vapply(Filter(function(x) x$reviewed, n), `[[`, "", "path"))
  })

  # Edits made in Obsidian show up here too
  observeEvent(notes(), {
    n <- notes()
    updateCheckboxGroupInput(session, "reviewed",
                             selected = vapply(Filter(function(x) x$reviewed, n), `[[`, "", "path"))
  }, ignoreInit = TRUE)

  observeEvent(input$reviewed, {
    n <- notes()
    ticked <- input$reviewed
    for (note in n) {
      want <- note$path %in% ticked
      if (want != note$reviewed) write_reviewed(note$path, want)
    }
  }, ignoreNULL = FALSE, ignoreInit = TRUE)

  output$progress_text <- renderText({
    n <- notes()
    sprintf("%d of %d lecture notes reviewed", sum(vapply(n, `[[`, TRUE, "reviewed")), length(n))
  })

  output$progress_plot <- renderPlot({
    n <- notes()
    rev_n <- rev(n)
    done <- vapply(rev_n, `[[`, TRUE, "reviewed")
    par(mar = c(1, 17, 1, 1), family = "sans")
    bp <- barplot(rep(1, length(rev_n)), horiz = TRUE, names.arg = vapply(rev_n, `[[`, "", "title"),
                  las = 1, col = ifelse(done, col_done, col_todo), border = NA, axes = FALSE,
                  xlim = c(0, 1), space = 0.35, cex.names = 1)
    text(0.5, bp, ifelse(done, "Reviewed", "Not yet"), col = ifelse(done, "white", "#222"), font = 2)
  }, bg = "white")

  # -- Predict the output
  q <- reactiveValues(i = 1, revealed = FALSE, got = 0, missed = 0, marked = FALSE)

  pool <- reactive({
    if (is.null(input$q_section) || input$q_section == "All") seq_along(questions)
    else which(vapply(questions, `[[`, "", "section") == input$q_section)
  })

  observeEvent(input$q_section, { q$i <- 1; q$revealed <- FALSE; q$marked <- FALSE })

  current <- reactive({
    p <- pool()
    questions[[p[min(q$i, length(p))]]]
  })

  go_to <- function(i) {
    q$i <- i; q$revealed <- FALSE; q$marked <- FALSE
    updateTextInput(session, "q_guess", value = "")
  }
  observeEvent(input$q_next, go_to(if (q$i >= length(pool())) 1 else q$i + 1))
  observeEvent(input$q_random, go_to(sample(length(pool()), 1)))
  observeEvent(input$q_reveal, q$revealed <- TRUE)

  observeEvent(input$q_got, if (!q$marked) { q$got <- q$got + 1; q$marked <- TRUE })
  observeEvent(input$q_missed, if (!q$marked) { q$missed <- q$missed + 1; q$marked <- TRUE })
  observeEvent(input$q_reset, { q$got <- 0; q$missed <- 0 })

  output$q_position <- renderText(sprintf("Question %d of %d · %s", min(q$i, length(pool())),
                                          length(pool()), current()$section))
  output$q_code <- renderText(current()$code)
  output$q_setup <- renderUI({
    s <- current()$setup
    if (length(s) == 0) return(NULL)
    div(class = "subtle", "Already run in this section: ", code(paste(s, collapse = "; ")))
  })

  output$q_result <- renderUI({
    if (!q$revealed) return(NULL)
    cur <- current()
    env <- new.env(parent = globalenv())
    for (s in cur$setup) try(eval(parse(text = s), env), silent = TRUE)
    out <- run_like_console(cur$code, env)
    tagList(
      br(),
      tags$pre(class = "console", out),
      div(class = "answer", strong("Notes say: "), cur$expected),
      br(),
      if (!q$marked) tagList(
        actionButton("q_got", "I got it", class = "btn-success"),
        actionButton("q_missed", "I missed it", class = "btn-danger")
      ) else span(class = "subtle", "Marked. Press Next.")
    )
  })

  output$score_text <- renderText({
    total <- q$got + q$missed
    if (total == 0) "Score: no answers yet"
    else sprintf("Score: %d / %d (%d%%)", q$got, total, round(100 * q$got / total))
  })

  # -- Vectors lab: recycling
  recycle <- reactive({
    x <- parse_nums(input$vx); y <- parse_nums(input$vy)
    list(x = x, y = y, ok = length(x) > 0 && length(y) > 0 && !anyNA(c(x, y)))
  })

  output$recycle_msg <- renderUI({
    r <- recycle()
    if (!r$ok) return(p(class = "warn", "Enter numbers separated by commas, like 1, 2, 3"))
    long <- max(length(r$x), length(r$y)); short <- min(length(r$x), length(r$y))
    code <- sprintf("c(%s) + c(%s)", paste(fmt(r$x), collapse = ", "), paste(fmt(r$y), collapse = ", "))
    res <- run_like_console(code, new.env())
    tagList(
      div(class = "code-box", code),
      tags$pre(class = "console", res),
      if (long %% short == 0) p(class = "ok", sprintf("%d is a multiple of %d, so R recycles silently (no warning).", long, short))
      else p(class = "warn", sprintf("%d is not a multiple of %d, so R still runs it but warns.", long, short))
    )
  })

  output$recycle_plot <- renderPlot({
    r <- recycle()
    if (!r$ok) return(invisible())
    n <- max(length(r$x), length(r$y))
    if (n > 14) { plot.new(); text(0.5, 0.5, "Use 14 or fewer values to see the picture"); return(invisible()) }
    xr <- rep(r$x, length.out = n); yr <- rep(r$y, length.out = n)
    reused <- function(v) seq_len(n) > length(v)
    par(mar = c(0.5, 7, 0.5, 0.5))
    plot(NA, xlim = c(0, max(n, 4)), ylim = c(0.4, 3.6), axes = FALSE, xlab = "", ylab = "")
    tile_row(fmt(xr), 3, ifelse(reused(r$x), adjustcolor(col_main, 0.4), col_main))
    tile_row(fmt(yr), 2, ifelse(reused(r$y), adjustcolor(col_alt, 0.4), col_alt))
    tile_row(fmt(xr + yr), 1, rep(col_done, n))
    axis(2, at = 3:1, labels = c("x", "y", "x + y"), las = 1, tick = FALSE, cex.axis = 1.2, font = 2)
    legend("topright", bty = "n", fill = adjustcolor(col_faint, 0.4), border = NA,
           legend = "faded = recycled copy", cex = 0.95)
  }, bg = "white")

  # -- Vectors lab: rep() and seq()
  build_call <- function(fun, args) {
    args <- args[vapply(args, function(a) trimws(a) != "", TRUE)]
    if (length(args) == 0) return(paste0(fun, "()"))
    parts <- ifelse(names(args) == "", trimws(args), paste0(names(args), " = ", trimws(args)))
    paste0(fun, "(", paste(parts, collapse = ", "), ")")
  }

  rep_call <- reactive(build_call("rep", setNames(c(input$rep_x, input$rep_times, input$rep_each),
                                                c("", "times", "each"))))
  seq_call <- reactive(build_call("seq", c(from = input$seq_from, to = input$seq_to,
                                           by = input$seq_by, length.out = input$seq_len)))
  output$rep_call <- renderText(rep_call())
  output$rep_out  <- renderText(run_like_console(rep_call(), new.env()))
  output$seq_call <- renderText(seq_call())
  output$seq_out  <- renderText(run_like_console(seq_call(), new.env()))

  # -- Variance trap
  var_at <- function(k) {
    v <- 1:10 + 10^k
    n <- length(v)
    c(two = sum((v - mean(v))^2) / (n - 1), one = (sum(v^2) - n * mean(v)^2) / (n - 1))
  }

  output$var_table <- renderTable({
    r <- var_at(input$shift_pow)
    data.frame(
      Formula = c("Two-pass: sum((x - mean(x))^2) / (n - 1)", "One-pass: (sum(x^2) - n * mean(x)^2) / (n - 1)"),
      Result = format(c(r[["two"]], r[["one"]]), digits = 7),
      Verdict = ifelse(abs(c(r[["two"]], r[["one"]]) - 55 / 6) < 1e-6, "correct", "wrong")
    )
  }, striped = TRUE, align = "llc")

  output$var_plot <- renderPlot({
    ks <- seq(0, 12, by = 0.25)
    vals <- sapply(ks, var_at)
    err <- function(v) pmax(abs(v - 55 / 6) / (55 / 6), 1e-16)
    par(mar = c(4.5, 5.5, 1, 1), family = "sans")
    plot(ks, err(vals["one", ]), log = "y", type = "l", lwd = 3, col = col_alt, ylim = c(1e-16, 1e8),
         xaxt = "n", yaxt = "n", bty = "l", xlab = "Shift", ylab = "")
    lines(ks, err(vals["two", ]), lwd = 3, col = col_main)
    axis(1, at = 0:12, labels = parse(text = paste0("10^", 0:12)))
    yt <- 10^seq(-16, 8, by = 4)
    axis(2, at = yt, labels = c("exact", parse(text = paste0("10^", log10(yt[-1])))), las = 1)
    mtext("Relative error", side = 2, line = 4)
    abline(v = input$shift_pow, col = col_faint, lty = 2)
    abline(h = 1, col = col_todo, lty = 3)
    legend("topleft", bty = "n", lwd = 3, col = c(col_alt, col_main),
           legend = c("One-pass formula", "Two-pass (what var() does)"))
  }, bg = "white")
}

shinyApp(ui, server)
