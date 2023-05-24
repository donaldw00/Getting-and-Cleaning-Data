#load data manipulation package
library(reshape2)

#download data
if (!file.exists("UCI HAR Dataset")){
  print("Files Downloaded")
} else {
  download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset.zip")
  unzip("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset")
}

#read data from test/train sets and corresponding labels
activity_labels<- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\activity_labels.txt")
features <- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\features.txt")

test_subject <- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\test\\subject_test.txt")
test_x <- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\test\\X_test.txt")
test_y <- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\test\\y_test.txt")

train_subject <- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\train\\subject_train.txt")
train_x <- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\train\\X_train.txt")
train_y <- read.table("C:\\Users\\patri\\OneDrive\\Documents\\R Programming 2022\\UCI HAR Dataset\\train\\y_train.txt",)

#Combine data sets
x_combined <- rbind(train_x, test_x)
y_combined <- rbind(train_y, test_y)
Subject_combined <- rbind(train_subject, test_subject)


#Subset data set to include only mean and standard deviation measurements
meanstdindex <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x <- x_combined[,meanstdindex]
colnames(x) <- features[meanstdindex, 2]

#Label data set with appropriate variable names
colnames(x) <- gsub("\\(|\\)","", colnames(x))
colnames(x) <- gsub("-",".", colnames(x))
colnames(x) <- tolower(colnames(x))

#Name activities using corresponding activity labels
activity_labels[,2] <- tolower(gsub("_","", activity_labels[,2]))
label <- activity_labels[y_combined[,1],2]
y_combined[,1] <- label

colnames(y_combined) <- "activity"
colnames(Subject_combined) <- "subject"

#Create tidy data set
combined_dataset <- cbind(Subject_combined, y_combined, x)
reshape_dataset <- melt(combined_dataset, id = c("activity","subject"))
tidy_dataset <- dcast(reshape_dataset, activity + subject ~ variable, mean)

#Export tidy data set to external text file
write.table(tidy_dataset, "tidydata.txt", row.names= FALSE, col.names= TRUE, sep = "\t")

