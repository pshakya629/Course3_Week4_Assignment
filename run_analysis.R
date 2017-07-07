################################################################################
## Project: Course 3 Final Assignment
## Script purpose: Cleans and creates Tidy Data from wearable comupting data
## Date: 07/07/2017
## Author: Prabin Shakya
################################################################################


# Initialize
# Set the working directory for the assignment.
# The zipped data file is downloaded and unzipped in a folder named Dataset under the working directory.
setwd("H:\\_R\\Course_3\\Course_3_Week_4_Asn")


#################################################################################
## Task #1. Merges the training and the test sets to create one data set.      ##
#################################################################################

#Read the Test data
testX <- read.table("Dataset\\test\\X_test.txt")
testY <- read.table("Dataset\\test\\y_test.txt", col.names="label")
testSubject <- read.table("Dataset\\test\\subject_test.txt", col.names="subject")
testData <- cbind(testSubject, testY, testX)

# Read Training Data
trainX <- read.table("Dataset\\train\\X_train.txt")
trainY <- read.table("Dataset\\train\\y_train.txt", col.names="label")
trainSubject <- read.table("Dataset\\train\\subject_train.txt", col.names="subject")
trainData <- cbind(trainSubject, trainY, trainX)
  
# Merge to create one data set
data <- rbind(testData,trainData)


#################################################################################
## Task #2. Extracts only the measurements on the mean and standard            ##
##          deviation for each measurement.                                    ##
#################################################################################

# Read Data points from Features file
dataFeatures <- read.table("Dataset\\features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

# Identify mean and SD fields from data points
dataFeaturesSelected <- grep("mean|std",dataFeatures$V2)

######DataFeatureFiltered <- dataFeatures[dataFeaturesSelected,2]

# Filter out unwanted fields from data
dataFiltered<- data[,c(1,2,dataFeaturesSelected+2)]
dataFeaturesFiltered<-dataFeatures[dataFeaturesSelected,]


#################################################################################
## Task #3. Uses descriptive activity names to name the activities             ##
##          in the data set                                                    ##
#################################################################################

# Read the Activity Enum
activityLabels <- read.table("Dataset\\activity_labels.txt", stringsAsFactors=FALSE)

# Insert descriptive activity name into the label field.
dataFiltered$label <- activityLabels[dataFiltered$label, 2]


#################################################################################
## Task #4. Appropriately labels the data set with descriptive variable names. ##
##          in the data set                                                    ##
#################################################################################

columnHeadings<- c("Subject","ActivityLabel",dataFeaturesFiltered$V2)
colnames(dataFiltered) = columnHeadings


#################################################################################
## Task #5. From the data set in step 4, creates a second, independent tidy    ##
##          data set with the average of each variable for each activity       ##
##          and each subject.                                                  ##
#################################################################################

dataAvg <- aggregate(dataFiltered[, 3:ncol(dataFiltered)]
                     ,by=list(subject = dataFiltered$Subject,AnalysisLabel = dataFiltered$ActivityLabel)
                     ,mean)

write.table(dataAvg, "tidyData.txt") 
