library(tidyverse)
library(lubridate)

# Rebuilds data/cache_all_data.rds, the file app.R reads.
# The original source,
#   http://web.mta.info/developers/data/nyct/turnstile/turnstile_190302.txt
# returned 404 when checked on 2026-11-17. Point turnstile_src at a local copy
# of that weekly turnstile file to re-run this script.
turnstile_src <- "data/turnstile_190302.txt"

data_station <- read_csv("data/NYC_Transit_Subway_Entrance_And_Exit_Data.csv")
data3 <- read_csv(turnstile_src)

# one coordinate per station name + division, so the join cannot fan one
# turnstile out to several stations
# ponytail: where two real stations share a name within a division, the first
# one wins; a control-area-to-station lookup table is the proper fix
stations <- data_station %>%
  filter(Entry == 'YES') %>%
  mutate(`Station Name` = toupper(`Station Name`)) %>%
  distinct(`Station Name`, Division, .keep_all = TRUE)

all <- inner_join(stations, data3, by = c("Station Name" = "STATION", "Division" = "DIVISION")) %>%
  filter(DESC == 'REGULAR')

all_clean <- all %>%
  mutate(TIME_C = paste(DATE, TIME) %>% mdy_hms(),
         ENTRIES = as.numeric(ENTRIES)) %>%
  distinct(`Station Latitude`, `Station Longitude`, TIME_C, Line, ENTRIES, SCP, `C/A`) %>%
  filter(SCP == '00-00-00') %>%
  group_by(`C/A`) %>%
  arrange(TIME_C) %>%
  mutate(ENTRIES_new = coalesce(ENTRIES - lag(ENTRIES), 0)) %>%
  ungroup() %>%
  # counter resets and reversed counters give negative deltas; drop them
  filter(ENTRIES_new >= 0)

write_rds(data_station, "data/cache_coordinate.rds")
write_rds(all_clean, "data/cache_all_data.rds")
