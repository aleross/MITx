# Preliminaries
#-------------------------------------------------
#install.packages('perm')
library(perm)
rm(list = ls())
setwd("/Users/alexross/MITx/Module7")

# Questions 1 - 4
#-------------------------------------------------
#print(dat)
perms <- chooseMatrix(8,4)
A <- matrix(c(0.462, 0.731, 0.571, 0.923, 0.333, 0.750, 0.893, 0.692), nrow=8, ncol=1, byrow=TRUE)

treatment_avg <- (1/4)*perms%*%A
control_avg <- (1/4)*(1-perms)%*%A
test_statistic <- abs(treatment_avg-control_avg)

rownumber <- apply(apply(perms, 1, function(x) (x == c(0, 1, 0, 0, 0, 1, 1, 1))), 2, sum)
rownumber <- (rownumber == 8)
observed_test <- test_statistic[rownumber == TRUE]
larger_than_observed <- (test_statistic >= observed_test)
sum(larger_than_observed)

df <- data.frame(perms,control_avg,treatment_avg,test_statistic)

# Question 5 - 6
#-------------------------------------------------
simul_stat <- as.vector(NULL)
schools <- read.csv('teachers_final.csv')
set.seed(1001)
for(i in 1:10000) {
  print(i)
  schools$rand <- runif(100,min=0,max=1)
  schools$treatment_rand <- as.numeric(rank(schools$rand)<=49)
  schools$control_rand = 1-schools$treatment_rand
  simul_stat <-append(simul_stat,
            sum(schools$treatment_rand*schools$open)/sum(schools$treatment_rand) 
            - sum(schools$control_rand*schools$open)/sum(schools$control_rand))
}

schools$control = 1-schools$treatment
actual_stat <- sum(schools$treatment*schools$open)/sum(schools$treatment) - 
  sum(schools$control*schools$open)/sum(schools$control)

sum(abs(simul_stat) >= actual_stat)/NROW(simul_stat)

#Question 7 - 8
#---------------------------------------------------
#Printing the ATE
ate <- actual_stat
ate

control_mean <- sum(schools$control*schools$open)/sum(schools$control)
treatment_mean <- sum(schools$treatment*schools$open)/sum(schools$treatment)

s_c <- (1/(sum(schools$control)-1))*sum(((schools$open-control_mean)*schools$control)^2)
s_t <- (1/(sum(schools$treatment)-1))*sum(((schools$open-treatment_mean)*schools$treatment)^2)

Vneyman <- (s_c/sum(schools$control) + s_t/sum(schools$treatment))
print(sqrt(Vneyman))
print(actual_stat/sqrt(Vneyman))

print(actual_stat-1.96*sqrt(Vneyman))
print(actual_stat+1.96*sqrt(Vneyman))

# Question 12
ate / 2

# Question 13
sigma <- (s_c + s_t)/2
power <- 0.9
alpha <- 0.05
tau <- 0.098 ^ 2
N <- ((qnorm(power) + qnorm(1 - (alpha/2))) ^ 2) / ((tau/(sigma)) * 0.5 * 0.5)
N

# Question 15
#---------------------------------------------------
#install.packages('np')
library(np)
attach(schools)
plot <-npreg(xdat=schools$open, ydat= schools$teacherscore, bws=0.04,bandwidth.compute=FALSE)
plot(plot)

# Question 18
library('ggplot2')

# score_cv is a list of scores from the control group
control <- schools$control*schools$open
score_cv <- control[control > 0]

# score_tv is a list of scores from the treatment group
# the number of entries in score_tv do not match those in score_cv
treatment <- schools$treatment*schools$open
score_tv <- treatment[treatment > 0]

# create data frames from lists
# the data frames have one column each
cv <- cbind.data.frame(score_cv)
tv <- cbind.data.frame(score_tv)

# give the column a name
colnames(cv) <- colnames(tv) <- "score"

# add a group number to the data frames
# 0 for control, 1 for treatment
cv_df <- cbind(0, cv$score)
tv_df <- cbind(1, tv$score)

# combine the two dataframes into one (longer) data frame
y <- rbind.data.frame(cv_df, tv_df)

# give the data frame column names
colnames(y) <- c("group", "score")

# plot ecdf of the two groups
ggplot(y, aes(x=score, colour=factor(group))) + stat_ecdf() + labs(colour="group")
