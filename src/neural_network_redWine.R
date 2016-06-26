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

maxis = 1000
size = 100

redTrainResultsPath = paste(basePath,"//results//NN//redWine_matrix_train.csv", sep = "")
redTestResultsPath =  paste(basePath,"//results//NN//redWine_matrix_test.csv", sep = "")
write(paste("max iter:",maxis,"size:",size), redTrainResultsPath , append = TRUE)
write(paste("max iter:",maxis,"size:",size), redTestResultsPath , append = TRUE)


inputTest = redWineTest[,1:11]
outputTest = decodeClassLabels(redWineTest$quality)
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
  write(paste("-----", "l =",l), redTestResultsPath , append = TRUE)
  write.table(y, redTestResultsPath , append = TRUE)
}
empty_col = c(0,0,0,0,0,0,0)
# best models l = 0.64,0.94
l = 0.64
model_64 <- mlp(trainData$inputsTrain, trainData$targetsTrain, size = size,
learnFuncParams = l, maxis = maxis)
predictions <- predict(model_64,inputTest)
matrix_64 = confusionMatrix(outputTest, predictions)
matrix_64 = cbind(empty_col, empty_col,matrix_64,empty_col, empty_col)
f1(matrix_64)

l = 0.94
model_94 <- mlp(trainData$inputsTrain, trainData$targetsTrain, size = size,
learnFuncParams = l, maxis = maxis)
predictions <- predict(model_94,inputTest)
matrix_94 = confusionMatrix(outputTest, predictions)
matrix_94 = cbind(empty_col, empty_col,matrix_94,empty_col,empty_col)
f1(matrix_94)