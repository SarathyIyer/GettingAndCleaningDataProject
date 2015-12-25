==================================================================
Getting and Cleaning Data Project
Version 1.0
==================================================================

The cleaned up data is a result of data melted and summarized based on the understanding of
the requirement. The data from training and the test directory were read and stored in appropriate variables.
The dataset were combined to single data set. They were given appropriate labels. Using the Tidy data principle,
the data was melted. Finally they are summarized to provide the average of the data based on Subject, activity name.
I split the experiment as "Experiment variable",Experiment Value type ( mean or std deviation) and axis.

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

