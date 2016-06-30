#Train on whiteWine test with redWine
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

redWineTest = read.csv(redWineTrainPath)
attach(redWineTest)
b = as.factor(redWineTest$quality)
testData = data.frame(redWineTest[,1:11],quality = b)

randomForestModel <- randomForest(trainData$quality ~ ., data=trainData, ntree=15, proximity=TRUE)


pred <- predict(randomForestModel, newdata=testData)


 #estimate RMSE
 predNum = as.numeric(pred)
 err = rmse(predNum,redWineTest$quality)
table = table(pred,redWineTest$quality)
emptyRow = c(0,0,0,0,0,0,0)
table = cbind(table, emptyRow)
precision(table)
recall(table)
f1(table)