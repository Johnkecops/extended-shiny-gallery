# Run from app root: Rscript tests/test_the_data.R
source("global.R")
d = the_data(10000)
stopifnot(abs(d$pi_hat - 4 * cumsum(d$point == "Inside") / d$id) <= 5e-4 + 1e-9)
stopifnot(!anyDuplicated(slider_vals), all(pre_rendered %in% slider_vals))
cat("ok\n")
