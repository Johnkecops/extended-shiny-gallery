library(leaflet)
library(tidyverse)
library(shiny)
library(lubridate)

shinyOptions(cache = diskCache("./clock-cache"))

# data produced by etl.R, read once for all sessions
all_clean <- read_rds("data/cache_all_data.rds")
time_range <- range(all_clean$TIME_C)

# Blue < Pink < Red < Orange, as documented in README.md
pal <- colorQuantile(c("navy", "pink", "red", "orange"), domain = all_clean$ENTRIES_new)

# latest reading per control area at time t
# ponytail: readings older than 4 h (the MTA audit interval) are treated as
# stale and dropped; widen the window if a feed with sparser audits is used
frame_at <- function(t) {
  all_clean %>%
    filter(TIME_C <= t, TIME_C > t - hours(4)) %>%
    group_by(`C/A`) %>%
    slice_max(TIME_C, n = 1, with_ties = FALSE) %>%
    ungroup()
}

is_day <- function(t) hour(t) >= 7 & hour(t) < 17

# one layerId for the base map, so a new tile layer replaces the old one
# Night map: Esri dark gray canvas, no API key needed. CartoDB.DarkMatter was
# used before, but CARTO now serves "API KEY REQUIRED" tiles to keyless clients.
# The service has real tiles up to zoom 16; deeper zooms upscale those.
night_tiles <- "https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}"

add_base <- function(map, t) {
  if (is_day(t)) {
    addTiles(map, layerId = "base")
  } else {
    addTiles(map, night_tiles, layerId = "base",
             attribution = "Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ",
             options = tileOptions(maxNativeZoom = 16))
  }
}

add_stations <- function(map) {
  addCircleMarkers(map,
                   lng = ~`Station Longitude`,
                   lat = ~`Station Latitude`,
                   radius = ~ENTRIES_new / 100,
                   fillOpacity = 0.6,
                   fill = FALSE,
                   color = ~pal(ENTRIES_new))
}

ui <- fluidPage(

  sidebarPanel(

    sliderInput("year", "Time", min = time_range[1], max = time_range[2],
                value = time_range[1], step = 3600, timezone = "+0000", animate = TRUE),
    h4(textOutput("time")),
    plotOutput("clock", width = 250, height = 250)),
  mainPanel(
    leafletOutput("mymap1", width = "100%", height = "800"))
)


server <- function(input, output, session) {

  # adding the text for date display ----------------------------------------

  output$time <- renderText({
    paste(input$year %>% date(), ifelse(hour(input$year) >= 12, "PM", "AM"))
  })


  # adding time animation with renderCachePlot ------------------------------

  output$clock <- renderCachedPlot({

    # hour hand, minute hand: both on the 0-12 dial
    time <- data.frame(x = c(hour(input$year) %% 12 + minute(input$year) / 60,
                             minute(input$year) / 5),
                       y = c(.9, 1.3))

    ggplot(time, aes(xmin = x, xmax = x + 0.1, ymin = 0, ymax = y)) +
      geom_rect(aes(alpha = 0.5)) +
      scale_x_continuous(limits = c(0, 11.98333), breaks = 0:11,
                         labels = c(12, 1:11)) +
      scale_y_continuous(limits = c(0, 1.3)) + scale_alpha() + theme_bw() +
      coord_polar() +
      theme(axis.text.y = element_blank(), axis.ticks = element_blank(),
            panel.grid.major = element_blank(),
            strip.background = element_rect(colour = 'white'),
            legend.title = element_blank(),
            legend.position = "none")

  },
  cacheKeyExpr = { input$year })

  # map part ----------------------------------------------------------------

  output$mymap1 <- renderLeaflet({
    leaflet(frame_at(time_range[1])) %>%
      add_base(time_range[1]) %>%
      add_stations()
  })

  observeEvent(input$year, {
    leafletProxy("mymap1", data = frame_at(input$year)) %>%
      clearMarkers() %>%
      add_base(input$year) %>%
      add_stations()
  })

}

shinyApp(ui, server)
