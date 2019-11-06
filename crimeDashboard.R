library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)


interface <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    uiOutput('select_category')
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
  
}

shinyApp(interface, logic)