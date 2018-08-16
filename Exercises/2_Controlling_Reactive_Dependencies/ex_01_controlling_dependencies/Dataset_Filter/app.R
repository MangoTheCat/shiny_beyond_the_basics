library(dplyr)
library(readr)
library(shiny)
library(shinydashboard)
ui <- dashboardPage(
  dashboardHeader(title = "Dataset Filter"),
  dashboardSidebar(
    fileInput("file", "Upload a CSV file"),
    textInput("filter", "Enter a valid dplyr filter", placeholder = "e.g. mpg > 30"),
    actionButton("applyFilter", "Apply filter")

  ),
  dashboardBody(
    h3("Filtered dataset"),
    tableOutput("filteredTable")
  )
)

server <- function(input, output) {
  
  # Reactive expression to save processing
  dataset <- reactive({
    req(input$file)
    read_csv(input$file$datapath)
  })
  
  getFilteredData <- reactive({
    # Don't filter anything if no filter is specified.
    if (!isTruthy(input$filter)) filt <- "TRUE" else filt <- input$filter
    # Apply the filter
    filter_(dataset(), filt)
  })
  
  saveFilteredData <- observe({
    write_csv(getFilteredData(), "filteredData.csv")
  })
  
  output$filteredTable <- renderTable({
    getFilteredData()
  })

}
shinyApp(ui, server)