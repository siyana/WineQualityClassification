source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))

redWinePath = paste(basePath,"\\resources\\winequality-red.csv",sep = "")
redWineTrainPath = paste(basePath,"\\resources\\redWineTrain.csv",sep = "")
redWineTestPath = paste(basePath,"\\resources\\redWineTest.csv",sep = "")

redWineSet = read.csv(redWinePath,sep=";")
splitSet(redWineSet, redWineTestPath, redWineTrainPath)

whiteWineTrainPath = paste(basePath,"\\resources\\whiteWineTrain.csv",sep = "")
whiteWineTestPath = paste(basePath,"\\resources\\whiteWineTest.csv",sep = "")
whiteWinePath = paste(basePath,"\\resources\\winequality-white.csv",sep = "")

whiteWineSet = read.csv(whiteWinePath, sep=";")
splitSet(whiteWineSet, whiteWineTestPath, whiteWineTrainPath)