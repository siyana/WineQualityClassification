source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\functions.R", sep=""))

whiteWineTrain = read.csv(whiteWineTrainPath)
redWineTrain = read.csv(redWineTrainPath)

wineMixed = whiteWineTrain
wineMixed = rbind(wineMixed,redWineTrain)

png(filename = boxplotFileName("wineMixed", "train_quality_distribution"))
   barplot(table(wineMixed$quality))
dev.off()
detach(wineMixed)

write.csv(wineMixed, mixedWineTrainPath, row.names=FALSE, fileEncoding = "UTF-8")