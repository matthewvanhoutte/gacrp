#Preprocessing of data
#Last Modified: 11/10/18

#Required Libraries
library(readr)
library(jsonlite)
library(tidyverse)


# Initialise --------------------------------------------------------------

#Setting working directory to where the Github folder is located
#setwd("~/Documents/Github/garcp")
setwd("C://Users//user1//Documents//Kaggle")

#Import the data
#tr_name <- "~/Documents/Kaggle Comp/split/splitaa.csv"
#te_name <- "~/Documents/Kaggle Comp/test.csv"
tr_name <- "train.csv"
te_name <- "test.csv"
tr <- read_csv(tr_name)
te <- read_csv(te_name)

# Functions ---------------------------------------------------------------

# Remove [] from the data before JSON to String conversion
# Do this prior to parsing
tr$customDimensions <- substr(tr$customDimensions,2,nchar(tr$customDimensions)-1)
tr$hits <- substr(tr$hits,2,nchar(tr$hits)-1)



#Conversion from JSON to String
flatten_json <- . %>%
  str_c(., collapse = ",") %>% 
  str_c("[", ., "]") %>%
  fromJSON(flatten = T)

# Conversion from JSON to String but for customDimensions
flatten_json_2 <- . %>%
  substr(., 2, nchar(.)-1) %>%
  gsub("\'",'\"',.) %>%
  str_c(., collapse = ",") %>%
  str_c("[",.,"]") %>%
  fromJSON(flatten = T)

# Conversion from JSON to String for hits
flatten_json_3 <- . %>%
  # gsub("(\\[\\{)", "{",.) %>%
  # substr(., 2, nchar(.)-1) %>%
  gsub("\'\'", "",.)
# gsub("(?<!')'(?!')",'\"',., perl = T) %>%
# gsub("True",'"TRUE"',.) %>%
# gsub("False", '"FALSE"',.) %>%
# # str_c(., collapse = ",") %>%
# # str_c("[",.,"]") %>%
# jsonlite::fromJSON()

parse <- . %>% 
  bind_cols(flatten_json(.$device)) %>%
  bind_cols(flatten_json_2(.$customDimensions)) %>%
  bind_cols(flatten_json(.$geoNetwork)) %>%
  bind_cols(flatten_json_3(.$hits)) %>%
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



