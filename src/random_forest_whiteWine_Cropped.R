source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))
#install.packages("randomForest")
library(hydroGOF)
library(randomForest)

dropColumnNames = c("quality", "chlorides", "citric.acid", "free.sulfur.dioxide", "dencity", "fixed.acidity")
#WhiteWineTrain
whiteWineTrain = read.csv(whiteWineTrainPath)

attach(whiteWineTrain)
a = as.factor(whiteWineTrain$quality)
#columnsTrain = whiteWineTrain[,!names(whiteWineTrain) %in% dropColumnNames]
columnsTrain = data.frame(alcohol = whiteWineTrain$alcohol, pH =whiteWineTrain$pH)
trainData = data.frame(columnsTrain,quality = a)

whiteWineTest = read.csv(whiteWineTestPath)
attach(whiteWineTest)
b = as.factor(whiteWineTest$quality)
#columnsTest = whiteWineTest[,!names(whiteWineTest) %in% dropColumnNames]
columnsTest = data.frame(alcohol = whiteWineTest$alcohol, pH =whiteWineTest$pH)
testData = data.frame(columnsTest,quality = b)

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

png(filename=boxplotFileName("whiteWine", "rmseAlcoholeAndPH"))
plot(errorsDF)
dev.off()

errorsWhiteWinePath = paste(basePath,"results//whiteWineRandomForestErrorsAlcoholeAndPH.csv",sep = "")
write.csv(errorsDF, file = errorsWhiteWinePath,row.names = FALSE, fileEncoding = "UTF-8")
