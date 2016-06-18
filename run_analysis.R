
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

## estimated body acceleration for test group from accelerometer, 128 col for 
## each measurement over time of one activity
testax <- read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
testay <-read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
testaz <- read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")

## angular velocity for test group from gyrometer, 128 col for each measurement
## over time of one activity
testgx <-  read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
testgy <- read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
testgz <- read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")

## total acceleration for test group from accelerometer, 128 col for each 
##measurement over time of one activity
testtotalax <- read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
testtotalay <- read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
testtotalaz <- read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")

## creating table of test obs that has variable names and index column (last col
## in dataframe)

colnames(testobs) <- variablelabels[ ,2]
testobs$ID<-seq.int(nrow(testobs))

