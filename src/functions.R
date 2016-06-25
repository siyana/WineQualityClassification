source(paste(getwd(),"\\src\\global_constants.R", sep = ""))

splitSet <- function (set, testPath, trainPath) {
    indexes <- sample(2, nrow(set), replace=TRUE, prob=c(0.7, 0.3)) #create a sample list ot 1/2
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