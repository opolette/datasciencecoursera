==================================================================
Human Activity Recognition Using Smartphones Dataset
Summary dataframe
Version 1.0
==================================================================
Code: O.P.
Based on data from:
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

======================================
Detail about the experiment
======================================
Details can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

======================================
Raw data
======================================
Raw data can be downloaded here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

======================================
Instructions
======================================
Download the Raw Data, extract it in the source code folder.
Details about execution and an execution example can be found in the markdown file: run_analysis.Rmd

you can use the function generateTidy() to generate a tidyDF.


======================================
Variables
======================================

The raw data contains 561 variables (features) with time and frequency domain variables.
Out of these 561 variables, only the ones related to mean and std are extracted in the dataframe (80 variables in total).
The data frame presents the following columns:
- an id
- subject (identificatio of the volunteer)
- activity
- one column per variable

the list of variables can be found in run_analysis_variables.txt file


