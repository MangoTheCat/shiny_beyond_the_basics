library(shiny)
library(dplyr)
`%then%` <- shiny:::`%OR%`
ui <- fluidPage(
  h3("Dataset Summary"),
  fileInput("file", label = "Upload a CSV"),
  plotOutput("pairs"),
  verbatimTextOutput("summary")
)
server <- function(input, output) {
  
  getData <- reactive({
    validate(
      need(input$file, "Please upload a CSV file.") %then%
      need(try(endsWith(input$file$name, ".csv")), "")
    )
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

# The outputs both render the validation message "Please upload a CSV file." even
# though one is a plot and the other is a print. Shiny knows how to propagate the
# validation message and display it in all its outputs.


# Extension: be careful when processing reactives as part of your validation
# Wrap statements in try() where necessary
