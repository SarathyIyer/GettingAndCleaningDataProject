==================================================================
Getting and Cleaning Data Project
Version 1.0
==================================================================

The cleaned up data is a result of data melted and summarized based on the understanding of
the requirement. The data from training and the test directory were read and stored in appropriate variables.
The dataset were combined to single data set. They were given appropriate labels. Using the Tidy data principle,
the data was melted. Finally they are summarized to provide the average of the data based on Subject, activity name.
I split the experiment as "Experiment variable",Experiment Value type ( mean or std deviation) and axis.

The data was tied in stages the o/p of which will be provided 
a. The program is sourced in R, and the functional call is made
b. The directory names are accepted as input to the function. The path can be relative to the
	working directory of R or absolute path. either way the directory has to have / at the end of the 
	path as file names are in the program.
c.	1st part of the program imports the libraries into the program. Main packages used are plyr, dplyr, reshape2.
d.  Program prints statements to let the user know where the current execution of the program is. Easier to debug
e.  2nd Section works basically on the "train" files. Reads the x_train.txt, y_train.txt, subject_train.txt. Also read
	are activity.txt, feature.txt. It then creates a training file with heading, add the subject, activity etc
	to the training file. In my opinion, it is easier to handle the data with headings in it.
	Here is the sample data. Variable stored is called "xTrainData". All 561 features and subject, activity and type( Training/Testing)
	are added to this data
f. Same is performed for Test data set. The data is stored in "xTestData".
g. Next step is to combine Test and training data sets
h. Since both datasets have same of column names and types xData is the resultant data from rbinding the xTrainData and xTestData
i. Now the activity data set that has the random columns is replaced with a sensible column names
j. Join xData and activityLabel to xDataWithActivty using activity to make sure the activity name appears in the data set
k. Retain activity names in xDataWithActivty and activity. Thats what is requested in the assignment
l. Using couple of grep functions, filter only mean, avg, std, Mean from xDataWithActivty to form a subset. reqColumnsSkinning
   and columnsSubset holds the required columns for the data set. These are descriptive column anyone can understand
m. xSubsetDataWithActivity contains only the subset with mean, std, activity, subject, type(Train/Test)
n. Reshape the data using melt function. Ids used for melt are subject, activityname and type. All the feature variable mean/stds were
	used as measurements.
> head(xSubsetDataWithActivityMelt,n=5)
  Subject  Type ActivityName          variable     value
1       1 Train      WALKING tBodyAcc-mean()-X 0.2820216
2       1 Train      WALKING tBodyAcc-mean()-X 0.2558408
3       1 Train      WALKING tBodyAcc-mean()-X 0.2548672
4       1 Train      WALKING tBodyAcc-mean()-X 0.3433705
5       1 Train      WALKING tBodyAcc-mean()-X 0.2762397
o. I split the variable data into feature, measure type and axis using split str function. SplitString added data if there is no value.
	Some of the varibles do not axis. Fixed that issue
p.	Changed the column names to appropriate readable format
> head(xSubsetDataWithActivityMelt2,n=5)
  Subject AssessmentType ActivityName     value ExperimentVariable ExperimentValueType ExperimentVariableAxis
1       1          Train      WALKING 0.2820216           tBodyAcc              mean()                      X
2       1          Train      WALKING 0.2558408           tBodyAcc              mean()                      X
3       1          Train      WALKING 0.2548672           tBodyAcc              mean()                      X
4       1          Train      WALKING 0.3433705           tBodyAcc              mean()                      X
5       1          Train      WALKING 0.2762397           tBodyAcc              mean()                      X
>q. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> head(cdata,n=5)
  Subject ActivityName   ExperimentVariable       Mean
1       1       LAYING             fBodyAcc -0.5812895
2       1       LAYING         fBodyAccJerk -0.6114714
3       1       LAYING          fBodyAccMag -0.5245533
4       1       LAYING  fBodyBodyAccJerkMag -0.5295711
5       1       LAYING fBodyBodyGyroJerkMag -0.5661806

==========================================================================

Execution Instructions:

a.	Download the experiment files to a data directory
d.	Identify which directory the output of the tidy file needs to be created
c. 	Source the run_analysis.R
d.	run the function run_analysis(dirName,targetDirectoryName) - The directory name should include / at the end
		  source("C:/Tools/R/workdir/R-Repository/Week2Project/run_analysis.R")
		  run_analysis(dirName="./data/week2proj/",targetDirectoryName="./data/") 

The dataset includes the following files:
=========================================

- 'README.txt'

- 'Codebook.txt'

- run_analysis.R

- 'TidyDataWithMeanAndStdDevData.txt'

Notes: 
======
- Features are normalized and bounded within [-1,1].
- 

