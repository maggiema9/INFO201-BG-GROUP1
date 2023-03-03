#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

SLR <- read_delim("Data/GMSL_TPJAOS_5.1_199209_202212.csv")
landimpact <- read_delim("Data/Total Land Impacted by SLR.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Summary"
             
             ),
    tabPanel("Plot", 
             # Application title
             titlePanel("Plot of General Mean Sea Level Rise Variation by Year"),
             
             # Sidebar with a slider input for number of bins 
             sidebarLayout(
               sidebarPanel(
               
               sliderInput("Year_range", label = "Choose the year range", 
                           min = min(SLR$Year), max = max(SLR$Year),
                           value = c(1994, 2022))
             ),
             
             # Show a plot of the generated distribution
             mainPanel(
               plotOutput("graph")
             )
    )
  ),
  
    tabPanel("Table", 
            # Application title
            titlePanel("Table of Affected Land as a Result of SLR"),
           
            # Sidebar with a slider input for number of bins 
            sidebarLayout(
              sidebarPanel(
                
            ),
             
            # Show a plot of the generated distribution
            mainPanel(
              tableOutput("table")
            )
          )     
    )
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$graph <- renderPlot({
    SLR %>%
      filter(Year >= input$Year_range[1], Year <= input$Year_range[2]) %>%
      ggplot(aes(x = Year, y = GMSLV_in_mm)) +
      geom_line() 
  })
  output$table <- renderTable({
    landimpact %>%
      select("country name", 
             "% of Country Area Impacted - 1 meter", 
             "% of Country Area Impacted - 2 meter",
             "% of Country Area Impacted - 3 meter",
             "% of Country Area Impacted - 4 meter",
             "% of Country Area Impacted - 5 meter")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
