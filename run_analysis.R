# read the data
download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile = 'Dataset.zip')
unzip(zipfile = 'Dataset.zip')

#read the data
data_train <- read.table("UCI HAR Dataset/train/X_train.txt")
lables_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

data_test <- read.table("UCI HAR Dataset/test/X_test.txt")
lables_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

collumn_names <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)[,2]

#bind the data
data <- rbind(data_train, data_test)
data_lables <- rbind(lables_train,lables_test)
names(data_lables) <- 'lable'
data_subjects <- rbind(subjects_train, subjects_test)
names(data) <- collumn_names
names(data_subjects) <- 'subjects'

#check on NA values
na_filter <- is.na(data)
any(na_filter)

#Keep only SD and Means and add lable
mean_filter <- as.data.frame(grep("mean()", collumn_names, value=TRUE, fixed = TRUE))
std_filter <- as.data.frame(grep("std()", collumn_names, value=TRUE, fixed = TRUE))
names(mean_filter) <- 'variable'
names(std_filter) <- 'variable'
filter<- as.character(rbind(mean_filter, std_filter)[,1])

data <- cbind(data[,filter],data_lables,data_subjects)

#add lable names
lable_names <- read.table("UCI HAR Dataset/activity_labels.txt")
names(lable_names) <- c('lable', 'name')
data <- merge(lable_names, data)

#create tidy data set
tidy_data <- aggregate(x = data[,filter], by = list(data$name, data$subjects), mean)
colnames(tidy_data)[1:2] <- c('activity', 'subject')
write.table(tidy_data,file = 'tidy_data.txt', row.name = FALSE)

