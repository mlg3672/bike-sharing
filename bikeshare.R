# This script creates a submission file for the kaggle
# competiton on bike sharing in DC
library(ggplot2)
library(lubridate)
library(randomForest)
library("lattice")
set.seed(8)
setwd("~/Documents/KaggleProjects/bike-sharing")

train<-read.csv("data/train.csv")
test<-read.csv("data/test.csv")

#function to add transformations to data
extractFeatures <- function(data) {
  features <- c("season",
                "holiday",
                "workingday",
                "weather",
                "temp",
                "atemp",
                "humidity",
                "windspeed",
                "hour", 
                "month", 
                "year",
                "day",
                "night")
  data$hour <- hour(ymd_hms(data$datetime))
  data$month <-month(ymd_hms(data$datetime))
  data$year <- year(ymd_hms(data$datetime))
  data$day <- wday(as.Date(data$datetime,label=TRUE))
  data$night <- lapply(data$hour,function (x) as.integer(x>7))
  return(data[,features])
}

trainF<-extractFeatures(train)
xnames <- colnames(train)[1:11]
featurePlot(x=train[, xnames], y=train$count, plot="pairs")

# random forest prediction algorithm
rf <- randomForest(extractFeatures(data), data$count, ntree=100, importance=TRUE)
imp <- importance(rf, type=1)
featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])

# uniform 
submission <-data.frame(datetime=test$datetime, 	
	count=50)
	
# write submission file
write.csv(submission, file = 
	"data/1_uniform_submission.csv", row.names=FALSE)
	
# compare submission to test

# plot to explore data features
p <- ggplot(featureImportance, aes(x=reorder(Feature, Importance), y=Importance)) +
     geom_bar(stat="identity", fill="#53cfff") +
     coord_flip() + 
     theme_light(base_size=20) +
     xlab("Importance") +
     ylab("") + 
     ggtitle("Random Forest Feature Importance\n") +
     theme(plot.title=element_text(size=18))
# save graph
ggsave("graphs/2_feature_importance.png", p)

# fit a linear model to the data
lm(data)

# explore data with plots
ddd <- subset(train, select=c("weather", "atemp", "humidity", "count"))
pairs(ddd)
qplot(season,count,data=data)
xyplot(count ~ temp, group=season,
		data=data[data$year==2012], 	
		auto.key=list(space="right"), 
		jitter.x=TRUE, jitter.y=TRUE)
hist(data$temp,main="Temperature Distribution", 
		xlab="Temperature (Celsius)", 	
		col="green",breaks=25)
rug(data$temp)
boxplot(count~temp,data=data, col="red", main="Temperature versus Bike Use", xlab="Temperature", ylab="Count")