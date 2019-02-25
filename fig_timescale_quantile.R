rm(list=ls())


Res <- readRDS("result_basic.RDS")

xaxt<-c(0.1,1/3,1/2,2/3,0.9)
xaxl<-c('10','3','2','1.5','1.11')
name.site<-c("JRG","KBS","HAY","JRN","KNZ","SEV")

pdf("Figs/fig_timescale_quantile.pdf", 
     width=7, height=8)
op<-par(mfrow=c(3,2),oma=c(3.5,3.5,0.5,0.5), mar=c(1.5,1.5,1,1),mgp=c(2.5,0.5,0),
        tck=-.02,cex.axis=1.2,cex.lab=1.5,cex.main=1.5)

for(i in 1:6){
  vrs <- Res[[i]][[1]][[4]]
  freq <- 1/Res[[i]][[1]][[1]]  
  
  res<-matrix(NA, 6, length(freq))
  colnames(res)<- freq
  res[1:5,] <- apply(vrs, 2, quantile, c(0.025, 0.25, 0.5, 0.75, 0.975))
  res[6,] <- colMeans(vrs)
  rownames(res) <- c("q2.5", "q25", "median", "q75", "q97.5", "mean")
  
  plot(freq, res[3,], xlim=rev(range(freq)),ylim=c(0,5), xlab=NA, 
       ylab=NA, xaxt="n", typ="p",pch=20,cex=1.2)
  rect(0.5,-100,2,100,density=NA,col=rgb(0,0,0,alpha=0.05))
  lines(freq, res[3,], lwd=2)
  lines(c(-1,1), c(1,1), lty="dashed", col="darkgray", lwd=2)
  polygon(x=c(freq,rev(freq)), y=c(res[1,], rev(res[5,])), col=adjustcolor("gray", alpha.f=0.25), border=NA)
  polygon(x=c(freq,rev(freq)), y=c(res[2,], rev(res[4,])), col=adjustcolor("darkgray", alpha.f=0.3), border="darkgray")
  axis(1, at=xaxt, labels = xaxl)
  mtext(paste0("(",letters[i],") ", name.site[i]), side=3, line=-1.5, adj=0.05)
}
op<-par(new=T, mfrow=c(1,1),mar=c(0,0,0,0))
plot(NA, xlim=c(0,1), ylim=c(0,1), xlab=NA, ylab=NA, xaxt="n", yaxt="n",bty="n")
mtext("timescale",side=1,line=1.8,cex=1.2)
mtext(expression(varphi["ts"](sigma)),side=2,line=2, cex=1.4)
par(op)
dev.off()


