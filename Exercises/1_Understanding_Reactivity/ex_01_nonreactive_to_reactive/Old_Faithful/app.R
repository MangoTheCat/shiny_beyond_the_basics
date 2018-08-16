# Non-reactive version
# library(ggplot2)
# nBins <- 10
# qplot(faithful$eruptions, bins = nBins, fill = I("orange"))

# Reactive version
library(shiny)
library(ggplot2)
ui <- fluidPage(
  sliderInput("nBins", "Number of histogram bins", 
              min = 1, max = 50, value = 5),
  selectInput("colour", "Select a colour", 
              choices = c("orange", "hotpink", "cornflowerblue")),
  plotOutput("histogram")
)

server <- function(input, output) {
  output$histogram <- renderPlot({
    qplot(faithful$eruptions, bins = input$nBins, fill = I(input$colour))
  })
}
shinyApp(ui, server)
