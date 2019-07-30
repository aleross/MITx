#Preliminaries
#---------------------------------------
rm(list=ls())
library("utils")
#install.packages('plot3D')
library(plot3D)

#Calculating cdf
x <- seq(0, 1, length=1000)
y <- seq(0, 1, length=1000)
cdfy <- 6/5 * (1/2*y+y^3/3)
cdfx <- 6/5*(1/3*x+x^2/2)

#Plotting cdf
pdf("cumulative.pdf")
plot(x, cdfx, type = "l", col="blue", xlab=" ", ylab = "Cumulative Probability", xlim=c(0,1), main="CDF plot")
lines(y, cdfy, lty=2, col="red", lwd=2)
legend("bottomright", ncol=1, legend = c("X", "Y"), lty=c(1,2), col=c("blue", "red"))
dev.off
