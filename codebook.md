---
title: "Codebook"
output: html_document
---

# 1. Transformations

## 1.1 load data, filtering and naming features (REQ2 & REQ4)

Before loading the observations, we first load data from features.txt and create a list of all the features that are mean and standard deviation measurements and will be  kept on our tidy dataset(**REQ2**), and derive descriprive variable names (**REQ4**) from the variable names from the features.txt file.

This is performed by the function `loadFeatures()` that matches the variable name from features.txt against a regular expression filtering only features related to mean and standard deviation variables and extracts its domain (time or frequency), the signal (eg.: 'BodyAcc', 'BodyGyro') and variable (eg.: 'mean', 'std') and the direction when available (X/Y/Z), that are used to generate the variable names as explained in codebook.md

By filtering features while loading we can achieve better performance, as we don't use memory to store information we'll not need to create our tidy dataset.

We then proceed to load data using function `loadDataSet(features)`, that returns a list where each element is part of the original dataset:

* activityLabels
* xTrain
* yTrain
* subjectTrain
* xTest
* yTest
* subjectTest

While loading xTrain and xTest, we filter the features so only mean and standard deviation variables are loaded (**REQ2**). This is done by specifing the parameter `colClasses` in the call to `read.table`. We pass '-' (don't load) or '?' (use default behavior of `type.convert`)

## 1.2 Merging data and using descriptive names to name activities (REQ1 & REQ3)

After loading the original dataset, we create the tidy dataset by column bindnig features (xTrain/xTest), subjects (subjectTrain/subjectTest) and results (yTrain/yTest) and row biding the resulting train and test sets (**REQ1**).

We them perform a inner join between this data.frame with a data.frame loaded from activity_labels.txt matching on teh activity ids to add a new column to the resulting data.frame with a descriptive activity name (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) (**REQ3**)

The outcome is:

features|outcomes|subjects    |activity desc
--------|--------|------------|-----------
xTrain  |yTrain  |subjectTrain|activity desc
xTest   |yTest   |subjectTest |activity desc


## 1.3 Create summary dataset (REQ5)

The last step is to create a second, independent tidy data set with the average of each variable for each activity and each subject.

We achive that with function `summariseByActivityAndSubject(mergedDataSet)` and then save it to a file. In this function, the merged data set is summarized with dplyr by first using grouping_by to group by subject and activity and then using summarise_each to generate only the mean of each feature (**REQ5**)

# 2 Information about variables and summaries calculated

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 'time' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (eg. time_BodyAcc_mean_X and time_GravityAcc_mean_X) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (eg. time_BodyAccJerk_mean_X and time_BodyGyroJerk_mean_X). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (time_BodyAccMag_mean, time_GravityAccMag_mean, time_BodyAccJerkMag_mean, time_BodyGyroMag_mean, time_BodyGyroJerkMag_mean). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing variables in the frequency domain (same variable names, but with freq replacing time)

Variable        | variable_desc      
----------------|-------------------
subject         | ID of the subject for this row
activity_desc   | a description of the activity performed. One of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING


|feature_name                  |domain_desc      |signal              |variable_desc      |direction |original_feature_name       |
|:-----------------------------|:----------------|:-------------------|:------------------|:---------|:---------------------------|
|time_BodyAcc_mean_X           |time domain      |BodyAcc             |mean               |X         |tBodyAcc-mean()-X           |
|time_BodyAcc_mean_Y           |time domain      |BodyAcc             |mean               |Y         |tBodyAcc-mean()-Y           |
|time_BodyAcc_mean_Z           |time domain      |BodyAcc             |mean               |Z         |tBodyAcc-mean()-Z           |
|time_BodyAcc_std_X            |time domain      |BodyAcc             |standard deviation |X         |tBodyAcc-std()-X            |
|time_BodyAcc_std_Y            |time domain      |BodyAcc             |standard deviation |Y         |tBodyAcc-std()-Y            |
|time_BodyAcc_std_Z            |time domain      |BodyAcc             |standard deviation |Z         |tBodyAcc-std()-Z            |
|time_GravityAcc_mean_X        |time domain      |GravityAcc          |mean               |X         |tGravityAcc-mean()-X        |
|time_GravityAcc_mean_Y        |time domain      |GravityAcc          |mean               |Y         |tGravityAcc-mean()-Y        |
|time_GravityAcc_mean_Z        |time domain      |GravityAcc          |mean               |Z         |tGravityAcc-mean()-Z        |
|time_GravityAcc_std_X         |time domain      |GravityAcc          |standard deviation |X         |tGravityAcc-std()-X         |
|time_GravityAcc_std_Y         |time domain      |GravityAcc          |standard deviation |Y         |tGravityAcc-std()-Y         |
|time_GravityAcc_std_Z         |time domain      |GravityAcc          |standard deviation |Z         |tGravityAcc-std()-Z         |
|time_BodyAccJerk_mean_X       |time domain      |BodyAccJerk         |mean               |X         |tBodyAccJerk-mean()-X       |
|time_BodyAccJerk_mean_Y       |time domain      |BodyAccJerk         |mean               |Y         |tBodyAccJerk-mean()-Y       |
|time_BodyAccJerk_mean_Z       |time domain      |BodyAccJerk         |mean               |Z         |tBodyAccJerk-mean()-Z       |
|time_BodyAccJerk_std_X        |time domain      |BodyAccJerk         |standard deviation |X         |tBodyAccJerk-std()-X        |
|time_BodyAccJerk_std_Y        |time domain      |BodyAccJerk         |standard deviation |Y         |tBodyAccJerk-std()-Y        |
|time_BodyAccJerk_std_Z        |time domain      |BodyAccJerk         |standard deviation |Z         |tBodyAccJerk-std()-Z        |
|time_BodyGyro_mean_X          |time domain      |BodyGyro            |mean               |X         |tBodyGyro-mean()-X          |
|time_BodyGyro_mean_Y          |time domain      |BodyGyro            |mean               |Y         |tBodyGyro-mean()-Y          |
|time_BodyGyro_mean_Z          |time domain      |BodyGyro            |mean               |Z         |tBodyGyro-mean()-Z          |
|time_BodyGyro_std_X           |time domain      |BodyGyro            |standard deviation |X         |tBodyGyro-std()-X           |
|time_BodyGyro_std_Y           |time domain      |BodyGyro            |standard deviation |Y         |tBodyGyro-std()-Y           |
|time_BodyGyro_std_Z           |time domain      |BodyGyro            |standard deviation |Z         |tBodyGyro-std()-Z           |
|time_BodyGyroJerk_mean_X      |time domain      |BodyGyroJerk        |mean               |X         |tBodyGyroJerk-mean()-X      |
|time_BodyGyroJerk_mean_Y      |time domain      |BodyGyroJerk        |mean               |Y         |tBodyGyroJerk-mean()-Y      |
|time_BodyGyroJerk_mean_Z      |time domain      |BodyGyroJerk        |mean               |Z         |tBodyGyroJerk-mean()-Z      |
|time_BodyGyroJerk_std_X       |time domain      |BodyGyroJerk        |standard deviation |X         |tBodyGyroJerk-std()-X       |
|time_BodyGyroJerk_std_Y       |time domain      |BodyGyroJerk        |standard deviation |Y         |tBodyGyroJerk-std()-Y       |
|time_BodyGyroJerk_std_Z       |time domain      |BodyGyroJerk        |standard deviation |Z         |tBodyGyroJerk-std()-Z       |
|time_BodyAccMag_mean          |time domain      |BodyAccMag          |mean               |NA        |tBodyAccMag-mean()          |
|time_BodyAccMag_std           |time domain      |BodyAccMag          |standard deviation |NA        |tBodyAccMag-std()           |
|time_GravityAccMag_mean       |time domain      |GravityAccMag       |mean               |NA        |tGravityAccMag-mean()       |
|time_GravityAccMag_std        |time domain      |GravityAccMag       |standard deviation |NA        |tGravityAccMag-std()        |
|time_BodyAccJerkMag_mean      |time domain      |BodyAccJerkMag      |mean               |NA        |tBodyAccJerkMag-mean()      |
|time_BodyAccJerkMag_std       |time domain      |BodyAccJerkMag      |standard deviation |NA        |tBodyAccJerkMag-std()       |
|time_BodyGyroMag_mean         |time domain      |BodyGyroMag         |mean               |NA        |tBodyGyroMag-mean()         |
|time_BodyGyroMag_std          |time domain      |BodyGyroMag         |standard deviation |NA        |tBodyGyroMag-std()          |
|time_BodyGyroJerkMag_mean     |time domain      |BodyGyroJerkMag     |mean               |NA        |tBodyGyroJerkMag-mean()     |
|time_BodyGyroJerkMag_std      |time domain      |BodyGyroJerkMag     |standard deviation |NA        |tBodyGyroJerkMag-std()      |
|freq_BodyAcc_mean_X           |frequency domain |BodyAcc             |mean               |X         |fBodyAcc-mean()-X           |
|freq_BodyAcc_mean_Y           |frequency domain |BodyAcc             |mean               |Y         |fBodyAcc-mean()-Y           |
|freq_BodyAcc_mean_Z           |frequency domain |BodyAcc             |mean               |Z         |fBodyAcc-mean()-Z           |
|freq_BodyAcc_std_X            |frequency domain |BodyAcc             |standard deviation |X         |fBodyAcc-std()-X            |
|freq_BodyAcc_std_Y            |frequency domain |BodyAcc             |standard deviation |Y         |fBodyAcc-std()-Y            |
|freq_BodyAcc_std_Z            |frequency domain |BodyAcc             |standard deviation |Z         |fBodyAcc-std()-Z            |
|freq_BodyAccJerk_mean_X       |frequency domain |BodyAccJerk         |mean               |X         |fBodyAccJerk-mean()-X       |
|freq_BodyAccJerk_mean_Y       |frequency domain |BodyAccJerk         |mean               |Y         |fBodyAccJerk-mean()-Y       |
|freq_BodyAccJerk_mean_Z       |frequency domain |BodyAccJerk         |mean               |Z         |fBodyAccJerk-mean()-Z       |
|freq_BodyAccJerk_std_X        |frequency domain |BodyAccJerk         |standard deviation |X         |fBodyAccJerk-std()-X        |
|freq_BodyAccJerk_std_Y        |frequency domain |BodyAccJerk         |standard deviation |Y         |fBodyAccJerk-std()-Y        |
|freq_BodyAccJerk_std_Z        |frequency domain |BodyAccJerk         |standard deviation |Z         |fBodyAccJerk-std()-Z        |
|freq_BodyGyro_mean_X          |frequency domain |BodyGyro            |mean               |X         |fBodyGyro-mean()-X          |
|freq_BodyGyro_mean_Y          |frequency domain |BodyGyro            |mean               |Y         |fBodyGyro-mean()-Y          |
|freq_BodyGyro_mean_Z          |frequency domain |BodyGyro            |mean               |Z         |fBodyGyro-mean()-Z          |
|freq_BodyGyro_std_X           |frequency domain |BodyGyro            |standard deviation |X         |fBodyGyro-std()-X           |
|freq_BodyGyro_std_Y           |frequency domain |BodyGyro            |standard deviation |Y         |fBodyGyro-std()-Y           |
|freq_BodyGyro_std_Z           |frequency domain |BodyGyro            |standard deviation |Z         |fBodyGyro-std()-Z           |
|freq_BodyAccMag_mean          |frequency domain |BodyAccMag          |mean               |NA        |fBodyAccMag-mean()          |
|freq_BodyAccMag_std           |frequency domain |BodyAccMag          |standard deviation |NA        |fBodyAccMag-std()           |
|freq_BodyBodyAccJerkMag_mean  |frequency domain |BodyBodyAccJerkMag  |mean               |NA        |fBodyBodyAccJerkMag-mean()  |
|freq_BodyBodyAccJerkMag_std   |frequency domain |BodyBodyAccJerkMag  |standard deviation |NA        |fBodyBodyAccJerkMag-std()   |
|freq_BodyBodyGyroMag_mean     |frequency domain |BodyBodyGyroMag     |mean               |NA        |fBodyBodyGyroMag-mean()     |
|freq_BodyBodyGyroMag_std      |frequency domain |BodyBodyGyroMag     |standard deviation |NA        |fBodyBodyGyroMag-std()      |
|freq_BodyBodyGyroJerkMag_mean |frequency domain |BodyBodyGyroJerkMag |mean               |NA        |fBodyBodyGyroJerkMag-mean() |
|freq_BodyBodyGyroJerkMag_std  |frequency domain |BodyBodyGyroJerkMag |standard deviation |NA        |fBodyBodyGyroJerkMag-std()  |

# 3. Notes

## General

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

## "descriptive variable names"

One person "descriptive" variable name may be someone else "verbose" variable name 
and at the same time "cryptic" variable name to another person.

I'm basing my choice for variable names on the clarification provided by community TA Gregory D. Horne on the post below:

> https://class.coursera.org/getdata-032/forum/thread?thread_id=115#comment-277

According to him:

>	- The only real requirement is the column names be valid variable names as defined by the R language and enforced by the make.names() function
>	- As long as you document the variable names and their definitions in the codebook you should be okay during peer evaluation
