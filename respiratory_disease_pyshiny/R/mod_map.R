# Piecewise-linear radius: slope 1.1 up to 10, 0.8 to 20, 0.75 to 25, then 0.2.
# Continuous, so the circle never shrinks as the death rate grows.
circle_radius <- function(x) {
  as.integer(
    pmin(x, 10) * 1.1 +
      pmax(pmin(x, 20) - 10, 0) * 0.8 +
      pmax(pmin(x, 25) - 20, 0) * 0.75 +
      pmax(x - 25, 0) * 0.2
  )
}

circle_color <- function(pm25) {
  colors <- c("#F7FCF0", "#E0F3DB", "#CCEBC5", "#A8DDB5", "#7BCCC4", "#4EB3D3", "#2B8CBE", "#08589E")
  out <- colors[findInterval(pm25, c(0, 1, 2, 5, 10, 20, 50, 100))]
  out[is.na(pm25)] <- "#D2D2D2"
  out
}

# shared colour scale across years and datasets
choropleth_pal <- leaflet::colorNumeric(
  "GnBu",
  domain = c(0, max(map_data_world_bank$Death.Rate, map_data_oecd$Death.Rate))
)

map_ui <- function(id) {
  ns <- NS(id)
  div(
    div(
      about_text,
      tags$hr(),
      slider_text_map,
      tags$br(),
      sliderInput(ns("years_value"), "Select Year", min = 1990, max = 2017, value = 2010, sep = ""),
      tags$hr(),
      dataset_information,
      tags$hr(),
      missing_note,
      class = "main-sidebar card-style"
    ),
    div(
      leafletOutput(ns("map"), width = "100%", height = "100%"),
      class = "main-main card-style no-padding"
    ),
    class = "main-layout"
  )
}

map_server <- function(id, is_wb_data) {
  moduleServer(id, function(input, output, session) {
    output$map <- renderLeaflet({
      leaflet(options = leafletOptions(minZoom = 3, maxZoom = 16, worldCopyJump = FALSE)) |>
        # CARTO basemaps now need an API key; Esri gray canvas is keyless (max zoom 16)
        addProviderTiles(providers$Esri.WorldGrayCanvas, options = providerTileOptions(noWrap = TRUE)) |>
        setView(lng = 10, lat = 50, zoom = 5) |>
        addMapPane("choropleth", zIndex = 410) |>
        addMapPane("circles", zIndex = 420)
    })
    outputOptions(output, "map", suspendWhenHidden = FALSE)

    data <- reactive(if (is_wb_data()) map_data_world_bank else map_data_oecd)
    point_data <- reactive(data()[data()$Year == input$years_value, ])

    observe(updateSliderInput(session, "years_value", max = max(data()$Year)))

    observe({
      points <- point_data()
      polygons <- merge(polygon_data, points, by.x = "id", by.y = "Code")
      leafletProxy("map") |>
        clearGroup("choropleth") |>
        clearGroup("circles") |>
        addPolygons(
          data = polygons,
          group = "choropleth",
          fillColor = choropleth_pal(polygons$Death.Rate),
          fillOpacity = 0.5,
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          highlightOptions = highlightOptions(weight = 1, color = "#FFF", dashArray = "", fillOpacity = 0.8),
          options = pathOptions(pane = "choropleth")
        ) |>
        addCircleMarkers(
          data = points,
          lng = ~lng,
          lat = ~lat,
          group = "circles",
          radius = circle_radius(points$Death.Rate),
          weight = 1,
          color = "white",
          opacity = 0.7,
          fillColor = circle_color(points$PM2.5),
          fillOpacity = 0.5,
          popup = sprintf("<b>%s:</b><br>%s", htmltools::htmlEscape(points$Entity), round(points$Death.Rate, 2)),
          options = pathOptions(pane = "circles")
        )
    })
  })
}
