 
rm(list=ls())

Res <- readRDS("result_basic.RDS")

name.site<-c("JRG","KBS","HAY","JRN","KNZ","SEV")

tiff("Figs/fig_new_vs_classic.tif", 
    width=7.4, height=5, units="in",res=300,compression = "lzw")
op<-par(mfrow=c(2,3),mgp=c(1.8,0.6,0),mar=c(2,2,1,1), oma=c(3,3,0,0))
for(i in 1:6){
  vr <- Res[[i]][[2]][[3]]
  plot(NA, xlim=c(0,2.5), ylim=c(0,2.5),
       xlab=NA, ylab=NA)
  points(vr[,3], vr[,1], col='blue', pch=1,cex=1) #short
  points(vr[,3], vr[,2], col='red', pch=1,cex=1) #long
  lines(c(0,3),c(0,3), lty="dashed")
  abline(h=1,v=1,col='gray',lwd=0.7)
  legend('bottomright',c('short','long'),pch=1,col=c(4,2))#,bty='n')
  mtext(paste0("(",letters[i],") ", name.site[i]), side=3, line=-1.5, adj=0.02)
}
op<-par(new=T, mfrow=c(1,1),mar=c(0,0,0,0))
plot(NA, xlim=c(0,1), ylim=c(0,1), xlab=NA, ylab=NA, xaxt="n", yaxt="n",bty="n")
mtext(expression(varphi["classic"]),side=1,line=1.5)
mtext(expression(weighted~average~of~varphi(sigma)),side=2,line=1.5)
par(op)
dev.off()



