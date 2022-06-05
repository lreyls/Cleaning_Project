#download and unzip data

library(dplyr)

fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile=".\\project.zip")
unzip(".\\project.zip")

#Create one data set

testsubject <- read.table("UCI HAR Dataset\\test\\subject_test.txt")
testset <- read.table("UCI HAR Dataset\\test\\X_test.txt")
testlabel <- read.table("UCI HAR Dataset\\test\\y_test.txt")

trainsubject <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
trainset <- read.table("UCI HAR Dataset\\train\\X_train.txt")
trainlabel <- read.table("UCI HAR Dataset\\train\\y_train.txt")

Totalsubject <- rbind(testsubject, trainsubject)
Totallabel <- rbind(testlabel,trainlabel)
Totalset <- rbind(testset,trainset)

Data <- cbind(Totalsubject,Totallabel,Totalset)

# Q2. Keep mean and sd variables
  #First. Assign names to the columns
col_names <- read.table("UCI HAR Dataset\\features.txt")[,2]
col_names [1]<-"subject"
col_names [2]<-"activity"

colnames(Data) <- col_names 
 
   #Second. select columns

Data<- Data %>% select(contains('subject')|contains('activity')
                       |contains('mean()')|contains('std()'))

#Q3. name the activities

activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt")

for (i in 1:6) {
  tmp <- i
  Data[,2] <- gsub(tmp, activity_labels[tmp,2], Data[,2])
}

#Q4. Clean names

DataCols <- colnames(Data)

DataCols <- gsub("[\\(\\)-]", "", DataCols)
DataCols <- gsub("^f", "freq", DataCols)
DataCols <- gsub("^t", "time", DataCols)

colnames(Data) <- DataCols

#Q5. Second dataset

DataMeans <- Data %>%
  group_by(activity,subject) %>%
  summarise_each(funs(mean))

write.table(DataMeans, "tidydataset.txt", row.names = FALSE)





