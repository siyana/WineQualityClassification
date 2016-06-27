#install.packages("RSNNS")
library("Rcpp")
library("RSNNS")

source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))

#redWineTrain
redWineTrain= read.csv(redWineTrainPath)

attach(redWineTrain)

#redWineTest 
redWineTest = read.csv(redWineTestPath)
attach(redWineTest)

inputTrain = redWineTrain[,1:11];
outputTrain = decodeClassLabels(redWineTrain$quality)
trainData <- splitForTrainingAndTest(inputTrain , outputTrain , ratio = 0)
trainData <- normTrainingAndTestSet(trainData)

inputTest = redWineTest[,1:11]
outputTest = decodeClassLabels(redWineTest$quality)

maxis = 1000
size = 100

redTrainResultsPath = paste(basePath,"//results//NN//redWine_matrix_train.csv", sep = "")
redTestResultsPath =  paste(basePath,"//results//NN//redWine_matrix_test.csv", sep = "")
write(paste("max iter:",maxis,"size:",size), redTrainResultsPath , append = FALSE)
write(paste("max iter:",maxis,"size:",size), redTestResultsPath , append = FALSE)

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
  
  write(paste("-----", "l =",l), redTrainResultsPath , append = TRUE)
  write.table(x, redTrainResultsPath , append = TRUE)
  y = confusionMatrix(outputTest, predictions)
  currentSum = diagSum(outputTest, y)
  if (currentSum > maxSum) {
    maxSum = currentSum
    maxL = l;
    maxModelMatrix = y 
  }
  write(paste("-----", "l =",l), redTestResultsPath , append = TRUE)
  write(paste("-----", "accuracy: ", currentSum/nrow(outputTest)), redTestResultsPath , append = TRUE)
  write.table(y, redTestResultsPath , append = TRUE)
}

write(paste("-----\n", "maxAccuracy: ", maxSum/nrow(outputTest), ", l = ", maxL), redTestResultsPath , append = TRUE)
empty_col = c(0,0,0,0,0)
matrix = cbind(empty_col, empty_col,maxModelMatrix,empty_col, empty_col)


write.table(paste("-----\n", "f1: ", f1(matrix)), redTestResultsPath , append = TRUE)
write.table(paste("precision: ", precision(matrix)), redTestResultsPath , append = TRUE)
write.table(paste("recall: ", recall(matrix)), redTestResultsPath , append = TRUE)