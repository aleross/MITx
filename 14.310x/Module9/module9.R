rm(list = ls())
setwd("/Users/alexross/MITx/Module9")

# Questions 1-10
fastfood = read.csv("fastfood.csv")
model = lm(empft ~ state, data = fastfood)
summary(model) # show results 
coef(model) # model coefficients
ci = confint(model, level=0.98)

nj_avg = with(fastfood, mean(empft[state == 1]))
pa_avg = with(fastfood, mean(empft[state == 0]))
avg_diff2 = round(nj_avg - pa_avg, 3) # print avg diff 1
avg_diff1 = round(coef(model)[["state"]], 3) # print avg diff 2

plot(fastfood$wage_st, fastfood$empft)
abline(model, col="red")

# Question 3
model1 = lm(empft ~ state, data = fastfood)
model2 = lm(emppt ~ state, data = fastfood)
model3 = lm(wage_st ~ state, data = fastfood)
summary(model3)

# PA avg wage prior to change
round(coef(model3)[["(Intercept)"]], 3)
round(with(fastfood, mean(wage_st[state == 0], na.rm=TRUE)), 3)

# NJ avg wage prior to change
round(coef(model3)[["(Intercept)"]] + coef(model3)[["state"]], 3)
round(with(fastfood, mean(wage_st[state == 1], na.rm=TRUE)), 3)

# Question 6
model4 = lm(empft ~ state + pa1 + pa2, data = fastfood)
summary(model4)
coef(model4)

# Question 7
model5 = lm(empft2-empft ~ state, data = fastfood)
summary(model5)
coef(model5)

# Questions 11-18
voting = read.csv("indiv_final.csv")
#install.packages("rdd")
library("rdd")

# Question 11
proportion = round(sum(voting$difshare > 0) / (sum(voting$difshare > 0) + sum(voting$difshare <= 0)), 2)

# Question 12-13
result = DCdensity(voting$difshare, ext.out = TRUE, verbose = TRUE)
result$theta

# Question 14
library("dplyr")
voting_subset = filter(voting, difshare >= -0.5 & difshare <= 0.5)
voting_subset$difsharepos = voting_subset$difshare >= 0
voting_subset$difsharesquare = voting_subset$difshare ^ 2
voting_subset$difsharecube = voting_subset$difshare ^ 3

votingmodel1 = lm(myoutcomenext ~ difsharepos, data = voting_subset)
votingmodel2 = lm(myoutcomenext ~ difsharepos + difshare, data = voting_subset)
votingmodel3 = lm(myoutcomenext ~ difsharepos + difshare + difsharepos * difshare, data = voting_subset)
votingmodel4 = lm(myoutcomenext ~ difsharepos + difshare + difsharesquare, data = voting_subset)
votingmodel5 = lm(myoutcomenext ~ difsharepos + difshare + difsharesquare + difsharepos * difshare + difsharepos * difsharesquare, data = voting_subset)
votingmodel6 = lm(myoutcomenext ~ difsharepos + difshare + difsharesquare + difsharecube, data = voting_subset)
votingmodel7 = lm(myoutcomenext ~ difsharepos + difshare + difsharesquare + difsharecube + difsharepos * difshare + difsharepos * difsharesquare + difsharepos * difsharecube, data = voting_subset)

# Question 14
coef(votingmodel1)[["difshareposTRUE"]]
coef(votingmodel2)[["difshareposTRUE"]]
coef(votingmodel3)[["difshareposTRUE"]]
coef(votingmodel4)[["difshareposTRUE"]]
coef(votingmodel5)[["difshareposTRUE"]]
coef(votingmodel6)[["difshareposTRUE"]]
coef(votingmodel7)[["difshareposTRUE"]]

# Question 15
summary(votingmodel1)$coefficients[,4][["difshareposTRUE"]] < 0.01
summary(votingmodel2)$coefficients[,4][["difshareposTRUE"]] < 0.01
summary(votingmodel3)$coefficients[,4][["difshareposTRUE"]] < 0.01
summary(votingmodel4)$coefficients[,4][["difshareposTRUE"]] < 0.01
summary(votingmodel5)$coefficients[,4][["difshareposTRUE"]] < 0.01
summary(votingmodel6)$coefficients[,4][["difshareposTRUE"]] < 0.01
summary(votingmodel7)$coefficients[,4][["difshareposTRUE"]] < 0.01

# Question 17
RDestimate(myoutcomenext ~ difshare, data = voting_subset) # LATE coefficient

# Question 18
bandwidth = RDestimate(myoutcomenext ~ difshare, data = voting_subset)$bw[1]
plot(RDestimate(myoutcomenext ~ difshare, data = voting_subset))
plot(RDestimate(myoutcomenext ~ difshare, data = voting_subset, kernel = "rectangular", bw = 3*bandwidth))
plot(RDestimate(myoutcomenext ~ difshare, data = voting_subset, kernel = "rectangular", bw = bandwidth/3))
