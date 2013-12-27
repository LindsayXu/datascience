library(DMwR)
library(cluster)
data(algae)

dm <- daisy(algae)

o <- outliers.ranking(dm)

o$prob.outliers[o$rank.outliers]

data(sales)

s <- sales[sales$Prod == 'p1',c(1,3:4)]

tr <- na.omit(s[s$ID != 'v431', -1])
ts <- na.omit(s[s$ID == 'v431', -1])

o1 <- outliers.ranking(data=tr, test.data=ts, clus=list(dist='euclidean', alg='hclust', meth='average'))