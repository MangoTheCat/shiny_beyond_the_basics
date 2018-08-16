library(dplyr)
library(readr)
library(shiny)
library(shinydashboard)
ui <- dashboardPage(
  dashboardHeader(title = "Dataset Filter"),
  dashboardSidebar(
    fileInput("file", "Upload a CSV file"),
    textInput("filter", "Enter a valid dplyr filter", placeholder = "e.g. mpg > 30"),
    actionButton("applyFilter", "Apply Filter")

  ),
  dashboardBody(
    h3("Filtered dataset"),
    tableOutput("filteredTable"),
    actionButton("save", "Save"),
    helpText("Click Save to save the filtered dataset to disk as \"filteredData.csv\".")
  )
)

server <- function(input, output) {
  
  # Reactive expression to save processing
  dataset <- reactive({
    req(input$file)
    read_csv(input$file$datapath)
  })
  
  # Changed reactive to eventReactive (with a dependency on filter action button)
  getFilteredData <- eventReactive(input$applyFilter, {
    # Don't filter anything if no filter is specified.
    if (!isTruthy(input$filter)) filt <- "TRUE" else filt <- input$filter
    # Apply the filter
    filter_(dataset(), filt)
  })
  
  # Changed eventReactive to observeEvent
  saveFilteredData <- observeEvent(input$save, {
    write_csv(getFilteredData(), "filteredData.csv")
  })
  
  output$filteredTable <- renderTable({
    getFilteredData()
  })

}
shinyApp(ui, server)