rm(list = ls())
setwd("/Users/alexross/MITx/Module8")

# Questions 1-6
nlsw88 = read.csv("nlsw88.csv")
single = lm(lwage ~ yrs_school, data = nlsw88)
summary(single) # show results 
coefficients(single) # model coefficients
ci = confint(single, level=0.9)

plot(data$yrs_school, data$lwage)
abline(fit, col="red")

fit = lm(lwage ~ black, data = nlsw88)
summary(fit)

fit2 = lm(lwage ~ yrs_school + ttl_exp, data = nlsw88)
summary(fit2)

res_fit2 = lm(lwage ~ I(yrs_school + 2*ttl_exp), data = nlsw88)
summary(res_fit2)

anova(fit2, res_fit2)

# Question 17
#install.packages("car")
library(car)
multi <- lm(lwage ~ yrs_school + ttl_exp, data = nlsw88)
summary(multi)
matrixR <- c(0, -2, 1)
linearHypothesis(multi, matrixR)
