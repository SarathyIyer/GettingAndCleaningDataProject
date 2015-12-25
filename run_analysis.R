######################################################################################
## Week2 Data Cleaning Course work Code
## Name: Run Analysis
## Function Name: run_analysis
## Usage: source run_analysis.R
##        from the prompt call run_anlysis(Inputput Directory, Output Directory) 
## Example: source("C:/Tools/R/workdir/R-Repository/Week2Project/run_analysis.R")
##          run_analysis(dirName="./data/week2proj/",targetDirectoryName="./data/") 
## Explanation: 	1. Merges the training and the test sets to create one data set. - Done
##	2. Extracts only the measurements on the mean and standard deviation for each measurement.  - Done
##	3. Uses descriptive activity names to name the activities in the data set - Done
##	4. Appropriately labels the data set with descriptive variable names. - Done
##	5. From the data set in step 4, creates a second, independent tidy data set 
##	with the average of each variable for each activity and each subject.
#######################################################################################
run_analysis<-function(dirName="./data/week2proj/",targetDirectoryName="./data/") {
###Step 0
	###Get the directory where the parent directory exists. I have downloaded the entire data under ./data/week2proj
	 print(" Import Libraries")
	 library("dplyr")
	 library(reshape2)
	 library(plyr)
	 
###Step 1 - Combine the test Data and train data and label with the alphabetically names and include a column names for activity
###a. Assemble the header for the training file
	print(" Read Train Files")
	####Training files
		###Read the activity label
			fName<-paste0(dirName,"activity_labels.txt")
			activityLabel<-read.table(file=fName,fill=TRUE)
		###Read from the subject File
			fName<-paste0(dirName,"train/subject_train.txt")
			subjectTrainLabel<-read.table(file=fName,fill=TRUE)
		###Read the y_train.txt. Add it to the original data. This will help in merge as merge will sort by default
			fName<-paste0(dirName,"train/y_train.txt")
			yTrainLabel<-read.table(file=fName,fill=TRUE)
		####Read the feature.txt - There are 561 column definitions here
			fName<-paste0(dirName,"features.txt")
			featureLabel<-read.table(file=fName,fill=TRUE)
			vecFeatureLabel<-as.vector(featureLabel[,2])
###b.	Add header to the x_train data
			fName<-paste0(dirName,"train/X_train.txt")
			xTrainData<-read.table(file=fName,fill=TRUE)
			colnames(xTrainData)<-c(vecFeatureLabel)
###c.	Add a type called "training or test"  as the subjects participated in the test may be different from the 
###	from the subject participating in the training. After skinning the data we should be able to distingusish them
			xTrainData$Subject<-subjectTrainLabel[,1]
			 xTrainData$Type<-"Train"
###d. Add the activity label to the training data
###   At this time the training data will have the labels for each column, the subject who performed
###   the training and the activity number corresponding to that training. As we will merge the data, it
###   it will have an identifier to say if it is training.
			xTrainData$Activity<-yTrainLabel[,1]
		print(" Read Test Files")	
####   Repeat the same set of steps for testing file
####e. Assemble the header for the testing file
	### Test files
		###Read from the subject File
			fName<-paste0(dirName,"test/subject_test.txt")
			subjectTestLabel<-read.table(file=fName,fill=TRUE)
		###Read the y_test.txt
			fName<-paste0(dirName,"test/y_test.txt")
			yTestLabel<-read.table(file=fName,fill=TRUE)
###f.Add header to the x_test data
			fName<-paste0(dirName,"test/X_test.txt")
			xTestData<-read.table(file=fName,fill=TRUE)
			colnames(xTestData)<-c(vecFeatureLabel)
##g.Add a type called "training or test"  as the subjects participated in the test may be different 
##	from the subject participating in the training. After skinning the data we should be able to distingusish them
			xTestData$Subject<-subjectTestLabel[,1]
			xTestData$Type<-"Test"	
###h. Add the activity label to the training data
			xTestData$Activity<-yTestLabel[,1]
##i. Put the training and testing data together 
			xData<-rbind(xTrainData,xTestData)
##j. Set the column name for activity Data, It is easier to have proper naming for the columns
##   Replacing the random column name ( V1 and V2 )with proper column names
	colnames(activityLabel)<-c("Activity","ActivityName")
###k.  Merge was truncating the column names and join did not. Hence using join instead. Join would do the same work
###    to add activity label in the data set
	 print(" Combine Test Data and Training data into one")	
	 xDataWithActivty<-right_join(xData,activityLabel)
###   Since activity name is there, I am removing activity id from the data set
	 xDataWithActivty<-subset(xDataWithActivty, select=-(Activity))

### The above data set contains training and testing data together with all the columns in descriptive names and subject, 
### activity and the type( training or testing) included in the dataset

###Step - 2 • by the end of Step 2 you have a subset of the original combined raw data set in which the only measurement variables contain either mean or standard deviation (std) in their names;
###Key words to follow are avg, mean, Mean, std,
	  print("Identify Columns to be used in the Step 4 data set")
###a.  Identify the list of colummns are in the data set
	reqColumns<-as.vector(colnames(xDataWithActivty))
###b.	Pick the list of columns required for the exercisereqColumns
	reqColumns<-grep("mean|Mean|avg|std|ActivityName|Subject|Type",reqColumns,value=TRUE)
### Following will be useful while skinning the data
	reqColumnsSkinning<-grep("mean|Mean|avg|std",reqColumns,value=TRUE)
#### Based on the feature information only required details for the project are
### tBodyAcc-XYZ,tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ, tBodyGyroJerk-XYZ
### tBodyAccMag,tGravityAccMag,tBodyAccJerkMag,tBodyGyroMag,tBodyGyroJerkMag
### fBodyAcc-XYZ,fBodyAccJerk-XYZ,fBodyGyro-XYZ,fBodyAccMag,fBodyAccJerkMag
### fBodyGyroMag,fBodyGyroJerkMag. Following statement will trim the data further to only
### these measurements
	reqColumnsSkinning<-grep("^t|^f",reqColumns,value=TRUE)
	columnsSubset<-c("Subject","Type","ActivityName",reqColumnsSkinning)
###c. 	Create the subset of mean and std deviation. I have included the subject and Activity Name and Type to identify later if they required later
	print("Collect Subset of data with mean and std")
	xSubsetDataWithActivity<-subset(xDataWithActivty, select=columnsSubset)	

###Step - 3 by the end of Step 3 you have replaced the numeric codes for activity with the corresponding alphabetic value from another of the data files;
###	- Tidying the data Melting the Data to make it skinny. 1st step is Get the subject ActivityName AssessmentType(Train/Test) Variable 
###   used and the value corresponding to the variable. 

### Library("reshape2")	
###	Subject		ActivityName	Type (Training or Test) Variable			Value
###	1			Walking         Test					tBodyAcc-mean()-X 0.28202157
	print("Melt the data")
	xSubsetDataWithActivityMelt<-melt(xSubsetDataWithActivity,id=c("Subject","Type","ActivityName"),measure.vars=reqColumnsSkinning)
### Melt the Variable value as it has 3 sets of information a.Actual variable for the experiment e.g tBodyAcc
### what is the measure mean/std deviation and 3 third is axis ( optional )
 print("Splitting the Experiment variable into variable, type and axis")
 xSubsetDataWithActivityMelt1<-data.frame(do.call(rbind,strsplit(as.vector(xSubsetDataWithActivityMelt$variable),split="-")))
 xSubsetDataWithActivityMelt2<-cbind(xSubsetDataWithActivityMelt,xSubsetDataWithActivityMelt1$X1,xSubsetDataWithActivityMelt1$X2,xSubsetDataWithActivityMelt1$X3)
 print("Re naming the column variables that are better")
 colnames(xSubsetDataWithActivityMelt2)<-c("Subject","AssessmentType","ActivityName","variable","value","ExperimentVariable","ExperimentValueType","ExperimentVariableAxis")

###by the end of Step 4 you have modified the original variable names (column names) with names conforming to 
###both the R naming standard and the convention introduced by the tidy data principles; 
###domain experts would likely consider the names as already easy to read but you want non-domain experts to understand the content of each column; 
	xSubsetDataWithActivityMelt2$ExperimentVariableAxis<-revalue(xSubsetDataWithActivityMelt2$ExperimentVariableAxis,c("fBodyAccMag"=NA,"fBodyBodyAccJerkMag"=NA,"fBodyBodyGyroJerkMag"=NA,"fBodyBodyGyroMag"=NA,"tBodyAccJerkMag"=NA,
	"tBodyAccJerkMag"=NA,"tBodyAccMag"=NA, "tBodyGyroJerkMag"=NA, "tBodyGyroMag"=NA,   "tGravityAccMag"=NA  ))
	
### Step 5. Use decast to arrive at mean of the subject		

### Remove the variable. This is "My undertanding of Tidiest Data" based on the papers I read.
	xSubsetDataWithActivityMelt2<-subset(xSubsetDataWithActivityMelt2, select=-(variable))
	print("Collect the mean of Subject and Activity name")
#### Write the data into a file	
	
	cdata<-ddply(xSubsetDataWithActivityMelt2,c("Subject","ActivityName","ExperimentVariable","ExperimentValueType","ExperimentVariableAxis"),summarize,Mean=mean(value))
	print("Write to the target File")
	fName<-paste0(targetDirectoryName,"TidyDataWithMeanAndStdDevData.txt")
	write.table(cdata,fName)
}