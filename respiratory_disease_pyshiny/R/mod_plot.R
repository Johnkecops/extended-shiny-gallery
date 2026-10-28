country_choices <- sort(union(plot_data_oecd$Entity, plot_data_world_bank$Entity))

create_figure <- function(data, year_range, country, y_from, title, y_label) {
  plot_data <- data[data$Year >= year_range[1] & data$Year <= year_range[2] & data$Entity %in% country, ]
  plot_ly(
    plot_data,
    x = ~Year,
    y = plot_data[[y_from]],
    color = ~Entity,
    colors = RColorBrewer::brewer.pal(9, "Blues")[-1],
    type = "scatter",
    mode = "markers+lines",
    line = list(width = 5),
    marker = list(size = 15)
  ) |>
    layout(
      title = title,
      plot_bgcolor = "white",
      hovermode = "x unified",
      xaxis = list(title = "Year", showline = FALSE, gridcolor = "#d2d2d2", gridwidth = 0.5),
      yaxis = list(title = y_label, showline = FALSE, gridcolor = "#d2d2d2", gridwidth = 0.5)
    )
}

plot_ui <- function(id) {
  ns <- NS(id)
  div(
    div(
      about_text,
      tags$hr(),
      slider_text_plot,
      tags$br(),
      sliderInput(ns("years_value"), "Select Year", min = 1990, max = 2017, value = c(2010, 2015), sep = ""),
      selectizeInput(ns("country_select"), "Select Countries:", choices = country_choices, selected = "World", multiple = TRUE),
      tags$hr(),
      dataset_information,
      tags$hr(),
      missing_note,
      class = "main-sidebar card-style"
    ),
    div(
      plotlyOutput(ns("dr_plot")),
      tags$hr(),
      plotlyOutput(ns("pm_plot")),
      class = "main-main card-style"
    ),
    class = "main-layout"
  )
}

plot_server <- function(id, is_wb_data) {
  moduleServer(id, function(input, output, session) {
    data <- reactive(if (is_wb_data()) plot_data_world_bank else plot_data_oecd)

    observe(updateSliderInput(session, "years_value", max = max(data()$Year)))

    output$dr_plot <- renderPlotly(create_figure(
      data(), input$years_value, input$country_select,
      "Death.Rate", "Death Rate From Respiratory Diseases", "Deaths per 100,000"
    ))
    output$pm_plot <- renderPlotly(create_figure(
      data(), input$years_value, input$country_select,
      "PM2.5", "PM2.5 Measure", "PM2.5"
    ))
    outputOptions(output, "dr_plot", suspendWhenHidden = FALSE)
    outputOptions(output, "pm_plot", suspendWhenHidden = FALSE)
  })
}
