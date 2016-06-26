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

write(paste("max iter:",maxis,"size:",size), paste(basePath,"//matrix_train.csv", sep = ""), append = TRUE)
write(paste("max iter:",maxis,"size:",size), paste(basePath,"//matrix_test.csv", sep = ""), append = TRUE)


inputTest = whiteWineTest[,1:11]
outputTest = decodeClassLabels(whiteWineTest$quality)
for(i in 1:100) {
  print(i)
  l = i/100
  model <- mlp(trainData$inputsTrain, trainData$targetsTrain, size = size,
  learnFuncParams = l, maxis = maxis)
  predictions <- predict(model,inputTest)
  x = confusionMatrix(trainData$targetsTrain, fitted.values(model))
  write(paste("-----", "l =",l), paste(basePath,"//matrix_train.csv", sep = ""), append = TRUE)
  write.table(x, paste(basePath,"//matrix_train.csv", sep = ""), append = TRUE)
  y = confusionMatrix(outputTest, predictions)
  write(paste("-----", "l =",l), paste(basePath,"//matrix_test.csv", sep = ""), append = TRUE)
  write.table(y, paste(basePath,"//matrix_test.csv", sep = ""), append = TRUE)
}

empty_col = c(0,0,0,0,0,0,0)
# best models l = 0.15,0.32
l = 0.15
model_15 <- mlp(trainData$inputsTrain, trainData$targetsTrain, size = size,
learnFuncParams = l, maxis = maxis)
predictions <- predict(model_15,inputTest)
matrix_15 = confusionMatrix(outputTest, predictions)
matrix_15 = cbind(empty_col,empty_col,matrix_15,empty_col)
f1(matrix_15)

l = 0.33
model_32 <- mlp(trainData$inputsTrain, trainData$targetsTrain, size = size,
learnFuncParams = l, maxis = maxis)
predictions <- predict(model_32,inputTest)
matrix_32 = confusionMatrix(outputTest, predictions)
matrix_32 = cbind(empty_col,empty_col,matrix_32,empty_col, empty_col)
f1(matrix_32)