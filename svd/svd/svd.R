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

#first approximation
tux.gray.reduce1 <- reduce(tux.gray, 1)
image(1:dims[1],1:dims[2], tux.gray.reduce1, col = grey(seq(0, 1, length = 256)))

#more approximation
tux.gray.reduce50 <- reduce(tux.gray, 50)
image(1:dims[1],1:dims[2], tux.gray.reduce50, col = grey(seq(0, 1, length = 256)))

