justify <- "text-align: justify; word-break: break-word; hyphens: auto;"

about_text <- tagList(
  tags$h3("About"),
  tags$br(),
  tags$p(
    "The app gives a visual overview of PM2.5 air pollution for different
    countries over the years and its potential relationship to respiratory
    diseases and their prevalence.",
    style = justify
  )
)

slider_text_map <- tags$p(
  "Please use the slider below to choose the year. The map will reflect
  data for the input",
  style = justify
)

slider_text_plot <- tags$p(
  "Please use the slider below to change the years as well as the dropdown
  to select the countries to compare. By default, the mean data for the
  World is plotted.",
  style = justify
)

dataset_information <- tagList(
  tags$strong(tags$h3("Dataset Information")),
  tags$p(
    "For the app, we have chosen data from the World Bank and Organisation
    for Economic Co-operation and Development (OECD). Also, for the data
    regarding the Death Rate, we relied on Our World in Data. References to
    all three can be found below.",
    style = justify
  ),
  tags$ul(
    tags$li(tags$a("World Bank", href = "https://data.worldbank.org/indicator/EN.ATM.PM25.MC.M3")),
    tags$li(tags$a("OECD", href = "https://stats.oecd.org/Index.aspx?DataSetCode=EXP_PM2_5")),
    tags$li(tags$a("Our World in Data", href = "https://ourworldindata.org/grapher/respiratory-disease-death-rate"))
  )
)

missing_note <- tags$p(
  tags$strong("Note: "),
  "For years 1990 to 2010, the PM2.5 data was collected at every five-year
  mark. That is, the PM2.5 data is only available for 1990, 1995, 2000,
  2005, 2010, and 2010 onwards.",
  style = paste("font-size: 14px;", justify)
)

info_modal <- function() {
  showModal(modalDialog(
    tags$strong(tags$h3("Respiratory Diseases App")),
    tags$p("Exploring Relationships between PM2.5 & Respiratory Diseases"),
    tags$hr(),
    tags$strong(tags$h4("Problem Statement")),
    tags$p(
      "Air Pollution has always been a problem for the world and over the
      years, especially with the pandemic, the ambient air pollution seems
      to be a slow burn for the entire population of the planet. Through
      this app, we wish to explore the relationship between the PM2.5
      particulate metric and the Death Rate (defined as deaths per 100,000)
      from respiratory illnesses over the world over the years.",
      style = justify
    ),
    tags$hr(),
    dataset_information,
    tags$hr(),
    missing_note,
    size = "l",
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
}
