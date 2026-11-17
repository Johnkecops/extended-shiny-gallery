# Animated NYC metro traffic

---

- Developed by: [Tiger Tang](https://community.rstudio.com/u/tiger/)
- App on gallery: https://gallery.shinyapps.io/nyc-metro-vis

---

Wonder what one week of metro traffic would look like? Wanna see the heaviest/lightest traffic times for your NYC metro stops? Check out this app [here](https://gallery.shinyapps.io/nyc-metro-vis/).

## Background 

Inspired by the awesome visualizations about MTA Turnstile Data from [Chris Whong’s visualization](https://chriswhong.com/open-data/visualizing-the-mtas-turnstile-data/) and I wondered if similar stuff can be done with Shiny. 

In the gif below, you can see an 'animated' leaflet map that shows whether or not a lot of people are entering a metro station in NYC at different times of the week from 02-23-2019 to 03-01-2019. The data source contains more specific time stamps and you can see the changes of the number of people entering different station at different hours of the day. The data can be found [here](http://web.mta.info/developers/).

This was submitted for the 1st Shiny Contest by RStudio and was recognized with an honorable mention. Currently listed on the [Shiny Gallery](https://shiny.rstudio.com/gallery/nyc-metro.html).

![](MTA.gif)

## Vis insights:

+ The dots are representing the number of people entering the specific station. (Blue < Pink < Red < Orange)
+ The size of the dots reflect the number of people too.
+ The map background will change from day to night and night to day according to the average time of the sunrise and sunset of that week.
+ See that less people are using metro at mid night and much more people are using it at rush hour. See the size of the circle during weekend vs weekdays.

## Behind the scenes:

+ The `sliderinput` with a play button made the animation possible.
+ The clock is made with `ggplot`.
+ `RenderCachePlot` was used for faster generation with the clock.

## Running it locally

Needs R with `shiny`, `leaflet`, `tidyverse` and `lubridate`. Checked with R 4.5.2 and shiny 1.14.0.

```r
shiny::runApp(".")
```

The app reads `data/cache_all_data.rds`. `etl.R` rebuilds that file from the station list in `data/` and one weekly MTA turnstile file. The original turnstile URL (`http://web.mta.info/developers/data/nyct/turnstile/turnstile_190302.txt`) returned 404 on 2026-11-17, so `etl.R` now reads a local copy from `data/turnstile_190302.txt`, which you have to supply yourself.

`Rscript check.R` verifies the cached data and the per-frame logic: no negative entry counts, one coordinate per control area, and at least one marker on each of the 168 hourly frames.

## Changes from the gallery version (November 2026)

The gallery code no longer starts on a current `future` package (`object 'multiprocess' not found`). A review turned up more problems, fixed here:

+ Removed the "Refresh Data" button together with the `future` and `promises` dependencies. The button re-downloaded the same fixed 2019 week, never updated the map, and hid any download error. Removing it also removes the `plan(multiprocess)` call that caused the startup error.
+ Each frame now shows the latest reading per control area within the last 4 hours. Before, only stations reporting at the single most recent timestamp were drawn, which left 3 or fewer markers on 92 of the 168 frames. Frames now carry 72 to 159 markers (median 156).
+ The time filter is inclusive (`<=`), so the first frame is no longer empty and the last hour is shown.
+ One colour palette is used throughout. The initial map and the animation used two different orders, and neither matched the order documented above. The code now follows the documented order.
+ Base map tiles are replaced on each tick. They used to pile up, about 168 layers per pass of the animation.
+ The night base map now uses Esri's dark gray canvas tiles, which need no API key. CARTO's `CartoDB.DarkMatter` tiles, used before, now come back as "API KEY REQUIRED" images.
+ The clock's hour hand is computed the same way for AM and PM, and the slider is part of the static UI, so the clock no longer errors while the page loads.
+ Data: 80 negative entry counts (counter resets) are dropped, and each control area maps to one station coordinate. 13 control areas were previously drawn at two stations. `data/cache_all_data.rds` went from 7,220 to 6,598 rows; the original is kept as `data/cache_all_data.rds.bak`.

Known limits:

+ The cached file was cleaned in place with the same two rules that `etl.R` now applies, because the raw turnstile file is no longer downloadable. The updated `etl.R` has not been run end to end.
+ Where two stations share a name within a division, the turnstile data is attached to the first one. A control-area-to-station lookup table would fix that properly.
+ `diskCache()` still works but is deprecated since shiny 1.6.0 in favour of `cachem::cache_disk()`.

---

AI Assistance Disclaimer: This codebase was developed with the assistance of Claude Code. While the AI provided code generation, debugging, and structural support, the human developer maintains full responsibility for reviewing, testing, and maintaining all content and functionality
