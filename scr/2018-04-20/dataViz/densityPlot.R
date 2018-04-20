library(tidyverse)
library(here)


# Loading metadata and real data ------------------------------------------
outpath <- here("Results/2018-04-20/figures/densityPlot.png")
runfile <- read.csv(here("data/CROMO_11_metadata.csv"), stringsAsFactors = F)
data <- read.csv(here("data/2018-04-18/metaboAnalyst_Input/chromoPeaks.csv"))


# QA on data --------------------------------------------------------------
dataCols <- grep(colId, colnames(data))
blankMatches <- colnames(data) %in% runfile$Sample.Name[runfile$Well %in% "Blank"]
blankCols <- colnames(data)[blankMatches]
colId <- sub("_00[0-9]", "", blankCols[1])
for(curCol in blankCols) {
  
  ## determining type of blank
  blankCol <- data[,colnames(data) %in% curCol]
  removeRows <- which(!is.na(blankCol))
  
  ## determining which columns are same type as blank to correct
  blankType <- runfile$Type[runfile$Sample.Name == curCol]
  correctData <- colnames(data) %in% runfile$Sample.Name[runfile$Type %in% blankType]
  
  ## correcting the data
  data[removeRows,correctData] <- NA
}


# creating a density plot on the data -------------------------------------
colnames(data)[14:17] <- c("CSW intracellular","CSW DOC", "QV intracellular", "QV DOC")
meltedData <- reshape2::melt(data = data, id.vars = c("mz", "rt"), measure.vars = c("CSW intracellular",
                                                                                    "CSW DOC", 
                                                                                    "QV intracellular", 
                                                                                    "QV DOC"))

meltedDataSub <- meltedData[!is.na(meltedData$value),]
ggplot(meltedDataSub, mapping = aes(x = mz, y = rt, col = variable)) +
  geom_point(size = .75, stroke = 0.25, shape = 16) + 
  theme_minimal() + 
  xlab("M/Z ratio") +
  ylab("Retention Time (seconds)") +
  ggtitle("Density Plot of Observed Features Across Samples") +
  guides(colour = guide_legend(override.aes = list(size=3)))

ggsave(outpath)