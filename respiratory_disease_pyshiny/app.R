# Shiny sources R/ automatically before this file, so top-level code in R/
# only uses shiny (already attached) or pkg:: calls.
library(shiny)
library(bslib)
library(leaflet)
library(plotly)

page_dependencies <- tags$head(
  tags$link(rel = "stylesheet", type = "text/css", href = "layout.css"),
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  tags$script(src = "index.js"),

  # PWA Support
  tags$script(HTML("
    async function delayManifest() {
      let retries = 100;
      let statusCode = 404;
      let response;

      while (statusCode === 404 && --retries > 0) {
        response = await fetch('pwa/manifest.json');
        statusCode = response.status;
      }

      if (response.status === 404) throw new Error('max retries reached');

      $('head').append('<link rel=\"manifest\" href=\"pwa/manifest.json\"/>');

      return response;
    }
    delayManifest();

    if ('serviceWorker' in navigator) {
      navigator.serviceWorker
        .register('pwa-service-worker.js')
        .then(function() { console.log('Service Worker Registered'); })
        .catch(function(err) { console.warn('Service Worker registration failed', err); });
    }
  ")),
  tags$link(rel = "apple-touch-icon", href = "pwa/icon.png"),

  tags$meta(name = "description", content = "Respiratory Disease Shiny"),
  tags$meta(name = "theme-color", content = "#000000"),
  tags$meta(name = "apple-mobile-web-app-status-bar-style", content = "#000000"),
  tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
  tags$meta(name = "viewport", content = "width=device-width, initial-scale=1")
)

# top navbar
page_header <- div(
  div(
    tags$a(tags$img(src = "static/img/appsilon-logo.png", height = "50px"), href = "https://demo.appsilon.com/"),
    id = "logo-top",
    class = "navigation-logo"
  ),
  div(
    div(actionButton("tab_map", "Map", class = "navbar-button"), id = "div-navbar-map"),
    div(actionButton("tab_plot", "Graphs", class = "navbar-button"), id = "div-navbar-plot"),
    id = "div-navbar-tabs",
    class = "navigation-menu"
  ),
  div(
    input_switch("dataset", "World Bank", value = TRUE),
    id = "div-navbar-selector",
    class = "navigation-dataset"
  ),
  div(
    actionButton("info_icon", label = NULL, icon = icon("circle-info"), class = "navbar-info"),
    class = "navigation-info"
  ),
  id = "div-navbar",
  class = "navbar-top page-header card-style"
)

page_layout <- div(
  page_header,
  div(map_ui("map"), id = "map-container", class = "page-main main-visible"),
  div(plot_ui("plot"), id = "plot-container", class = "page-main"),
  class = "page-layout"
)

ui <- page_fluid(
  page_dependencies,
  page_layout,
  title = "Respiratory Disease App"
)

server <- function(input, output, session) {
  info_modal()
  observeEvent(input$info_icon, info_modal())

  is_wb_data <- reactive(input$dataset)

  map_server("map", is_wb_data)
  plot_server("plot", is_wb_data)

  observeEvent(input$tab_map, session$sendCustomMessage("toggleActiveTab", list(activeTab = "map")))
  observeEvent(input$tab_plot, session$sendCustomMessage("toggleActiveTab", list(activeTab = "plot")))
}

shinyApp(ui, server)
