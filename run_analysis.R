####################################################################
# Body Acceleration test and train averages
#
# This script reads a subset of the measurements for a case study of
# wearable device data, make it tidy and then create a set of averages of
# the mean and standard deviation information.
#
# There was identification of the subjects in the data sets, so I did the averages by Test and Train
#
# Note: before reading in the data I manually removed a leading space at the beginning
#       of the datasets
####################################################################

library(dplyr)
library(tidyr)

# the zip file of the data was manually downloaded and unzipped locally

test <- read_delim ("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", delim=" ", col_names = FALSE)
train <- read_delim ("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", delim=" ", col_names = FALSE)

# extract the first 6 elements of each 561 element row
#   The first 3 columns are the Mean data in the X, Y and Z directions
#   The second 3 columns are the Standard Deviation data in the X, Y and Z directions
subsetTest <- test[ ,1:6]
subsetTrain <- train[ ,1:6]

# rename columns
#names(subsetTest)[1:6] <- c("bodyAccelMean_X", "bodyAccelMean_Y", "bodyAccelMean_Z", "bodyAccelStdDev_X", "bodyAccelStdDev_Y", "bodyAccelStdDev_Z")
#names(subsetTrain)[1:6] <- c("bodyAccelMean_X", "bodyAccelMean_Y", "bodyAccelMean_Z", "bodyAccelStdDev_X", "bodyAccelStdDev_Y", "bodyAccelStdDev_Z")

# add column to specify whether the data set is Test or Train
subsetTest <- mutate(subsetTest, observationType="Test")
subsetTrain <- mutate(subsetTrain, observationType="Train")

# read in subject data
testSubject <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
trainSubject <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))

# read in activity data
testActivity <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = c("activity"))
trainActivity <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = c("activity"))

# combine columns together
subsetTest <- cbind(subsetTest, testSubject, testActivity)
subsetTrain <- cbind(subsetTrain, trainSubject, trainActivity)

# combine data frames, this is the Tidy data set of the combined Test and Train data sets
statsData <- tbl_df(rbind(subsetTest, subsetTrain, stringsAsFactors = FALSE))

 # measurement names
measurements <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", col.names = c("id", "name"))
# subset and make more understandable names
subsetMeasurements <- measurements[1:6, ]
subsetMeasurementsNames <- c(as.vector(subsetMeasurements[,"name"]))
subsetMeasurementsNames <- gsub("tBody", "body", subsetMeasurementsNames)
subsetMeasurementsNames <- gsub("Acc", "_acceleration", subsetMeasurementsNames)          
subsetMeasurementsNames <- gsub("std", "standard_deviation", subsetMeasurementsNames)
subsetMeasurementsNames <- gsub("\\(\\)", "", subsetMeasurementsNames)
subsetMeasurementsNames <- gsub("-", "_", subsetMeasurementsNames)
subsetMeasurementsNames <- tolower(subsetMeasurementsNames)

names(statsData) <- c(as.vector(subsetMeasurementsNames),"observationType", "subject", "activity")

# activity descriptions
activities <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names=c("id", "name"))
for (i in 1:nrow(activities)) {
  statsData$activity[statsData$activity == activities[i, "id"]] <- as.character(activities[i, "name"])
}

for (i in 1:6){
  statsData[ ,i] <- as.numeric(as.character(unlist(statsData[ ,i])))
}

avgStatsData <- tbl_df(statsData) %>%
  select(-observationType) %>%
  group_by(subject, activity) %>%
  dplyr::summarize_all(funs(average = mean)) 

# Save the data into a file
write.table(avgStatsData, file="./data/avgStatsData.txt", row.name=FALSE)
