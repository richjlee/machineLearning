rm(list=ls())
set.seed(123467)

#Simulate data
x = matrix(rnorm(100*2),ncol=2)
x[1:50,1] = x[1:50,1] + 5 
x[1:50,2] = x[1:50,2] - 3

K = 2 # Note: program only works for k=2
#initialize by randomly assigning observations to clusters
init = sample(1:nrow(x), nrow(x), replace=FALSE)
cluster1 = x[c(init[1:50]),]
cluster2 = x[c(init[51:100]),]
mean.error1 = 100 #initialize mean error (arbitrary large value)
delta.error = 100 #initialize stopping variable (arbitrary large value)

#K-means algorithm - stops when change in mean distance between successive iterations is smaller than chosen value
while(delta.error > 0.001) {
  #calculate initial centroid for each cluster
  centroid1 = colMeans(cluster1)
  centroid1 = matrix(centroid1, nrow = 1, ncol = 2)
  centroid1 = do.call(rbind, replicate(50, centroid1, simplify=FALSE))
  centroid2 = colMeans(cluster2)
  centroid2 = matrix(centroid2, nrow = 1, ncol = 2)
  centroid2 = do.call(rbind, replicate(50, centroid2, simplify=FALSE))
  
  #calcualte distance to centroid
  cluster1to1 = abs(cluster1-centroid1)
  cluster1to1 = (cluster1to1^2)
  cluster1to1$dist = cluster1to1[,1] + cluster1to1[,2]
  cluster1to1 = sqrt(cluster1to1$dist)
  cluster1to2 = abs(cluster1-centroid2)
  cluster1to2 = (cluster1to2^2)
  cluster1to2$dist = cluster1to2[,1] + cluster1to2[,2]
  cluster1to2 = sqrt(cluster1to2$dist)
  nearest1 = cluster1to1 < cluster1to2
  
  cluster2to1 = abs(cluster2-centroid1)
  cluster2to1 = (cluster2to1^2)
  cluster2to1$dist = cluster2to1[,1] + cluster2to1[,2]
  cluster2to1 = sqrt(cluster2to1$dist)
  cluster2to2 = abs(cluster2-centroid2)
  cluster2to2 = (cluster2to2^2)
  cluster2to2$dist = cluster2to2[,1] + cluster2to2[,2]
  cluster2to2 = sqrt(cluster2to2$dist)
  nearest2 = cluster2to1 < cluster2to2
  
  nearest = c(nearest1, nearest2)
  
  #Reassign to nearest clusters
  cluster1 = x[nearest,]
  cluster2 = x[!nearest,]
  
  #Calculate mean distance from centroid
  cluster1dist = abs(cluster1-centroid1)
  cluster1dist = (cluster1dist^2)
  cluster1dist$dist = cluster1dist[,1] + cluster1dist[,2]
  cluster1dist = sqrt(cluster1dist$dist)
  cluster2dist = abs(cluster2-centroid2)
  cluster2dist = (cluster2dist^2)
  cluster2dist$dist = cluster2dist[,1] + cluster2dist[,2]
  cluster2dist = sqrt(cluster2dist$dist)
  
  #Calculate change in mean distance and update
  mean.error2 = (mean(cluster1dist) + mean(cluster2dist)) / 2
  delta.error = mean.error1 - mean.error2 
  mean.error1 = mean.error2
  cluster.results = nearest
}

#Plot clusters
plot(x,col=(cluster.results))
