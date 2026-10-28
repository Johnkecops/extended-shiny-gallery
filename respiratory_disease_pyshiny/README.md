Note: The original version of this application is at https://github.com/Appsilon/respiratory_disease_pyshiny

# Respiratory Disease: R/Shiny Version

This is an R/Shiny port of Appsilon's Shiny for Python app-sprint project. The Python version translated an R/Shiny app into Shiny for Python; this version brings it back to R with the same layout, data, styling and PWA assets. You can explore Appsilon's original app as a [demo](https://connect.appsilon.com/respiratory_disease_app_sprint/).

The app compares PM2.5 air pollution with death rates from respiratory disease (deaths per 100,000), using World Bank or OECD PM2.5 data and Our World in Data death rates.

## Structure

```
app.R            UI shell, navbar, PWA script, top-level server
R/data.R         loads CSVs and data/countries.geojson
R/helper_text.R  sidebar text and info modal
R/mod_map.R      leaflet map module (circles = PM2.5 and death rate, polygons = death rate)
R/mod_plot.R     plotly line charts module
www/             CSS, tab-switch JS, PWA manifest and service worker
tests/test_app.R regression checks (data, scaling, server logic)
```

Shiny sources every file in `R/` before `app.R`.

## Run locally

Requires R >= 4.1 (native pipe). Tested with R 4.5.2, shiny 1.14.0, bslib 0.10.0, leaflet 2.2.3, plotly 4.12.1, sf 1.1.3.

```r
install.packages(c("shiny", "bslib", "leaflet", "plotly", "sf", "RColorBrewer"))
shiny::runApp("respiratory_disease_pyshiny", port = 8000)
```

Run the checks from the app directory:

```shell
Rscript tests/test_app.R
```



## AI Assistance Disclaimer

AI Assistance Disclaimer: This codebase was developed with the assistance of Claude Code. While the AI provided code generation, debugging, and structural support, the human developer maintains full responsibility for reviewing, testing, and maintaining all content and functionality
