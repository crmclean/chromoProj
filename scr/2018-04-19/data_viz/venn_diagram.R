
# Loading packages --------------------------------------------------------
library(dplyr)
library(here)
library(limma)

# Loading metadata and real data ------------------------------------------

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

# counting total number of blanks observed within the data
removeRows <- data[,] %>% apply(1, function(row) {sum(is.na(row)) == length(row)}) 
message("Total rows removed through blank correction: ", sum(removeRows))


# subsetting data to only consider sample columns
dataObservations <- data[,dataCols[!dataCols %in% which(blankMatches)]]
dataObservations <- apply(dataObservations, 2, function(col) {
  col[is.na(col)] <- 0
  return(col)
})


# venn diagram ------------------------------------------------------------
featureCounts <- dataObservations %>% apply(2, function(col) {col > 0}) 

vennCountTable <- vennCounts(featureCounts)
colnames(vennCountTable) <- c("CSW intracellular", 
                              "CSW DOC",
                              "QV intracellular",
                              "QV DOC",
                              "Counts")
vennDiagram(vennCountTable, circle.col = c("blue", "blue", "orange", "orange"),
            mar = rep(0.01,4),
            cex = c(1.2,1.2,1.2),
            show.include = F)
