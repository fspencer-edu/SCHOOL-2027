# What is ML?

- Machine learning
	- Finds patterns in data for useful applications in the real world
# Problems applicable to ML

## Supervised learning

- Understand the patterns and relationships among the data
- Predict the results
- Regression
	- Find a line that most correctly fits the data
- Classification
	- Predict categories of examples based on their features

## Unsupervised learning

- Finding underlying patterns in data that may be difficult to find by inspecting the data manually
- Clustering

## Reinforcement learning

- Train an agent in an environment based on rewards and penalties

# A ML workflow

- Data domain knowledge
- Data integrity
	- Missing data
	- Inconsistent data
	- Data formats
- Missing data
	- Remove
	- Mean or median
	- Most frequent
	- Statistical approaches
		- K-nearest
		- Neural networks
	- Do nothing
		- XGBoost
- Ambiguous values
	- Standardization
- Encoding categorical data
	- One hot encoding
	- Label encoding


## Training a model

- Regression means predicting a continuous value
- Least squared method
- Testing the model
	- Training and testing data
	- Performance of the line
		- $R^2$
			- Used to determine variance between the actual value and a predicted value

## Improving accuracy

- Collect mode data
- Prepare the data differently
- Choose different features in the data
- Use a different algorithm to train the model
- Dealing with false-positive tests

# Classification with decision trees

- Decision trees
	- Structures that describe a series of decisions that are made to find a solution to a problem

## Training decision trees

- Classification and Regression Tree (CART)
	- Decide what questions to ask and when to ask those questions to best filter the examples into their respective categories
- Map of classes/label groupings
- Tree of nodes
	- Decision tree
- Question
- Gini index
	- Uncertainty in the dataset
- Entropy
	- Measures disorder using the Gini index for a specific split of data
- Information gain
	- Describes the amount of information gained by asking a question
- Confusion matrix
	- Describes the performance
		- True positive
		- True negative
		- False positive
		- False negative
	- Deduced measurements
		- Precision
		- Negative precision
		- Sensitivity or recall
		- Specificity
		- Accuracy
# Other popular ML algorithms

- Supervised learning
	- Classification
		- Decision trees
		- Logistic regression
		- K-nearest neighbour
		- Support vector machines
		- Naive Bayes
	- Regression
		- Linear regression
		- Polynomial regression
		- Lasse regression
- Unsupervised learning
	- Clusering
		- K-means
		- Mean shift
		- Density based spatial clustering of application with noise (DBSCAN)
		- Agglomerative
	- Dimensionality reduction
		- t-distributed stochastic
		- Neighbour embedding (t-SNE)
		- Principle Component Analysis (PCA)
- Reinforcement learning
	- Q-Leaning
	- Genetic algorithms
	- State action reward state action (SARSA)
- Deep learning
	- Artificial neural networks (ANN)
	- Convolutional neural networks (CNN)
	- Generative adversarial neural network (GAN)
	- Recurrent neural networks (RNN)

# Use cases for ML algorithms

- Fraud and threat detection
- Product and content recommendations
- Dynamic product and service pricing
- Health condition risk prediction
