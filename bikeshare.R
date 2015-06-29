# This script creates a submission file for the kaggle
# competiton on bike sharing in DC
library(ggplot2)
library(lubridate)
library(randomForest)
library("lattice")
library(caret)
set.seed(8)
setwd("~/Documents/KaggleProjects/bike-sharing")

train<-read.csv("data/train.csv")
test<-read.csv("data/test.csv")


#function capture feature other than count and transform data
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
                "weekday",
                "monthday",
                "night")
  data$hour <- hour(ymd_hms(data$datetime))
  data$month <-month(ymd_hms(data$datetime))
  data$year <- year(ymd_hms(data$datetime))
  data$monthday <- mday(ymd_hms(data$datetime))
  data$weekday <- wday(as.Date(data$datetime,label=TRUE))
  data$night <- lapply(data$hour,function (x) as.integer(x>7))
  return(data[,features])
}

#split train into testing, validation, and training
inBuild<-createDataPartition(y=train$count,p=0.6,list=FALSE)
validation<-train[inBuild,]
buildData<-train[-inBuild,]
inTrain<- createDataPartition(y=buildData$count,p=0.6,list=FALSE)
training<-buildData[inTrain,]
testing<-buildData[-inTrain,]

# split data by time 
## use first 10 days to predict next 7 days
ts1 <- extractFeatures(train)
ts1$count <- train$count
tsTrain<-ts1[ts1$monthday<=10,]
tsTest<-ts1[ts1$monthday>10,]

## try use time series to view data
ts1 <- ts(train[,-c(10,11)], frequency = 24)
ts1Train<-window(ts1,start=1,end=5)
ts1Test<-window(ts1,start=5,end=(7-0.01))
plot(ts1Train)
# moving average


# exponential smoothing
ets1 <- ets(ts1Train,model="MMM")
fcast <-forecast(ets1)
plot(fcast,col="black")
lines(ts1Test,col="red")
xnames <- colnames(training)[1:11]
featurePlot(x=training[, xnames], y=training$count, plot="pairs") # warning takes > 5 min

# random forest prediction algorithm
rf <- randomForest(extractFeatures(training), training$count, ntree=100, importance=TRUE)
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
