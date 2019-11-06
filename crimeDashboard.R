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
    tabsetPanel(
      tabPanel('Explore',
    fluidRow(
      column(width=10,
             plotOutput('bar_plot')
             ),
      
      column(width=2,
             tags$h4('How the dashboard works'),
             tags$hr(),
             tags$p('The user select a crime category and the dashboard displays the counts of selected crime category for each province for the period from 2015 to 2016.'))
      )),
      tabPanel('Download',
               uiOutput(
                 outputId = 'provinces'
               ),
               dataTableOutput('table'),
                 tags$h4('Visualize how crime has changed over time'),
                 tags$p('select time periods to visualize'),
                 wellPanel(
                   uiOutput('periods_selector'),
                   plotOutput('plotviz')
                 ),
               wellPanel(
                 tags$h3('Options'),
                 tags$p('Select a province and click download to download data for selected province'),
                 tags$hr(),
                 downloadButton(
                   outputId = 'download_button',
                   label = 'Download data'
                 )
               )
               )
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
  
  #method to control downloading
  output$download_button <- downloadHandler(
    filename = 'downloaded_data.csv',
    content = function(file_loc){
      data = load_data()
      selected_data = data%>%filter(Province==input$province_selected)
      write.csv(selected_data, file_loc)
    },
    contentType = 'text/csv'
  )
  
  #method to display provinces to user
  output$provinces <- renderUI({
    selectInput(
      inputId = 'province_selected',
      label = 'Select a province',
      choices = load_data()%>%select(Province)
    )
  })
  
  #
  output$periods_selector <- renderUI({
    selectInput(
      inputId = 'periods_selected',
      label = '',
      choices = colnames(load_data()[4:14]),
      multiple = TRUE
    )
  })
  
  output$table <- renderDataTable({
    selected_data = data%>%filter(Province==input$province_selected)
  })
  
  output$plotviz <- renderPlot({
    period1 = input$periods_selected[1]
    period2 = input$periods_selected[2]
    selected_data = data%>%filter(Province==input$province_selected)$period1
    plot(seq(1:dim(selected_data)[1]), selected_data)
  })
}

shinyApp(interface, logic)