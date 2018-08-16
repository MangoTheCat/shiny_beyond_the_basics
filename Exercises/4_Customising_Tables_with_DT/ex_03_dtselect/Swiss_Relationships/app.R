
library(magrittr)
library(shiny)
library(DT)

# Do some preliminary formatting of swiss data
swiss2 <- swiss / 100

ui <- fluidPage(
  DTOutput("swiss"),
  plotOutput("plot")
)

server <- function(input, output) {
  output$swiss <- renderDT({
    datatable(swiss2,
              selection = list(target = "row+column"))
  })
  
  output$plot <- renderPlot({
    # Ensure we have only 2 columns to plot
    validate(need(length(input$swiss_columns_selected) >= 2,
                  "Select two columns to plot."))
    xInd <- input$swiss_columns_selected[1]
    yInd <- input$swiss_columns_selected[2]
    # Scatterplot
    plot(swiss[, c(xInd, yInd)])
    # Overplot selected rows in red
    points(swiss[input$swiss_rows_selected, c(xInd, yInd)],
           pch = 19, col = "red")
  })
}
shinyApp(ui, server)
