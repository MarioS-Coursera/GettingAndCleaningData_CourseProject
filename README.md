# Getting and Cleaning Data Course Project
This repository contains code for the course project

## This script will performe the following actions according to the assignment

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names.
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Prerequisits
For using this code make sure you have the **Human Activity Recognition Using Smartphones Dataset
Version 1.0** in a folder named "**UCI HAR Dataset**" inside your workspace.

## Running the script
For running this script simply source the file *run_analysis.R* in R  
`source(file="run_analysis.R")`

## Output
The tidy dataset is stored as a csv file inside the workspace as *tidy_dataset.csv* 

