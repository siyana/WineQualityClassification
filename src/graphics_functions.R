source(paste(getwd(), "\\src\\functions.R", sep=""))

boxplotByQuality <- function(set, column, columnName) {      
	  boxplot(column ~ quality, data = set, main = paste(columnName, "~ quality", sep = " "),
        xlab = "quality class",
        ylab = columnName)      
}