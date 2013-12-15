
#Examination of sample data

# install.packages("Matching")
library(Matching)
# install.packages("rbounds")
library("rbounds")

mydata<- read.csv("matching_earnings.csv")
attach(mydata)

# Defining variables (Tr is treatment, Y is outcome, X are independent variables)
Tr <- cbind(TREAT)
Y <- cbind(RE78)
X <- cbind(AGE, EDUC, MARR)
var1 <- AGE

# Outcome for difference-in-differences model
# Y <- cbind(REDIFF)

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


# Checking the balancing property
MatchBalance(Tr ~ X, match.out = rr1, nboots=0, data=mydata)
qqplot(var1[rr1$index.control], var1[rr1$index.treated])
abline(coef = c(0, 1), col = 2)

# Genetic matching
gen1 <- GenMatch(Tr = Tr, X = X, BalanceMatrix = X, pop.size = 10)
mgen1 <- Match(Y = Y, Tr = Tr, X = X, Weight.matrix = gen1)
MatchBalance(Tr ~ X, data = mydata, match.out = mgen1, nboots = 0)

# Sensitivity tests
psens(mgen1, Gamma=1.7, GammaInc=.05)
hlsens(mgen1, Gamma=1.7, GammaInc=.05, .1)