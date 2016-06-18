
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

## use activitylabels for replacing numbers with activity names
testactivity <- read.table("UCI HAR Dataset/test/y_test.txt")


## numbers to represent individuals
testid <- read.table("UCI HAR Dataset/test/subject_test.txt")


## creating table of test obs that has variable names and index column (last col
## in dataframe)

colnames(testobs) <- variablelabels[ ,2]
testobs$ID<-seq.int(nrow(testobs))

## adding subject numbers
testobs$subject <- testid

##adding activity in number code
testobs$activity <- testactivity

## probably don't need raw data from inertial signals folder...

