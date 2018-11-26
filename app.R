#Shiny App
#Last Modified: 11/10/18

#Required Libraries
library(data.table)
library(shiny)
library(shinyjs)
library(ggplot2)

# Any data prep required for shiny application ----
# setwd("C://Users//user1//Documents//Kaggle")
# tr_name <- "tr.csv"
# te_name <- "te.csv"
# tr_total <- fread(file = tr_name, data.table = FALSE, stringsAsFactors = FALSE)
# te_total <- fread(file = te_name, data.table = FALSE, stringsAsFactors = FALSE)

# Subsetting the data - Only required if dataset is large
# If running Task 4 to do the data prep then there should
# only be 22 features, subsetting is not required
# index <- sample(1:nrow(tr), 10000, replace = FALSE)
# tr <- tr_total[index,]
# te <- te_total[index,]

# Converting the date columns into date format - best
# use Task 4 code which does the data cleansing
# tr$date <- as.Date(as.character(tr$date), "%Y%m%d")
# te$date <- as.Date(as.character(te$date), "%Y%m%d")
# 
tr$visitTimeBin12 <- as.factor(tr$visitTimeBin12)

# Adding a True False filter enabling the choice between
# TransactionRevenue split and no split
tr$hasTransaction <- tr$transactionRevenue>0

#Define variables required in the UI ----
hist_names <- lapply(tr, class)
hist_names <- hist_names[hist_names[1] == "integer"
                         | hist_names[1] == "factor"
                         | hist_names[1] == "ordered"
                         | hist_names[1] == "numeric"]
hist_graph <- hist_names
hist_names <- unlist(names(hist_names))
filter_label <- c("Both", "No Transaction", "Transaction")

scat_names <- lapply(tr, class)
scat_names <- scat_names[scat_names == "integer"
                         | scat_names == "factor"
                         | scat_names == "numeric"]
scat_graph <- scat_names
scat_names <- unlist(names(scat_names))

# Define UI for app ----
ui <- fluidPage(# Title panel for shiny
  useShinyjs(),
  
  titlePanel("Data Exploration"),
  tabsetPanel(
    # App layout for Data tables ----
    tabPanel("Data",
             tabsetPanel(
               tabPanel("Train Data", dataTableOutput("tr")),
               tabPanel("Test Data", dataTableOutput("te"))
             )),
    
    # App layout for graphs ----
    tabPanel("Graphs",
             tabsetPanel(
               
               # Histograms ----
               tabPanel("Histograms",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("hist_var",
                                        "Histogram Variable:",
                                        hist_names),
                            sliderInput(
                              "bin_num",
                              "Bin Number",
                              min = 1,
                              max = 200,
                              value = 30
                            ),
                            radioButtons("filter_hist",
                                         "Filter by transactionRevenue",
                                         choices = filter_label)
                            # downloadButton("save_hist",
                            #                "Save Histogram")
                          ),
                          mainPanel(plotOutput("hist"))
                        )),
               
               # Density ----
               tabPanel("Density",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("dens_var",
                                        "Density Variable:",
                                        hist_names),
                            sliderInput(
                              "bin_num",
                              "Bin Number",
                              min = 1,
                              max = 200,
                              value = 30
                            ),
                            radioButtons("filter_dens",
                                         "Filter by transactionRevenue",
                                         choices = filter_label),
                            checkboxInput("dens_col",
                                          "Colour Plot?",
                                          value = FALSE)
                          ),
                          mainPanel(plotOutput("dens"))
                        )),
               
               
               # Scatter ----
               tabPanel("Scatter",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("var_x",
                                        "Variable X Axis",
                                        scat_names),
                            selectInput("var_y",
                                        "Variable Y Axis",
                                        scat_names),
                            checkboxInput("colour",
                                          "Colour Graph?",
                                          FALSE),
                            hidden(
                              selectInput("scat_col",
                                          "Colour Transaction points",
                                          scat_names)),
                            radioButtons("filter",
                                         "Filter by transactionRevenue",
                                         choices = filter_label)
                          ),
                          mainPanel(plotOutput("scat"))
                        ))
             ))))

# Server Function ----
server <- function(input, output, session){
  
  observe({
    if (input$colour) {
      show("scat_col")
    } else {
      hide("scat_col")
    }
  })

  #Produce Tables of data ----
  output$tr <- renderDataTable(tr)
  
# Produce Graphs of data
  # Producing Histogram graphs ----
  output$hist <- renderPlot({
    if (hist_graph[[input$hist_var]] == "factor"){
      if (input$filter_hist == "Both") {
        ggplot(tr) + geom_histogram(aes_string(input$hist_var), stat = "count")
      } else if (input$filter_hist == "No Transaction") {
        ggplot(tr[!tr$hasTransaction,]) + geom_histogram(aes_string(input$hist_var), stat = "count")
      } else if (input$filter_hist == "Transaction") {
        ggplot(tr[tr$hasTransaction,]) + geom_histogram(aes_string(input$hist_var), stat = "count")
      }
    } else {
      if (input$filter_hist == "Both") {
        ggplot(tr) + geom_histogram(aes_string(input$hist_var), bins = input$bin_num)
      } else if (input$filter_hist == "No Transaction") {
        ggplot(tr[!tr$hasTransaction,]) + geom_histogram(aes_string(input$hist_var), bins = input$bin_num)
      } else if (input$filter_hist == "Transaction") {
        ggplot(tr[tr$hasTransaction,]) + geom_histogram(aes_string(input$hist_var), bins = input$bin_num)
      }
      
    }
  })
  
  # Producing Density graphs ----
  output$dens <- renderPlot({
    if (hist_graph[[input$dens_var]] == "factor" | hist_graph[[input$dens_var]] == "ordered"){
      if (input$filter_dens == "Both") {
        if (input$dens_col) {
          ggplot() + 
            geom_histogram(aes(tr[tr$hasTransaction==1,input$dens_var], 
                               y = ..count../sum(..count..)), 
                           stat = "count", 
                           fill = "red",
                           color = "red",
                           alpha = 0.2) +
            geom_histogram(aes(tr[tr$hasTransaction==0,input$dens_var], 
                               y = ..count../sum(..count..)), 
                           stat = "count", 
                           fill = "blue",
                           color = "blue", 
                           alpha = 0.2) + 
            ggtitle(paste(input$dens_var,":", "Transactions = Red, No Transactions = Blue"))
        } else {
          ggplot(tr) + 
            geom_histogram(aes_string(input$dens_var), 
                           stat = "count") +
            ggtitle(input$dens_var)
        }
      } else if (input$filter_dens == "No Transaction") {
        ggplot(tr[!tr$hasTransaction,]) + 
          geom_histogram(aes_string(input$dens_var), 
                         stat = "count") +
          ggtitle(input$dens_var)
      } else if (input$filter_dens == "Transaction") {
        ggplot(tr[tr$hasTransaction,]) + 
          geom_histogram(aes_string(input$dens_var), 
                         stat = "count") +
          ggtitle(input$dens_var)
      }
    } else {
      if (input$filter_dens == "Both") {
        if (input$dens_col) {
          ggplot() + 
            geom_histogram(aes(tr[tr$hasTransaction==1,input$dens_var], 
                               y = ..count../sum(..count..)),
                           fill = "red",
                           color = "red",
                           alpha = 0.2) +
            geom_histogram(aes(tr[tr$hasTransaction==0,input$dens_var], 
                               y = ..count../sum(..count..)), 
                           fill = "blue",
                           color = "blue", 
                           alpha = 0.2) + 
            ggtitle(paste(input$dens_var,":", "Transactions = Red, No Transactions = Blue"))
        } else {
          ggplot(tr) + 
            geom_histogram(aes_string(input$dens_var), 
                           stat = "count") +
            ggtitle(input$dens_var)
        }
      } else if (input$filter_dens == "No Transaction") {
        ggplot(tr[!tr$hasTransaction,]) + 
          geom_histogram(aes_string(input$dens_var), 
                         bins = input$bin_num) +
          ggtitle(input$dens_var)
      } else if (input$filter_dens == "Transaction") {
        ggplot(tr[tr$hasTransaction,]) + 
          geom_histogram(aes_string(input$dens_var), 
                         bins = input$bin_num) +
          ggtitle(input$dens_var)
      }
      
    }
  })
  
  # Producing Scatter plots ----
  output$scat <- renderPlot({
    if (input$colour) {
      if (input$filter == "Both") {
        ggplot(tr) + geom_point(aes_string(input$var_x, input$var_y, color = input$scat_col))
      } else if (input$filter == "No Transaction") {
        ggplot(tr[!tr$hasTransaction,]) + geom_point(aes_string(input$var_x, input$var_y), color = input$scat_col)
      } else if (input$filter == "Transaction") {
        ggplot(tr[tr$hasTransaction,]) + geom_point(aes_string(input$var_x, input$var_y), color = input$scat_col)
      }
    } else {
      if (input$filter == "Both") {
        ggplot(tr) + geom_point(aes_string(input$var_x, input$var_y))
      } else if (input$filter == "No Transaction") {
        ggplot(tr[!tr$hasTransaction,]) + geom_point(aes_string(input$var_x, input$var_y))
      } else if (input$filter == "Transaction") {
        ggplot(tr[tr$hasTransaction,]) + geom_point(aes_string(input$var_x, input$var_y))
      }
    }
  })
  
  
  # Saving files ----
  output$save_hist <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".png", sep = "")
    },
    content = function(file) {
      ggsave(filename, plot = output$hist, device = device)
    }
  )
  
}

# Run the shiny app ----
shinyApp(ui = ui, server = server)

