# decision tree prediction

data(iris)

pairs(iris[1:4],main="Iris Data (red=setosa,green=versicolor,blue=virginica)", pch=21, bg=c("red","green3","blue")[unclass(iris$Species)])

# prediction with decision trees
library(tree)
tree1 <- tree(Species ~ Sepal.Width + Petal.Width, data=iris)
summary(tree1)

set.seed(32313)
newdata <- data.frame(Petal.Width = runif(20,0, 2.5), Sepal.Width = runif(20,2, 25))
pred1 <- predict(tree1, newdata, type="class")