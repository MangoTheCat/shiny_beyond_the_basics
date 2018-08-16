
library(magrittr)
library(shiny)
library(DT)

# Do some preliminary formatting of swiss data
swiss2 <- swiss / 100

ui <- fluidPage(
  DTOutput("swiss")  
)

server <- function(input, output) {
  output$swiss <- renderDT(
    datatable(swiss2,
              extensions = "Buttons",
              options = list(
                dom = "Bfrtip",
                buttons = c("copy", "pdf"))) %>% 
      formatPercentage(names(swiss2), digits = 1) %>% 
      formatStyle(names(swiss2),
                  background = styleColorBar(data = range(swiss2),
                                             color = "goldenrod"))
  )
}
shinyApp(ui, server)
