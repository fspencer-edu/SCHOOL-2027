# Cluster Analysis

- Given a set of objects, place them in groups such that the objects in a group are similar to one another and different from the objects in other groups

- Intra-cluster
	- Within a cluster
	- Measure how close data points are to one another inside the same cluster
- Inter-cluster
	- Between clusters
	- Measure the distance or separation between data point or centroids belonging to different clusters
- Reduce the size of large datasets

## Types of Clusterings

- A clustering is a set of clusters
- Partitional clustering
	- A division of data objects into non-overlapping subsets
- Hierarchical clustering
	- A set of nested clusters organized as a hierarchical tree
		- Traditional hierarchical clustering
		- Dendrogram

- Well separated clusters
- Prototype-based clusters
- Contiguity-based clusters
- Density-based clusters

### Well Separated

- A cluster is a set of points such that any point in a cluster is closer (or more similar) to every other point in the cluster than to any point not in the cluster
### Prototype-Based Separated

- A cluster is a set of objects such that an object in a a cluster is closer to the prototype or "center" of a cluster, than to the center of any other cluster
- The center of a cluster is often a centroid
	- The average of all the points in the cluster
- Memoid
	- The most representative point of a cluster
### Contiguity-Based Separated

- Contiguous cluster (nearest neighbour or transitive)
	- A cluster is a set of points such that a point in a cluster is closer to one or more other points in the cluster than to any point not in the cluster
### Density-Based Separated

- A cluster is a dense region of points, which is separated by low-density regions, from other regions of high density
- Used when the clusters are irregular or intertwined
- Noise and outliers are present

## Objective Function

- Clusters defined by an objective function
	- Finds clusters that minimize or maximize an objective function
	- Enumerate all possible ways of dividing the points into clusters and evaluate the goodness of each potential set of clusters by using the given objective function
	- A variation of the global objective function approach is to fit the data to a parameterized model

# Clustering Algorithms

- K-means and its variants
- Hierarchical clustering
- Density based clustering

## K-Means Clustering

- Partitional clustering approach
- Each cluster is associated with a centroid
- Number of clusters, K, must be specified
- Each point is assigned to the cluster with the closest centroid
- Initial centroids are chosen randomly
	- Clusters produced can vary from one run to another
- Centroid is the mean of the points in the cluster
	- Other definitions are possinle
- K-means will converge for common proximity measure with approxpriately defined centroid
- Most of the convergence happens in the first few iterations

- A common objective function is the sum of squared error (SSE)
	- For each point, the error is the distance to the nearest cluster centre
	- To get SSE, square errors and sum
- x is a data point in the cluster, and m is the centroid
- SSE improves in each iteration of K-means until it reaches a local or global minima

- Selecting Initial points
	- If there are K real cluster than the chance of selected one centroid from each cluster is small
		- Chance is relatively small when K is large

- Solutions to initial centroid problem
	- Multiple runs
	- Some strategy to select the k initial centroids
	- Bisecting K-means
		- Variant of K-means that can produce a partitional or a hierarchical clustering

- Limitations of K-means
	- Sizes
	- Densities
	- Non-globular shapes
- Remove outliers before clustering

- Overcoming K-means limitations
	- Find a large number of clusters
	- Combine the small clusters in a post processing step

## Hierarchical Clustering

- Produces a set of nested clusters organized as a hierarchical tree
- Visualized as a dendrogram

<img src="/images/Pasted image 20261104003624.png" alt="image" width="500">

- Do not have to assume any particular number of clusters
- Desired number of clusters can be obtained by cutting the dendrogram at the proper level
- Correspond to meaningful taxonomies

- 2 main types of hierarchical clustering
	- Agglomerative
		- Start with the points as individual clusters
		- Merge the closest pair of clusters until only one cluster left
	- Divisive
		- Start with one, all inclusive cluster
		- At each step, split a cluster until each cluster contains an individual point
- Traditional hierarchical algorithms use a similarity or distance matrix
	- Merge or split one cluster at a time

### Agglomerative Clustering Algorithms

- Successively merge closest clusters
- Let each data point be a cluster
- Compute the proximity matix
	- Merge the two closest
	- Update the proximity matrix
- 


## Density Based Clustering