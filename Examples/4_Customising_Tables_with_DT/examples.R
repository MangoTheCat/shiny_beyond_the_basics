# Customising Tables with DT

# ------------------- Minimal DT Table -------------------------------
library(shiny)
library(DT)
ui <- fluidPage(
  h2("The mtcars dataframe"),
  DTOutput("cars")
)
server <- function(input, output) {
  output$cars <- renderDT({ mtcars })
}
shinyApp(ui, server)

# ------------------- Using datatable --------------------------------
library(shiny)
library(DT)
ui <- fluidPage(
  h2("The mtcars dataframe"),
  DTOutput("cars1"),
  DTOutput("cars2")
  
)
server <- function(input, output) {
  output$cars1 <- renderDT({ mtcars })
  output$cars2 <- renderDT({ datatable(mtcars) })
}
shinyApp(ui, server)

# --------------- Turning on Filtering -------------------------------
library(shiny)
library(DT)
ui <- fluidPage(
  h2("The mtcars dataframe"),
  DTOutput("cars")
)
server <- function(input, output) {
  output$cars <- renderDT({
    datatable(mtcars, filter = "top")
  })
}
shinyApp(ui, server)

# --------------- Making a simple table ------------------------------
library(shiny)
library(DT)
ui <- fluidPage(
  h2("The mtcars dataframe"),
  DTOutput("cars")
)
server <- function(input, output) {
  output$cars <- renderDT({
    datatable(mtcars, options = list(
      paging = FALSE,
      ordering = FALSE,
      searching = FALSE,
      info = FALSE
    ))
  })
}
shinyApp(ui, server)


# ---------------- Formatting columns --------------------------------
library(magrittr)
stateInfo <- as.data.frame(state.x77, row.names = FALSE)
stateInfo$State <- row.names(state.x77)
stateInfo$Illiteracy <- stateInfo$Illiteracy / 100
datatable(stateInfo, rownames = FALSE) %>% 
  formatCurrency("Income", currency = "$") %>% 
  formatPercentage("Illiteracy", digits = 1)

# ----------------- Styling columns ----------------------------------
datatable(stateInfo) %>% 
  formatStyle("Population", color = "grey", 
              fontWeight = "bold",
              backgroundColor = "orange" )

# Conditional styling
datatable(stateInfo) %>% 
  formatStyle("Illiteracy",
              color = styleInterval(cuts = c(0.008, 0.011),
                                    values = c("red", "tan", "navy"))) %>%
  formatStyle("Population",
              background = styleColorBar(data = stateInfo$Population, 
                                              color = "skyblue")) %>% 
  formatStyle("State",
              backgroundColor = styleEqual("California", "hotpink"))
                                              
# ---------------- Extensions (Button) -------------------------------
datatable(stateInfo, 
          extensions = "Buttons", 
          options = list(
            dom = "Bfrtip",
            buttons = c("copy","csv", "pdf"))
)


# ---------------- Datatables as Inputs ------------------------------

# Controlling Selection Options
datatable(stateInfo, selection = list(target = "column"))
          
# Example using selected rows
library(shiny)
library(DT)
ui <- fluidPage(
  titlePanel(title = "States"),
  fluidRow(DTOutput("states")),
  fluidRow(verbatimTextOutput("info")),
  fluidRow(plotOutput("plot"))
)
server <- function(input, output) {
  output$states <- renderDT({
    datatable(state.x77, selection = list(target = "row"))
  })
  output$info <- renderPrint({
    cat("Row indices selected: ")
    cat(input$states_rows_selected, sep = ",")
  })
  output$plot <- renderPlot({
    cols <- rep("black", nrow(state.x77))
    cols[input$states_rows_selected] <- "red"
    pairs(state.x77, col = cols, pch = 19)
  })
}
shinyApp(ui, server)
