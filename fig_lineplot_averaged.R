####### line plot (new: cv.all is the mean across all timescales) 
rm(list=ls())

panlabs<-c("a","g","m","s",
           "b","h","n","t",
           "c","i","o","u",
           "d","j","p","v",
           "e","k","q","w",
           "f","l","r","x")

library(scales) # col: alpha
library(normtest)
Res <- readRDS("result_basic.RDS")
Res.prop <- readRDS("result_shuffling_proportion.RDS")  #new added

tiff("Figs/fig5_lineplot_average.tif", 
     width=9, height=10, units="in",res=600,compression = "lzw")
op <- par(mfrow=c(6,4),oma=c(3,1,1,3), mar=c(1,3.5,1,1),mgp=c(2.5,0.5,0))

i.measure <- c(3, 2, 1)
name.site <- c("JRG","KBS", "HAY","JRN","KNZ","SEV")
name.y <- c(expression(paste(weighted~average~of~italic(varphi)[ts]~(italic(sigma)))),
           expression(paste(average~of~CV[com_ip]^2~(italic(sigma)))),
           expression(paste(average~of~CV[com]^2~(italic(sigma)))),
           expression(paste(average~of~CV[com]^2~(italic(sigma)))))
cols <- alpha(c("blue","red"),0.5)
a <- 1
jbtest.jb <- matrix(NA,6,3)
row.names(jbtest.jb) <- names(Res)[1:6]
colnames(jbtest.jb) <- names(Res[[1]][[2]])[i.measure]
jbtest.p <- jbtest.jb
for(i in 1:6){
  for(j in 1:3){
    x <- Res[[i]][[2]][[i.measure[j]]]
    x <- x[,c(1,2)]  # short, long
    P <- Res.prop[[i]][[i.measure[j]]] #new added
    
    z1<-jb.norm.test(x[,1]-x[,2])
    jbtest.jb[i,j]<-z1$statistic
    jbtest.p[i,j]<-z1$p.value
    
    z<-t.test(x[,1], x[,2], paired=T)
    if(z$p.value<0.001) stars="***"
    else if(z$p.value<0.01) stars="**"
    else if(z$p.value<0.05) stars="*"
    else stars="NS"
    
    if(j==1){max.y<- max(x)+0.25*diff(range(x))}else{max.y<- max(x)+0.1*diff(range(x))}
    
    plot(NA, xlab=NA, ylab=NA, xaxt="n",xlim=c(0,1.1), ylim=c(min(x), max.y))
    
    if(i==6){
      if(j==1){
        axis(1, at=c(0.1,0.7,1), labels=c("short","long","classic"))
      }else{
        axis(1, at=c(0.2,0.9), labels=c("short","long"))
      }
    }
    
    xaxis.short <- c(0.1,0.2,0.2)
    xaxis.long <- c(0.7, 0.9, 0.9)
    for(t in 1:nrow(x)){
      if(P[t]>0.05){lines(c(xaxis.short[j],xaxis.long[j]), x[t,], col=alpha("lightgrey",1)) #modified
      }else{
        lines(c(xaxis.short[j],xaxis.long[j]), x[t,], col=alpha("black",0.9))}
      points(c(xaxis.short[j],xaxis.long[j]), x[t,], col=alpha(cols, 0.7), pch=1, cex=1.6)
    }
    
    if(j==1){
      lines(c(0,3), c(1,1), col="black", lty="dashed", lwd=2)
      vr.class <- Res[[i]][[2]][[3]][,3] #classic variance ratio
      cols1<-"darkgray"
      boxplot(vr.class, xlab=NA, ylab=NA, boxwex=0.3, at=1, 
              ylim=c(min(x), max(x)+0.1*diff(range(x))), xaxt="n", add=T,
              col=cols1, medcol="black",
              whiskcol=cols1,staplecol=cols1,boxcol="black",outcol="black")
    }
    
    adjs <- c(0.4,0.5,0.5)
    if(stars=="NS"){
      mtext(stars, side=3, line=-1.2, cex=0.8,adj=adjs[j])
    }else{
        mtext(stars, side=3, line=-1.5, cex=1.2, adj=adjs[j])}
    
    mtext(paste0("(",panlabs[a],")"), side=3, line=-1.2, adj=0.05, cex=0.8)
    a<-a+1
  }
  
  cv2.com <- Res[[i]][[2]][[1]][,1:2]
  cv2.comip <- Res[[i]][[2]][[2]][,1:2]
  
  plot(NA, xlim=c(-3.7,-0.5), ylim=c(-3.7,-0.5), xlab=NA, ylab=NA,xaxt="n", yaxt="n")
  for(j in 1:2){
    points(log10(cv2.comip[,j]),log10(cv2.com[,j]), col=cols[j])
  }
  lines(c(-10,10),c(-10,10),lty="dashed")
  mtext(name.site[i], side=4, line=0.6, cex=1.1, las=1)
  axis(1, at=c(-4,-3,-2,-1,0), labels = c(0.0001,0.001,0.01,0.1,1))
  axis(2, at=c(-4,-3,-2,-1,0), labels = c(0.0001,0.001,0.01,0.1,1))
  mtext(paste0("(",panlabs[a],")"), side=3, line=-1.2, adj=0.05, cex=0.8)
  a<-a+1
}

par(fig = c(0, 1, 0, 1), oma=c(1,1,1,0.5), mar = c(2, 2, 2, 1),mgp=c(2.5,0.5,0), new = TRUE)
plot(NA, xlim=c(1,1),ylim=c(0,1), xlab=NA,ylab=NA, axes=FALSE)
# 0.05 0.33 0.64 for adj
mtext(name.y[1], side=2, line=1, adj=0.5, cex=0.9)
mtext(name.y[2], side=2, line=-15.5, adj=0.5, cex=0.9)
mtext(name.y[3], side=2, line=-31.5, adj=0.5, cex=0.9)
mtext(name.y[4], side=2, line=-47.5, adj=0.5, cex=0.9)
mtext(expression(paste(average~of~CV[com_ip]^2~(italic(sigma)))), adj=0.96, side=1, line=1.6, cex=0.9)
mtext("timescale", adj=0.07, side=1, line=1.2, cex=0.9)
mtext("timescale", adj=0.35, side=1, line=1.2, cex=0.9)
mtext("timescale", adj=0.63, side=1, line=1.2, cex=0.9)
par(op)
dev.off()

