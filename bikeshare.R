# This script creates a submission file for the kaggle
# competiton on bike sharing in DC
library(ggplot2)
library(lubridate)
library(randomForest)

setwd("~/Documents/KaggleProjects/Bike Sharing DC/data")

data<-read.csv("train.csv")

data$hour <- hour(ymd_hms(data$datetime))
data$month <-month(ymd_hms(data$datetime))
data$year <- year(ymd_hms(data$datetime))

