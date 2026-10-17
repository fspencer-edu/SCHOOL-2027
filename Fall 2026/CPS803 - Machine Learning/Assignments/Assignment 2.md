
# Machine Learning — Assignment 2

## Part 1: Basic Linear Regression

### Objective

Predict restaurant profit ($y$) based on the population ($X$) of the city where the restaurant is located.

### Method

Linear regression finds the best-fitting straight line through the training data using least squares, minimizing the sum of squared errors.

$$
\hat{y} = b_0 + b_1X
$$

Where:
- $b_0$ = Intercept (bias)
- $b_1$ = Slope (weight)
- $X$ = Population
- $\hat{y}$ = Predicted profit

### Results

The model learned the following parameters:

$$
b_0 = -3.895781
$$

$$
b_1 = 1.193034
$$

Therefore, the fitted equation is:

$$
\boxed{\hat{y} = -3.895781 + 1.193034X}
$$

For a population input of $X = 18$:

$$
\hat{y} = -3.895781 + (1.193034 \times 18)
$$

$$
\boxed{\hat{y} \approx 17.58}
$$

### Interpretation

- The positive slope indicates that larger populations are associated with higher predicted restaurant profits.
- Each one-unit increase in population corresponds to approximately 1.193 units of additional predicted profit.
- The model predicts a profit of approximately **17.58 units** when $X = 18$.

**Conclusion:** Linear regression learns a numerical relationship from existing data and uses it to predict continuous values.

---

## Part 2: Logistic Regression

### Objective

Predict whether an applicant will be hired or rejected based on two technical interview scores.

### Dataset

- $X_1$ = First technical interview score
- $X_2$ = Second technical interview score
- $y = 0$ = Rejected
- $y = 1$ = Hired

### Method

Logistic regression uses a sigmoid function to convert a linear combination of input features into a probability between 0 and 1.

$$
z = b_0 + b_1X_1 + b_2X_2
$$

$$
P(y=1 \mid X) = \frac{1}{1+e^{-z}}
$$

A typical classification threshold is 0.5:

$$
\hat{y} =
\begin{cases}
1 & \text{if } P(y=1 \mid X) \geq 0.5 \\
0 & \text{otherwise}
\end{cases}
$$

### Results

The logistic regression model was trained and evaluated on 100 applicants.

| Metric | Result |
|---|---:|
| Total applicants | 100 |
| Correct predictions | 89 |
| Incorrect predictions | 11 |
| Training accuracy | 89% |
| Training error rate | 11% |

Training accuracy:

$$
\text{Accuracy} = \frac{\text{Correct Predictions}}{\text{Total Predictions}}\times100
$$

$$
\text{Accuracy} = \frac{89}{100}\times100 = \boxed{89\%}
$$

### Interpretation

- The model correctly classified 89% of applicants in the training dataset.
- The remaining 11% were classified incorrectly.
- The actual and predicted scatter plots show how the classifier separates applicants using their two scores.
- Since evaluation was performed on training data, the accuracy does not necessarily represent performance on new applicants.

**Conclusion:** Logistic regression predicts categorical outcomes by estimating the probability of belonging to a class.

---

## Part 3: Multi-Class Classification

### Objective

Extend binary logistic regression to classification problems involving more than two classes.

Two strategies are One-vs-Rest (OvR) and One-vs-One (OvO).

### 1. One-vs-Rest (OvR)

One-vs-Rest trains one binary classifier for each class, comparing that class against all remaining classes.

For example, with classes A, B, and C:

- Classifier 1: A vs. (B, C)
- Classifier 2: B vs. (A, C)
- Classifier 3: C vs. (A, B)

For $K$ classes, the number of classifiers is:

$$
\boxed{N_{\text{OvR}} = K}
$$

Each classifier produces a score, and the class with the highest score is selected.

### 2. One-vs-One (OvO)

One-vs-One trains a separate binary classifier for every possible pair of classes.

For classes A, B, and C:

- Classifier 1: A vs. B
- Classifier 2: A vs. C
- Classifier 3: B vs. C

For $K$ classes, the number of classifiers is:

$$
\boxed{N_{\text{OvO}} = \frac{K(K-1)}{2}}
$$

For three classes:

$$
N_{\text{OvO}} = \frac{3(3-1)}{2} = \boxed{3}
$$

Each classifier predicts one of its two classes, and the class receiving the most votes is typically selected.

### Comparison

| Feature | One-vs-Rest | One-vs-One |
|---|---|---|
| Classifiers | $K$ | $\frac{K(K-1)}{2}$ |
| Training data | Entire dataset per classifier | Only two classes per classifier |
| Prediction | Highest score | Majority vote |
| Main advantage | Fewer models for many classes | Simpler pairwise decisions |
| Main limitation | Possible class imbalance | Number of models grows quickly |

### Conclusion

Both methods extend binary classifiers to multi-class problems.

- **OvR** compares each class against all other classes.
- **OvO** compares every pair of classes and combines the predictions.

No additional model was trained in Part 3; the assignment requires conceptual explanations only.

---

## Overall Conclusion

This assignment demonstrates three fundamental machine learning concepts:

1. **Linear Regression:** Predicts continuous numerical values, such as restaurant profit.
2. **Logistic Regression:** Predicts binary classes, such as hired or rejected.
3. **Multi-Class Classification:** Extends binary classification to three or more categories.

The main workflow is:

**Load Data → Identify Features and Labels → Train Model → Predict → Evaluate Results**

The key distinction is that regression predicts *how much*, while classification predicts *which category*.
