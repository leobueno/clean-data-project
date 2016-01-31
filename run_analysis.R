# Setup environment, loading required packages and downloading the original data set if not already present in the current folder
source("setup.R")

# Load feature names and position from features.txt, matches the variable name from features.txt against a regular 
# expression filtering only features related to mean and standard deviation variables and extracts its domain 
# (time or frequency), the signal (eg.: 'BodyAcc', 'BodyGyro') and variable (eg.: 'mean', 'std') and the direction 
# when available (X/Y/Z), that are used to generate the variable names as explained in codebook.md
#
# We will return a data.frame containing the col.name/colClass to use for each feature
#
loadFeatures <- function() {
  
  features <- read.table("features.txt", col.names = c("feature_idx","original_feature_name"))
  
  #This regex below will allow us to filter only mean and standard deviation
  REGEX_FEATURE_NAMES_OF_INTEREST <- "(t|f)([a-zA-Z]+)\\-(mean|std)(?:\\(\\))(?:\\-([XYZ]))?"

  feature_name_components <- str_match(features[,2], REGEX_FEATURE_NAMES_OF_INTEREST)
  colnames(feature_name_components) <- c("original_feature_name","domain","signal","variable","direction")
  feature_name_components <- data.frame(feature_name_components)
  
  create_new_name <- function(feature_component_row) {
    if (is.na(feature_component_row['original_feature_name'])) {
      NA
    } else {
      domain = if (feature_component_row['domain'] == 't') {'time'} else {'freq'}
      new_name = paste(domain, feature_component_row['signal'], feature_component_row['variable'], sep = "_")
      if (!is.na(feature_component_row['direction'])) { 
        new_name = paste(new_name, feature_component_row['direction'], sep = "_")
      }
      new_name
    }
  }
  
  mutate(
    feature_name_components, 
    feature_name = apply(feature_name_components, 1, create_new_name), 
    colClass = ifelse(is.na(original_feature_name),"NULL",NA)
    )
}

#loads each component of the data set into a named list member, returning the list
# To retain only mean and std dev variables, we will pass NULL as colClasses for columns that are
# not mean and std dev columns. This will make read.table skip loading these columns
# (See https://stat.ethz.ch/R-manual/R-devel/library/utils/html/read.table.html)
loadDataSet <- function(variables) {
  list(
    activityLabels = read.table('activity_labels.txt', header = FALSE, col.names = c("activity_id","activity_desc")),
    xTrain = read.table('train/X_train.txt', header = FALSE, col.names = variables$feature_name, colClasses = variables$colClass),
    yTrain = read.table('train/y_train.txt', header = FALSE, col.names = c("activity")),
    subjectTrain = read.table('train/subject_train.txt', header = FALSE, col.names = c("subject")),
    xTest = read.table('test/X_test.txt', header = FALSE, col.names = variables$feature_name, colClasses = variables$colClass),
    yTest = read.table('test/y_test.txt', header = FALSE, col.names = c("activity")),
    subjectTest = read.table('test/subject_test.txt', header = FALSE, col.names = c("subject"))
  )	
}

# We will merge the sets by:
# 1) column binding data from observations (X), classificatio9n of activity (Y), subject and a boolean indicating if the row is from the train (TRUE) or test (FALSE) set
# 2) Row binding the data from train and test sets
mergeSets <- function(dataSet) {
  rbind(
    cbind(dataSet$xTrain, dataSet$yTrain, dataSet$subjectTrain),
    cbind(dataSet$xTest, dataSet$yTest, dataSet$subjectTest)
  ) %>% inner_join(dataSet$activityLabels, c("activity" = "activity_id")) %>% select(-activity)
}

# This function creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summariseByActivityAndSubject <- function(mergedSet) {
  group_by(mergedSet, subject, activity_desc) %>%  summarise_each(funs(mean), -activity_desc, -subject)
}


dataSetDir <- "UCI HAR Dataset"

initial_work_dir <- getwd()

setwd(dataSetDir)

# 1) Load data sets with descriptive variable names, extracting only the measurements on the mean and standard deviation.  (REQ 2 & REQ 4)
features <- loadFeatures()

dataSet <- loadDataSet(features)

setwd(initial_work_dir)

# 2) Merge observations, activity classification and subject of the train and test sets into a single data frame (REQ1 & REQ3)
mergedSet <- mergeSets(dataSet)

write.table(mergedSet, file = "tidy.txt", row.names = FALSE)

# 3) summarize
summarised <- summariseByActivityAndSubject(mergedSet)

write.table(summarised, file = "summary.txt", row.names = FALSE)