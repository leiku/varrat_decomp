## Summary of the datasets

## information used in table S1
ii<-c(4,6,3,5,7,8)
names.sites<-names(allsites)[ii]
num.sp<-vector("list", 6)
names(num.sp)<-names.sites
num.sp.all<-matrix(NA, 4, 6)
colnames(num.sp.all)<-names.sites
row.names(num.sp.all)<-c("sp","plots","years","richness")
for(i in 1:6){
  x<-allsites[[ii[i]]]
  
  y1<-matrix(NA, nrow(x[[1]]), length(x))
  rownames(y1)<-rownames(x[[1]])
  colnames(y1)<-names(x)
  y2<-rep(NA, length(x))
  for(j in 1:length(x)){
    x1<-x[[j]]
    x1[x1>0]<-1
    y1[,j]<-rowSums(x1)
    tmp<-colSums(x1)
    y2[j]<-sum(tmp>0)
  }
  num.sp[[i]]<-y1
  num.sp.all[1,i]<-ncol(x1)
  num.sp.all[2,i]<-length(x)
  num.sp.all[3,i]<-nrow(x1)
  num.sp.all[4,i]<-mean(y2)
}
