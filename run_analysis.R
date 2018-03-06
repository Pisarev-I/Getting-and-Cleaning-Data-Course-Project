# Downloading and unzip data
if (!file.exists("data")) {
  dir.create("data")
}
strFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(strFileURL, destfile = "./data/dataset.zip", method = "curl")
unzip(zipfile = "./data/dataset.zip", exdir = "./data")

# Read Test, Train, Activities and Variables
dfTestMeasurement <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
dfTestActivities <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
dfTestSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
dfTrainMeasurement <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
dfTrainActivities <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
dfTrainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
dfActivityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
dfVariableNames <- read.table("./data/UCI HAR Dataset/features.txt")

# Add Activities and Subject to Measurement, delete unused data frames
dfTestData <- cbind(dfTestSubject, dfTestActivities, dfTestMeasurement)
dfTrainData <- cbind(dfTrainSubject, dfTrainActivities, dfTrainMeasurement)
rm(dfTestMeasurement, dfTestActivities, dfTestSubject,
   dfTrainMeasurement, dfTrainActivities, dfTrainSubject)

#1. Merges the training and the test sets to create one data set
dfData <- rbind(dfTestData, dfTrainData)
rm(dfTestData, dfTrainData)

#4. Appropriately labels the data set with descriptive variable names
colnames(dfData) <- c("Subject", "Activity", as.vector(dfVariableNames$V2))

#2. Extracts only the measurements on the mean and standard deviation for each measurement
vNames <- names(dfData)
dfDataMeanAndSD <- dfData[, grepl("Subject|Activity|.*mean().*|.*std().*",vNames)]

#3. Uses descriptive activity names to name the activities in the data set
library(dplyr)
dfDataMeanAndSD <- merge(dfDataMeanAndSD,
                             dfActivityLabels,
                             by.x = "Activity",
                             by.y = "V1")
dfDataMeanAndSD <- mutate(dfDataMeanAndSD,Activity = V2, V2 = NULL)

#5. From the data set in step 4, creates a second,
#   independent tidy data set with the average of
#   each variable for each activity and each subject
dfTidyData <- aggregate(. ~ Activity + Subject, data = dfDataMeanAndSD, mean)
rm(dfDataMeanAndSD)
dfTidyData <- arrange(dfTidyData, Subject, Activity)

# Write the result to a file
write.table(dfTidyData, file = "tidy_data_set.txt")