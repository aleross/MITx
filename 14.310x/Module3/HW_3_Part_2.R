#Preliminaries
#---------------------------------------
rm(list=ls())
library("utils")
#install.packages('plot3D')
library(plot3D)
setwd("/Users/alexross/MITx/Module3")

#Creating the vector x and y
M <- mesh(seq(0,1,length=100), seq(0,1,length=100))
x<-M$x
y<-M$y
z<-6/5*(M$x+M$y^2)

#Plotting this pdf
persp3D(x, y, z, xlab='X variable', ylab= 'Y variable', xlim = c(0,1), main= "Plotting joint pdf')")

# Calculate cdfs for x (Caroline) and y (Anna)
x <- seq(0, 1, length=1000)
y <- seq(0, 1, length=1000)
# complete the cdfx formula below; code will not work without this!
cdfx <- (6/5*((x^2)/2 + x/3))
# complete the cdfy formula below; code will not work without this!
cdfy <- (2*y^3+3*y)/5
  
  # Plotting cdf using ggplot
  library("ggplot2")
ggplot() +
  geom_line(aes(x=x, y=cdfx, color="Caroline")) + 
  geom_line(aes(x=y, y=cdfy, color="Anna")) +
  xlab("x, y") + 
  ylab("cdfx, cdfy")
