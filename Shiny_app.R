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

## upload data
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
    tabPanel("Summary",
             titlePanel("The Effects of Climate Change on Sea Level Rise"),
             #image
             tags$img(src ="Sea_Level_Rise.png", width = "959px", height = "478px"),
               
             p("Climate change has affected our world in countless ways, one of the 
             most prominent ways being rising sea levels. Our project's goals 
             are to address sea level rise by focusing on its causes and its effects 
             on people and land.", 
                align = "center"),
             
             p("We intend on answering our questions about rising sea levels with data 
             sets that come from reputable sources that have extensively researched 
             this topic. One data set from NASA, which we will be using, describes 
             the causes of sea level rise. Our other two data sets come from the 
             The World Bank rising sea levels have affected people and land.", 
                
                  align = "center"),
             
             p("We hope to deliver this information to students in high school or college 
             who are interested in learning more about climate change. It is important 
             that younger generations learn about the effects of climate change since 
             this audience will be responsible for dealing with it and making a change 
             in the future.", 
                align = "center")
             ),
    
    tabPanel("Plot", 
             # Application title
             titlePanel("Plot of General Mean Sea Level Rise Variation by Year"),
             p("This plot is a visual representation of the change in global average 
               sea level rise as function of time. The year range can be adjusted 
               using the slider function. Analysis of this plot shows that, although 
               sea levels can fluctuate up and down from year to year, overall sea 
               levels have risen consistently over the past 30 years."),
             
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
           p("The default view of this table allows users to observe countries’ 
             land impacted by SLR in both percentage and square kilometers. 
             The checkbox widget allows for a more summarized view of the data."),
            
            # Sidebar with a checkbox input for number of bins 
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
              p("The graph shows how many people are affected for every one meter 
                rise in sea level. Each point represents a country and is colored 
                by region. The region and the extent of sea level rise can be 
                selected by adjusting the widget on the right."),
              
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
             
             
             # Sidebar with a checkbox input for number of bins 
             sidebarLayout(
               sidebarPanel(
                 checkboxInput("trendline", "Add trend line", value = TRUE)
               ),
               
               # Show a plot of the generated distribution
               mainPanel(
                 plotOutput("graph2")
               ),
             ),
             
             h3("Description of notable insight: "),
             
             p("The most notable takeaway from this data is that Sea Level is affecting 
             all countries in unprecedented ways. From our first graph that displays 
             sea level variation between the years, we can see that it has been 
             trending upwards. This poses a massive concern because of the threat 
             to our land, population, and ecosystem."), 
             
             h3("Data that demonstrates the pattern: "),
             p("The graph shows the general trendline between sea level rise across 
               the years, and it is clear that there is a strong positive relationship. "),
             
             h3("Broader implications: "),
             p("Some broader implications we had is that countries with a larger 
               coastline are more disproportionately affected by SLR. A reason 
               why we draw this conclusion is because the graph that displays 
               affected populations by region shows that Latin American/Caribbean 
               countries have generally a higher population that are detrimentally 
               affected by sea level rise. The same graph also shows that South Asia 
               generally has a trend where their population is significantly less affected 
               by sea level rise as compared to Latin America/Caribbean countries. "),
             
             h3("Data quality: "),
             p("Given that we drew our data from NASA and The World Bank, it is 
             reasonable to claim that our data is of reliable quality. Both these 
             sources are highly reputable and are research based; generally, that 
             means that there is little to no bias when it comes to providing concrete information."), 

             p("There is always the possibility of undercoverage of SLR data with many 
             countries. When it comes to undercoverage, the data becomes more variable 
             and can compromise the reliability of the data. The under representation 
             of countries can mislead and reduce urgency within mutual aid support groups. "),
             
             h3("Future ideas: "),
             p("As more data becomes accessible to the general public, a clear answer 
             is providing more information/data within this project to increase accuracy 
             and understanding of sea level rise. It would also be useful to provide 
             more information about more aspects of sea level rise because we focused 
             on the primary effects of sea level rise, meanwhile there are many 
             secondary results of SLR. Examples of this could be how SLR affects 
             ecosystems, funding, infrastructure damage, tectonic movements, etc.")
             
     )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  ## making graph 1
  output$graph <- renderPlot({
    SLR %>%
      filter(Year >= input$Year_range[1], Year <= input$Year_range[2]) %>%
      ggplot(aes(x = Year, y = GMSLV_in_mm)) +
      geom_line() +
      labs(x="Year", y="Global Average Sea Level Rise in milimeters", title="Mean Sea Level Rise by Year")+
      theme(plot.title=element_text(size = 20),
            axis.title.x=element_text(size = 16),
            axis.title.y=element_text(size = 16),
            axis.text.x = element_text(size = 16),
            axis.text.y = element_text(size = 16))
  })
  
  ## making data table 
  output$table <- renderTable({
    data_subset <- landimpact %>%
      select(input$columns)
    
    data_subset
  })
  
  ## making scatterplot
  output$Plot <- renderPlot({
    population_impacted %>% 
      filter(Region %in% input$Region) %>%
      filter(variable %in% input$Sea_Level_Rise) %>% 
      group_by(Region) %>% 
      ggplot(aes(x=variable, y=value, group=Region, color=factor(Region)))+
      geom_point()+
      labs(x="Sea Level Rise", y="Country Population Impacted", color="Region", title="Country Population Impacted by Sea Level Rise")+
      theme(plot.title=element_text(size = 20),
            axis.title.x=element_text(size = 16),
            axis.title.y=element_text(size = 16),
            axis.text.x = element_text(size = 16),
            axis.text.y = element_text(size = 16),
            legend.text = element_text(size=14))
  })
  
  ## making graph 2
  output$graph2 <- renderPlot({
    SLR %>%
      ggplot(aes(x = Year, y = GMSLV_in_mm)) +
      geom_point() +
      labs(x="Year", y="Global Average Sea Level Rise in milimeters", title="Mean Sea Level Rise by Year")+
      theme(plot.title=element_text(size = 20),
            axis.title.x=element_text(size = 16),
            axis.title.y=element_text(size = 16),
            axis.text.x = element_text(size = 16),
            axis.text.y = element_text(size = 16))+
      if (input$trendline) {
        stat_smooth(method = "lm")
      }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
