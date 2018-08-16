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
    
    plotOutput("predsplot") 
    
  )
)

server <- function(input, output) {
  
  output$predsplot <- renderPlot({
    
    # Construct model formula and build the model
    modelForm <- paste0("mpg ~ ", paste0(input$predictors, collapse = "+"))
    model <- buildModel(modelForm, data = mtcars)
    
    # Plot residuals
    ggplot(mtcars, aes(x = mpg, y = predict(model, mtcars))) + 
             geom_point(shape = as.numeric(input$plotshape)) + 
      labs(title = input$title, x = "Actual", y = "Predictions")
    
  })
  
}

shinyApp(ui, server)
