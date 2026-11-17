# Self-check for the data and frame logic: Rscript check.R
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

all_clean <- read_rds("data/cache_all_data.rds")

# frame_at() is defined in app.R; evaluate only that definition, not the app
exprs <- parse("app.R")
eval(exprs[[which(map_lgl(as.list(exprs), ~ grepl("^frame_at <- ", deparse(.x)[1])))]])

stopifnot(
  "negative entry deltas" = all(all_clean$ENTRIES_new >= 0),
  "control area at more than one coordinate" =
    !anyDuplicated(distinct(all_clean, `C/A`, `Station Latitude`, `Station Longitude`)$`C/A`)
)

ticks <- seq(min(all_clean$TIME_C), max(all_clean$TIME_C), by = 3600)
n <- map_int(ticks, function(t) {
  f <- frame_at(t)
  stopifnot("station drawn twice in one frame" = !anyDuplicated(f$`C/A`))
  nrow(f)
})

stopifnot("empty frame" = all(n > 0))
cat("ok:", length(ticks), "frames, markers per frame min/median/max =",
    min(n), median(n), max(n), "\n")
