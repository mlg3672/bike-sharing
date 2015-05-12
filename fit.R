# This script compares the fit of the submission 
# method to the training data set
library(lubridate)

train<-read.csv("data/train.csv")
sub<-read.csv("data/1_uniform_submission.csv")

# calculate and add columns month, day, year, and monyear 
# to training data
train$year <- year(ymd_hms(train$datetime))
train$month <- month(ymd_hms(train$datetime))
train$day <- mday(as.Date(train$datetime,label=TRUE))
train$monyear <- interaction(train$month,train$year,sep="-")

# extract counts between 11th and 19th of each 
# month, split usig factors for each year, month
xt <- data.frame(cbind(train$datetime,train[train$day>10,], monyear=train$monyear,train$count
s<-split(xt,xt$monyear)

# return results to dataframe
as.data.frame(do.call(rbind, results))

# get and compare mean
x <-lapply(s, mean)
test
y = sum(train[2,]-test[2,])

# compare median
apply(s,,2,median)
# plot chronologically