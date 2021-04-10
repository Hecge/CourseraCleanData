#Loading libraries
library(dplyr)

#Loading the data and naming it
dat <- readLines('UCI HAR Dataset/features.txt')
df <- read.table('UCI HAR Dataset/train/X_train.txt', header = FALSE, col.names = dat)
df <- rbind(df, read.table('UCI HAR Dataset/test/X_test.txt', header = FALSE, col.names = dat))
df <- df[,grepl("(mean|std)\\.", names(df))]

#Loading activity and subject columns
activities <- readLines('UCI HAR Dataset/train/y_train.txt')
activities <- append(activities, readLines('UCI HAR Dataset/test/y_test.txt'))
df$activity = activities

subjects <- readLines('UCI HAR Dataset/train/subject_train.txt')
subjects <- append(subjects, readLines('UCI HAR Dataset/test/subject_test.txt'))
df$subject = subjects

#Changing the values of activity column
df$activity[df$activity == '1'] <- 'WALKING'
df$activity[df$activity == '2'] <- 'WALKING_UPSTAIRS'
df$activity[df$activity == '3'] <- 'WALKING_DOWNSTAIRS'
df$activity[df$activity == '4'] <- 'SITTING'
df$activity[df$activity == '5'] <- 'STANDING'
df$activity[df$activity == '6'] <- 'LAYING'

#Creating a new data frame with the means of all columns grouped by activity and subject
df2 <- df %>% group_by(activity, subject) %>% summarise(across(everything(), list(mean)))

#Printing results in a file
write.table(df2, file = "Avg_DataFrame.txt", row.name = FALSE)