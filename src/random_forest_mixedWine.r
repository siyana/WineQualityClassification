source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))
#install.packages("randomForest")
library(hydroGOF)
library(randomForest)

#mixedWineTrain
mixedWineTrain = read.csv(mixedWineTrainPath)

attach(mixedWineTrain)
a = as.factor(mixedWineTrain$quality)
trainData = data.frame(mixedWineTrain[,1:11],quality = a)

whiteWineTest = read.csv(whiteWineTestPath)
attach(whiteWineTest)
b = as.factor(whiteWineTest$quality)
testData = data.frame(whiteWineTest[,1:11],quality = b)

errorsDF = data.frame()
for (i in 10:100) {
    randomForestModel <- randomForest(trainData$quality ~ ., data=trainData, ntree=i, proximity=TRUE)
    #table(predict(rf), data$quality)
    #plot(rf)
    #legend()

    pred <- predict(randomForestModel, newdata=testData)
    #table(pred, testData$quality)

    #estimate RMSE
    predNum = as.numeric(pred)
    err = rmse(predNum,whiteWineTest$quality)
    errorsDF = rbind(errorsDF, data.frame(numThree = i, rmse = err))
}

png(filename=boxplotFileName("whiteWine", "mixedTrain - rmse"))
plot(errorsDF)
dev.off()

errorsMixedWinePath = paste(basePath,"results//RF//mixedWineRandomForest_whiteTest_Errors.csv",sep = "")
write.csv(errorsDF, file = errorsMixedWinePath,row.names = FALSE, fileEncoding = "UTF-8")
