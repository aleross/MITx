rm(list = ls())
setwd("/Users/alexross/MITx/FinalExam")
library("dplyr")

# Question 16???
dat1 = matrix(c(0.9, 0.1, 0, 0, 0, 0, 0.6, 0.4), ncol = 2)
fisher.test(dat1)

# Questions 24-27
data = read.csv("qian.csv")

# Question 24
data$post = as.integer(data$biryr >= 1979)
data$postxteasown = data$post * data$teasown
count(filter(data, post == 1))

# Question 25
model1 = lm(sex ~ teasown + post + postxteasown, data = data)
summary(model1)
round(coef(model1)[["(Intercept)"]], 3)
round(coef(model1)[["teasown * post "]], 3)

# Question 26-27
model2 = lm(sex ~ post + postxteasown + factor(admin), data = data)
(beta3 = coef(model1)[["postxteasown"]])
(alpha3 = coef(model2)[["postxteasown"]])
alpha3 <= beta3 # False
alpha3 >= beta3 # True

(beta3pvalue = summary(model1)$coefficients[,4][["postxteasown"]])
(alpha3pvalue = summary(model2)$coefficients[,4][["postxteasown"]])
beta3pvalue >= alpha3pvalue # True
beta3pvalue <= alpha3pvalue # False
