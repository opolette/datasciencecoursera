## Create a dataframe with training and test data 
## from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## Raw data is https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
##
## Assumptions: data has been extracted and in the same folder than code (with subfolders kept)
##
## Steps:
## 1 - Create a "activity_label" dataframe containing labels, using file "activity_labels.txt"
## 2 - Create a "featureDF" dataframe containing all features from "features.txt" file
## 3 - Create a "training" staging dataframe containing training data:
##      with one column per variable: subject_train, x_train (many variables), y_train 
##      name columns with: subject, value, label and the name of X variables mapped from featureDF
##      Replace the values in "activity" column by activity labels, using a join on "activity_label" dataframe
## 4 - Do the same thing with the test dataframe ("test" staging dataframe)
## 5 - merge both staging dataframes in a dataframe called "ARMeanStdDF" and drop the staging dataframes
## 6 - Create a tidy dataframe called "ARMeanStdDFTidy" with the mean per subject / per activity for each variable
##
## How to use:
## source("run_analysis.R")
## initializeLibs()
## sampleDF <- createARDF() # creates the main Dataframe
## tidyDF <- createTydiDF(sampleDF) # creates the tidy Dataframe
##


# initializeLibs
# Loads required libraries

initializeLibs <- function() {
  library(dplyr)
  library(data.table)
}

# createActivityLabel
# Creates the activity_label dataframe

createActivityLabelDF <- function() {
  activity_labelDF <- read.table(file="./UCI HAR Dataset/activity_labels.txt", sep = " ", col.names = c("id", "activity"))
  return(activity_labelDF)
}

# createFeaturesDF 
# creates a dataframe of column numbers that match columns about "means" and "std" 
# in the features.txt file

createFeaturesDF <- function() {
  featuresColDF <- read.table(file="./UCI HAR Dataset/features.txt", sep = " ", col.names = c("id", "feature"))
  featuresColDF <- mutate(featuresColDF, isMeanStd = grepl("mean|std", feature))
  return(featuresColDF)
}


# createStagingDF
# Creates a staging dataframe
# name:  can be "training"or "test"

createStagingDF <- function(name) {
  # Load the subjects and the labels
  stagingSubjectDF <- read.table(file=paste0("./UCI HAR Dataset/", name, "/subject_", name, ".txt"), sep = " ", col.names = c("subject"))
  stagingSubjectDF <- stagingSubjectDF %>% mutate(id = row_number())
  stagingActivityDF <- read.table(file=paste0("./UCI HAR Dataset/", name, "/y_", name, ".txt"), col.names = c("activity"))
  stagingActivityDF <- stagingActivityDF %>% mutate(id = row_number())
  # match with activity labels to replace labels
  activity_labelDF = createActivityLabelDF()
  stagingActivityDF$activity <- activity_labelDF$activity[match(stagingActivityDF$activity, activity_labelDF$id)]
  # create vector with ids and names of mean and std measures (i.e. features)
  featuresColDF = createFeaturesDF()
  colIDs <- filter(featuresColDF, isMeanStd == TRUE) %>% select(id) %>% as.vector
  colNames <- filter(featuresColDF, isMeanStd == TRUE) %>% select(feature) %>% as.vector
  # Use fread to be able to select columns easily
  stagingValuesDF <- suppressWarnings(fread(file=paste0("./UCI HAR Dataset/", name, "/X_", name, ".txt"), sep = " ", select = colIDs, stringsAsFactors = FALSE))
  # convert all values to numbers
  stagingValuesDF <- as.data.frame(sapply(stagingValuesDF, as.numeric))
  # rename columns with features names
  names(stagingValuesDF) <- as.character(colNames$feature)
  # create staging dataframe
  stagingValuesDF <- stagingValuesDF %>% mutate(id = row_number())
  stagingSubjectDF <- merge(stagingSubjectDF, stagingActivityDF, by.x = "id", by.y = "id")
  stagingSubjectDF <- merge(stagingSubjectDF, stagingValuesDF, by.x = "id", by.y = "id")
  return(stagingSubjectDF)
}

# createTidyDF
# ARDF: "big" dataframe
# Returns a tidy DF based on ARDF with average of each variable per subject and per activity

createTidyDF <- function(ARDF){
  ## Note one tricky thing is that the grouped columns are not used in grouping functions
  ## so that there are 2 columns less (i.e. ncol(ARDF) - one for "subject" column and one for "activity" column) 
  ## in the range of columns that can be summarized. Hence the -2 after ncol(ARDF) in the formula below
  ## dplyr.summarise.inform = FALSE : suppress the useless warnings from summarize
  options(dplyr.summarise.inform = FALSE)
  ARTidyDF <- ARDF %>% group_by(subject, activity ) %>% summarize(across(4:ncol(ARDF)-2, mean))
} 

# createARDF
# Returns the Activity Recognition Dataframe with Mean and Std variables

createARDF <- function() {
  stagingTrainDF = createStagingDF("train")
  stagingTestDF = createStagingDF("test")
  ARMeanStdDF <- rbind(stagingTrainDF, stagingTestDF)
  return(ARMeanStdDF)
}
