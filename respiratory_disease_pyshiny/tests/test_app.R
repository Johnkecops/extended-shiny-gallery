# Regression check. Run from the app directory: Rscript tests/test_app.R
# mirror runApp: shiny attached, R/ sourced, then app.R
library(shiny)
for (f in sort(list.files("R", full.names = TRUE))) source(f)
source("app.R")

# data loads with coordinates and geometry
stopifnot(nrow(map_data_world_bank) > 0, nrow(map_data_oecd) > 0, all(c("lng", "lat") %in% names(map_data_oecd)))
stopifnot(inherits(polygon_data, "sf"), "id" %in% names(polygon_data))

# radius never shrinks as death rate grows
radii <- circle_radius(seq(0, 300, by = 0.1))
stopifnot(!is.unsorted(radii))

# PM2.5 colour bins and missing values
stopifnot(identical(circle_color(c(0.5, 1, 150, NA)), c("#F7FCF0", "#E0F3DB", "#08589E", "#D2D2D2")))

# country list covers World Bank-only entities
stopifnot(all(c("China", "World") %in% country_choices), !anyDuplicated(country_choices))

# both modules build their UI inside the full page
stopifnot(grepl("map-map", as.character(ui)), grepl("plot-dr_plot", as.character(ui)))

# server logic runs for both datasets without error
for (wb in c(TRUE, FALSE)) {
  testServer(map_server, args = list(is_wb_data = reactive(wb)), {
    session$setInputs(years_value = 2015)
    stopifnot(nrow(point_data()) > 0, max(data()$Year) == if (wb) 2017 else 2019)
  })
  testServer(plot_server, args = list(is_wb_data = reactive(wb)), {
    session$setInputs(years_value = c(2010, 2015), country_select = c("World", "China"))
    stopifnot(nchar(output$dr_plot) > 0, nchar(output$pm_plot) > 0)
  })
}

cat("ok\n")
