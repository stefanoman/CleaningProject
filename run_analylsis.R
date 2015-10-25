## Coursera Getting and Cleaning Data Course
## PROJECT ASSIGNMENT

# runAnalysis.r File Description:

# This script perform the following operations using the UCI HAR Dataset 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data in step 4, creates a second, independent tidy data set with the average of 
#    each variable for each activity and each subject. 

# In addition to tinyData reduced dataset, I also kept the full dataset intact with descriptive names

##########################################################################################################


# 1. Merge the training and the test sets to create one data set.

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('c:/Users/Stef/Documents/DataScience/CleaningProject/UCI HAR Dataset');

# Read in the training dataset contained in three files, with the accelerometer and gyro measurement 
#headers in features.txt.  The activity Labels describe the type of activity, and subject describes
# the identity of the person who carried out the experiment
features     <-read.table('./features.txt',header=FALSE); #import features.txt
features[,2] <- as.character(features[,2])
activityLabels <-read.table('./activity_labels.txt',header=FALSE); #import activity_labels.txt
activityLabels[,2] <- as.character(activityLabels[,2])

subjectTrain <-read.table('./train/subject_train.txt',header=FALSE); #import subject_train.txt
xTrain       <-read.table('./train/x_train.txt',header=FALSE);      #import x_train.txt (Training set)
yTrain       <-read.table('./train/y_train.txt',header=FALSE);     #import y_train.txt (Training labels)

# Assigin column names to training data 
colnames(activityLabels)  =c("activityId","activityLabel");   # 2 Columns: Activity has an ID and a Label
colnames(subjectTrain)  <-"subjectId";
colnames(xTrain)        <-features$V2;                       # 2nd Column of feature names for xTrain labels
colnames(yTrain)        <-"activityId";                        # Activity ID of training set

# Merge yTrain, subjectTrain, and xTrain by columns to create combined TRAINING Set
trainingSet <-cbind(yTrain,subjectTrain,xTrain);

# Load the test data
subjectTest <-read.table('./test/subject_test.txt',header=FALSE);   #import subject_test.txt
xTest       <-read.table('./test/x_test.txt',header=FALSE);        #import x_test.txt (Test Set)
yTest       <-read.table('./test/y_test.txt',header=FALSE);        #imports y_test.txt (Test Set Labels)

# Assign column names to test data
colnames(subjectTest) <- "subjectId";
colnames(xTest)       <- features$V2; 
colnames(yTest)       <- "activityId";


# Merge xTest, yTest and subjectTest data by columns to creat combined TEST set
testSet <-cbind(yTest,subjectTest,xTest);


# Combine training and test data sets by rows - the data sets have the same number of columns and matching
# column labels
comboData <-rbind(trainingSet,testSet);

# Extract column names from comboData in "colNames", which will be used
# to select the desired mean() & stddev() columns in step 2.
colNames  <-colnames(comboData); 

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

mean_and_std_features <- grep("-(mean|std|Mean|Std)\\(\\)", colNames)   # Find the columns that contain mean and std values
trimmedData <- comboData[,mean_and_std_features]                        # use indexes above to create new reduced data set "trimmedData" with just mean/std columns  
trimmedData <- cbind(comboData[,1:2],trimmedData)                       # add in subject and activity columns to trimmed data
# DONE EXTRACTING MEAN AND STANDARD DEVIATION READINGS #

# 3. Use descriptive activity names to name the activities in the data set

#  Merge the comboData set with the acitivityType table to include descriptive activity names
activityLabel <- activityLabels[comboData[, 2], 2]   # pull out activity labels
comboData <- cbind(comboData,activityLabel)         # join comboData and activityLabel columns (preserves Master Data)
trimmedData <- cbind(trimmedData,activityLabel)     # join trimmedData and activityLabel columns (just the mean/std set)

# # Updating the colNames vector to include the new column names after merge

## For FULL or TRIMMED DATASET
colNames  <-colnames(comboData); 

 
# # 4. Appropriately label the data set with descriptive activity names. 
# 
# # Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] <-gsub("\\()","",colNames[i])
  colNames[i] <-gsub("-std$","StdDev",colNames[i])
  colNames[i] <-gsub("-mean","Mean",colNames[i])
  colNames[i] <-gsub("^(t)","time",colNames[i])
  colNames[i] <-gsub("^(f)","freq",colNames[i])
  colNames[i] <-gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] <-gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] <-gsub("[Gg]yro","Gyroscope",colNames[i])
  colNames[i] <-gsub("AccMag","Accelerometer Magnitude",colNames[i])
  colNames[i] <-gsub("([Bb]odyaccjerkmag)","Body Accelerometer JerkMagnitude",colNames[i])
  colNames[i] <-gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] <-gsub("GyroMag","GyroMagnitude",colNames[i])  };
# 
# Convert column tames to more descriptive names for FULL comboData set
colnames(comboData) <-colNames;

# FOR TRIMMED DATASET WITH ONLY MEAN AND STD DEVIATION 
colNames  <-colnames(trimmedData); 
for (i in 1:length(colNames)) 
{
  colNames[i] <-gsub("\\()","",colNames[i])
  colNames[i] <-gsub("-std$","StdDev",colNames[i])
  colNames[i] <-gsub("-mean","Mean",colNames[i])
  colNames[i] <-gsub("^(t)","time",colNames[i])
  colNames[i] <-gsub("^(f)","freq",colNames[i])
  colNames[i] <-gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] <-gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] <-gsub("[Gg]yro","Gyroscope",colNames[i])
  colNames[i] <-gsub("AccMag","Accelerometer Magnitude",colNames[i])
  colNames[i] <-gsub("([Bb]odyaccjerkmag)","Body Accelerometer JerkMagnitude",colNames[i])
  colNames[i] <-gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] <-gsub("GyroMag","GyroMagnitude",colNames[i])
};
# 
# # Reassigning the new descriptive column names to the comboData set
colnames(trimmedData) <-colNames;

 
# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(plyr);

#  Create a new table, comboDataNoactivityLabel without the activityLabel column
comboDataNoactivityLabel  <-trimmedData[,names(trimmedData) !='activityLabel'];
# 
# Calculate MEANs of each data column for each activity and subject
tidyData    <-aggregate(comboDataNoactivityLabel[,names(comboDataNoactivityLabel) !=c('activityId','subjectId')],by=list(activityId=comboDataNoactivityLabel$activityId,subjectId = comboDataNoactivityLabel$subjectId),mean);
# 
# Merge the tidyData with activityLabel to include descriptive acitvity names
tidyData <- tidyData[order(tidyData$subjectId,tidyData$activityId),]

# 
# # Export the tidyData set 
 write.table(tidyData, file = "tidydata.txt",row.names=TRUE,sep='\t')
 
