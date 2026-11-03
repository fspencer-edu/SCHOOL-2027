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

$p_i$ = proportion of records belonging to class $i$
$c$ = number of classes
$log_2$ = log base 2
### Gini Index

Gini Index = $1 - \sum^{c-1}_{i=0}p_i(t)^2$
### Entropy

$H(t) = - \sum^c_{i=1}p_ilog_2(p_i)$

### Classification Error

classification error = $1 - max[p_i(t)]$

- Maximum of $log_2c$
	- Records are equality distributed among all classes
	- Least beneficial situation for classification
- Minimum of 0
	- When all records belong to one class
	- Most beneficial situation for classification

**Compute Entropy of a Single Node**

```python
C1 = 0
C2 = 6

P(C1) = 0/6 = 0
P(21) = 6/6 = 1

Entropy(P) = - 0log0 - 1log1 = -0 - 0 = 0

-------------------------------------------

C1 = 1
C2 = 5

P(C1) = 1/6
P(C2) = 5/6

Entropy(P) = -(1/6)log2(1/6) - (5/6)log2(5/6) = 0.65

-------------------------------------------

C1 = 2
C2 = 4

P(C1) = 2/6
P(C2) = 4/6

Entropy(P) = -(2/6)log2(2/6) - (4/6)log2(4/6) = 0.92
```

## Finding the Best Split

- Compute impurity measure (P) before splitting
- Compute impurity measure (M) after splitting
	- Compute impurity measure of each child node
	- M is the weighted impurity of child nodes
- Choose the attribute test condition that produces the highest gain
	- **Gain = P - M**
	- Or lowest impurity measure after splitting (M)

<img src="/images/Pasted image 20261103120654.png" alt="image" width="500">

- When a node p is split into k partitions

Entropy_{split} $= \sum^k_{i=1}\frac{n_1}{n} Entropy(i)$

$n_i$ = number of records at child i
$n$ = number or records at parent node p

## Binary Attributes: Computing Entropy

```python
P(C1) = 7
P(C2) = 5

Entropy(P) = -(7/12)log(7/12) - (5/12)log(5/12)
= 0.98

-------------------------------------------


P(N1) => 5, 2
P(N2) => 1, 5
```