# Codebook for Getting and Cleaning Data Project

## Scope
The script run_analysis.R performs the functions required in the project description:
1.  Merges the training and the test sets to create one     data set.
2.  Extracts only the measurements on the mean and          standard deviation for each measurement. 
3.  Uses descriptive activity names to name the a           ctivities in the data set
4.  Appropriately labels the data set with descriptive      variable names. 
5.  From the data set in step 4, creates a second,          independent tidy data set with the average of each      variable for each activity and each subject.
## Secton 1
The data set consists of:
- x_train, y_train, x_test, y_test, subject_train and subject_test from the provided files
- The three files that make up the training and test data sets are first merged by columns (cbind) into "trainingSet" and "testSet"
- TrainingSet and TestSet are then row-combined to form "ComboData" using rbind

## Section 2
- find the columns with mean and std values
- extract just these columns from "comboData" and create a new data frame called "trimmedData".  This data frame has just the columns with mean and std values, plus the activity/subject columns added in

## Section 3
