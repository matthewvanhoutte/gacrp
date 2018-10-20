# Data Invesitgation
# Last Modified: 12/10/18

# Checking the unique values ----
duplicats <- te[duplicated(te$fullVisitorId),]

x <- data.frame(table(tr$fullVisitorId))
x <- x[x$Freq > 1,]
duplicats <- te[te$fullVisitorId %in% x$Var1,]

x <- unique(tr$fullVisitorId)
test

# Creating table of unique values ----
# Functions
uniqueTable <- function (data){
  data <- data.frame(
    table(data)
    )
}

outputFile <- function(x, fileName){
  write.table(
    data.frame(x)
    ,file = fileName
    ,append = TRUE
    ,sep = ","
    ,row.names = FALSE
    )
}


# Finding Unique values
uniqueTr <- lapply(tr, uniqueTable)
uniqueTe <- lapply(te, uniqueTable)

# Saving Unique Values to csv
lapply(uniqueTr, function(x) write.table(data.frame(x), "~/Documents/Kaggle Comp/uniqueTr.csv", append = T, sep = ","))

# Other
duplicated_rows <- tr[duplicated(tr$sessionId),]
duplicated_rows <- tr[tr$sessionId %in% duplicated_rows$sessionId,]
