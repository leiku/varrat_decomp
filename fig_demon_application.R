## Fig. 2 ##
rm(list=ls())

tiff("Figs/fig_demon_application1.tif", 
     width=11, height=3, units="in",res=600,compression = "lzw")
op1<-par(mfrow=c(1,4),oma=c(0.5,0.5,0.5,0.5), mar=c(4,4,3,1),mgp=c(2,0.5,0),
        tck=-.02,cex.axis=1.2,cex.lab=1.5,cex.main=1.5)



########### artificial example ##########
s.all <- readRDS("Data_example_timeseries.RDS")

res.ts <- tsvreq_classic(t(s.all))
freqs <- 1/res.ts$ts
vrfs <- res.ts$tsvr
vrfs[abs(freqs-1/3)>1e-10 & abs(freqs-1/10)>1e-10 & abs(freqs-2/3)>1e-10 & abs(freqs-9/10)>1e-10]<-NA

res.class <- vreq_classic(t(s.all))


xaxt<- c(.1,1/3,1/2,2/3,.9)
xaxl<- c('10','3','2','1.5','1.1')

topfact<-1.2

#plot the frequency specific vr
pchs <- rep(16, length(freqs))
pchs[c(100,200)] <- 15
plot(freqs,vrfs,type='p', xlim=rev(range(freqs)), xlab="timescale (years)",
     ylab=expression(paste(italic(varphi)[ts])~(italic(sigma))),xaxt='n',
     ylim=c(0,max(vrfs,na.rm=T)),pch=pchs,cex=2)
axis(side=1,at=xaxt,labels=xaxl)
lines(c(0,1),c(1,1),lty='dashed')
lines(c(.5,.5),c(0,max(vrfs, na.rm=T)),lty='dotted')
rect(2,-max(vrfs, na.rm=T),0.5,2*max(vrfs, na.rm=T),density=NA,col=rgb(0,0,0,alpha=0.2))
text(0.5,max(vrfs,na.rm=T)-0.6,
     labels=bquote(italic(varphi)==~.(round(res.class$vr,4))),
     adj=c(-0.1,0.5),cex=1.3)
text(0.5, 1.4, labels="synchronous", col="darkgray", cex=1.5)
text(0.5, 0.6, labels="compensatory", col="darkgray", cex=1.5)
mtext("(a)",3,cex=1,adj=0.02,line=-1.2)

#plot CVcomip^2
plot(freqs,res.ts$comnull, type='l',
     xlim=rev(range(freqs)), xlab="timescale (years)",
     ylim=c(0,topfact*max(res.ts$comnull)),ylab=expression(paste(CV[com_ip]^2,(italic(sigma)))),xaxt='n')
axis(side=1,at=xaxt,labels=xaxl)
lines(c(.5,.5),c(0,topfact*max(res.ts$comnull)),lty='dotted')
rect(2,-max(res.ts$comnull), 0.5,2*max(res.ts$comnull),density=NA,col=rgb(0,0,0,alpha=0.2))
text(0.5,max(res.ts$comnull)+0.05*diff(range(res.ts$comnull)),
     labels=bquote(paste(CV[com_ip]^2,"=",.(round(res.class$comnull,4)))),
     adj=c(-0.05,0), cex=1.2)
mtext("(b)",3,cex=1,adj=0.02,line=-1.2)

#plot CVcom
plot(freqs,res.ts$com,type='l',  
     xlim=rev(range(freqs)), xlab="timescale (years)",
     ylim=c(0,topfact*max(res.ts$com)),ylab=expression(paste(CV[com]^2,(italic(sigma)))),xaxt='n')
axis(side=1,at=xaxt,labels=xaxl)
lines(c(.5,.5),c(0,topfact*max(res.ts$com)),lty='dotted')
rect(2,-max(res.ts$com),0.5,2*max(res.ts$com),density=NA,col=rgb(0,0,0,alpha=0.2))
text(0.5,max(res.ts$com)+0.05*diff(range(res.ts$com)),
     labels=bquote(paste(CV[com]^2,"=",.(round(res.class$com,4)))),
     adj=c(-0.1,0), cex=1.2)
mtext("(c)",3,cex=1,adj=0.02,line=-1.2)



#plot cv2com vs. cv2comip
cvcom <- c(res.ts$com[which.min(abs(freqs-1/3))], res.ts$com[which.min(abs(freqs-1/10))])
cvpop <- c(res.ts$comnull[which.min(abs(freqs-1/3))], res.ts$comnull[which.min(abs(freqs-1/10))])

plot(log10(cvcom)~log10(cvpop), xlim=c(-3.5,-1),ylim=c(-3.5,-1), xaxt="n", yaxt="n",#log='xy',
     xlab=expression(paste(CV[com_ip]^2~(italic(sigma)))),ylab=expression(paste(CV[com]^2~(italic(sigma)))),
     #col=c(4,2),pch=c(0,1),cex=2)
     col=c("black","black"),pch=c(15,16),cex=2)
abline(0,1,lty=2)
axis(1, at=c(-3,-2,-1), labels = c(0.001,0.01,0.1))
axis(2, at=c(-3,-2,-1), labels = c(0.001,0.01,0.1))
text(-2.5, -1.6, labels="synchronous", col="darkgray", cex=1.5, srt=45)
text(-1.7, -2.7, labels="compensatory", col="darkgray", cex=1.5, srt=45)
mtext("(d)", side=3, cex=1, line=-1.2, adj=0.05)

dev.off()


####### find an example plot from JRG: the 15th
library(scales) # col: alpha
Res <- readRDS("result_basic.RDS")

res <- Res[[1]][[2]]  #JRG

i.chosen <- 15

##output values of classic vr, CV2com and CV2com_ip, and corresponding p-values
vr.class <- res$vr[i.chosen, 3] 
CV2com.class <- rowSums(Res[[1]][[1]][[2]])[i.chosen]
CV2comnull.class <- rowSums(Res[[1]][[1]][[3]])[i.chosen]

### new added (p-values)
Res.prop <- readRDS("result_shuffling_proportion.RDS")
p.vr <- Res.prop[[1]][[3]][i.chosen]
p.com <- Res.prop[[1]][[1]][i.chosen]
p.comnull <- Res.prop[[1]][[2]][i.chosen]
save(vr.class, CV2com.class, CV2comnull.class,
     p.vr, p.com, p.comnull, file="JRGSinglePlotResults.RData")


tiff("Figs/fig_demon_application2.tif", 
     width=11, height=3, units="in",res=600,compression = "lzw")
op2<-par(mfrow=c(1,4),oma=c(0.5,0.5,0.5,0.5), mar=c(4,4,3,1),mgp=c(2,0.5,0),
        tck=-.02,cex.axis=1.2,cex.lab=1.5,cex.main=1.5)

###new added (choosing color by p)
col.p <- function(pvalue){
  if(pvalue > 0.05){
    return("darkgray")
  }else{return("black")}
}

barplot(res$vr[i.chosen, 1:2],names.arg=c('Short','Long'),ylab=expression(paste(weighted~average~of~italic(varphi)[ts]~(italic(sigma)))),border=F,
        xlab="timescale",ylim=c(0, 1.6),col=c('lightgray','lightgray')); 
abline(h=1,lty=2,col="darkgray", lwd=2)
abline(h=res$vr[i.chosen, 3], lty=1, col="black")
points(res$vr[i.chosen, 1:2]~c(0.7,1.9),pch=c(15,16),col=c('black','black'),cex=2)
lines(res$vr[i.chosen, 1:2]~c(0.7,1.9),col=col.p(p.vr))
text(1.3, 1.15, labels="synchronous", col="darkgray", cex=1.5)
text(1.3, 0.85, labels="compensatory", col="darkgray", cex=1.5)
text(0.7,max(res$vr[i.chosen, 1:2],na.rm=T)+0.15,
     labels=bquote(italic(varphi)==~.(round(vr.class,4))),
     adj=c(-0.1,0.5),cex=1.3)
mtext("(a)", side=3, cex=1, line=-1.2, adj=0.05)

barplot(res$comnull[i.chosen, 1:2],names.arg=c('Short','Long'),ylab=expression(paste(average~of~CV[com_ip]^2~(italic(sigma)))),border=F,
        xlab="timescale", ylim=c(0, 0.007),col=c('lightgray','lightgray'))
#points(res$comnull[i.chosen, 1:2]~c(0.7,1.9),pch=c(15,16),col=c('blue','red'),cex=2)
points(res$comnull[i.chosen, 1:2]~c(0.7,1.9),pch=c(15,16),col=c('black','black'),cex=2)
lines(res$comnull[i.chosen, 1:2]~c(0.7,1.9), col=col.p(p.comnull))
text(0.65,max(res$comnull[i.chosen, 1:2])+0.05*diff(range(res$comnull[i.chosen, 1:2])),
     labels=bquote(paste(CV[com_ip]^2,"=",.(round(CV2comnull.class,4)))),
     adj=c(-0.05,0), cex=1.2)
mtext("(b)", side=3, cex=1, line=-1.2, adj=0.05)

barplot(res$com[i.chosen, 1:2],names.arg=c('Short','Long'),ylab=expression(paste(average~of~CV[com]^2~(italic(sigma)))),border=F,
        xlab="timescale", ylim=c(0, 0.007),col=c('lightgray','lightgray'))
#points(res$com[i.chosen, 1:2]~c(0.7,1.9),pch=c(15,16),col=c('blue','red'),cex=2)
points(res$com[i.chosen, 1:2]~c(0.7,1.9),pch=c(15,16),col=c('black','black'),cex=2)
lines(res$com[i.chosen, 1:2]~c(0.7,1.9), col=col.p(p.com))
text(0.65,max(res$comnull[i.chosen, 1:2])+0.05*diff(range(res$comnull[i.chosen, 1:2])),
     labels=bquote(paste(CV[com]^2,"=",.(round(CV2com.class,4)))),
     adj=c(-0.1,0), cex=1.2)
mtext("(c)", side=3, cex=1, line=-1.2, adj=0.05)

plot(log10(res$com[i.chosen, 1:2])~log10(res$comnull[i.chosen, 1:2]), xlim=c(-3.5,-1),ylim=c(-3.5,-1), xaxt="n", yaxt="n",#log='xy',
     #xlab=expression(paste(CV[com_ip]^2~(italic(sigma)))),ylab=expression(paste(CV[com]^2~(italic(sigma)))),col=c(4,2),pch=c(15,16),cex=2)
     xlab="",ylab=expression(paste(average~of~CV[com]^2~(italic(sigma)))),col=c("black","black"),pch=c(15,16),cex=2)
abline(0,1,lty=2)
axis(1, at=c(-3,-2,-1), labels = c(0.001,0.01,0.1))
axis(2, at=c(-3,-2,-1), labels = c(0.001,0.01,0.1))
mtext(expression(paste(average~of~CV[com_ip]^2~(italic(sigma)))),side=1,line=2.6)
text(-2.5, -1.6, labels="synchronous", col="darkgray", cex=1.5, srt=45)
text(-1.7, -2.7, labels="compensatory", col="darkgray", cex=1.5, srt=45)
mtext("(d)", side=3, cex=1, line=-1.2, adj=0.05)


#op<-par(new=T, mfrow=c(1,1),oma=c(0.5,0.5,0.5,0.5), mar=c(0,0,0,0))
#plot(NA, xaxt="n", yaxt="n", bty="n", xlim=c(0,1), ylim=c(0,1), xlab=NA, ylab=NA)
#mtext("Artificial", side=2, line=-1.5, adj=0.82, cex=1.5)
#mtext("Empirical", side=2, line=-1.5, adj=0.18, cex=1.5)
par(op2)

dev.off()


