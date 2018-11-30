#Preprocessing of data
#Last Modified: 11/10/18

#Required Libraries
library(readr)
library(jsonlite)
library(tidyverse)
library(data.table)


# Initialise --------------------------------------------------------------

#Setting working directory to where the Github folder is located
#setwd("~/Documents/Github/garcp")
setwd("C://Users//user1//Documents//Kaggle")

#Import the data
tr_name <- "test_v2-1.csv"
tr <- read_csv(paste("~/Downloads/data/",tr_name, sep = ""))
tr$hits <- NULL

# Functions ---------------------------------------------------------------

#Conversion from JSON to String
flatten_json <- . %>%
  str_c(., collapse = ",") %>% 
  str_c("[", ., "]") %>%
  jsonlite::fromJSON(flatten = T)

# Conversion from JSON to String but for customDimensions
flatten_json_2 <- . %>%
  # substr(., 2, nchar(.)-1) %>%
  gsub("\'",'\"',.) %>%
  gsub("\\[\\{","{",.) %>%
  gsub("\\}\\]", "}",.) %>%
  gsub("\\[\\]", "{\"index\": null, \"value\": null}",.) %>%
  str_c(., collapse = ",") %>%
  str_c("[",.,"]") %>%
  jsonlite::fromJSON()

# Conversion from JSON to String trafficsource
flatten_json_3 <- . %>%
  str_c(., collapse = ",") %>% 
  str_c("[", ., "]")
  # jsonlite::fromJSON(flatten = T)

# Parsing the data
parse <- . %>% 
  bind_cols(flatten_json(.$device)) %>%
  bind_cols(flatten_json_2(.$customDimensions)) %>%
  bind_cols(flatten_json(.$geoNetwork)) %>%
  bind_cols(flatten_json(.$trafficSource)) %>%
  bind_cols(flatten_json(.$totals)) %>%
  select(-device, - customDimensions, -geoNetwork, -trafficSource, -totals)


is_na_val <- function(x) x %in% c("not available in demo dataset", "(not set)", 
                                  "unknown.unknown", "(not provided)")

has_many_values <- function(x) n_distinct(x) > 1

# Run Time ----------------------------------------------------------------

tr$geoNetwork[is.na(tr$geoNetwork)] <- "null"
tr$trafficSource[is.na(tr$trafficSource)] <- "null"
tr$totals[is.na(tr$totals)] <- "null"


#Parsing data
tr <- parse(tr)
tr <- as.data.frame(tr)
tr2 <- tr
fwrite(tr, file = paste("~/Documents/Kaggle Comp/processed/",tr_name, sep = ""))


