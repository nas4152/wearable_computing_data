
##check if data is already downloaded, if not download data and unzip files
if (!dir.exists("UCI HAR Dataset")) { 
        url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url1, "data.zip")
        unzip("data.zip")
}


## features.txt lists col names for observation variables
## train or test/subject_test.txt col to add with individual ids
## train or test/y_train or test.txt col to add with activity (see activity_
##labels.txt for meaning)
## inertial data: 128 variables b/c 128 readings per video

activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
## first col is number, col2 is description
variablelabels <- read.table("UCI HAR Dataset/features.txt")
## col1 is index

## see variablelabels for col names
testobs <- read.table("UCI HAR Dataset/test/x_test.txt")
trainobs <- read.table("UCI HAR Dataset/train/X_train.txt")

## use activitylabels for replacing numbers with activity names
testactivity <- read.table("UCI HAR Dataset/test/y_test.txt")
trainactivity <- read.table("UCI HAR Dataset/train/y_train.txt")

## numbers to represent individuals
testid <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainid <- read.table("UCI HAR Dataset/train/subject_train.txt")

## observation variables - combine train and test sets and label columns
combobs <- rbind(trainobs, testobs)
colnames(combobs) <- variablelabels[ ,2]
colnames(combobs) <- make.unique(colnames(combobs))



## select mean and standard of deviation for observation data
library(dplyr)
tidydata <- select(combobs, contains("mean", ignore.case = TRUE), 
                   contains("std", ignore.case = TRUE))


## merging training and test sets for subject id and activity variables
id <- rbind(trainid, testid)
activity <- rbind (trainactivity, testactivity)



## adding subject id and activity columns to beginning of data set
tidydata <- cbind(id, activity, tidydata)



## labeling added columns
colnames(tidydata) <- c("subject", "activity", colnames(tidydata[ ,3:88]))

## converting activity column to factor with descriptive levels
tidydata$activity <- as.factor(tidydata$activity)
levels(tidydata$activity) <- activitylabels[ ,2]


## creating new dataset for variable means by subject and activity

library(reshape2)

meltdata <- melt(tidydata, id.vars = 1:2)
subjmeans <- dcast(meltdata, subject ~ variable, mean)
actmeans <- dcast(meltdata, activity ~ variable, mean)


