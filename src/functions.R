source(paste(getwd(),"\\src\\global_constants.R", sep = ""))

splitSet <- function (set, testPath, trainPath) {
    indexes <- sample(2, nrow(set), replace=TRUE, prob=c(0.9, 0.1)) #create a sample list ot 1/2
    trainData <- set[indexes == 1,] # indexes == 1 returns true or false for each value
    testData <- set[indexes == 2,] 
	
    write.csv(trainData , file = trainPath , row.names=FALSE, fileEncoding = "UTF-8") 
    write.csv(testData , file = testPath , row.names=FALSE, fileEncoding = "UTF-8") 
}

boxplotFileName <- function(xName, xColumnName) {
    fileNamePlot = paste(xName, xColumnName, sep = "_")
    x = paste(baseGraphicsPath, xName, "\\",fileNamePlot, ".png", sep = "")
}

varToString = function(x){
    deparse(substitute(x))
}

#Evaluation

diagSum <- function(outputTest, matrix){
  allCategories = 1:ncol(outputTest)
  sum = 0
  delimiter = 0;
  emptyCol = c(0,0,0,0,0,0,0)
  for(i in allCategories){
    strI = toString(i)
    if(strI %in% colnames(matrix)) {
      sum = sum + matrix[strI,strI]
      delimiter = delimiter + sum(matrix[strI,])
    }
  }
  c(sum,delimiter)
}

precision <- function(table){
   mat = as.matrix(table)
   precision = diag(mat) / rowSums(mat)
   replace(precision, is.na(precision), 0)
}

recall <- function(table) {
   mat = as.matrix(table)
   recall <- diag(mat) / colSums(mat)
   replace(recall, is.na(recall), 0)
}

f1 <- function(table) {
  recall = recall(table)
  precision = precision(table)
  f1 = 2*recall*precision/(recall + precision)
  replace(f1, is.na(f1), 0)
}