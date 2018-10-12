# Data Invesitgation
# Last Modified: 12/10/18

# Checking the unique values ----
duplicats <- te[duplicated(te$fullVisitorId),]

x <- data.frame(table(tr$fullVisitorId))
x <- x[x$Freq > 1,]
duplicats <- te[te$fullVisitorId %in% x$Var1,]

x <- unique(tr$fullVisitorId)
test