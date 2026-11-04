# Model Underfitting and Overfitting

- Underfitting
	- Model is too simple, both training and test errors are large
- Overfitting
	- Model is too complex, training error is small but test error is large
	- Not enough training data
	- High model complexity

# Classification Errors

- Training errors
- Testing errors

$Error Rate$ = $\frac{Incorrect Predictions}{Total Pred}$

```python
Data pred Actual Result
1      1     1    Correct
2      -1    1    Incorrect
3      1     1    Correct
4      1    -1    Incorrect
5      -1    -1   Correct

Error = 2/5 = 0.4
Accuracy = 1 - Error
= 1 - 0.4
0.6
```

# Model Evaluation

- To estimate performance of classifier on previously unseen data (test set)
- Holdout
	- Reserve %k for training and (100-k)% for testing
	- Repeated holdout
- Cross validation
	- Partition data into k disjoint subsets
	- k-fold
		- Train on k-1 partitions, test on remaining one
		- Leave one out
			- k = n

## Variations on Cross Validation

- Repeated cross validaton
	- Perform cross validation a number of times
	- Gives an estimate of the variance of the generalization error
- Stratified cross validation
	- Guarantee the same percentage of class labels in the training and test
	- Important when classes are imbalanced and the sample is small
- Use nested cross validation approach for model selection and evaluation

## Model Selection

- Select the kind of model to deploy
	- Best algorithm and hyperparameters
	- Cannot select best model on the test set
		- Lead to optimistic estimate of the generalization error

- Divide data into training, validation, and test sets
	- Validation set
		- For measuring prediction error of the different models
	- Train multiple version of the models using training set
	- Evaluate on validation set then select best algorithm/hyperparameters
	- Retrain on training + validation
	- Estimate generalization error on test set
- Nested cross validation approach for model selection and evaluation

<img src="/images/Pasted image 20261103193357.png" alt="image" width="500">

# Regression

- In classification, the output class is categorical
- In regression, the output is continuous
- Input vector, $X^T = (x_1, x_2, ..., x_p)$
- Output y has real values
- Goal remains the same
	- Find mapping to predict the output y from the input X
- Linear regression and logistic regression

## Linear Regression

- Simplest model
	- Weighted sum of inputs, plus a constant (bias)

$f(X) = \beta_o + \sum^{p}_{j=1}x_i\beta_j$

- Fit data with the optimized hyper plane
- Use the linear model to predict output y given input X
- The different between the predicted and actual outputs is the residue
- Residue is frequently the sum of squared errors (SSE)
	- Residual sum of squares (RSS)
	- Varies based on the weights and biases of the model
- Finding the optimized weights and biases

$RSS(\beta) = \sum^{n}{i=1}(y_i-f(X_i))^2$


### Data Quality Issues

- Errors in training data
	- Noise and outliers
	- Fake data
	- Wrong data
	- Missing data
## Logistic Regression

- Output is binary
- Fit data with a sigmoidal/logistic curve rather than a line
	- Probability of output given the input
- Map input feature to a number between 0 and 1

$\sigma(t) = \frac{1}{1+e^{-t}}$

- Find set of weights and bias $\beta$ that map input feature to a number between 0 and 1



# Gradient Descent

- Gradient descent
	- Iterative method to tweak the model's parameters until cost is minimized
	- Randomly initialize $\beta$ values, then improve them iteratively each time by decreasing the cost function
	- Measure the local gradient of the cost function with regards to the model's parameters $\beta$
	- Modify the parameter $\beta$ in the direction with the steepest descent of cost
	- Repeat until the gradient is zero
- Learning rate ($\alpha$)
	- Size of the steps
	- Always positive
	- Does not need to be decreased over time, because the gradient will decrease as it approaches a minimum
- Batch GD
	- Use the whole training set to compute the local gradients at every iteration
- Stochastic GD
	- Randomly pick a training instance to compute the local gradients at every iteration
	- Faster algorithm, but cost function converges in erratic way
- Mini-batch GD
	- Use small random set of instances to compute the local gradients
	- Trade-off between batch and stochastic

# Feature Transformation

- Function that maps the entire set of values of a given feature to a new set of replacement values
- Functions
	- $x^k$
	- $log(x)$
	- $e^x$
	- $|x|$
- Normalization/standardization
	- Refers to various techniques to adjust to differences among attributes in terms of frequency of occurrence, mean, variance, range

- Standardization
	- Z-score normalization
	- Centres the data by subtracting the mean and scaling it by the standard deviation
	- Mean of 0
	- Standard deviation of 1

$x_{scaled} = \frac{x-mean}{std}$

- Normalization
	- Min-max scaling
	- Rescales the range of data to a fixed boundary

$x_{norm} = \frac{x-x_{min}}{x_{max}-x_{min}}$

## Partial Derivatives of the sum of squares cost function