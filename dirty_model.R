# Dirty Model GBM
library(data.table)
library(gbm)

tr <- fread("~/Documents/Kaggle Comp/processed/splitaa.csv", stringsAsFactors = F, data.table = F, na.strings = "")
tr <- fread("~/Documents/Kaggle Comp/processed/test_v2.csv", stringsAsFactors = F, data.table = F, na.strings = "")

train <- tr
summary(tr)
model <- gbm()

library(dplyr)
# Not yet complete - suggestion is to only run this process on the duplicated data otherwise, takes far too long!
# Code to identify duplicates is below.
duplicated_rows <- tr[duplicated(tr$fullVisitorId),]
duplicated_rows <- tr[tr$fullVisitorId %in% duplicated_rows$fullVisitorId,]

# Grouping the training data ---- 
test <- duplicated_rows %>% group_by(fullVisitorId)
test <- test %>% summarise(totalTransactionRevenue = sum(totalTransactionRevenue))
test <- as.data.frame(test)
# Remove from training set ----
id_remove <- unique(duplicated_rows$fullVisitorId)
id_remove <- tr$fullVisitorId %in% id_remove
tr <- tr[!id_remove,]
# Add into summary into to training set ----
x <- data.frame(fullVisitorId = tr$fullVisitorId, totalTransactionRevenue = tr$totalTransactionRevenue)

final <- rbind(x,test)
sum(final$totalTransactionRevenue)
