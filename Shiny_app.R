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
library(reshape2)

SLR <- read_delim("Data/GMSL_TPJAOS_5.1_199209_202212.csv")
landimpact <- read_delim("Data/Total Land Impacted by SLR.csv")
population_impacts <- read_delim("Data/Population Impacted by SLR.csv")
renamed <- population_impacts %>% 
  rename("1m"=`% of Country Population Impacted - 1 meter`) %>% 
  rename("2m"=`% of Country Population Impacted - 2 meter`) %>% 
  rename("3m"=`% of Country Population Impacted - 3 meter`) %>% 
  rename("4m"=`% of Country Population Impacted - 4 meter`) %>% 
  rename("5m"=`% of Country Population Impacted - 5 meter`)

population_impacted <- renamed %>% 
  select(`Country Code`, `Country Name`, `Region`, `Population`, `1m`, `2m`, `3m`, `4m`, `5m`) %>% 
  melt(id=c("Country Code", "Country Name", "Region", "Population"))


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
                checkboxGroupInput("columns", "Select columns to display:",
                                   choices = colnames(landimpact),
                                   selected = colnames(landimpact)),
                
            ),
             
            # Show a plot of the generated distribution
            mainPanel(
              tableOutput("table")
            )
          )     
    ),
  
     tabPanel("Scatter Plot",
              titlePanel("Population"),
              sidebarLayout(
                sidebarPanel(
                  checkboxGroupInput("Region", label="Choose Region",
                                     choices=c("Latin America / Caribbean", "Middle East / North Africa", "Sub-Saharan Africa", "East Asia", "South Asia"),
                                     selected=c("Latin America / Caribbean", "Middle East / North Africa", "Sub-Saharan Africa", "East Asia", "South Asia")),
                  
                  checkboxGroupInput("Sea_Level_Rise", label="Choose Sea Level Range",
                                     choices=c("1m", "2m", "3m", "4m", "5m"),
                                     selected=c("1m", "2m", "3m", "4m", "5m"))
                ),
                mainPanel(
                  plotOutput("Plot"))
              )
     ),
    tabPanel("Conclusion",
             # Application title
             titlePanel("Plot of General Mean Sea Level Rise Variation by Year"),
             
             # Sidebar with a slider input for number of bins 
             sidebarLayout(
               sidebarPanel(
                 checkboxInput("trendline", "Add trend line", value = TRUE)
               ),
               
               # Show a plot of the generated distribution
               mainPanel(
                 plotOutput("graph2")
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
    data_subset <- landimpact %>%
      select(input$columns)
    
    data_subset
  })
  
  output$Plot <- renderPlot({
    population_impacted %>% 
      filter(Region %in% input$Region) %>%
      filter(variable %in% input$Sea_Level_Rise) %>% 
      group_by(Region) %>% 
      ggplot(aes(x=variable, y=value, group=Region, color=factor(Region)))+
      geom_point()+
      labs(x="Sea Lever Rise", y="Country Population Impacted", color="Region")
  })
  
  output$graph2 <- renderPlot({
    SLR %>%
      ggplot(aes(x = Year, y = GMSLV_in_mm)) +
      geom_point() +
      if (input$trendline) {
        stat_smooth(method = "lm")
      }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
