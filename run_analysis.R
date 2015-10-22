# here the file is downloaded and unzipped.
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Dataset.zip", method = "internal")
unzip("Dataset.zip", overwrite = TRUE, exdir = ".", unzip = "internal")

#here initial dataframes are generated and the names are obtained from features.txt
train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
names <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = "")
colnames(train) <- names[,2]
colnames(test) <- names[,2]

#here dataframes are updated with information about subjects
train_subj <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
colnames(train_subj) <- c("subject")
train <- cbind(train, train_subj)

test_subj <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
colnames(test_subj) <- c("subject")
test <- cbind(test, test_subj)

#now we need to update information with activities and replace them with the descriptive activity names 
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
train_activity1 <- data.frame()
dim1 <- dim(train_activity)[1]
for(i in 1:dim1) {
  train_activity1[i,1] <- activities[train_activity[i,1],2]
}
colnames(train_activity1) <- c("activity")
train <- cbind(train, train_activity1)

test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
test_activity1 <- data.frame()
dim2 <- dim(test_activity)[1]
for(i in 1:dim2) {
  test_activity1[i,1] <- activities[test_activity[i,1],2]
}
colnames(test_activity1) <- c("activity")
test <- cbind(test, test_activity1)

#here we merged the test and train dataframes to obtain mergedData frame
mergedData <- data.frame()
mergedData <- rbind(train, test)

names(mergedData)

#Extracts only the measurements on the mean and standard deviation for each measurement preserving information about avtivity and subject
mergedData2 <- mergedData[grepl("mean()",fixed=TRUE,names(mergedData))|
                          grepl("std()",fixed=TRUE,names(mergedData))|
                          grepl("activity",fixed=TRUE,names(mergedData))|
                          grepl("subject",fixed=TRUE,names(mergedData))]
names(mergedData2)

#create second, independent tidy data set with the average of each variable for each activity and each subject.
aggdata <-aggregate(mergedData2[,-c(67, 68)], 
                    by=list(subject=mergedData2$subject,activity=mergedData2$activity), 
                    FUN=mean, na.rm=TRUE)
names(aggdata)

#now it generates a txt file created with write.table() using row.name=FALSE
write.table(aggdata, file = "output.txt", row.names = FALSE)
