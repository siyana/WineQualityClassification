source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))
#install.packages("randomForest")
library(hydroGOF)
library(randomForest)

dropColumnNames = c("quality", "chlorides", "residual.sugar", "fixed.acidity", "free.sulfur.dioxide")
#RedWineTrain
redWineTrain = read.csv(redWineTrainPath)

attach(redWineTrain)
a = as.factor(redWineTrain$quality)
#columnsTrain = redWineTrain[,!names(redWineTrain) %in% dropColumnNames]
columnsTrain = data.frame(alcohol = redWineTrain$alcohol, sulphates = redWineTrain$sulphates)
trainData = data.frame(columnsTrain,quality = a)

redWineTest = read.csv(redWineTestPath)
attach(redWineTest)
b = as.factor(redWineTest$quality)
#columnsTest = redWineTest[,!names(redWineTest) %in% dropColumnNames]
columnsTest = data.frame(alcohol = redWineTest$alcohol, sulphates = redWineTest$sulphates)
testData = data.frame(columnsTest,quality = b)

errorsDF = data.frame()
for (i in 10:100) {
#i = 15
    randomForestModel <- randomForest(trainData$quality ~ ., data=trainData, ntree=i, proximity=TRUE)
    #table(predict(rf), data$quality)
    #plot(rf)
    #legend()

    pred <- predict(randomForestModel, newdata=testData)
    #table(pred, testData$quality)
#table = table(pred,testData$quality)
#emptyRow = c(0,0,0,0,0,0,0)
#table = cbind(emptyRow,table )
#precision(table)
#recall(table)
#f1(table)
    #estimate RMSE
    predNum = as.numeric(pred)
    err = rmse(predNum,redWineTest$quality)
    errorsDF = rbind(errorsDF, data.frame(numThree = i, rmse = err))
}

png(filename=boxplotFileName("redWine", "rmseAlcohol&Sulphates"))
plot(errorsDF)
dev.off()

errorsRedWinePath = paste(basePath,"results//redWineRandomForestErrorsAlcohol&Sulphates.csv",sep = "")
write.csv(errorsDF, file = errorsRedWinePath,row.names = FALSE, fileEncoding = "UTF-8")
