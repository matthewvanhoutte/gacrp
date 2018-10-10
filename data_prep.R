#Preprocessing of data
#Last Modified: 10/10/18

library(data.table)
library(jsonlite)

#Setting working directory to where the Github folder is located
setwd("~/Documents/Github/garcp")

#Import the data
train <- fread(file = "~/Documents/Kaggle Comp/train.csv", data.table = FALSE, stringsAsFactors = FALSE)
test <- fread(file = "~/Documents/Kaggle Comp/test.csv", data.table = FALSE, stringsAsFactors = FALSE)

