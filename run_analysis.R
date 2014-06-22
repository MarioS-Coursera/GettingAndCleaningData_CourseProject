#1. Merge the training and test sets to create one data set
#2. Extract only the measurements of the mean and standard deviation for each measurement
#3. Uses descriptive activity names to name the activity in the data set
#4. Appropriatly label the data set with descriptive variable names
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

setwd(dir=".")

## 1
#######################################################################################
## read the test and training set
testSet_RAW <- read.csv(file="UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
trainingSet_RAW <- read.csv(file="UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)

## read the feature names
featureNamesTable <- read.table(file="UCI HAR Dataset/features.txt",header=FALSE, stringsAsFactors=FALSE)
featureNames <- featureNamesTable$V2

##set the column names to the features
colnames(testSet_RAW) <- featureNames
colnames(trainingSet_RAW) <- featureNames

## merge the training and test set
combinedDataset_RAW <- rbind(trainingSet_RAW, testSet_RAW)

## 2
#######################################################################################

## extract only the columns with meassurements of the mean and standard diviation
columnsOfInterest <- grep("mean|std",featureNames)
combinedDataset <- combinedDataset_RAW[,columnsOfInterest]

## 3/4
#######################################################################################

## read the test and training label
testLabel_RAW <- read.csv(file="UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
trainingLabel_RAW <- read.csv(file="UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)

##append the labels to the combined dataset
combinedLabels <- rbind(trainingLabel_RAW, testLabel_RAW)
colnames(combinedLabels) <- "label"
combinedDataset <- cbind(combinedDataset, combinedLabels)

##read the activity label names
activityLabelNames <- read.csv(file="UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE, stringsAsFactors=FALSE)

## name the 
colnames(activityLabelNames) <- c("id","name")
## rename all activity labels with their name
for(id in activityLabelNames$id){
    combinedDataset$label[combinedDataset$label == id] <- activityLabelNames$name[activityLabelNames$id == id]
}

## 5
#######################################################################################

##read the subject ids
testSubject_RAW <- read.csv(file="UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
trainingSubject_RAW <- read.csv(file="UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

##merge the training and test subjects
combinedSubjects_RAW <- rbind(trainingSubject_RAW, testSubject_RAW)
colnames(combinedSubjects_RAW) <- "subject"

combinedDataset <- cbind(combinedDataset, combinedSubjects_RAW)



## create an empty object for storing the means of every subjects activity meassurement
tidyDataset <- NULL
## helper variable for storing the subject and activity information alongside the data
info <- NULL

## for each subject in the dataset ...
subjects <- split(combinedDataset, combinedSubjects_RAW$subject)
for(subject in subjects){
    
    ## ... get every activity of this subject ...
    activities <- split(subject, subject$label)
    for(activity in activities){
        ## ... and calculate the mean of every column
        tidyDataset <- rbind(tidyDataset,colMeans(activity[,1:length(columnsOfInterest)]))
        info <- rbind(info, c(activity$subject[1], activity$label[1]))
        
    }
}
## name the colums of the subject and activity information
colnames(info) <- c("subject", "activity")
## append the info to the dataset
tidyDataset <- cbind(tidyDataset, info)

## store the extracted dataset to disk
#write.csv(combinedDataset, file="dataset.csv")

## store the tidy dataset to disk
write.csv(tidyDataset, file="tidy_dataset.csv")

