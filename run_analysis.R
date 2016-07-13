
##check if data is already downloaded, if not download data and unzip files
if (!dir.exists("UCI HAR Dataset")) { 
        url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url1, "data.zip")
        unzip("data.zip")
}

## creates a dataframe of the code for activity descriptions:
## col 1 will be the number used in the dataset (int 1:6), col 2 is the activity 
##descriptions 
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
## first col is number, col2 is description

## creates a dataframe of the colnames for the observations in order, col 1 is
## an index, col 2 contains the names
variablelabels <- read.table("UCI HAR Dataset/features.txt")


## import observation data for test and train groups, inertial signal 
##data was ignored as it doesn't contain mean or std data

testobs <- read.table("UCI HAR Dataset/test/x_test.txt")
trainobs <- read.table("UCI HAR Dataset/train/X_train.txt")

## create one column df of activity information in numeric code
testactivity <- read.table("UCI HAR Dataset/test/y_test.txt")
trainactivity <- read.table("UCI HAR Dataset/train/y_train.txt")

## create one column df of individual subject id numbers used in the experiment
testid <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainid <- read.table("UCI HAR Dataset/train/subject_train.txt")

## observation variables: combine train and test sets and label columns
combobs <- rbind(trainobs, testobs)
colnames(combobs) <- variablelabels[ ,2]
## some variable names were duplicate, to prevent future complications 
## colnames were made unique by adding sequence #s to duplicates
colnames(combobs) <- make.unique(colnames(combobs))



## select only mean and standard of deviation data, will include variables 
## calculated from means (ie gravitymean used in computing angles)
## see README for rational
library(dplyr)
tidydata <- select(combobs, contains("mean", ignore.case = TRUE), 
                   contains("std", ignore.case = TRUE))


## merging training and test sets for subject id and activity variables
id <- rbind(trainid, testid)
activity <- rbind (trainactivity, testactivity)



## adding subject id and activity columns to beginning of data set
## (note: tidydata variable is not tidy yet)
tidydata <- cbind(id, activity, tidydata)



## labeling added columns
colnames(tidydata) <- c("subject", "activity", colnames(tidydata[ ,3:88]))

## converting activity column to factor column with levels that give a
## description of the activity
tidydata$activity <- as.factor(tidydata$activity)
levels(tidydata$activity) <- activitylabels[ ,2]


## creating new dataset for variable means by subject and activity

library(reshape2)

## melt dataframe so that id variables are subject id and activity
meltdata <- melt(tidydata, id.vars = 1:2)

## cast dataframes that divide data by subject and activity and report the means
## of each variable selected previously
subjmeans <- dcast(meltdata, subject ~ variable, mean)
actmeans <- dcast(meltdata, activity ~ variable, mean)


library(dplyr)

##add column indicating which rows represent data divided by subject
## then move it to the front and rename subject column to generic "group"
## column so that mean data sets can be merged
subjmeans <- mutate(subjmeans, group_type = "subject")
subjmeans <- select(subjmeans, group_type, group = subject, everything())
## change class of group to match activity group column
class(subjmeans$group) <- "character"

## repeat the process with the data grouped by activity
actmeans <- mutate(actmeans, group_type = "activity")
actmeans <- select(actmeans, group_type, group = activity, everything())
actmeans$group <- as.character(actmeans$group)

## merge data sets into one dataframe
## FINAL DATA SET IS dfmeans
dfmeans <- bind_rows(subjmeans, actmeans)
