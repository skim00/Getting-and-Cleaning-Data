
setwd("C:/_LOCALdata/_Data Science/DScience/GettingAndCleaningData")

library(reshape2)

filename <- "getdata_projectfiles_UCI_HAR_Dataset.zip'
####################################################################################################
#0.  Download the dataset
####################################################################################################
if (!file.exists(filename)){
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename)
}  

## Unzip the dataset
if (!file.exists("UCI HAR Dataset")) { unzip(filename) }

####################################################################################################
# 1. Merging the training and the test sets to create one data set
####################################################################################################

# Reading training sets
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Reading test sets
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 


# Reading feature data set
features <- read.table('./UCI HAR Dataset/features.txt')

# reading activity
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')

# 1.2 Assign column names

colnames(x_train) <- features[,2]  
colnames(y_train) <-"activityId" 
colnames(subject_train) <- "subjectId" 
     
colnames(x_test) <- features[,2]  
colnames(y_test) <- "activityId" 
colnames(subject_test) <- "subjectId" 
       
 colnames(activityLabels) <- c('activityId','activityType' )

###########################################################################
#1.3 merge training and test sets to create one data set
###########################################################################
merge_training <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(merge_training, merge_test)

####################################################################################################
# 2. Extracting only the measurements on the mean and standard deviation for each measurement
####################################################################################################
# 2.1 Reading column names:
colNames <- colnames(setAllInOne)

# 2.2 Create vector for defining ID, mean and standard deviation:
mean_and_standard <- (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames) )


setForMeanAndStandard <- setAllInOne[ , mean_and_standard == TRUE]

####################################################################################################
# 3. Use descriptive activity names to name the activities in the data set
setWithActivityNames <- merge(setForMeanAndStandard, activityLabels, by='activityId', all.x=TRUE)
####################################################################################################
# 4. Appropriately labels the data set with descriptive variable names.
# See above
####################################################################################################
# 5. Creating a second, independent tidy data set with the average each variable for each activity and each subject
####################################################################################################

# 5.1 Making second tidy data set 
secTidyDataSet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidyDataSet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# 5.2 Writing second tidy data set in txt file
write.table(secTidyDataSet, "./UCI HAR Dataset/TidyDataSet.txt", row.name=FALSE)



