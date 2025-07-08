


library(shiny)
library(shinythemes)
library(tidyverse)
library(babynames)

ui <- fluidPage( theme = bslib::bs_theme( bg = "#fdf6e3",           # solarized light
                                          fg = "#657b83",           # solarized gray
                                          base_font = "Merriweather" ),
                 titlePanel("Simple app to know your name's most popular year"),
                 sidebarLayout(
                   sidebarPanel(
                     textInput("name", "Enter your name", value = ""),
                     selectInput("sex", "sex",choices = list(male = "M",
                                                             female="F")),
                     sliderInput("year",label = "Year range",min = min(babynames$year),max = max(babynames$year),
                                 value = c(min(babynames$year),max(babynames$year)),sep = "" )),
                   mainPanel( plotOutput("nameplot"))
                 )
                 
)

server <- function(input, output, session) {
  output$nameplot <- renderPlot({
    babynames %>% 
      filter(name == input$name,
             sex  == input$sex) %>% 
      ggplot(mapping = aes(x = year, y = n))+
      geom_line()+
      theme_minimal()+
      scale_x_continuous(name = "name's popularity according to date of birth",
                         limits = input$year)
  }, res = 96)
  
}

shinyApp(ui, server)    