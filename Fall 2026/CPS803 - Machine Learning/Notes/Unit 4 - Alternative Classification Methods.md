
# Support Vector Machines (SVM)

- Find a linear hyperplane (decision boundary) that will separate the data
- Support vectors are the instances located on the margins
- Hard margin classification
	- Instances should be linearly separable
- Soft margin
	- Balance between keeping margins as large as possible and limiting margin violations
- Small c values
	- Large margins, but higher training errors
	- Prioritize simplicity
- Larger c values
	- Emphasis on minimizing the training error

- Non linear decision boundary
	- Transform data into high dimensional space so that it is linearly separable by a hyperplane
	- Rather than run SVM on data X, run it on mapped data $\theta(X)$

- Pairwise dot product between the data vectors often computed in machine learning
- Dot product gives a notion of similarity between the data bectors
- Relationships can be used as information to classify instances

- Compute the dot product, $\theta(x_i), \theta(x_j)$ of the instances $x_i$ and $x_j$ transformed by $\theta$ to be linearly separable
- Then use SVM on these relationships
- Function, $k$, should have properties similar to a dot product

- Kernel trick
	- Less expensive
	- A kernel function compute the relationships (similarity) between each data points, as if these data points had been transformed to higher dimensions
	- Data set is represented by an $x \times x$ kernel matrix of pairwise similarity comparisons

- Linear
	- Dot product between instances a and b
	- Transformation is the identity function $\theta(a)=a$
	- Gives a flat decision boundary

$K(a, b)=a^Tb$

- Polynomial
	- a and b describes by 2 features
		- $(a_1, a_2)$
		- $(b_1, b_2)$
	- A polynomial transformation of degree 2
	- Dot product
	- Instead if the kernel value is computed
	- Gives a curved decision boundary

$K(a, b)=(\gamma a^Tb+r)^d$

- Gaussian RBF
	- Population: Radian Basis Function (RBF) kernel
	- Hard or impossible to find the corresponding non-linear transformation
		- Infinite dimensions
	- Kernel expression simple
	- $\gamma$ adjusted to make the boundary smoothing or rougher

$K(a, b) = exp(-\gamma || {a-b}||^2)$


# Support Vector Machines (SVM)

- Kernel trick
	- Relationship between data points is directly computer as if the data points had been transformed to higher dimensions, but without tranfsorming these points
	- Plug only the information
		- Parametrs
		- Feature values
	- Similarity between the points
	- Similarity is used to separate the points using the simple linear SVM method

# Naive Bayes

- A probabilistic framework for solving classification problems

$P(Y|X)= \frac{P(X|Y)P(Y)}{P(X)}$

$P(Y|X)$ = posterior probability of class Y given the attribute X
$P(X|Y)$ = likelihood of the attribute X given the class Y
$P(Y)$ = prior probability of the class
$P(X)$ = prior probability of the attribute

- Given an instance with attribute, the goal is to predict class Y
- Find the value of Y that maximizes $P(Y|X_1, X2, ...)$

- Compute posterior probability using the Bayes theorem
- Choose Y that maximizes
	- $P(Y|X_1, X2, ...)$
- Equivalent to choosing value of Y that maximizes
	- $P(X_1, X_2, ... | Y)P(Y)$

<img src="/images/Pasted image 20261103231701.png" alt="image" width="500">

```python
# bayes theorem

P(Yes|X) = P(X|Yes)P(Yes)/P(X)
P(No|X) = P(X|No)P(No)/P(X)

P(Y) = fraction of instances of class Y
P(No) = 7/10
P(Yes) = 3/10
```

- Assume independence among attributes $X_i$ when class is given

$P(X_1, X_2, ... | Y)P(Y)$ = $P(X_1|Yj)P(X_2|Yj)$

```python
# estimate P(X|Yes) and P(X|No)

P(X|Yes) =
	P(Refund = No|Yes)
	P(Divorced|Yes)
	P(Income = 120k|Yes)
	
P(X|No) =
	P(Refund = No|No)
	P(Divorced|No)
	P(Income = 120k|No)
```


- For categorical attributes

$P(X_i = c|y) = \frac{n_c}{n}$

$n_c$ = number of instances having attribute value, $X_i =c$ and belonging to class $y$

$n$ = number of instances belonging to class $y$

## Naive Bayes

- For continuous attribute
	- Discretization
		- Partition the range into partitions
		- Replace continuous value with partition value
		- Attribute changed from continuous to ordinal
	- Probability density estimation
		- Assume attribute follows a normal distribution
		- Use data to estimate parameters of distribution
			- Mean
			- Standard deviation
		- Once probability distribution is known, use it to estimate the condition probability $P(X_i|Y)$


```python
P(Refund = Yes | No) = 3/7
P(Refund = No | No) = 4/7
P(Refund = Yes | Yes) = 0
P(Refund = No | Yes) = 1
P(Marital Status = Single | No) = 2/7
P(Marital Status = Divorced | No) = 1/7
P(Marital Status = Married | No) = 4/7
P(Marital Status = Single | Yes) = 2/3
P(Marital Status = Divorced | Yes) = 1/3
P(Marital Status = Married | Yes) = 0
```


# Nearest Neighbour Classifiers

- Set of stored records
- Distance metric to compute distance between records
- The value of k, the number of nearest neighbours to retrieve
- Classify unknown recrods
	- Compute distance to other training records
	- Identify k nearest neighbours
	- Use class labels of nearest neighbours to determine the class label of unknown record
		- Majority vote
- K-nearest neighbour or a record x are data points that have the k smallest distance to x

<img src="/images/Pasted image 20261103233113.png" alt="image" width="500">

- Compute distance between two points

- Euclidean distance

$d(p, q) = \sqrt{\sum_i{p_i-q_i}^2}$

- Determine the class from nearest neighbour list
	- Take the majority vote of class labels among the k-nearest neighbours
	- Weight the vote according to distance
		- $w = 1/d^2$

- Choosing the value of k
	- Too small
		- Sensitive to noise points
	- Too large
		- Neighbour hood may include points from other classes

- Scaling issues
	- Attributes may have to be scaled to prevent distance measure from being dominated by one of the attributes

## Attribute Transformation

- An attribute transformation is a function that maps the entire set of values of a given attribute to a new set of replacement values such that each old value can be identified with one of the new values
	- Simple functions
		- $x^k$
		- $log(x)$
		- $e^x$
		- $|x|$
- Standardization
	- Refers to various techniques to adjust to differences among attribute in terms of frequency of occurrence, mean, variance, range

- Normalization

$x_{norm} = \frac{x-x_{min}}{x_{max}-x_{min}}$

- Standardization

$x_{scaled} = \frac{x-mean}{std}$

## Nearest neighbour Classifiers

- KNN classifiers are lazy learners
	- Does not build models explicity
	- Unlike eager learners such as decision tree induction and rule-based systems
	- Classifying unknown records are relatively expensive

# Artificial Neural Network

- Complex non-linear function that can be learned as a composition of simple processing units
- ANN is a collection of simple processing units that are connected by directed links (edges)
- Every node receives signals from incoming edges, performs computations, and transmits signals to outgoing edges
- Analogous to human brain where nodes are neurons and signals are electrical impulses

<img src="/images/Pasted image 20261103233925.png" alt="image" width="500">

- Output Y is 1 if at least 2 of the 3inputs are equal to 1

```pthon
Y = I(0.3X1 + 0.3X2 + 0.3X3 - 0.4 > 0)
```

- ANN usually has more than one hidden layer of computing nodes
- Every node is a hidden layer operates on activations (outputs) from nodes in preceding layer
- Transmits activations to nodes of next layer

<img src="/images/Pasted image 20261103234050.png" alt="image" width="500">

- Number of layers is known as depth of ANN
- Training ANN means learning the weights

- Activation functions
	- ReLU
	- Sigmoid
	- Tanh
	- Binary step function

- Algorithm
	- Randomly initialize all the weights
	- Adjust the weight such that the final output is consistent with class labels y of training examples
	- Forward propagation
		- Estimate output $Y_i$ given input $X_i$ and weights $w_i$
	- Backpropagation
		- Find weights that minimize the output estimation error
		- Measured using objective function

$E = \sum{[Y_i-f(w_i, X_i)]^2}$


## Forward Propagation

- Weights have some values
- Feed data to the input layer
- Each value assigned to each unit is forward to the first hidden layer
- Each unit in the hidden layer multiplies each of these values with its weight vector, sums the multiplied values, adds a bias, applies the activation function, and forward the resulting value to the next layer

<img src="/images/Pasted image 20261103234652.png" alt="image" width="500">


$z = (1)(-30) + 20x1 + 20x2$

$g(z) = \frac{1}{(1+e^{-z})}$

<img src="/images/Pasted image 20261103234709.png" alt="image" width="500">

$z = (1)(10) + -20x1 + -20x2$


<img src="/images/Pasted image 20261103234719.png" alt="image" width="500">

$g1 = (1)(-30) + 20x1 + 20x2$
$g2 = (1)(10) + -20x1 + -20x2$
$g3 = (1)(-10) + 20g1 + 20g2$

- Minimize the output error
	- Compare the desired output and actual output
	- Compute the contribution of each output connection to the error
	- Compute the contribution of each connection in lower layer to these errors
	- Tweak all connection weights using gradient descent

- Number of feature = number if input units
- Number of class = number of output units
- Number of hidden layers and number of units per layer
	- More the better, but computation is expensive
- Layer close to the input layer are called layer layers, and closer to the output are upper layers
- Algorithm
	- Randomly initialize all the weights
	- Adjust the weights such that the final output is consistent with class labels y of training examples
	- Forward propagation to estimate output y given input X and weights $w_i$
	- Backpropagation to find the weights that minimize the output estimation error

# Classifiers

- Classification problems where classes are skewed
- Some evaluation measure
	- Accuracy is not well suited for imbalanced class

- Confusion matrix

<img src="/images/Pasted image 20261103235842.png" alt="image" width="500">

<img src="/images/Pasted image 20261103235855.png" alt="image" width="500">

- Problem with accuracy