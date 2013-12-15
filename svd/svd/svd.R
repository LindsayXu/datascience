source("http://bioconductor.org/biocLite.R")
biocLite("EBImage")

library("EBImage")

tux <- readImage("tux.jpg")
dims <- dim(tux)

convertToGray <- function(pic){
  pic.flip <- Image(flip(pic),colormode="Grayscale") # not sure why this one...
  # convert RGB to grayscale
  red.weight   <- .2989
  green.weight <- .587
  blue.weight  <- 0.114
  r <- red.weight   * imageData(pic.flip)[,,1] + 
    green.weight * imageData(pic.flip)[,,2] + 
    blue.weight  * imageData(pic.flip)[,,3]
  
  return(r)
  
}

tux.gray <- convertToGray(tux)
image(tux.gray, col = grey(seq(0, 1, length = 256)))

reduce <- function(A, dim) {
  
  #Calculate the SVD
  sing <- svd(A)
  
  #Approximate each result of the SVD 
  u<-as.matrix(sing$u[, 1:dim])
  v<-as.matrix(sing$v[, 1:dim])
  d<-as.matrix(diag(sing$d)[1:dim, 1:dim])
  
  return(u%*%d%*%t(v))
  
}



# Scale the data matrix in order to determine what components are contributing the most to variance
tux.gray.svd <- svd(scale(tux.gray))
plot(tux.gray.svd$d, xlab="Column", ylab="Singular value", pch=19)
plot(tux.gray.svd$d^2/sum(tux.gray.svd$d^2), xlab="Column", ylab="Percent of variance explained")
tux.gray.pct.variance <- tux.gray.svd$d^2/sum(tux.gray.svd$d^2)

# Out of the 1038 singular values of our 'image matrix', 20 of those values account for 93% of the variance
sum(tux.gray.pct.variance[1:20])
# [1] 0.9360585

#Code below shows what the penguin looks like when approximated by these 20 components
tux.gray.reduce20 <- reduce(tux.gray, 20)
image(1:dims[1],1:dims[2], tux.gray.reduce20, col = grey(seq(0, 1, length = 256)))

