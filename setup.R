# Defines an utility function that loads a package, downloading it if not already installed
usePackage <- function(p) {
    if (!is.element(p, installed.packages()[,1]))
        install.packages(p, dep = TRUE)
    require(p, character.only = TRUE)
}

usePackage("downloader")
usePackage("dplyr")
usePackage("stringr")

if (!file.exists("./UCI HAR Dataset")) {
  download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="UCI_HAR_Dataset.zip", mode="wb")
  unzip ("UCI_HAR_Dataset.zip")
}

if (!file.exists("./UCI HAR Dataset/merged")) {
  dir.create("./UCI HAR Dataset/merged")
}