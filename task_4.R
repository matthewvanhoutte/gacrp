# Task 4 - Column Processing
# Last Modified: 24/10/18
# Required libraries:
library(data.table)

# Importing the required file ----
tr_name <- "~/Documents/Kaggle Comp/tr.csv"
tr <- fread(file = tr_name, stringsAsFactors = FALSE, data.table =  FALSE)
print(colnames(tr))

# Processing "channelGrouping" ----
tr$channelGrouping <- as.factor(tr$channelGrouping)

# Processing "date" ----
# Days
tr$day <- as.integer(substr(tr$date,7,8))
tr$day <- cut(x = tr$day, breaks = c(1,10,20,31), labels = (1:3))
# Months
tr$month <- as.factor(substr(tr$date,5,6))
# Years
tr$year <- as.factor(substr(tr$date,1,4))

# Processing "