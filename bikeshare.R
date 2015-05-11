# This script creates a submission file for the kaggle
# competiton on bike sharing in DCttt
library(ggplot2)
library(lubridate)
library(randomForest)

setwd("~/Documents/KaggleProjects/bike-sharing")

data<-read.csv("data/train.csv")

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
                "year")
  data$hour <- hour(ymd_hms(data$datetime))
  data$month <-month(ymd_hms(data$datetime))
  data$year <- year(ymd_hms(data$datetime))
  return(data[,features])
}
rf <- randomForest(extractFeatures(data), data$count, ntree=100, importance=TRUE)
imp <- importance(rf, type=1)
featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])

p <- ggplot(featureImportance, aes(x=reorder(Feature, Importance), y=Importance)) +
     geom_bar(stat="identity", fill="#53cfff") +
     coord_flip() + 
     theme_light(base_size=20) +
     xlab("Importance") +
     ylab("") + 
     ggtitle("Random Forest Feature Importance\n") +
     theme(plot.title=element_text(size=18))

ggsave("graphs/2_feature_importance.png", p)