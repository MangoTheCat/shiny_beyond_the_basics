# Validating Inputs

# ---------------- Waiting for Missing Inputs ------------------------
library(shiny)
library(ggplot2)
ui <- fluidPage(
  h3("Car Relationships"),
  selectInput("x", "x var", c("", colnames(mtcars))),
  selectInput("y", "y var", c("", colnames(mtcars))),
  plotOutput("scatter")
)
server <- function(input, output) {
  output$scatter <- renderPlot({
    ggplot(mtcars, aes_string(x = input$x, y = input$y)) +
    geom_point() + geom_smooth()
  })
}
shinyApp(ui, server)


# ------------ Waiting for Missing Inputs (fixed) --------------------
library(shiny)
library(ggplot2)
ui <- fluidPage(
  h3("Car Relationships"),
  selectInput("x", "x var", c("", colnames(mtcars))),
  selectInput("y", "y var", c("", colnames(mtcars))),
  plotOutput("scatter")
)
server <- function(input, output) {
  output$scatter <- renderPlot({
    req(input$x, input$y)
    ggplot(mtcars, aes_string(x = input$x, y = input$y)) +
      geom_point() + geom_smooth()
  })
}
shinyApp(ui, server)


# ----------------------- Validating Inputs --------------------------
library(shiny)
library(ggplot2)
ui <- fluidPage(
  h3("Car Relationships"),
  selectInput("x", "x var", c("", colnames(mtcars))),
  selectInput("y", "y var", c("", colnames(mtcars))),
  plotOutput("scatter")
)
server <- function(input, output) {
  output$scatter <- renderPlot({
    validate(
      need(input$x, "Please select a variable for the x-axis"),
      need(input$y, "Please select a variable for the y-axis")
    )
    ggplot(mtcars, aes_string(x = input$x, y = input$y)) +
      geom_point() + geom_smooth()
  })
}
shinyApp(ui, server)
