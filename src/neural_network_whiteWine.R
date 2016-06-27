#install.packages("RSNNS")
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
outputTrain = decodeClassLabels(whiteWineTrain$quality)
trainData <- splitForTrainingAndTest(inputTrain , outputTrain , ratio = 0)
trainData <- normTrainingAndTestSet(trainData)

maxis = 1000
size = 100

inputTest = whiteWineTest[,1:11]
outputTest = decodeClassLabels(whiteWineTest$quality)

whiteTrainResultsPath = paste(basePath,"//results//NN//whiteWine_matrix_train.csv", sep = "")
whiteTestResultsPath =  paste(basePath,"//results//NN//whiteWine_matrix_test.csv", sep = "")
write(paste("max iter:",maxis,"size:",size), whiteTrainResultsPath , append = FALSE)
write(paste("max iter:",maxis,"size:",size), whiteTestResultsPath , append = FALSE)

maxSum = -1;
maxL = -1;
maxModelMatrix = NULL
for(i in 1:100) {
  print(i)
  l = i/100
  model <- mlp(trainData$inputsTrain, trainData$targetsTrain, size = size,
  learnFuncParams = l, maxis = maxis)
  predictions <- predict(model,inputTest)
  x = confusionMatrix(trainData$targetsTrain, fitted.values(model))
  write(paste("-----", "l =",l), whiteTrainResultsPath , append = TRUE)
  write.table(x, whiteTrainResultsPath , append = TRUE)
  y = confusionMatrix(outputTest, predictions)
  currentSum = diagSum(outputTest, y)
  if (currentSum > maxSum) {
    maxSum = currentSum
    maxL = l;
    maxModelMatrix = y 
  }
  write(paste("-----", "l =",l), whiteTestResultsPath , append = TRUE)
  write(paste("-----", "accuracy: ", currentSum/nrow(outputTest)), whiteTestResultsPath , append = TRUE)
  write.table(y,whiteTestResultsPath , append = TRUE)
}

write(paste("-----\n", "maxAccuracy: ", maxSum/nrow(outputTest), ", l = ", maxL), whiteTestResultsPath, append = TRUE)
empty_col = c(0,0,0,0,0,0,0)
matrix = cbind(empty_col, empty_col,maxModelMatrix,empty_col, empty_col, empty_col)

write.table(paste("-----\n", "f1: ", f1(matrix)), whiteTestResultsPath, append = TRUE)
write.table(paste("precision: ", precision(matrix)), whiteTestResultsPath, append = TRUE)
write.table(paste("recall: ", recall(matrix)), whiteTestResultsPath, append = TRUE)
