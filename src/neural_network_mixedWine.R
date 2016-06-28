#install.packages("RSNNS")
library("Rcpp")
library("RSNNS")

source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))

#mixedWineTrain
dropColumnNames = c("chlorides", "residual.sugar", "fixed.acidity", "free.sulfur.dioxide")
mixedWineTrain = read.csv(mixedWineTrainPath)

attach(mixedWineTrain)
columnsTrain = mixedWineTrain[,!names(mixedWineTrain) %in% dropColumnNames]
#WhiteWineTest
whiteWineTest = read.csv(whiteWineTestPath)
attach(whiteWineTest)

#inputTrain = mixedWineTrain[,1:11];
inputTrain = columnsTrain
outputTrain = decodeClassLabels(columnsTrain$quality)
trainData <- splitForTrainingAndTest(inputTrain , outputTrain , ratio = 0)
trainData <- normTrainingAndTestSet(trainData)

maxis = 1000
size = 100

columnsTest = whiteWineTest[,!names(whiteWineTest) %in% dropColumnNames]
inputTest = columnsTest
outputTest = decodeClassLabels(columnsTest$quality)

mixedWineTrainResultsPath = paste(basePath,"//results//NN//mixed_whiteWine_matrix_train.csv", sep = "")
whiteTestResultsPath =  paste(basePath,"//results//NN//mixed_whiteWine_matrix_test.csv", sep = "")
write(paste("max iter:",maxis,"size:",size), mixedWineTrainResultsPath , append = FALSE)
write(paste("max iter:",maxis,"size:",size), whiteTestResultsPath , append = FALSE)

maxSum = -1;
maxL = -1;
maxModelMatrix = NULL
maxSumComponents = c()
for(i in 1:100) {
  print(i)
  l = i/100
  model <- mlp(trainData$inputsTrain, trainData$targetsTrain, size = size,
  learnFuncParams = l, maxis = maxis)
  predictions <- predict(model,inputTest)
  x = confusionMatrix(trainData$targetsTrain, fitted.values(model))
  write(paste("-----", "l =",l), mixedWineTrainResultsPath , append = TRUE)
  write.table(x, mixedWineTrainResultsPath , append = TRUE)
  y = confusionMatrix(outputTest, predictions)
  accuracy = diagSum(outputTest, y)[1]/nrow(outputTest)
  recall = diagSum(outputTest, y)[1]/diagSum(outputTest, y)[2]
  currentSum = accuracy + recall
  if (currentSum > maxSum) {
    maxSum = currentSum
    maxL = l;
    maxModelMatrix = y 
    maxSumComponents = c(accuracy,recall)
  }
  write(paste("-----", "l =",l), whiteTestResultsPath , append = TRUE)
  write(paste("-----", "sum: ", currentSum), whiteTestResultsPath , append = TRUE)
  write(paste("-----", "recall: ", recall), whiteTestResultsPath , append = TRUE)
  write(paste("-----", "accuracy: ", accuracy), whiteTestResultsPath , append = TRUE)
  write.table(y,whiteTestResultsPath , append = TRUE)
}

write(paste("-----\n", "maxSum: ", maxSum, ", l = ", maxL), whiteTestResultsPath, append = TRUE)
write(paste("-----\n", "recall: ", maxSumComponents[2],"accuracy;",maxSumComponents[1], ", l = ", maxL), whiteTestResultsPath, append = TRUE)
empty_col = c(0,0,0,0,0,0,0)
matrix = cbind(empty_col, empty_col,maxModelMatrix,empty_col, empty_col, empty_col)

#write.table(paste("-----\n", "f1: ", f1(matrix)), whiteTestResultsPath, append = TRUE)
#write.table(paste("precision: ", precision(matrix)), whiteTestResultsPath, append = TRUE)
#write.table(paste("recall: ", recall(matrix)), whiteTestResultsPath, append = TRUE)
