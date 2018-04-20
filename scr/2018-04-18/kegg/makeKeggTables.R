library(dplyr)
files <- list.files(".", pattern = ".csv")
peakTables <- lapply(files, read.csv)

example <- read.table("~/MIT/Research/MMETSP_Project/data/2018-03-18/mtabAnalyst_input/mtabAnalyst_caf_neg_t-test_N.txt", header = T)

organizedPeaks <- list()
for(i in 1:length(peakTables)) {
  
   peakSub <- peakTables[[i]] %>% select(mz, contains("2016_09_12")) %>% 
    apply(2, function(col) {
      col[is.na(col)] <- 0
      return(col)
    }) %>% 
     as.data.frame()
   
   peakSub$p.value <- runif(n = nrow(peakSub), min = 0.0001, max = 0.2)
   peakSub$t.score <- sample(example$t.score, size = nrow(peakSub), replace = T)
  
  organizedPeaks[[i]] <- peakSub
  rm(peakSub)
}

outPath <- "data/2018-04-18/metaboAnalyst_Input"

for(i in 1:length(organizedPeaks)) {
  curTable <- organizedPeaks[[i]] %>% select(mz, p.value, t.score)
  colnames(curTable)[1] <- "m.z"
  export <- file.path(outPath, paste0("metaboIn", sub(".csv", "", files[i]), ".txt"))
  write.table(curTable, export, row.names = F)
}




