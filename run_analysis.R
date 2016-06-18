
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

## creating tables of test and train obs that has variable names and index 
## column (last col in dataframe)

colnames(testobs) <- variablelabels[ ,2]
testobs$ID<-seq.int(nrow(testobs))
rownames(testobs) <- paste(testobs$ID, "test")

colnames(trainobs) <- variablelabels[ ,2]
trainobs$ID<-seq.int(nrow(trainobs))
rownames(trainobs) <- paste(trainobs$ID, "train")

## adding subject numbers
testobs$subject <- testid
trainobs$subject <- trainid

##adding activity in number code
testobs$activity <- testactivity
trainobs$activity <- trainactivity

##select columns for each dataset
library(dplyr)

colnames(testobs) <- make.unique(colnames(testobs))
testdata <- select(testobs, subject, activity, 
                   contains("mean", ignore.case = TRUE), 
                   contains("std", ignore.case = TRUE))

colnames(trainobs) <- make.unique(colnames(trainobs))
traindata <- select(trainobs, subject, activity, 
                   contains("mean", ignore.case = TRUE), 
                   contains("std", ignore.case = TRUE))
##rownames(traindata) <- seq.int(nrow(testdata), length.out = nrow(traindata))
## fix, duplicate row names error
merge(testdata, traindata, by = intersect(names(testdata),names(traindata)))


