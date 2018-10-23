#Preprocessing of data
#Last Modified: 11/10/18

#Required Libraries
library(data.table)
library(jsonlite)
library(tidyverse)


# Initialise --------------------------------------------------------------

#Setting working directory to where the Github folder is located
#setwd("~/Documents/Github/garcp")
setwd("C://Users//user1//Documents//Kaggle")

#Import the data
#tr_name <- "~/Documents/Kaggle Comp/train.csv"
#te_name <- "~/Documents/Kaggle Comp/test.csv"
tr_name <- "train.csv"
te_name <- "test.csv"
tr <- read.csv(tr_name)
te <- read.csv(te_name)

# Functions ---------------------------------------------------------------

#Conversion from JSON to String
flatten_json <- . %>% 
  str_c(., collapse = ",") %>% 
  str_c("[", ., "]") %>% 
  fromJSON(flatten = T)

parse <- . %>% 
  bind_cols(flatten_json(.$device)) %>%
  bind_cols(flatten_json(.$geoNetwork)) %>% 
  bind_cols(flatten_json(.$trafficSource)) %>% 
  bind_cols(flatten_json(.$totals)) %>% 
  select(-device, -geoNetwork, -trafficSource, -totals)

is_na_val <- function(x) x %in% c("not available in demo dataset", "(not set)", 
                                  "unknown.unknown", "(not provided)")

has_many_values <- function(x) n_distinct(x) > 1



# Run Time ----------------------------------------------------------------

#Parsing data
tr <- parse(tr)
te <- parse(te)

tr <- as.data.frame(tr)
te <- as.data.frame(te)


# Task 3 - Concatenate on SessionID ---------------------------------------
# Required Libraries for Task:
# library(data.table)
# library(dplyr)

tr <- tr %>% group_by(sessionId)


