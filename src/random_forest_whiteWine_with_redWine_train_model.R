#Train on redWine, test with whiteWine
library (ROCR);
source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))
#install.packages("randomForest")
library(hydroGOF)
library(randomForest)

#RedWineTrain
redWineTrain = read.csv(redWineTrainPath)

attach(redWineTrain)
a = as.factor(redWineTrain$quality)
trainData = data.frame(redWineTrain[,1:11],quality = a)

whiteWineTest = read.csv(whiteWineTrainPath)
attach(whiteWineTest)
b = as.factor(whiteWineTest$quality)
testData = data.frame(whiteWineTest[,1:11],quality = b)

randomForestModel <- randomForest(trainData$quality ~ ., data=trainData, ntree=15, proximity=TRUE)

pred <- predict(randomForestModel, newdata=testData)

 #estimate RMSE
 predNum = as.numeric(pred)
 err = rmse(predNum,whiteWineTest$quality)