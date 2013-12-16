load("./data/samsungData.rda")

numericActivity <- as.numeric(as.factor(samsungData$activity))[samsungData$subject==1]

distanceMatrix <- dist(samsungData[samsungData$subject==1,1:3])
hclustering <- hclust(distanceMatrix)

svd1 <- svd(scale(samsungData[samsungData$subject==1,-c(562,563)]))

par(mfrow=c(1,2))
plot(svd1$u[,1],col=numericActivity, pch=19)
plot(svd1$u[,2],col=numericActivity, pch=19)
