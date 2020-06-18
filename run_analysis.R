
##Reading in the main data sets i.e. data, labels and subject id

xtestdata    <- read.table("./test/x_test.txt")         # testdata
xtraindata    <- read.table("./train/x_train.txt")      # traindata
ytestdata    <- read.table("./test/y_test.txt")         # testlabel
ytraindata    <- read.table("./train/y_train.txt")      # trainlabel
testsubjects <- read.table("./test/subject_test.txt")   # testsubjects
trainsubjects <- read.table("./train/subject_train.txt") # testsubjects


##merging the  above data 

Data <- rbind(xtestdata,xtraindata)
Label <- rbind(ytestdata,ytraindata)
Subjects <- rbind(testsubjects,trainsubjects)



##extracting only measurements with "mean" and "Std"
features <- read.table("./features.txt")                
features<-features[,2]                                 
names(Data)<-NULL
names(Data)<-features                               
Data_filtered <- Data[grep("*[Mm]ean|*std", names(Data))]
     

##read other important files

activityLabels <-read.table("./activity_labels.txt")  ##read the activity_labels data
activity<-as.factor(Label$V1)                         ##create object "activity" using the factor of "Label" created earlier
levels(activity)<-activityLabels$V2                   ##levels assigned to the contents of second column in "activityLabels

subjects <- as.factor(Subjects$V1)                    ##transform "Subject" to a factor in preparation for later analysis     


TData <- cbind(subjects,activity,Data_filtered)       

##Appropriately labels the data set with descriptive variable names.

col_list<-gsub("^t","time",names(TData))
col_list<-gsub("^f","frequency",col_list)
col_list<-gsub("Gyro","Gyroscope",col_list)
col_list<-gsub("Acc","Accelerometer",col_list)
col_list<-gsub("-X","Xaxis",col_list)
col_list<-gsub("-Y","Yaxis",col_list)
col_list<-gsub("-Z","Zaxis",col_list)
col_list<-gsub("mean","Mean",col_list)
col_list<-gsub("Mag","Magnitude",col_list)
col_list<-gsub("std","Std",col_list)
col_list<-gsub("-","",col_list)
colnames(TData)=col_list


##save the dataframe as a csv and text files


write.csv(TData, file="cleanData.csv")
write.table(TData, "cleanData.txt", sep="\t")

##melt the clean data based on the subject and activity, determine the average for each activity and subject

library(reshape2)
TDataMelt <- melt(TData,id.vars=c("subjects","activity"))
tidyData <- dcast(TDataMelt,subjects + activity ~ variable,mean)


##create csv and text files of the melted tidy data

write.csv(TDataMelt, file="tidyDataLean.csv")
write.table(tidyData, "tidyDataLean.txt", sep="\t")
write.csv(tidyData, file="tidyDataLean.csv")
