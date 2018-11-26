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
                         browserVersion = unique(browserVersion)[1],
                         operatingSystem = unique(operatingSystem)[1],
                         deviceCategory = unique(deviceCategory)[1],
                         continent = unique(continent)[1],
                         subContinent = unique(subContinent)[1],
                         networkDomain = unique(networkDomain)[1],
                         campaign = unique(campaign)[1],
                         medium = unique(medium)[1],
                         isTrueDirect = unique(isTrueDirect)[1],
                         campaignCode = unique(campaignCode)[1],
                         adwordsClickInfo.page = unique(adwordsClickInfo.page)[1],
                         adwordsClickInfo.slot = unique(adwordsClickInfo.slot)[1],
                         adwordsClickInfo.adNetworkType = unique(adwordsClickInfo.adNetworkType)[1],
                         adwordsClickInfo.isVideoAd = unique(adwordsClickInfo.isVideoAd)[1],
                         visits = max(visits),
                         hits = sum(hits) - 1,
                         pageviews = sum(pageviews) - 1,
                         bounces = max(bounces),
                         newVisits = max(newVisits),
                         transactionRevenue = sum(transactionRevenue),
                         day = min(day),
                         month = min(month),
                         year = min(year),
                         fullVisitId = unique(fullVisitId)[1],
                         visitTimeBin12 = max(visitTimeBin12))
test <- as.data.frame(test)
# Remove from training set ----
id_remove <- unique(duplicated_rows$sessionId)
id_remove <- tr$sessionId %in% id_remove
tr <- tr[!id_remove,]
# Add into summary into to training set ----
tr <- rbind(tr,test)
