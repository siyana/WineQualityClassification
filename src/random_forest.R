source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))

#WhiteWineTrain
whiteWineTrain = read.csv(whiteWineTrainPath)

attach(whiteWineTrain)

install.packages("randomForest")
library(randomForest)
a = as.factor(whiteWineTrain$quality)
data = data.frame(whiteWineTrain[,1:11],quality = a)
rf <- randomForest(data$quality ~ ., data=data, ntree=50, proximity=TRUE)
table(predict(rf), data$quality)
plot(rf)
legend()
whiteWineTest = read.csv(whiteWineTestPath)
b = as.factor(whiteWineTest$quality)
testData = data.frame(whiteWineTest[,1:11],quality = b)
pred <- predict(rf, newdata=testData)
table(pred, testData$quality)

plot(table(rf), table(pred, testData$quality))