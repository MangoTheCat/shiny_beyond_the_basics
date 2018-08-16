library(shiny)
library(dplyr)
ui <- fluidPage(
  h3("Dataset Summary"),
  fileInput("file", label = "Upload a CSV"),
  plotOutput("pairs"),
  verbatimTextOutput("summary")
)
server <- function(input, output) {
  
  getData <- reactive({
    read.csv(input$file$datapath)
  })
  
  output$pairs <- renderPlot({
    pairs(select_if(getData(), is.numeric))
  })
  
  output$summary <- renderPrint({
    summary(getData())
  })
}
shinyApp(ui, server)
