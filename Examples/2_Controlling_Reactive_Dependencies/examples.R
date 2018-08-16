# Controlling Reactive Dependencies 


# Multiple inputs, one output
library(shiny)
ui <- fluidPage(
  textInput("title", "Title:", value = "Random normals"),
  selectInput("colour", "Select a colour", 
              choices = c("orange", "blue", "green")),
  numericInput("sampleSize", "Select size of data:", 
               min = 10, max = 500, value = 100),
  plotOutput("histogram")
)
server <- function(input, output){
  output$histogram <- renderPlot(
    hist(x = rnorm(input$sampleSize),
         main = isolate(input$title),
         col = isolate(input$colour))
  )
}
shinyApp(ui, server)

# --- Preventing Dependencies with isolate -------------------------------------
library(shiny)
ui <- fluidPage(
  textInput("title", "Title:", value = "Random normals"),
  selectInput("colour", "Select a colour", 
              choices = c("orange", "blue", "green")),
  numericInput("sampleSize", "Select size of data:", 
               min = 10, max = 500, value = 100),
  plotOutput("histogram")
)
server <- function(input, output){
  output$histogram <- renderPlot(
    hist(x = rnorm(input$sampleSize),
         main = isolate(input$title),
         col = isolate(input$colour))
  )
}
shinyApp(ui, server)

# --- Defining Our Own Dependencies --------------------------------------------

# --- Defining Dependencies with eventReactive
library(shiny)
ui <- fluidPage(
  sliderInput("n", "Number of samples", min = 25, max = 500, step = 25, value = 100),
  radioButtons("dist", "Distribution type:",
               c("Normal" = "norm",
                 "Uniform" = "unif",
                 "Exponential" = "exp")),
  actionButton("go", "Go"),
  plotOutput("distPlot")
)
server <- function(input, output) {
  
  getDistData <- reactive({
    input$go
    isolate({
      dist <- switch(input$dist,
                     norm = rnorm,
                     unif = runif,
                     exp = rexp,
                     rnorm)
      dist(input$n)
    })

  })
  
  output$distPlot <- renderPlot({
    hist(getDistData(), col = "orange")
  })
}
shinyApp(ui, server)

# ------------------------------------------------------------------------------
# Supplementary note: using eventReactive is the same as reactive + isolate
# E.g. this app has the same dependency graph as that above.
library(shiny)
ui <- fluidPage(
  sliderInput("n", "Number of samples", min = 25, max = 500, step = 25, value = 100),
  radioButtons("dist", "Distribution type:",
               c("Normal" = "norm",
                 "Uniform" = "unif",
                 "Exponential" = "exp")),
  actionButton("go", "Go"),
  plotOutput("distPlot")
)
server <- function(input, output) {
  
  getDistData <- reactive({
    input$go  # Take dependency
    isolate({
      dist <- switch(input$dist,
                     norm = rnorm,
                     unif = runif,
                     exp = rexp,
                     rnorm)
      dist(input$n)
    })
  })
  
  output$distPlot <- renderPlot({
    hist(getDistData(), col = "orange")
  })
}
shinyApp(ui, server)

