Getting and Cleaning Data Project
=================================
Preparations:
------------------
Load packages:

```r
library(data.table)
```

Download and unzip the dataset. **This chunk of code has "eval = F". To run this on your local machine, set it as "TRUE"**:

```r
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dataset.zip")
unzip("dataset.zip")
```

Read in the data:

```r
var.names = fread("UCI HAR Dataset/features.txt") # Varible names
activity_labels = fread("UCI HAR Dataset/activity_labels.txt") # Activity names

train.x = fread("UCI HAR Dataset/train/X_train.txt", col.names = var.names$V2)
train.y = fread("UCI HAR Dataset/train/y_train.txt", col.names = "activity_label")
train.subject = fread("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

test.x = fread("UCI HAR Dataset/test/X_test.txt", col.names = var.names$V2)
test.y = fread("UCI HAR Dataset/test/y_test.txt", col.names = "activity_label")
test.subject = fread("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

train = cbind(train.x,train.y,train.subject,dataset = "train")
```

1. Merge datasets:
---------------

```r
train = cbind(train.x,train.y,train.subject,dataset = "train")
test = cbind(test.x,test.y,test.subject,dataset = "test")
dt = rbind(train,test)
rm(list = ls(pattern = "train|test")) # Remove temporary objects to recycle some memory
```

2. Extract mean and standard deviation for each measurement:
-------------------

```r
measure.index = c(grep("std\\(\\)|mean\\(\\)",var.names$V2), (ncol(dt)-2):ncol(dt)) # The index of extracted value and also the augmented varibles.
dt = dt[,measure.index, with = F] # to select columns in data.table, "with = FALSE" is needed.
```

3. Change to descriptive activity names:
----------------

```r
dt$activity_label = activity_labels$V2[dt$activity_label]
```

4. Label the data set with descriptive variable names:
----------------
The varible names have been already set at the reading data step. (See the parameter we passed into the function "col.names = var.names$V2")

5. Create a new tidy data set:
---------------

```r
dt.tidy = aggregate(.~activity_label+subject+dataset, data = dt, mean)
write.csv(dt.tidy, "tidy.data.csv", row.names = FALSE)
```


