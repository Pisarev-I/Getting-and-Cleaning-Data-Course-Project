---
title: "README"
author: "pisarev.ik"
date: "2018 M03 7"
output: html_document
---

## Script "run_analysis.R" work:
1. Data downloaded from
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Test and Train data set from files "X_test.txt" and "X_train.txt" merged to one data set
3. Variables names get from file "features.txt"
4. Get only columns with "mean()" and "std()" in name
5. Add activity names from file "activity_labels.txt"
6. Aggregate and order by Subject and Activity
