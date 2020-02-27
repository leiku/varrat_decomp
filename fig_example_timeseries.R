rm(list=ls())
set.seed(1)

#***make the time series
omega1<-.2
omega2<-.6
w1<-2*pi/3
w2<-2*pi/10
phi<-2*pi*runif(5)
#phi<-2*pi*(0:4)/5
t<-1:(3*10*10)
s.all<-matrix(NA,length(t),length(phi))
s1<-omega1*sin(w1*t)
s2<-matrix(NA,length(t),length(phi))
for (counter in 1:length(phi))
{
  s2[,counter]<-omega2*sin(w2*t+phi[counter])
  s.all[,counter]<-s1+omega2*sin(w2*t+phi[counter])
  s.all[,counter]<-s.all[,counter]-min(s.all[,counter])+1
}

saveRDS(s.all, "Data_example_timeseries.RDS")

#***have a look at 'em
tiff("Figs/fig1_example_timeseries.tif", 
     width=3.5, height=7, units="in",res=600,compression = "lzw")
op<-par(mfrow=c(3,1),oma=c(1,0.5,0,0), mar=c(3.2,3.5,.5,1),mgp=c(2.2,0.5,0), cex.axis=1.2, cex.lab=1.6)

#plot the aggregate time series
pl<-20
plot(t[1:pl],s.all[1:pl,1],type='l',col=rainbow(length(phi))[1],
     ylab="population",xlab=NA,
     ylim=c(min(s.all),max(s.all)+0.1))
for (counter in 2:length(phi))
{
  lines(t[1:pl],s.all[1:pl,counter],type='l',col=rainbow(length(phi))[counter])
}
lines(t[1:pl],apply(FUN=mean,X=s.all[1:pl,],MAR=1),type='l',col='black',lwd=2)
mtext("(a)",3,cex=1.1,adj=0.02,line=-1.2)

#plot the synchronous component
plot(t[1:pl],s1[1:pl],type='l',
     xlab=NA,ylab="pop. component",
     ylim=c(min(s1,s2),max(s1,s2)))
mtext("(b)",3,cex=1.1,adj=0.02,line=-1.2)

#plot the asynchronous components
plot(t[1:pl],s2[1:pl,1],type='l',col=rainbow(length(phi))[1],
     xlab="years",ylab="pop. component",
     ylim=c(min(s1,s2),max(s1,s2)+0.1))
for (counter in 2:length(phi))
{
  lines(t[1:pl],s2[1:pl,counter],type='l',col=rainbow(length(phi))[counter])
}
#lines(t[1:pl],apply(FUN=mean,X=s2[1:pl,],MAR=1),type='l',col='black',cex=2)
mtext("(c)",3,cex=1.1,adj=0.02,line=-1.2)

par(op)
dev.off()


