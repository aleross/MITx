rm(list = ls())
setwd("/Users/alexross/MITx/Module11")

# Questions 1-9
data = read.csv("census80.csv")
summary(data)

compareNA <- function(v1,v2) {
  same <- (v1 == v2) | (is.na(v1) & is.na(v2))
  same[is.na(same)] <- FALSE
  return(same)
}

# Question 2
data$mulpreg = as.integer(compareNA(data$ageq2nd, data$ageq3rd))
summary = summary(data)

# Question 3
data$samesex = as.integer(compareNA(data$sex1st, data$sex2nd))

# Question 4
data$threechild = as.integer(data$numberkids == 3)
model1 = lm(workedm ~ threechild + blackm + hispm + othracem, data = data)
model2 = lm(weeksm ~ threechild + blackm + hispm + othracem, data = data)
summary(model1)
summary(model2)

# Question 5
model3 = lm(threechild ~ mulpreg + blackm + hispm + othracem, data = data)
summary(model3)

# Question 6
model4 = lm(threechild ~ samesex + blackm + hispm + othracem, data = data)
summary(model4)

# Questions 7-8
#install.packages("ivpack")
library("ivpack")

# Question 7
model5 = ivreg(workedm ~ threechild + blackm + hispm + othracem | mulpreg + blackm + hispm + othracem, data = data)
summary(model5)

# iva1 <- ivreg(workedm ~ three + blackm + hispm + othracem | blackm + hispm + othracem + multiple, data = census80)
# iva2 <- ivreg(weeksm ~ three + blackm + hispm + othracem | blackm + hispm + othracem + multiple, data = census80)

# Question 8
model6 = ivreg(workedm ~ threechild + blackm + hispm + othracem | samesex + blackm + hispm + othracem, data = data)
summary(model6)
