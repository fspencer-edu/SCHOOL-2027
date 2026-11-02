# Supervised Learning

- Classification
	- Task of assigning objects to one of several predefined categories also known as class
- Regression
	- task of assigning objects to a continuous value

- A dataset is a collection of data objects
- An objects is also known as
	- Instance
	- Record
	- Point
	- Case
	- Sample
	- Entity
- An attribute is a property or characteristic of an object
- An attribute is also known as
	- Variable
	- Field
	- Characteristic
	- Dimension
	- Feature
- Target concept is the function to be learned
- A training set is the set of instances that are used to figure out the target concept
	- Inductive the inputs and outputs pairs

- A candidate is a concept that might be the target concept
- A test set is the set of instances that are used to evaluate the candidate concept
	- Test and training set should have different instances for unbiased evaluation

# Classification

- Learn a model that maps each attribute set $x$ into one of the predefined class labels $y$
- Given a collection of instances (training set)
	- Each instance is by characterized by a tuple $(x,y)$ = (attribute, label)

- Classification techniques
	- Decision trees
	- Neural networks
	- Ensemble (Boosting, Bagging)
	- Support Vector Machines
	- Bayesian Learning
	- Rule-based Methods
	- Nearest neighbour

- General approach for building a classification mode
	- Induction (learn model)
	- Deduction (apply model)

- Decision Tree Induction
	- Hunt's Algorithm
	- CART
	- ID3, C4.5
	- SLIQ, SPRINT

## General Structure of Hunt's Algorithm

- Let $D_t$ be the set of training instances that reach a node t
- General procedure
	- If $D_t$ contains instances that belong the same class $y_t$, then t is a leaf node labeled as $y_t$
	- If $D_t$ contains records that belong to more than one class, use an attribute to split the data into small subsets
	- Recursively apply the procedure
- Divide the training data into smaller groups until each group contains records belonging to only one class

<img src="/images/Pasted image 20261102131039.png" alt="image" width="500">


```python
(x, y) = (no, yes)

Defaulted No = (7, 3)

partition on Home Owner
Yes = (3, 0)
No (4, 3)

partition on Marital Status
Single, Divorced = (1, 3)
Married = (3, 0)

partition on Annual Income
< 80K = (1, 0)
> 80K = (0, 3)
```


## Design Issues of Decision Tree Induction

- Splitting training instances
	- Method for expressing test condition
	- Measure for evaluating the goodness of test condition

- Test conditions
	- Multi-way split
	- Binary split

## Measure of Node Impurity

- Greedy approach
	- Nodes with purer class distribution are preferred

```python
# high degree of impurity
C0: 5
C1: 5

# low degree of impurity
C0: 9
C1: 1
```

### Gini Index

Gini Index = $1 - $
### Entropy

### Classification Error