library(ggplot2)
library(shiny)
library(shinydashboard)
source("model.R")

ui <- dashboardPage(
  dashboardHeader(title = "MPG Model"),
  dashboardSidebar(
    selectInput("predictors", "Pick predictors", choices = colnames(mtcars)[-1], multiple = TRUE,
                selected = "cyl"),
    textInput("title", "Plot Title", value = "Actuals vs. Predictions"),
    selectInput("plotshape", "Plotting symbol", choices = 1:25)
  ),
  dashboardBody(
    h3("Actuals vs. Predictions"),
    plotOutput("predsplot"),
    h3("Residuals Summary"),
    verbatimTextOutput("residSummary")
  )
)

server <- function(input, output) {
  
  # Reactive expression to cache the model building
  model <- reactive({
    modelForm <- paste0("mpg ~ ", paste0(input$predictors, collapse = "+"))
    cat(file = stderr(), "calling model()\n")
    buildModel(modelForm, data = mtcars)
  })
  
  output$predsplot <- renderPlot({
    preds <- predict(model(), mtcars)
    # Plot residuals
    ggplot(mtcars, aes(x = mpg, y = preds)) + 
      geom_point(shape = as.numeric(input$plotshape)) + 
      labs(title = input$title, x = "Actual", y = "Predictions")
  })
  
  output$residSummary <- renderPrint({
    summary(residuals(model()))
  })
}
shinyApp(ui, server)
