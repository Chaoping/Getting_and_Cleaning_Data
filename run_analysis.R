## ------------------------------------------------------------------------
library(data.table)

## --------------------------------------------------------------
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dataset.zip")
unzip("dataset.zip")

## ------------------------------------------------------------------------
var.names = fread("UCI HAR Dataset/features.txt") # Varible names
activity_labels = fread("UCI HAR Dataset/activity_labels.txt") # Activity names

train.x = fread("UCI HAR Dataset/train/X_train.txt", col.names = var.names$V2)
train.y = fread("UCI HAR Dataset/train/y_train.txt", col.names = "activity_label")
train.subject = fread("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

test.x = fread("UCI HAR Dataset/test/X_test.txt", col.names = var.names$V2)
test.y = fread("UCI HAR Dataset/test/y_test.txt", col.names = "activity_label")
test.subject = fread("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

train = cbind(train.x,train.y,train.subject,dataset = "train")

## ------------------------------------------------------------------------
train = cbind(train.x,train.y,train.subject,dataset = "train")
test = cbind(test.x,test.y,test.subject,dataset = "test")
dt = rbind(train,test)
rm(list = ls(pattern = "train|test")) # Remove temporary objects to recycle some memory

## ------------------------------------------------------------------------
measure.index = c(grep("std\\(\\)|mean\\(\\)",var.names$V2), (ncol(dt)-2):ncol(dt)) # The index of extracted value and also the augmented varibles.
dt = dt[,measure.index, with = F] # to select columns in data.table, "with = FALSE" is needed.

## ------------------------------------------------------------------------
dt$activity_label = activity_labels$V2[dt$activity_label]

## ------------------------------------------------------------------------
dt.tidy = aggregate(.~activity_label+subject+dataset, data = dt, mean)
write.csv(dt.tidy, "tidy.data.csv", row.names = FALSE)

