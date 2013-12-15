
# Examining how unemployment insurance affects the time that it takes in order to find a job
# Methodology used: Survival Analysis

library(survival)
data <- read.csv('survival_unemployment.csv')

attach(data)

# Spell - This is the dependent variable ; it is the number of periods that a person is unemployed.
time <- spell

# Event implies that the person has found a job
event <- event

#ui (unemployment insurance as 0 or 1, age, and a log of wage earned)
X <- cbind(logwage, ui, age)

# renaming unemployment insurance. 
group <- ui

# Kaplan-Meier non-parametric analysis

kmsurvival1 <- survfit(Surv(time, event) ~ group)
summary(kmsurvival1)

#Plotting this survfit shows that people with unemployment insurance take longer to get a job
plot(kmsurvival1)




