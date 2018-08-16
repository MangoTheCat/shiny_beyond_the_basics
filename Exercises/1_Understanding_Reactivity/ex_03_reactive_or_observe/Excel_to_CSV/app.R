library(readr)
library(readxl)
library(shiny)
ui <- fluidPage(
  titlePanel("Excel to CSV Converter"),
  fileInput("file", "Upload an Excel file"),
  helpText("Upload an Excel file and it will be converted and saved to \"data.csv\"."),
  h3("Data Preview"),
  tableOutput("table")
)

server <- function(input, output) {

  dataset <- reactive({
    req(input$file)
    read_excel(input$file$datapath)
  })
  
  output$table <- renderTable({
    dataset()
  })
  
  saveFilteredData <- reactive({
    write_csv(dataset(), "data.csv")
  })
  
}
shinyApp(ui, server)