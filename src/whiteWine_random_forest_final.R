library (ROCR);

source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))
#install.packages("randomForest")
library(hydroGOF)
library(randomForest)

#WhiteWineTrain
whiteWineTrain = read.csv(whiteWineTrainPath)

attach(whiteWineTrain)
a = as.factor(whiteWineTrain$quality)
trainData = data.frame(whiteWineTrain[,1:11],quality = a)

whiteWineTest = read.csv(whiteWineTestPath)
attach(whiteWineTest)
b = as.factor(whiteWineTest$quality)
testData = data.frame(whiteWineTest[,1:11],quality = b)

randomForestModel <- randomForest(trainData$quality ~ ., data=trainData, ntree=10, proximity=TRUE)
#table(predict(rf), data$quality)
#plot(rf)
#legend()

pred <- predict(randomForestModel, newdata=testData)
#table(pred, testData$quality)

 #estimate RMSE
 predNum = as.numeric(pred)
 err = rmse(predNum,whiteWineTest$quality)

png(filename=boxplotFileName("whiteWine", "rmse"))
plot(errorsDF)
dev.off()

errorsWhiteWinePath = paste(basePath,"results//whiteWineRandomForestErrors.csv",sep = "")
write.csv(errorsDF, file = errorsWhiteWinePath,row.names = FALSE, fileEncoding = "UTF-8")
