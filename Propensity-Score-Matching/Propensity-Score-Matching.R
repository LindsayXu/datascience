
#Examination of sample data to determine the effect that a training program has on income

# install.packages("Matching")
library(Matching)
# install.packages("rbounds")
library("rbounds")

mydata<- read.csv("matching_earnings.csv")
attach(mydata)

# Defining variables (Tr is treatment, Y is outcome, X are independent variables)

Tr <- cbind(TREAT)          # 0 is there is no training, 1 if there is training

#Construct Y in order to use a difference-in-differences model
Y <- cbind(REDIFF)          # Difference in income that occurs before and after treatment

X <- cbind(AGE, EDUC, MARR)
var1 <- AGE


# Descriptive statistics
summary (Tr)
summary(Y)
summary(X)

# Propensity score model 
glm1 <- glm(Tr ~ X, family=binomial(link = "probit"), data=mydata)
summary(glm1)

# Average treatment on the treated effect
rr1 <- Match(Y = Y, Tr = Tr, X = glm1$fitted)
summary(rr1)
# The difference of differences model shows that the training results in a $2,604 increase in income. 


# Checking the balancing property
MatchBalance(Tr ~ X, match.out = rr1, nboots=0, data=mydata)
qqplot(var1[rr1$index.control], var1[rr1$index.treated])
abline(coef = c(0, 1), col = 2)

# Genetic matching
gen1 <- GenMatch(Tr = Tr, X = X, BalanceMatrix = X, pop.size = 10)
mgen1 <- Match(Y = Y, Tr = Tr, X = X, Weight.matrix = gen1)
MatchBalance(Tr ~ X, data = mydata, match.out = mgen1, nboots = 0)


