source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))

#WhiteWineTrain
whiteWineTrain = read.csv(whiteWineTrainPath)

attach(whiteWineTrain)
png(filename = boxplotFileName("whiteWine", "test_quality_distribution"))
   barplot(table(whiteWineTrain$quality))
dev.off()
detach(whiteWineTrain)

#WhiteWineTest
whiteWineTest = read.csv(whiteWineTestPath)

attach(whiteWineTest)
png(filename = boxplotFileName("whiteWine", "test_quality_distribution"))
   barplot(table(whiteWineTest$quality))
dev.off()
detach(whiteWineTest)

#RedWineTrain
redWineTrain = read.csv(redWineTrainPath)

attach(redWineTrain)
png(filename = boxplotFileName("redWine", "train_quality_distribution"))
   barplot(table(redWineTrain$quality))
dev.off()
detach(redWineTrain)

#RedWineTest
redWineTest = read.csv(redWineTestPath)

attach(redWineTest)
png(filename = boxplotFileName("redWine", "test_quality_distribution"))
   barplot(table(redWineTest$quality))
dev.off()
detach(redWineTest)