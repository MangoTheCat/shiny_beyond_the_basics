# Understanding Reactivity

# --- Reactive vs. Non-reactive Programming ------------------------------------

# Non-reactive
n <- 1000
hist(rnorm(n))
n <- 2000  # nothing happens to the plot

# Reactive
library(shiny)
ui <- fluidPage(
  sliderInput("n", "Generate n randoms", 
              min = 100, max = 2000, value = 1000, step = 100),
  plotOutput("histogram")
)

server <- function(input, output) {
  output$histogram <- renderPlot({
    hist(rnorm(input$n))
  })
}
shinyApp(ui, server)


# --- Adding a Conductor -------------------------------------------------------
# Sharing a calculation between multiple outputs
library(shiny)
ui <- fluidPage(
  # Input
  sliderInput("n", "Generate n randoms", 
              min = 100, max = 2000, value = 1000, step = 100),
  plotOutput("histogram"),
  verbatimTextOutput("textSummary")
)

server <- function(input, output) {
  
  # Conductor (a reactive expression)
  normData <- reactive({
    rnorm(input$n)
  })
  
  # Outputs
  output$histogram <- renderPlot({
    hist(normData())
  })
  output$textSummary <- renderPrint({
    summary(normData())
  })
}
shinyApp(ui, server)

# Using a conductor to save processing
library(shiny)
ui <- fluidPage(
  sliderInput("n", "Generate n randoms", 
              min = 100, max = 2000, value = 1000, step = 100),
  selectInput("colour", "Select a colour",
              choices = c("orange", "blue", "green")),
  
  plotOutput("histogram")
)
server <- function(input, output) {
  # Conductor
  normDataSlow <- reactive({
    Sys.sleep(3)  # sleep for 3 seconds (simulating a slow process)
    rnorm(input$n)
  })
  # Output
  output$histogram <- renderPlot({
    hist(normDataSlow(), col = input$colour)
  })
}
shinyApp(ui, server)


# --- Reactive vs. Observe -----------------------------------------------------
# What happens when we click Go?
library(shiny)
ui <- fluidPage( 
  actionButton("go", "Go!")
)
server <- function(input, output) {
  reactive({
    message(paste("The Go button has the value", input$go))
  })
}
shinyApp(ui, server)  # Nothing

# observe
library(shiny)
ui <- fluidPage( 
  actionButton("go", "Go!")
)
server <- function(input, output) {
  observe({
    message(paste("The Go button has the value", input$go))
  })
}
shinyApp(ui, server)  # Something!


# --- Making Our Own Inputs ----------------------------------------------------

library(shiny)
ui <- fluidPage(
  sliderInput("n", "Generate n randoms", 
              min = 100, max = 2000, value = 1000, step = 100),
  plotOutput("histogram"),
  textOutput("lastUpdated")
)

server <- function(input, output) {
  
  rv <- reactiveValues(time = Sys.time())
  
  output$histogram <- renderPlot({
    hist(rnorm(input$n))
  })
  
  output$lastUpdated <- renderText({
    paste("Inputs were last updated at",  
          format(rv$time, format = "%d/%m/%Y %H:%m:%S"))
  })
  
  observe({
    tmp <- input$n  # take a dependency on input$n
    rv$time <- Sys.time()
  })
}
shinyApp(ui, server)
