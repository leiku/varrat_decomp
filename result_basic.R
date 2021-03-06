rm(list=ls())

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

#get some summary results into a table
snshort<-sitenames[c(4, 6, 3, 10, 7, 8)]
Resn<-Res[1:6]
names(Resn)[4]<-"jrn"
names(Resn)<-toupper(names(Resn))
sumtab<-data.frame(Site=snshort,Abbr.=names(Resn),Years=NA*numeric(6),YearRange=rep(NA,6),
                   Plots=NA*numeric(6),PlotSizeSqMeter=NA*numeric(6),Richness=NA*numeric(6),
                   DataCollectMethod=character(6),Description=character(6))

#fill in data that just has to be typed in
sumtab$PlotSizeSqMeter<-c(0.8,1,1,1,10,1)
sumtab$DataCollectMethod<-c("Percent cover","Biomass","Percent cover",
                            "Allometric biomass",
                            "Percent cover","Biomass")
sumtab$Description<-c("Serpentine grassland","Old field",
                                        "Tallgrass prairie","Desert grassland",
                                        "Annually burned tallgrass prairie",
                                        "Desert grassland")

#fill in number of plots
sumtab$Plots<-unname(sapply(X=Resn,FUN=function(x){dim(x$averaged$com)[1]}))

#fill in years, and year range
alln <- allsites[c(4,6,3,10,7,8)]
tmp <- lapply(alln, "[[", 1)
sumtab$Years <- unlist(lapply(tmp, nrow))
tmp1 <- lapply(tmp, rownames)
for(i in 1:6){
  sumtab$YearRange[i] <- paste0(tmp1[[i]][1],"-",tmp1[[i]][length(tmp1[[i]])])
}

#fill in richness
for(i in 1:6){
  tmp <- lapply(alln[[i]], function(X) sum(colSums(X)>0))
  sumtab$Richness[i] <- round(mean(unlist(tmp)),1)
}

saveRDS(sumtab, "summary_table.RDS")

names(sumtab)[4]<-"Yr. rg."
names(sumtab)[6]<-"Plot size"
names(sumtab)[8]<-"Measured"
rownames(sumtab)<-NULL
tabres<-xtable::xtable(sumtab,caption=c("Summary of datasets. Plot size in square meters. Richness is the number of species that were ever seen in a plot, averaged across plots for a site. Biomass, when measured, was in g per square meter","Summary of datasets"),
                       align=c('p{2in}',rep("l",ncol(sumtab))))
xtable::print.xtable(tabres,file="XTableResult.tex",include.rownames=FALSE,scalebox=0.75)


#get some summary results for the main text
numplots<-sum(sumtab[5])
tmp <- lapply(Resn, "[[", 1)
tmp.CVcom2 <- unlist(lapply(lapply(tmp, "[[", 2), rowSums))
minCVcom2<- min(tmp.CVcom2) 
maxCVcom2<-max(tmp.CVcom2)
tmp.CVcomip2 <- unlist(lapply(lapply(tmp, "[[", 3), rowSums))
minCVcomip2<-min(tmp.CVcomip2)
maxCVcomip2<-max(tmp.CVcomip2)
allvr<-tmp.CVcom2 / tmp.CVcomip2
minvr<-min(allvr) 
maxvr<-max(allvr) 
fraccomp<-sum(allvr<1)/length(allvr)
save(minCVcom2,maxCVcom2,minCVcomip2,maxCVcomip2,allvr,minvr,maxvr,fraccomp,file="TextResults.RData")


#more summary results for the main text
long_comp<-c()
long_sync<-c()
long_tot<-c()
short_comp<-c()
short_sync<-c()
short_tot<-c()
for (counter in 1:length(Resn))
{
  long_comp[counter]<-sum(Resn[[counter]]$averaged$vr[,colnames(Resn[[counter]]$averaged$vr)=="long"]<1)
  long_sync[counter]<-sum(Resn[[counter]]$averaged$vr[,colnames(Resn[[counter]]$averaged$vr)=="long"]>1)
  long_tot[counter]<-dim(Resn[[counter]]$averaged$vr)[1]

  short_comp[counter]<-sum(Resn[[counter]]$averaged$vr[,colnames(Resn[[counter]]$averaged$vr)=="short"]<1)
  short_sync[counter]<-sum(Resn[[counter]]$averaged$vr[,colnames(Resn[[counter]]$averaged$vr)=="short"]>1)
  short_tot[counter]<-dim(Resn[[counter]]$averaged$vr)[1]
  
}
names(long_comp)<-names(Resn)
names(long_sync)<-names(Resn)
names(long_tot)<-names(Resn)
names(short_comp)<-names(Resn)
names(short_sync)<-names(Resn)
names(short_tot)<-names(Resn)
long_comp_all<-sum(long_comp)
long_sync_all<-sum(long_sync)
short_comp_all<-sum(short_comp)
short_sync_all<-sum(short_sync)
save(long_comp,long_sync,long_tot,short_comp,short_sync,short_tot,file="TextResults2.RData")
