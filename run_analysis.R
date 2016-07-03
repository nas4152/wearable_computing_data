
##check if data is already downloaded, if not download data and unzip files
if (!dir.exists("UCI HAR Dataset")) { 
        url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url1, "data.zip")
        unzip("data.zip")
}
## checked with and without data in wd

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

## adding subject numbers
##testobs$subject <- testid
##trainobs$subject <- trainid

##adding activity in number code
##testobs$activity <- testactivity
##trainobs$activity <- trainactivity

##colnames(testobs) <- make.unique(colnames(testobs))
##rownames(testobs) <- rownames(testobs, do.NULL = FALSE, prefix = "test")

##colnames(trainobs) <- make.unique(colnames(trainobs))
##rownames(trainobs) <- rownames(trainobs, do.NULL = FALSE, prefix = "train")

##rawcombdata <- rbind(testobs, trainobs)

rownames(testobs)<- seq(from = 7353, by = 1, length.out = length(testobs[ ,1]))

combobs <- rbind(trainobs, testobs)
## SUCCESSFUL MERGE!!!
