rm(list = ls())
setwd("/Users/alexross/MITx/FinalExam2")

# Question 2 - Hypergeometric distribution
phyper(50-1, 400, 1200-400, 158, lower.tail=FALSE)
1-phyper(50-1, 400, 1200-400, 158)

# Question 4 - web scraping
library(rvest)
webpage <- read_html("https://www.cbinsights.com/research-unicorn-companies")
table <- html_nodes(webpage,"table")[[1]]
mytable <- html_table(table, fill = TRUE)
companies <- as.data.frame.matrix(mytable)
companies <- companies[apply(companies,1,function(x)any(!is.na(x))),]
nrow(companies)
nrow(companies[companies$Country == "United States",])

# Question 5
drug = c(6.1,7,8.2,7.6,6.5,7.8,6.9,6.7,7.4,5.8)
placebo = c(5.2,7.9,3.9,4.7,5.3,4.8,4.2,6.1,3.8,6.3)
difference = drug-placebo

round(mean(difference), 2)
round(var(difference), 2)

t.test(difference, mu = 0)

# Question 6
library(perm)
perms <- chooseMatrix(6,3)
A <- matrix(c(65, 68, 79.2, 60, 74, 72.6), nrow=6, ncol=1, byrow=TRUE)

# Calculating test statistic
treatment_avg <- (1/3)*perms%*%A
control_avg <- (1/3)*(1-perms)%*%A
test_statistic <- abs(treatment_avg-control_avg)

# Calculating p-value
rownumber <- apply(apply(perms, 1, function(x) (x == c(1, 1, 1, 0, 0, 0))), 2, sum)
rownumber <- (rownumber == 6)
observed_test <- test_statistic[rownumber == TRUE]
larger_than_observed <- (test_statistic >= observed_test)
num_larger_than_observed = sum(larger_than_observed)
p_value = num_larger_than_observed / choose(6, 3)

treatment_avg
control_avg
num_larger_than_observed
p_value

# All results
df <- data.frame(perms,control_avg,treatment_avg,test_statistic)

# Question 7
library("tidyr")
banks = read.csv("datasets_banks.csv")
fed_data = gather(subset(banks, select = -c(day, month)), "district", "branches", -year)
fed_data$treatment = as.numeric(fed_data$district == "dis6")
fed_data$post = as.numeric(fed_data$year >= 1931)

model = lm(branches ~ treatment + post + (treatment * post), data = fed_data)
summary(model)

# Question 8
cigs_data = read.csv("datasets_cigs.csv")
cigs_data$ln_price = log(cigs_data$price)
model1 = lm(ln_price ~ SalesTax, data = cigs_data)
summary(model1)
round(coef(model1)[["SalesTax"]], 3)

library("ivpack")
iva1 = ivreg(log(packs) ~ log(price) | SalesTax, data = cigs_data)
summary(iva1)
round(coef(iva1)[["log(price)"]], 3)

iva2 = ivreg(log(packs) ~ log(price) + log(income) | SalesTax + log(income), data = cigs_data)
summary(iva2)
round(coef(iva2)[["log(price)"]], 3)

########################
# Fisher Exact Test
########################
library(perm)
perms <- chooseMatrix(8,4)
A <- matrix(c(0.85, 0.99, 1.00, 0.76, 0.26, 0.45, 0.97, 0.72), nrow=8, ncol=1, byrow=TRUE)

# Calculating test statistic
treatment_avg <- (1/4)*perms%*%A
control_avg <- (1/4)*(1-perms)%*%A
test_statistic <- abs(treatment_avg-control_avg)

# Calculating p-value
rownumber <- apply(apply(perms, 1, function(x) (x == c(1, 1, 1, 1, 0, 0, 0, 0))), 2, sum)
rownumber <- (rownumber == 8)
observed_test <- test_statistic[rownumber == TRUE]
larger_than_observed <- (test_statistic >= observed_test)
num_larger_than_observed = sum(larger_than_observed)
p_value = num_larger_than_observed / choose(8, 4)

# All results
df <- data.frame(perms,control_avg,treatment_avg,test_statistic)

# Can't get this to work
data2 = matrix(c(0.85, 0.99, 1, 0.76, 0.26, 0.45, 0.97, 0.72), nrow=2, ncol=4, byrow=TRUE)
chisq.test(data2)

fisher.test(data2)
