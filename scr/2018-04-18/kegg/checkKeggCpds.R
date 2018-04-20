library(here)
library(dplyr)
library(KEGGREST)
library(doMC)
registerDoMC(cores=3)



path2Data <- read.csv("data/2018-04-18/metaboAnalyst_Out/mummichog_matched_compound_all.csv")

checkCpds <- unique(path2Data$Matched.Compound)


cpdInfo <- list()
cpdInfo <- foreach::foreach(i = 1:length(checkCpds))  %dopar% {
  
  cpdName <- tryCatch(keggFind("cpd", checkCpds[i]), error = function(e) "No cpd match")
  pathways <- tryCatch(keggLink("pathway", checkCpds[i]), error = function(e) "No pathway match")
  
  if(length(pathways) == 0) {
    pathwayNames <- "No Pathway match"  
  } else {
    pathwayNames <- tryCatch(keggList(pathways), error = function(e) "No pathway name match")  
  }
  
  pathwayNames
  
}

cpdTable <- list()
for(i in 1:length(cpdInfo)) {
  cpdName <- checkCpds[i]
  paths <- cpdInfo[[i]]
  cpdTable[[i]] <- data.frame(cpdName, paths)
}
pathwayTable <- plyr::ldply(cpdTable, data.frame)

colnames(pathwayTable)[1] <- "Matched.Compound"
cpdPathTable <- dplyr::full_join(pathwayTable, path2Data, "Matched.Compound")
cpdPathTable <- cpdPathTable %>% mutate(ppm = round(Mass.Diff/Query.Mass * 10^6))

cpdPathTable <- unique(cpdPathTable[,-5])

cpdPathTable[grep("Oxocarboxylic acid", cpdPathTable$paths, ignore.case = T),]
