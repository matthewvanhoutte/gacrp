#Shiny App
#Last Modified: 11/10/18

#Required Libraries
library(data.table)
library(shiny)
library(ggplot2)

# Any data prep required for shiny application ----
setwd("C://Users//user1//Documents//Kaggle")
tr_name <- "tr.csv"
te_name <- "te.csv"
tr_total <- fread(file = tr_name, data.table = FALSE, stringsAsFactors = FALSE)
te_total <- fread(file = te_name, data.table = FALSE, stringsAsFactors = FALSE)

# Subsetting the data - Only required if dataset is large
# If running Task 4 to do the data prep then there should
# only be 22 features, subsetting is not required
index <- sample(1:nrow(tr), 10000, replace = FALSE)
tr <- tr_total[index,]
te <- te_total[index,]

# Converting the date columns into date format - best
# use Task 4 code which does the data cleansing
tr$date <- as.Date(as.character(tr$date), "%Y%m%d")
te$date <- as.Date(as.character(te$date), "%Y%m%d")

#Define variables required in the UI ----
hist_names <- lapply(tr, class)
hist_names <- hist_names[hist_names == "integer"
                         | hist_names == "factor"
                         | hist_names == "numeric"]
hist_graph <- hist_names
hist_names <- unlist(names(hist_names))


# Define UI for app ----
ui <- fluidPage(
  
  # Title panel for shiny
  titlePanel("Data Exploration"),
  tabsetPanel(
    
    # App layout for Data tables ----
    tabPanel("Data",
      tabsetPanel(
        tabPanel("Train Data", dataTableOutput("tr")),
        tabPanel("Test Data", dataTableOutput("te"))
      )
    ),
    
    # App layout for graphs ----
    tabPanel("Graphs",
      tabsetPanel(
        
        # Histograms ----
        tabPanel(
          "Histograms",
          sidebarLayout(
            sidebarPanel(
              selectInput("hist_var", 
                          "Histogram Variable:",
                          hist_names),
              sliderInput("bin_num",
                          "Bin Number",
                          min = 1,
                          max = 200,
                          value = 30)
            ),
            mainPanel(
              plotOutput("hist"))
          )

        ),
        tabPanel("Scatter", plotOutput("scat"))
      )
    )
  )
)


# Server Function ----
server <- function(input, output, session){
  
  #Produce Tables of data ----
  output$tr <- renderDataTable(tr)
  
  #Produce Graphs of data ----
  output$hist <- renderPlot({
    if (hist_graph[[input$hist_var]] == "factor"){
      ggplot(tr) + geom_histogram(aes_string(input$hist_var), bins = input$bin_num, stat = "count")
    } else {
      ggplot(tr) + geom_histogram(aes_string(input$hist_var), bins = input$bin_num)
    }
  })
  
}

# Run the shiny app ----
shinyApp(ui = ui, server = server)
  