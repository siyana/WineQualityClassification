
source(paste(getwd(),"\\src\\global_constants.R", sep = ""))
source(paste(basePath, "\\src\\graphics_functions.R", sep=""))

whiteWine = read.csv(whiteWineTrainPath)

columnNames = names(whiteWine)
attach(whiteWine )
for (i in 1:length(columnNames)){
	if (columnNames[i] != "quality") {
	    column = eval(parse(text = columnNames[i]))
	    png(filename = boxplotFileName(varToString(whiteWine), columnNames[i]))
	  	 boxplotByQuality(whiteWine, column, columnNames[i])
	    dev.off()
	}
}

detach(whiteWine)

redWine = read.csv(redWineTrainPath)
attach(redWine)
columnNames = names(redWine)
for (i in 1:length(columnNames)){
	if (columnNames[i] != "quality") {
		column = eval(parse(text = columnNames[i]))
		png(filename=boxplotFileName(varToString(redWine), columnNames[i]))
			boxplotByQuality(redWine, column, columnNames[i])
		dev.off()
	}
}

detach(redWine)