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

# read in the test and the train data sets
test <- read_delim ("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", delim=" ", col_names = FALSE)
train <- read_delim ("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", delim=" ", col_names = FALSE)

# extract the first 6 elements of each 561 element row
#   The first 3 columns are the Mean data in the X, Y and Z directions
#   The second 3 columns are the Standard Deviation data in the X, Y and Z directions
subsetTest <- test[ ,1:6]
subsetTrain <- train[ ,1:6]

# rename columns
names(subsetTest)[1:6] <- c("bodyAccelMean_X", "bodyAccelMean_Y", "bodyAccelMean_Z", "bodyAccelStdDev_X", "bodyAccelStdDev_Y", "bodyAccelStdDev_Z")
names(subsetTrain)[1:6] <- c("bodyAccelMean_X", "bodyAccelMean_Y", "bodyAccelMean_Z", "bodyAccelStdDev_X", "bodyAccelStdDev_Y", "bodyAccelStdDev_Z")

# add column to specify whether the data set is Test or Train
subsetTest <- mutate(subsetTest, observationType = "Test")
subsetTrain <- mutate(subsetTest, observationType = "Train")


# combine data frames, this is the Tidy data set of the combined Test and Train data sets
bodyAccelStats <- tbl_df(rbind(subsetTest, subsetTrain, stringsAsFactors = FALSE))


# create an overall index
idx <- 1:length(bodyAccelStats$bodyAccelMean_X)

# Create average(mean) statistics for each variable for test and train and overall
bodyAccelAvgStats <- data.frame(matrix(ncol = 7, nrow = 2))
columns <- c("observationType", "AvgMean_X", "AvgMean_Y", "AvgMean_Z", "AvgStdDev_X", "AvgStdDev_Y", "AvgStdDev_Z")
colnames(bodyAccelAvgStats) <- columns

# this is the created tidy data set for the average statistics for Test and Train
bodyAccelAvgStats <- bodyAccelStats %>% group_by(observationType) %>% 
  dplyr::summarize(AvgMean_X = mean(as.numeric(bodyAccelMean_X)), 
            AvgMean_Y = mean(as.numeric(bodyAccelMean_Y)),
            AvgMean_Z = mean(as.numeric(bodyAccelMean_Y)),
            AvgStdDev_X = mean(as.numeric(bodyAccelStdDev_X)),
            AvgStdDev_Y = mean(as.numeric(bodyAccelStdDev_Y)),
            AvgStdDev_Z = mean(as.numeric(bodyAccelStdDev_Z)))
