rm(list=ls())
library(tsvr)

allsites <- readRDS("Data_grassland.RDS")  # input data

# remove the extreme point for jrn ("JRN_NPP quadrat_BASN_7")
i.omit <- 46
allsites[[10]] <- allsites[[5]][-i.omit]  #JRN
names(allsites)[10] <- "jrn.omit"

ii <- c(4, 6, 3, 10, 7, 8, 5)  #index of sites used in the study (sorted by the average of classic vr)
names.sites <- names(allsites)[ii]


## calculating
Res <- vector("list", length(names.sites))
names(Res) <- names.sites
for(i in 1:length(names.sites)){
  X <- allsites[[ii[i]]]
  X <- lapply(X, t)  # each population matrix has species on row and years on col
  
  #remove species with constant abundance/density or not showing up at all
  X <- lapply(X, function(xx) xx[apply(xx,1,function(yy) length(unique(yy)))>1,]) 
  
  res.ts <- lapply(X, tsvreq_classic)
  ts <- res.ts[[1]][[1]]
  res.long <- lapply(res.ts, aggts, ts=ts[ts >= 4]) #aggregation
  res.short <- lapply(res.ts, aggts, ts=ts[ts < 4])
  
  
  #re-organize for timescale specific values
  Res.ts <- vector("list", length(res.ts[[1]]))
  names(Res.ts) <- names(res.ts[[1]])
  Res.ts[[1]] <- res.ts[[1]][[1]]
  for(j in 2:length(res.ts[[1]])){
    tmp <- lapply(res.ts, "[[", j)
    tmp <- matrix(unlist(tmp), nrow=length(tmp[[1]]))
    tmp <- t(tmp)  #matrix with plot by timescale
    rownames(tmp) <- names(res.ts) #name of plots
    Res.ts[[j]] <- tmp
  }
  
  
  #re-organize for short-ts, long-ts, and all-ts averaged (weighted averaged for vr) values
  Res.ave <- vector("list", 3)
  names(Res.ave) <- names(res.long[[1]])[1:3]
  for(j in 1:2){
    tmp.short <- unlist(lapply(res.short,"[[", j))
    tmp.long <- unlist(lapply(res.long,"[[", j))
    tmp.all <- tmp.short + tmp.long
    
    n.short <- length(res.short[[1]][[4]]) #number of short timescales
    n.long <- length(res.long[[1]][[4]])
    n.all <- n.short + n.long
    
    tmp <- cbind(tmp.short/n.short, tmp.long/n.long, tmp.all/n.all)
    colnames(tmp) <- c("short","long","all")
    Res.ave[[j]] <- tmp
  }
  Res.ave[[3]] <- Res.ave[[1]]/Res.ave[[2]]
  
  Res[[i]] <- list(ts.specific=Res.ts, averaged=Res.ave)
}
saveRDS(Res, "result_basic.RDS")

