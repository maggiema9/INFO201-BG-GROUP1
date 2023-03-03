library(shiny)
library(tidyverse)

ui <- navbarPage("Home",
                 tabPanel("page 1"),
                 tabPanel("page 2")
)


server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)