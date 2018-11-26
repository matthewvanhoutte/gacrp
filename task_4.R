# Task 4 - Column Processing
# Last Modified: 24/10/18
# Required libraries:
library(data.table)


# Importing the required file ----
setwd("C://Users//user1//Documents//Kaggle")
tr_name <- "tr.csv"
#tr_name <- "~/OneDrive/Kaggle Comp/tr.csv"
tr <- fread(file = tr_name, stringsAsFactors = FALSE, data.table =  FALSE, na.strings = "")
print(colnames(tr))

# functions ----
replace <- function(x, col_list, str_replace){
  if (x %in% col_list){
    return(x)
  } else {
    return(str_replace)
  }
}

binning <- function(data, num_bin){
  bin <- 1440/num_bin
  hrs <- hour(data)
  mins <- minute(data)
  total_min <- hrs * 60 + mins
  output <- ceiling(total_min/bin)
  output <- ifelse(output==0, 1, output)
  return (output)
}

# Processing "channelGrouping" ----
tr$channelGrouping <- as.factor(tr$channelGrouping)

# Processing "date" ----
# Days
tr$day <- as.integer(substr(tr$date,7,8))
tr$day <- cut(x = tr$day, breaks = c(1,10,20,31), labels = (1:3))
tr$day <- unclass(tr$day)
# Months
tr$month <- as.integer(substr(tr$date,5,6))
# Years
tr$year <- as.integer(substr(tr$date,1,4))

# Processing "fullVisitorId" and "visitId" ----
# This column is to be obtained from the sessionId as it has not been stored correctly in the csv
tr$sessionId <- as.character(tr$sessionId)
tr$fullVisitorId <- sapply(tr$sessionId, function(x) toString(unlist(strsplit(x, "_"))[1]))
tr$fullVisitId <- sapply(tr$sessionId, function(x) toString(unlist(strsplit(x, "_"))[2]))
#tr$sessionId <- NULL

# Processing socialEngagementType ----
tr$socialEngagementType <- as.factor(tr$socialEngagementType)

# Processing visitNnumber ----
tr$visitNumber <- as.integer(tr$visitNumber)

# Processing visitStartTime ----
tr$visitStartTime <- as.POSIXct(tr$visitStartTime, origin = "1970-01-01", tz = "America/Los_Angeles")
tr$visitTimeBin12 <- binning(tr$visitStartTime, 12)
tr$visitTimeBin12 <- factor(tr$visitTimeBin12, ordered = TRUE)

# Processing browser ----
#x <- data.frame(table(tr$browser))
#x <- x[order(x$Freq),]
col_list <- c("Chrome", "Safari", "Firefox", "Internet Explorer")
tr$browser <- sapply(tr$browser, replace, col_list = col_list, str_replace = "other")
tr$browser <- as.factor(tr$browser)

# Processing browserVersion ----
tr$browserVersion <- as.factor(tr$browserVersion)

# Processing browserSize ----
tr$browserSize <- as.factor(tr$browserSize)

# Processing operatingSystem ----
#x <- data.frame(table(tr$operatingSystem))
#x <- x[order(x$Freq),]
col_list <- c("Windows", "Macintosh", "Android", "iOS", "Linux")
tr$operatingSystem <- sapply(tr$operatingSystem, replace, col_list = col_list, str_replace = "other")
tr$operatingSystem <- as.factor(tr$operatingSystem)

# Processing operatingSystemVersion ----
tr$operatingSystemVersion <- as.factor(tr$operatingSystemVersion)

# Processing isMobile ----
tr$isMobile <- as.integer(1*tr$isMobile)

# Processing mobileDeviceBranding ----
tr$mobileDeviceBranding <- as.factor(tr$mobileDeviceBranding)

# Processing mobileDeviceModel ----
tr$mobileDeviceModel <- as.factor(tr$mobileDeviceModel)

# Processing mobileInputSelector ----
tr$mobileInputSelector <- as.factor(tr$mobileInputSelector)

# Processing mobileDeviceInfo ----
tr$mobileDeviceInfo <- as.factor(tr$mobileDeviceInfo)

# Processing mobileDeviceMarketingName ----
tr$mobileDeviceMarketingName <- as.factor(tr$mobileDeviceMarketingName)

# Processing flashVersion ----
tr$flashVersion <- as.factor(tr$flashVersion)

# Processing language ----
tr$language <- as.factor(tr$language)

# Processing screen colors ----
tr$screenColors <- as.factor(tr$screenColors)

# Processing screen resolution ----
tr$screenResolution <- as.factor(tr$screenResolution)

# Processing deviceCategory ----
tr$deviceCategory <- as.factor(tr$deviceCategory)

# Processing continent and subContinent combining the two ----
# put carribean into central america and central asia into western asia
#x <- data.frame(table(tr$subContinent))
#x <- x[order(x$Freq),]
#tr$subContinent <- as.factor(tr$subContinent)
tr[tr$subContinent=="Caribbean",]$subContinent <- "Central America"
tr[tr$subContinent=="Central Asia",]$subContinent <- "Western Asia"
sub_list <- c("Western Asia", "Southeast Asia", "Southern Asia", "Eastern Asia",
              "Eastern Europe", "Northern Europe", "Southern Europe", "Western Europe",
              "Central America", "Northern America", "South America")
continent_replace <- function(x, sub_list){
  if(x[2] %in% sub_list){
    return(x[2])
  } else {
    return(x[1])
  }
}
tr$subContinent <- apply(tr[,c("continent", "subContinent")],1,continent_replace, sub_list = sub_list)
tr$subContinent <- as.factor(tr$subContinent)

# Processing country ----
#x <- data.frame(table(tr$country))
#x <- x[order(x$Freq),]
tr$country <- as.factor(tr$country)

# Processing region ----
#x <- data.frame(table(tr$region))
#x <- x[order(x$Freq),]
tr$region <- as.factor(tr$region)

# Processing metro ----
#x <- data.frame(table(tr$metro))
#x <- x[order(x$Freq),]
tr$metro <- as.factor(tr$metro)

# Processing city ----
#x <- data.frame(table(tr$city))
#x <- x[order(x$Freq),]
tr$city <- as.factor(tr$city)

# Processing cityId ----
tr$cityId <- as.factor(tr$cityId)

# Processing latitude ----
tr$latitude <- as.integer(tr$latitude)

# Processing longitude ----
tr$longitude <- as.integer(tr$longitude)

# Processing networkLocation ----
tr$networkLocation <- as.factor(tr$networkLocation)

# Processing campaign ----
tr$campaign <- as.factor(tr$campaign)

# Processing source ----
tr$source <- as.factor(tr$source)

# Processing medium ----
#x <- data.frame(table(tr$medium))
#x <- x[order(x$Freq),]
tr[tr$medium=="(not set)",]$medium <- "organic"
tr$medium <- as.factor(tr$medium)

# Processing keyword ----
#x <- data.frame(table(tr$medium))
#x <- x[order(x$Freq),]
tr$keyword <- as.factor(tr$keyword)

# Processing isTrueDirect ----
tr$isTrueDirect <- as.integer(1*!is.na(tr$isTrueDirect))

# Processing referralPath ----
tr$referralPath <- as.factor(tr$referralPath)

# Processing adContent ----
tr$adContent <- as.factor(tr$adContent)

# Processing campaignCode ----
tr$campaignCode <- as.factor(tr$campaignCode)

# Processing adwordsClickInfo.criteriaParameters ----
tr$adwordsClickInfo.criteriaParameters <- as.factor(tr$adwordsClickInfo.criteriaParameters)

# Processing adwordsClickInfo.page ----
tr$adwordsClickInfo.page <- as.factor(tr$adwordsClickInfo.page)

# Processing adwordsClickInfo.slot ----
tr$adwordsClickInfo.slot <- as.factor(tr$adwordsClickInfo.slot)

# Processing adwordsClickInfo.gclId ----
tr$adwordsClickInfo.gclId <- as.factor(tr$adwordsClickInfo.gclId)

# Processing adwordsClickInfo.adNetworkType ----
tr$adwordsClickInfo.adNetworkType <- as.factor(tr$adwordsClickInfo.adNetworkType)

# Processing adwordsClickInfo.isVideoAd ----
tr$adwordsClickInfo.isVideoAd <- as.factor(tr$adwordsClickInfo.isVideoAd)

# Processing visits ----
tr$visits <- as.integer(tr$visits)

# Processing hits ----
tr$hits <- as.integer(tr$hits)

# Processing pageviews ----
tr$pageviews <- as.integer(tr$pageviews)

# Processing bounces
tr$bounces <- as.integer(tr$bounces)

# Processing newvisits
tr$newVisits <- as.integer(tr$newVisits)

# Processing transactionRevenue - Only required in Training Data set ----
tr$transactionRevenue <- as.double(tr$transactionRevenue)
tr$transactionRevenue <- ifelse(is.na(tr$transactionRevenue),0,tr$transactionRevenue)

# Columns to be removed ----
#tr$browserVersion <- NULL
tr$browserSize <- NULL
tr$socialEngagementType <- NULL
tr$operatingSystemVersion <- NULL
tr$isMobile <- NULL
tr$mobileDeviceBranding <- NULL
tr$mobileDeviceModel <- NULL
tr$mobileInputSelector <- NULL
tr$mobileDeviceInfo <- NULL
tr$mobileDeviceMarketingName <- NULL
tr$flashVersion <- NULL
tr$language <- NULL
tr$screenColors <- NULL
tr$screenResolution <- NULL
#tr$continent <- NULL
tr$country <- NULL
tr$region <- NULL
tr$metro <- NULL
tr$city <- NULL
tr$cityId <- NULL
tr$latitude <- NULL
tr$longitude <- NULL
tr$networkLocation <- NULL
#tr$campaign <- NULL
tr$source <- NULL
tr$keyword <- NULL
tr$referralPath <- NULL
tr$adContent <- NULL
#tr$campaignCode <- NULL
tr$adwordsClickInfo.criteriaParameters <- NULL
#tr$adwordsClickInfo.page <- NULL
#tr$adwordsClickInfo.slot <- NULL
tr$adwordsClickInfo.gclId <- NULL
#tr$adwordsClickInfo.adNetworkType <- NULL
#tr$adwordsClickInfo.isVideoAd <- NULL
#tr$visits <- NULL
#tr$bounces <- NULL
#tr$newVisits <- NULL
