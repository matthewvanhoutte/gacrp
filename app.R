#Shiny App
#Last Modified: 11/10/18

#Required Libraries
library(data.table)
library(shiny)

#Any data prep required for shiny application
tr_name <- "D:/Users/matthew.vanhoutte2/Documents/Kaggle Comp/tr.csv"
te_name <- "D:/Users/matthew.vanhoutte2/Documents/Kaggle Comp/te.csv"
tr <- fread(file = tr_name, data.table = FALSE, stringsAsFactors = FALSE)
te <- fread(file = te_name, data.table = FALSE, stringsAsFactors = FALSE)


#Generation of user interface
ui <- fluidPage(
  titlePanel("Data Exploration"),
  mainPanel(
    tabsetPanel(
      tabPanel("Data",
        dataTableOutput("data")
      )
    )
  )
)


#Server Function
server <- function(input, output, session){
  output$data <- renderDataTable(head(tr))
}

#Run the shiny app
shinyApp(ui = ui, server = server)
  