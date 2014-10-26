if (!getwd() == "./sampleGACDproject") {
    dir.create("./sampleGACDproject")
 }
rm(list = ls(all = TRUE))
rm(list = ls(all = TRUE))
library(plyr) # load plyr first, then dplyr 
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE) #This provides the list of variables and I choose the ones that are applicable for this data set
YTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
XTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
SubjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
YTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
XTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
SubjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
Features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
unlink(temp) # very important to remove this
colnames(XTrain) <- t(Features[2])
colnames(XTest) <- t(Features[2])
XTrain$activities <- YTrain[, 1]
XTrain$participants <- SubjectTrain[, 1]
XTest$activities <- YTest[, 1]
XTest$participants <- SubjectTest[, 1]
Master <- rbind(XTrain, XTest)
duplicated(colnames(Master))
Master <- Master[, !duplicated(colnames(Master))]
Mean <- grep("mean()", names(Master), value = FALSE, fixed = TRUE)
#In addition, we need to include 555:559 as they have means and are associated with the gravity terms
Mean <- append(Mean, 471:477)
InstrumentMeanMatrix <- Master[Mean]
# For STD
STD <- grep("std()", names(Master), value = FALSE)
InstrumentSTDMatrix <- Master[STD]
Master$activities <- as.character(Master$activities)
Master$activities[Master$activities == 1] <- "Walking"
Master$activities[Master$activities == 2] <- "Walking Upstairs"
Master$activities[Master$activities == 3] <- "Walking Downstairs"
Master$activities[Master$activities == 4] <- "Sitting"
Master$activities[Master$activities == 5] <- "Standing"
Master$activities[Master$activities == 6] <- "Laying"
Master$activities <- as.factor(Master$activities)
names(Master)  # survey the data
names(Master) <- gsub("Acc", "Accelerator", names(Master))
names(Master) <- gsub("Mag", "Magnitude", names(Master))
names(Master) <- gsub("Gyro", "Gyroscope", names(Master))
names(Master) <- gsub("^t", "time", names(Master))
names(Master) <- gsub("^f", "frequency", names(Master))
Master$participants <- as.character(Master$participants)
Master$participants[Master$participants == 1] <- "Participant A"
Master$participants[Master$participants == 2] <- "Participant B"
Master$participants[Master$participants == 3] <- "Participant C"
Master$participants[Master$participants == 4] <- "Participant D"
Master$participants[Master$participants == 5] <- "Participant E"
Master$participants[Master$participants == 6] <- "Participant F"
Master$participants[Master$participants == 7] <- "Participant G"
Master$participants[Master$participants == 8] <- "Participant H"
Master$participants[Master$participants == 9] <- "Participant I"
Master$participants[Master$participants == 10] <- "Participant I"
Master$participants[Master$participants == 11] <- "Participant K"
Master$participants[Master$participants == 12] <- "Participant L"
Master$participants[Master$participants == 13] <- "Participant M"
Master$participants[Master$participants == 14] <- "Participant N"
Master$participants[Master$participants == 15] <- "Participant O"
Master$participants[Master$participants == 16] <- "Participant P"
Master$participants[Master$participants == 17] <- "Participant Q"
Master$participants[Master$participants == 18] <- "Participant R"
Master$participants[Master$participants == 19] <- "Participant S"
Master$participants[Master$participants == 20] <- "Participant T"
Master$participants[Master$participants == 21] <- "Participant U"
Master$participants[Master$participants == 22] <- "Participant V"
Master$participants[Master$participants == 23] <- "Participant W"
Master$participants[Master$participants == 24] <- "Participant X"
Master$participants[Master$participants == 25] <- "Participant Y"
Master$participants[Master$participants == 26] <- "Participant Z"
Master$participants[Master$participants == 27] <- "Participant AA"
Master$participants[Master$participants == 28] <- "Participant AB"
Master$participants[Master$participants == 29] <- "Participant AC"
Master$participants[Master$participants == 30] <- "Participant AD"
Master$participants <- as.factor(Master$participants)
Master.dt <- data.table(Master)
#This takes the mean of every column broken down by participants and activities
TidyData <- Master.dt[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = "Tidy333.txt", row.names = FALSE)
