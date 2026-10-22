# Regression checks for plan.md fixes. Run from repo root: Rscript tests/check_fixes.R
suppressMessages({ library(dplyr); library(stringr); library(tidyverse) })
source("data_gen.R")
folder <- "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports"

# daily files in date order
d <- as.Date(basename(daily_files(folder)), "%m-%d-%Y.csv")
stopifnot(!is.unsorted(d))

# Inf must not leak into DT color breaks
stopifnot(all(is.finite(breaks_colors(c(1:50, rep(Inf, 6)))$brks)))

# NYC = sum of five boroughs after 2020-09 split
day <- read.csv(file.path(folder, "09-01-2020.csv"))
names(day)[grepl("Province", names(day))] <- "Province.State"
names(day)[grepl("Country", names(day))] <- "Country.Region"
names(day)[grepl("Last", names(day))] <- "Last.Update"
day <- day %>% select(Province.State, Country.Region, Last.Update, Confirmed, Deaths, Recovered, Combined_Key)
nyc <- per_country_daily(day) %>% filter(Country.Region == "New York City")
stopifnot(nyc$Confirmed == 53159 + 65975 + 30900 + 71391 + 15364)

cat("all checks passed\n")
