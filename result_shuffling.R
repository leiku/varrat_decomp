rm(list=ls())
set.seed(42)

####shuffling function
#input: XX, the matrix need to be shuffled.
#output: the matrix after shuffling
shuffling <- function(XX, dim.shuf=1){
  dims <- dim(XX)
  if(dim.shuf == 1){
    return(XX[sample(dims[1], replace=F),])
  }else if(dim.shuf == 2){
    return(XX[,sample(dims[2], replace=F)])
  }else{stop("dim.shuf has to be 1 or 2!")}
}

### input data ###

allsites <- readRDS("Data_grassland.RDS")  # input data
sitenames <- readRDS("SiteNames.RDS") # site names

# remove the extreme point for jrn ("JRN_NPP quadrat_BASN_7")
i.omit <- 46
allsites[[10]] <- allsites[[5]][-i.omit]  #JRN
names(allsites)[10] <- "jrn_omit"
sitenames[10]<-sitenames[5]

ii <- c(4, 6, 3, 10, 7, 8, 5)  #index of sites used in the study (sorted by the average of classic vr)
names.sites <- names(allsites)[ii]


## calculating
Res.shuf <- vector("list", length(names.sites))
names(Res.shuf) <- names.sites
for(i in 1:length(names.sites)){
  X <- allsites[[ii[i]]]
  X <- lapply(X, t)  # each population matrix has species on row and years on col
  
  #remove species with constant abundance/density or not showing up at all
  X <- lapply(X, function(xx) xx[apply(xx,1,function(yy) length(unique(yy)))>1,]) 
  
  #1000 simulations of shuffling
  #re-organize for short-ts, long-ts, and all-ts averaged (weighted averaged for vr) values
  
  TMP.com <- array(NA, c(length(X), 3, 1000))  #plot by timescale by replicates
  TMP.comnull <- TMP.com
  for(s in 1:1000){
    X.s <- lapply(X, shuffling, dim.shuf = 2)
    
    res.ts <- lapply(X.s, tsvreq_classic)
    ts <- res.ts[[1]][[1]]
    res.long <- lapply(res.ts, aggts, ts=ts[ts >= 4]) #aggregation
    res.short <- lapply(res.ts, aggts, ts=ts[ts < 4])
    
    for(j in 1:2){
      tmp.short <- unlist(lapply(res.short,"[[", j))
      tmp.long <- unlist(lapply(res.long,"[[", j))
      tmp.all <- tmp.short + tmp.long
      
      n.short <- length(res.short[[1]][[4]]) #number of short timescales
      n.long <- length(res.long[[1]][[4]])
      n.all <- n.short + n.long
      
      tmp <- cbind(tmp.short/n.short, tmp.long/n.long, tmp.all/n.all)
      colnames(tmp) <- c("short","long","all")
      if(j == 1){TMP.com[,,s] <- tmp}else{
        TMP.comnull[,,s] <- tmp
      }
    }
  }
  
  Res.ave <- vector("list", 3)
  names(Res.ave) <- c("com", "comnull", "vr")
  
  Res.ave[[1]] <- TMP.com
  Res.ave[[2]] <- TMP.comnull
  Res.ave[[3]] <- Res.ave[[1]]/Res.ave[[2]]
  
  
  Res.shuf[[i]] <- Res.ave
  print(i)
}
saveRDS(Res.shuf, "result_shuffling.RDS")


####### Analysis ######
Res.shuf <- readRDS("result_shuffling.RDS")
Res.diff <- Res.shuf
for(i in 1:length(Res.shuf)){  #different sites
  for(j in 1:3){   #com, comnull, vr
    tmp <- Res.shuf[[i]][[j]]
    ans <- abs(tmp[,1,] - tmp[,2,])  #|short - long|
    Res.diff[[i]][[j]] <- ans
  }
}

Res <- readRDS("result_basic.RDS")
Res.prop <- Res.diff
for(i in 1:length(Res.diff)){
  for(j in 1:3){
    tmp <- Res[[i]][[2]][[j]]
    real.diff <- abs(tmp[,1] - tmp[,2])
    simu.diff <- Res.diff[[i]][[j]]
    p <- real.diff
    for(s in 1:length(real.diff)){
      p[s] <- sum(simu.diff[s,] > real.diff[s])/1000
    }
    Res.prop[[i]][[j]] <- p
  }
}

saveRDS(Res.prop,"result_shuffling_proportion.RDS")


