# Sampling

- Sampling is the main technique employed for data reduction
- Used for both the preliminary investigation of the data and the final data analysis
- Sampling is typically used in data mining because processing the entire set of data is too expensive of time consuming

## Types of Sampling

- Simple random sampling
	- There is an equal probability of selecting any particular item
	- Sampling without replacement
		- As each item is selected, it is removed from the population
	- Sampling with replacement
		- Objects are not removed from the population as they are selected for the sample
		- Same object can be picked up more than once
- Stratified sampling
	- Split the data into several partitions
	- Draw random samples from each partition

# Ensemble Methods

- Construct a set of base classifiers learned from the training data
- Predict class label of test records by combining the predictions made by multiple classifiers
	- Majority vote

<img src="/images/Pasted image 20261104000311.png" alt="image" width="500">

- Each classifier has an error rate of 0.35
- Majority vote of classifiers used for classification
- If all classifiers are identical, error rate of ensemble = 0.35
- If all classifiers are independent, error rate of ensemble = probability of having more than half of base classifiers being wrong

## Constructing Ensemble Classifiers

- Manipulating training set
	- Bagging
	- Boosting
	- Random forests
- Manipulating input features
	- Random forests
- Manipulating learning algorithm
	- Injecting randomness in the initial weights of ANNs

### Bagging (Bootstrap Aggregating)

- Bootstrap sampling
	- Sampling with replacement
	- Build classifier on each bootstrap sample

### Boosting

- An iterative procedure to adaptively change distribution of training data by focusing more on previously misclassified records
	- Initially, all N records are assigned equal weights (for being selected for training)
	- Weights may change at the end of each boosting round
- Records that are wrongly classified will have their weights increased in the next round
- Records that are classified correctly will have their weights decreased in the next round
### AdaBoost

<img src="/images/Pasted image 20261104001104.png" alt="image" width="500">

- Weighted error rate of a base classifier
- Where N is the number of training instances
- If any intermediate rounds produce error rate higher than 50%, the weights re reverted back to 1/n and the resampling procedure is repeated
### Random Forest Algorithm

- Construct an ensemble of decision trees by manipulating training set as well as features
	- Use bootstrap sample to train every decision tree
	- Tree induction algorithm
		- At every internal node of decision tree, randomly sample p attribute for selecting split criterion
		- Repeat this procedure until all leaves are pure