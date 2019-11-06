library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(ggplot2)


interface <- dashboardPage(
  dashboardHeader(
    title = 'South African Crime Analytics'
  ),
  dashboardSidebar(
    uiOutput('select_category')
  ),
  dashboardBody(
    fluidRow(
      column(width=10),
      column(width=2)
    )
  )
)

logic <- function(input, output){
  
  #load data from file
  load_data <- reactive({
    data = read.csv('crime_stats.csv')
  })
  
  #create select input: user can select crime category
  output$select_category <- renderUI({
    selectInput(
      inputId = 'crime_category',
      label = 'Select crime category',
      choices = load_data() %>% select(Category)
    )
  })
  
  #filter through crime categories between 2015-2016 , aggregated by province
  filter_categories <- reactive({
    data = load_data() %>% filter(Category==input$crime_category) %>% group_by(Province)
    return(data%>%select(X2015.2016))
  })
  
  #code to render barplot
  output$bar_plot <- renderPlot({
    ggplot(data = filter_categories()) + geom_bar(aes(x=Province, y=X2015.2016), stat = 'identity')
  })
  
}

shinyApp(interface, logic)