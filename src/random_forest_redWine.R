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

redWineTest = read.csv(redWineTestPath)
attach(redWineTest)
b = as.factor(redWineTest$quality)
testData = data.frame(redWineTest[,1:11],quality = b)

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
    err = rmse(predNum,redWineTest$quality)
    errorsDF = rbind(errorsDF, data.frame(numThree = i, rmse = err))
}

png(filename=boxplotFileName("redWine", "rmse"))
plot(errorsDF)
dev.off()

errorsRedWinePath = paste(basePath,"results//redWineRandomForestErrors.csv",sep = "")
write.csv(errorsDF, file = errorsRedWinePath,row.names = FALSE, fileEncoding = "UTF-8")
