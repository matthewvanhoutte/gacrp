# Task 3 - Grouping by SessionID
# Last Modified: 01/11/2018
# Required libraries:
library(data.table)
library(dplyr)

# Not yet complete - suggestion is to only run this process on the duplicated data otherwise, takes far too long!
# Code to identify duplicates is below.
duplicated_rows <- tr[duplicated(tr$sessionId),]
duplicated_rows <- tr[tr$sessionId %in% duplicated_rows$sessionId,]

# Grouping the training data ---- 
test <- duplicated_rows %>% group_by(sessionId)
test <- test %>% summarise(channelGrouping = unique(channelGrouping),
                         date = min(date),
                         fullVisitorId = unique(fullVisitorId),
                         visitId = unique(visitId),
                         visitNumber = unique(visitNumber),
                         visitStartTime = min(visitStartTime),
                         browser = unique(browser)[1],
                         operatingSystem = unique(operatingSystem)[1],
                         deviceCategory = unique(deviceCategory)[1],
                         subContinent = unique(subContinent)[1],
                         networkDomain = unique(networkDomain)[1],
                         medium = unique(medium)[1],
                         isTrueDirect = unique(isTrueDirect)[1],
                         hits = sum(hits) - 1,
                         pageviews = sum(pageviews) - 1,
                         transactionRevenue = sum(transactionRevenue),
                         day = min(day),
                         month = min(month),
                         year = min(year),
                         fullVisitId = unique(fullVisitId)[1],
                         visitTimeBin12 = max(visitTimeBin12))
