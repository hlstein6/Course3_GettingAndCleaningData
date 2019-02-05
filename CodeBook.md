Codebook for the created Tidy data file related to UCI HAR Dataset

Context

This Codebook describes the context, transformations and fields related to creating the Tidy dataset,  avgStatsData.txt. 

The original raw set of data came from experiments carried out with a group of 30 volunteers, each of whom was wearing a Samsung Galaxy S II phone around their waists. A set of 561 measurements were taken as they performed a set of activities (LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS).

This script creates a set of averages for mean and standard deviation mesurements for each subject by activity across both testing and training runs. The remaining measurements are not included in the resulting avgStatsData.

Original / Raw dataset

The UCI HAR dataset was downloaded manually into "./data" and unzipped there manually from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This creates the following files that are used in the script:

Reference Data
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt
ID/Name pair for each type of activity being measured
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt
ID/Name pair for each type of measurement taken. They represent the columms for the 561 set of measurements taken for each observation

Testing
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt
The ID of the subject for each testing observation
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt
The set of 561 measurements for each testing observation
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt
The ID of the activity being performed for each testing observation

Training
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt
The ID of the subject for each training observation
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt
The set of 561 measurements for each training observation
./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_rain.txt
The ID of the activity being performed for each testing observation

Transformations

The testing measurements file was loaded into a dataframe and then subsetted to incude only the relevant columns for mean and standard deviation (tBodyAcc-mean-X, tBodyAcc-mean-Y, tBodyAcc-mean-Z, tbodyAcc-std-X, tBodyAcc-std-Y, tBodyAcc-std-Z). The subjects and activities for each testing observation were each read into dataframes. The three data frames were then combined into one, subsetTest. A column was added to subsetTest, observationType, and was set to "Test".

The training measurements file was loaded into a dataframe and then subsetted to incude only the relevant columns for mean and standard deviation (tBodyAcc-mean-X, tBodyAcc-mean-Y, tBodyAcc-mean-Z, tbodyAcc-std-X, tBodyAcc-std-Y, tBodyAcc-std-Z). The subjects and activities for each training observation were each read into dataframes. The three data frames were then combined into one, subsetTrain. A column was added to subsetTest, observationType, and was set to "Train".

The subsetTest and subsetTrain dataframes were then combined into one, statsData. 

The measurements column names in statsData were transformed as follows:
"tBody" was changed to "body"
"Acc" was changed to "-_acceleration"
"std" was changed to "standard_deviation"
The parentheses were removed
"-" was changed to "_"
The name was lowercased

In statsData the activity ID for each observation was changed to its associated activity name.

The measurements data in statsData for each observation were changed from character to numeric.

A dataframe was created, avgStatsData was the statsData grouped by subject and activity and the average calculated each grouping by measurement.

The resulting dataframe was written to "./data/avgStatsData.txt"

Data Fields in avgStatsData

subject - the ID of the subject performing the activity
activity - the Name of the activity that the
body_acceleration_mean_x_average
body_acceleration_mean_y_average
body_acceleration_mean_z_average
body_acceleration_standard_deviation_x_average
body_acceleration_standard_deviation_y_average
body_acceleration_standard_deviation_z_average






