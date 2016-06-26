install.packages("RSNNS")
library("Rcpp")
library("RSNNS")

source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))

#WhiteWineTrain
whiteWineTrain = read.csv(whiteWineTrainPath)

attach(whiteWineTrain)

#WhiteWineTest
whiteWineTest = read.csv(whiteWineTestPath)
attach(whiteWineTest)

inputTrain = whiteWineTrain[,1:11];
outputTrain = whiteWineTrain$quality

inputTest = whiteWineTest [,1:11]
outputTest = whiteWineTest$quality

model <- mlp(inputTrain, outputTrain, size = 10,
  learnFunc = "Std_Backpropagation", learnFuncParams = c(0.2, 0),
 maxit = 10, initFunc = "Randomize_Weights", 
 initFuncParams = c(-0.3, 0.3))
predictions <- predict(model, inputTest)
confusionMatrix(outputTrain, fitted.values(model))
confusionMatrix(outputTest, predictions)

weightMatrix(model)

plotIterativeError(model)
plotRegressionError(predictions[, 1], whiteWineTest$quality)
plotROC(fitted.values(model)[, 1], whiteWineTrain$quality[, 2])
plotROC(predictions[, 1], whiteWineTest$quality[, 2])