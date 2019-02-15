rm(list=ls())

Res <- readRDS("result_basic.RDS")

xaxt <- c(0.1,1/3,1/2,2/3,0.9)
xaxl <- c('10','3','2','1.5','1.11')
ylabs1<-c(expression(paste(CV[com]^2~(italic(sigma)))),
          expression(paste(CV[com_ip]^2~(italic(sigma)))),
          expression(paste(italic(varphi)[ts])~(italic(sigma))))
ylabs2<-c(expression(paste(average~of~CV[com]^2~(italic(sigma)))),
          expression(paste(average~of~CV[com_ip]^2~(italic(sigma)))),
          expression(paste(weighted~average~of~italic(varphi)[ts])~(italic(sigma))))

for(i in 1:7){
  #get index of plots (sorted by the difference between vr.short and vr.long)
  tmp <- Res[[i]][[2]][[3]]
  ind <- order(tmp[,1]-tmp[,2])
  
  pdf(paste0("Figs/fig_decomposed_",i,"_classic_",names(Res)[i],"_sorted_vrf.pdf"), 
      width=6, height=6)
  op<-par(mfrow=c(3,2),oma=c(3,1,1,1), mar=c(1,4,1,1),mgp=c(2,0.5,0))
  
  a <- 1 #index of panels
  for(j in c(3,2,1)){
    
    #timescale decomposed
    freq <- 1/Res[[i]][[1]][[1]]
    tmp <- Res[[i]][[1]][[j+1]]
    plot(NA, xlim=rev(range(freq)), ylim=range(tmp),ann=F, xaxt="n")
    for(ii in 1:nrow(tmp)){
      lines(freq, tmp[ii,],typ="l",col=rainbow(nrow(tmp))[ii])
    }
    lines(c(.5,.5),c(0,max(tmp)),lty='dotted')
    rect(.5,-max(tmp),2,2*max(tmp),density=NA,col=rgb(0,0,0,alpha=0.2))
    axis(side=1, at=xaxt, labels=xaxl)
    mtext(ylabs1[j], side=2, line=2, cex=0.8)
    mtext(paste0("(",letters[a],")"), side=3, line=-1.1, adj=0.04, cex=0.8)
    if(j==3){
      lines(c(0, 1), c(1, 1), lty=2, col="black") #for variance ratio only
    }
    a <- a+1
    
    #short and long timescale averaged for each plot
    tmp <- Res[[i]][[2]][[j]]
    tmp <- tmp[ind,]
    plot(1:nrow(tmp), tmp[, 1], typ="l", col="blue", ann=F,
         ylim=c(min(tmp)-0.3*diff(range(tmp)), max(tmp)+0.2*diff(range(tmp))))
    points(1:nrow(tmp), tmp[, 1], pch=20, col="blue")
    lines(1:nrow(tmp), tmp[, 2], typ="l", col="red")
    points(1:nrow(tmp), tmp[, 2], pch=20, col="red")
    legend("bottomleft", c("short", "long"), lty="solid", col=c("blue", "red"), horiz=T)
    z<-t.test(tmp[,1], tmp[,2], paired=T)
    p<-z$p.value; 
    if(p>=0.001){
      mtext(paste0("p = ", round(p,3)), side=3, line=-1.1, cex=0.9)
    }else{mtext("p < 0.001", side=3, line=-1.1, cex=0.9)}
    mtext(ylabs2[j], side=2, line=2, cex=0.8)
    mtext(paste0("(",letters[a],")"), side=3, line=-1.1, adj=0.04, cex=0.8)
    if(j==3){
      lines(c(1, 100), c(1, 1), lty=2, col="black")
    }
    a <- a+1
  }
  
  # xlab 
  par(fig = c(0, 1, 0, 1), oma=c(0,0,0,0), mar = c(3, 3, 0, 0), new = TRUE)
  plot(NA, xlim=c(0,1),ylim=c(0,1), xlab="",ylab="",
       type = "n", bty = "n", xaxt = "n", yaxt = "n", cex.lab=1.2, font.lab=2)
  mtext("timescale (years)", side=1, line=1, adj=0.15, cex=0.8)
  mtext("plot index", side=1, line=1, adj=0.77, cex=0.8)
  
  par(op)
  dev.off()
}


