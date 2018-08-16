
library(shiny)
library(DT)
ui <- fluidPage(
      DTOutput("iris")
)
server <- function(input, output) {
  
  output$iris <- renderDT({
    datatable(iris, 
              filter = "top",
              options = list(
                paging = FALSE,
                ordering = FALSE
              ))
  })
}
shinyApp(ui, server)
