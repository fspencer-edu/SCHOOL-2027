# Machine Learning — Complete Formula Sheet

> Covers Units 2–6: Decision Trees, Regression, Gradient Descent, SVM, Naive Bayes, KNN, Neural Networks, Model Evaluation, Ensembles, and Clustering.

---

# 1. General Machine Learning Notation

| Symbol | Meaning |
|---|---|
| $D$ | Dataset |
| $N$ or $m$ | Number of training instances |
| $x_i$ | Feature vector of instance $i$ |
| $y_i$ | Actual target value |
| $\hat{y}_i$ | Predicted target value |
| $p_i$ | Probability of class $i$ |
| $K$ | Number of classes, folds, neighbours, or clusters (depending on context) |
| $\alpha$ | Learning rate |
| $\theta$ or $\beta$ | Model parameters |
| $w$ | Weights |
| $b$ | Bias |
| $J(\theta)$ | Cost function |
| $\mu$ | Mean or centroid |
| $\epsilon$ | Error rate or neighbourhood radius (depending on context) |

## Supervised Learning

$$
D=\{(x_1,y_1),(x_2,y_2),\ldots,(x_N,y_N)\}
$$

Goal:

$$
\hat{y}=f(x)
$$

- Classification: predict a category.
- Regression: predict a continuous value.

## Unsupervised Learning

$$
D=\{x_1,x_2,\ldots,x_N\}
$$

Goal: discover groups, patterns, or relationships without target labels.

---

# 2. Decision Trees

## 2.1 Class Probability

For class $c$:

$$
\boxed{p_c=\frac{N_c}{N}}
$$

Where:

- $N_c$ = number of instances belonging to class $c$
- $N$ = total instances

Example: 6 Yes and 4 No.

$$
P(Yes)=\frac{6}{10}=0.6
$$

$$
P(No)=\frac{4}{10}=0.4
$$

---

## 2.2 Entropy

Entropy measures uncertainty or impurity.

$$
\boxed{
H(D)=-\sum_{i=1}^{c}p_i\log_2(p_i)
}
$$

For binary classification:

$$
\boxed{
H(D)=-p_+\log_2(p_+)-p_-\log_2(p_-)
}
$$

### Example: 6 Yes, 4 No

$$
H(D)=-0.6\log_2(0.6)-0.4\log_2(0.4)
$$

$$
H(D)=-0.6(-0.73697)-0.4(-1.32193)
$$

$$
\boxed{H(D)\approx0.97095}
$$

### Special Cases

Pure node:

$$
H(1,0)=0
$$

Perfectly mixed binary node:

$$
H(0.5,0.5)=1
$$

**Interpretation:**

- Entropy = 0: completely pure.
- Entropy = 1: maximum uncertainty for two classes.
- Lower entropy means less class uncertainty.

**Note:** Define $0\log_2(0)=0$ when calculating entropy.

---

## 2.3 Gini Impurity

$$
\boxed{
Gini(D)=1-\sum_{i=1}^{c}p_i^2
}
$$

For binary classification:

$$
Gini(D)=1-p_+^2-p_-^2
$$

### Example: 6 Yes, 4 No

$$
Gini(D)=1-(0.6)^2-(0.4)^2
$$

$$
=1-0.36-0.16
$$

$$
\boxed{Gini(D)=0.48}
$$

### Special Cases

Pure node:

$$
Gini(1,0)=0
$$

Perfectly mixed binary node:

$$
Gini(0.5,0.5)=0.5
$$

**Decision rule:** Prefer splits with lower weighted Gini impurity.

---

## 2.4 Classification Error / Misclassification Error

$$
\boxed{
Error(D)=1-\max_i(p_i)
}
$$

### Example: 6 Yes, 4 No

$$
Error(D)=1-\max(0.6,0.4)
$$

$$
\boxed{Error(D)=0.4}
$$

### Special Cases

Pure node:

$$
Error(1,0)=0
$$

Perfectly mixed binary node:

$$
Error(0.5,0.5)=0.5
$$

---

## 2.5 Comparison of Impurity Measures

| Measure | Formula | Pure Node | 50/50 Binary Node |
|---|---|---|---|
| Entropy | $-\sum p_i\log_2p_i$ | 0 | 1 |
| Gini | $1-\sum p_i^2$ | 0 | 0.5 |
| Classification Error | $1-\max(p_i)$ | 0 | 0.5 |

All three measure impurity.

---

## 2.6 Weighted Entropy After a Split

Suppose a split creates $k$ child nodes.

$$
\boxed{
H_{\text{split}}=
\sum_{j=1}^{k}
\frac{|D_j|}{|D|}H(D_j)
}
$$

For two children:

$$
H_{\text{split}}=
\frac{N_L}{N}H(L)+
\frac{N_R}{N}H(R)
$$

Where:

- $N_L$ = number of instances in left child
- $N_R$ = number of instances in right child
- $N$ = parent size

### Example

Parent: 10 records.

Left child: 4 records, entropy 0.

Right child: 6 records, entropy 0.9183.

$$
H_{\text{split}}=
\frac{4}{10}(0)+
\frac{6}{10}(0.9183)
$$

$$
\boxed{H_{\text{split}}\approx0.55098}
$$

---

## 2.7 Information Gain

Information gain measures the reduction in entropy.

$$
\boxed{
IG(D,A)=H(D)-H_{\text{split}}(D,A)
}
$$

Expanded:

$$
\boxed{
IG(D,A)=
H(D)-
\sum_{j=1}^{k}
\frac{|D_j|}{|D|}H(D_j)
}
$$

### Example

$$
H(D)=0.97095
$$

$$
H_{\text{split}}=0.55098
$$

$$
IG=0.97095-0.55098
$$

$$
\boxed{IG\approx0.41997}
$$

**Decision rule:** Choose the split with the highest information gain.

---

## 2.8 Weighted Gini After a Split

$$
\boxed{
Gini_{\text{split}}=
\sum_{j=1}^{k}
\frac{|D_j|}{|D|}Gini(D_j)
}
$$

For two child nodes:

$$
Gini_{\text{split}}=
\frac{N_L}{N}Gini(L)+
\frac{N_R}{N}Gini(R)
$$

### Gini Reduction

$$
\boxed{
\Delta Gini=
Gini(D)-Gini_{\text{split}}
}
$$

**Decision rule:**

- Minimize weighted Gini.
- Equivalently, maximize Gini reduction.

---

## 2.9 Weighted Classification Error

$$
\boxed{
Error_{\text{split}}=
\sum_{j=1}^{k}
\frac{|D_j|}{|D|}Error(D_j)
}
$$

### Error Reduction

$$
\boxed{
\Delta Error=
Error(D)-Error_{\text{split}}
}
$$

---

## 2.10 Split Information

Split Information measures how evenly instances are distributed among branches.

Let:

$$
q_j=\frac{|D_j|}{|D|}
$$

Then:

$$
\boxed{
SplitInfo(D,A)=
-\sum_{j=1}^{k}q_j\log_2(q_j)
}
$$

### Example: Split into 4 and 6 records

$$
q_1=\frac{4}{10}=0.4
$$

$$
q_2=\frac{6}{10}=0.6
$$

$$
SplitInfo=
-0.4\log_2(0.4)-0.6\log_2(0.6)
$$

$$
\boxed{SplitInfo\approx0.97095}
$$

**Important:** Split Information uses the proportions of instances assigned to each branch, not the Yes/No class proportions within those branches.

---

## 2.11 Gain Ratio

$$
\boxed{
GainRatio(D,A)=
\frac{IG(D,A)}{SplitInfo(D,A)}
}
$$

### Example

$$
IG=0.41997
$$

$$
SplitInfo=0.97095
$$

$$
GainRatio=\frac{0.41997}{0.97095}
$$

$$
\boxed{GainRatio\approx0.4325}
$$

**Decision rule:** Prefer larger Gain Ratio, subject to the algorithm's split-selection rules.

If $SplitInfo=0$, the ratio is undefined and the split is not useful.

---

## 2.12 Continuous Attribute Splits

For a continuous attribute $A$, candidate thresholds can be generated from sorted values.

$$
t_i=\frac{a_i+a_{i+1}}{2}
$$

A binary split is:

$$
A\le t
$$

versus:

$$
A>t
$$

Evaluate each candidate:

$$
IG(t)=H(D)-H_{\text{split}}(t)
$$

Select the eligible threshold with the best score.

---

## 2.13 Majority Class at a Leaf

$$
\boxed{
\hat{y}=\arg\max_c N_c
}
$$

The leaf predicts the most common class among the training examples that reach it.

---

# 3. Model Evaluation and Validation

## 3.1 Holdout Split

$$
N_{\text{train}}=(1-r)N
$$

$$
N_{\text{test}}=rN
$$

Where $r$ is the test proportion.

For a 60/40 split:

$$
r=0.4
$$

$$
N_{\text{train}}\approx0.6N
$$

$$
N_{\text{test}}\approx0.4N
$$

---

## 3.2 K-Fold Cross-Validation

$$
\boxed{
CV_{\text{mean}}=
\frac{1}{K}
\sum_{i=1}^{K}Score_i
}
$$

### Example

$$
Scores=[0.90,0.92,0.94,0.91,0.93]
$$

$$
CV_{\text{mean}}=
\frac{0.90+0.92+0.94+0.91+0.93}{5}
$$

$$
\boxed{CV_{\text{mean}}=0.92}
$$

---

## 3.3 Confusion Matrix

| Actual / Predicted | Positive | Negative |
|---|---|---|
| Positive | TP | FN |
| Negative | FP | TN |

Definitions:

- TP: True Positive
- TN: True Negative
- FP: False Positive
- FN: False Negative

Total:

$$
N=TP+TN+FP+FN
$$

---

## 3.4 Accuracy

$$
\boxed{
Accuracy=\frac{TP+TN}{TP+TN+FP+FN}
}
$$

---

## 3.5 Error Rate

$$
\boxed{
ErrorRate=\frac{FP+FN}{N}
}
$$

Alternatively:

$$
\boxed{
ErrorRate=1-Accuracy
}
$$

---

## 3.6 Precision

$$
\boxed{
Precision=\frac{TP}{TP+FP}
}
$$

Meaning: Of all predicted positives, how many were correct?

---

## 3.7 Recall / Sensitivity / True Positive Rate

$$
\boxed{
Recall=Sensitivity=TPR=
\frac{TP}{TP+FN}
}
$$

Meaning: Of all actual positives, how many were detected?

---

## 3.8 Specificity / True Negative Rate

$$
\boxed{
Specificity=TNR=
\frac{TN}{TN+FP}
}
$$

---

## 3.9 False Positive Rate

$$
\boxed{
FPR=\frac{FP}{FP+TN}
}
$$

Alternatively:

$$
\boxed{
FPR=1-Specificity
}
$$

---

## 3.10 False Negative Rate

$$
\boxed{
FNR=\frac{FN}{FN+TP}
}
$$

Alternatively:

$$
\boxed{
FNR=1-Recall
}
$$

---

## 3.11 F1 Score

$$
\boxed{
F1=
2\frac{Precision\cdot Recall}{Precision+Recall}
}
$$

Directly from the confusion matrix:

$$
\boxed{
F1=\frac{2TP}{2TP+FP+FN}
}
$$

---

## 3.12 Balanced Accuracy

$$
\boxed{
BalancedAccuracy=
\frac{Sensitivity+Specificity}{2}
}
$$

Useful for imbalanced binary classification.

---

## 3.13 ROC Curve

ROC plots:

$$
x=FPR
$$

$$
y=TPR
$$

For each decision threshold, calculate:

$$
TPR=\frac{TP}{TP+FN}
$$

$$
FPR=\frac{FP}{FP+TN}
$$

---

## 3.14 Area Under the ROC Curve (AUC)

Using the trapezoidal rule:

$$
\boxed{
AUC\approx
\sum_{i=1}^{n-1}
(FPR_{i+1}-FPR_i)
\frac{TPR_i+TPR_{i+1}}{2}
}
$$

Interpretation:

- $AUC=1$: perfect ranking
- $AUC=0.5$: chance-level ranking
- Higher AUC generally indicates better discrimination

---

## 3.15 Multiclass Macro and Micro Averages

Macro precision:

$$
\boxed{
Precision_{\text{macro}}=
\frac{1}{K}\sum_{c=1}^{K}Precision_c
}
$$

Macro recall:

$$
\boxed{
Recall_{\text{macro}}=
\frac{1}{K}\sum_{c=1}^{K}Recall_c
}
$$

Macro F1:

$$
\boxed{
F1_{\text{macro}}=
\frac{1}{K}\sum_{c=1}^{K}F1_c
}
$$

Micro precision:

$$
\boxed{
Precision_{\text{micro}}=
\frac{\sum_c TP_c}{\sum_c(TP_c+FP_c)}
}
$$

Micro recall:

$$
\boxed{
Recall_{\text{micro}}=
\frac{\sum_c TP_c}{\sum_c(TP_c+FN_c)}
}
$$

Micro F1 is the harmonic mean of micro precision and micro recall.

---

# 4. Linear Regression

## 4.1 Simple Linear Regression

$$
\boxed{
\hat{y}=\beta_0+\beta_1x
}
$$

Where:

- $\beta_0$ = intercept
- $\beta_1$ = slope
- $x$ = input
- $\hat{y}$ = prediction

---

## 4.2 Multiple Linear Regression

$$
\boxed{
\hat{y}=
\beta_0+\beta_1x_1+\beta_2x_2+\cdots+\beta_px_p
}
$$

Vector form:

$$
\boxed{
\hat{y}=X\beta
}
$$

Here $X$ includes a column of ones for the intercept.

---

## 4.3 Residual

$$
\boxed{
e_i=y_i-\hat{y}_i
}
$$

---

## 4.4 Sum of Squared Errors (SSE)

$$
\boxed{
SSE=\sum_{i=1}^{m}(y_i-\hat{y}_i)^2
}
$$

---

## 4.5 Mean Squared Error (MSE)

$$
\boxed{
MSE=\frac{1}{m}\sum_{i=1}^{m}(y_i-\hat{y}_i)^2
}
$$

---

## 4.6 Root Mean Squared Error (RMSE)

$$
\boxed{
RMSE=\sqrt{\frac{1}{m}\sum_{i=1}^{m}(y_i-\hat{y}_i)^2}
}
$$

---

## 4.7 Mean Absolute Error (MAE)

$$
\boxed{
MAE=\frac{1}{m}\sum_{i=1}^{m}|y_i-\hat{y}_i|
}
$$

---

## 4.8 Coefficient of Determination ($R^2$)

$$
\boxed{
R^2=1-\frac{SSE}{SST}
}
$$

Where:

$$
SST=\sum_{i=1}^{m}(y_i-\bar{y})^2
$$

and:

$$
\bar{y}=\frac{1}{m}\sum_{i=1}^{m}y_i
$$

$R^2=1$ indicates perfect predictions.

---

## 4.9 Least Squares Normal Equation

For ordinary least squares, when $X^TX$ is invertible:

$$
\boxed{
\hat{\beta}=(X^TX)^{-1}X^Ty
}
$$

This calculates regression coefficients directly.

---

# 5. Gradient Descent

## 5.1 General Gradient Descent Update

$$
\boxed{
\theta_{\text{new}}=
\theta_{\text{old}}-
\alpha\frac{\partial J}{\partial\theta}
}
$$

Vector form:

$$
\boxed{
\boldsymbol{\theta}_{t+1}=
\boldsymbol{\theta}_t-\alpha\nabla J(\boldsymbol{\theta}_t)
}
$$

Where:

- $\alpha$ = learning rate
- $J$ = cost function
- $\nabla J$ = gradient

---

## 5.2 Linear Regression Cost Function

A common convention is:

$$
\boxed{
J(\beta)=
\frac{1}{2m}
\sum_{i=1}^{m}
(\hat{y}_i-y_i)^2
}
$$

The factor $\frac12$ simplifies differentiation.

---

## 5.3 Partial Derivative for Linear Regression

For coefficient $\beta_j$:

$$
\boxed{
\frac{\partial J}{\partial\beta_j}
=
\frac{1}{m}
\sum_{i=1}^{m}
(\hat{y}_i-y_i)x_{ij}
}
$$

For the intercept, $x_{i0}=1$:

$$
\frac{\partial J}{\partial\beta_0}
=
\frac{1}{m}
\sum_{i=1}^{m}
(\hat{y}_i-y_i)
$$

---

## 5.4 Gradient Descent Parameter Update

$$
\boxed{
\beta_j^{new}=
\beta_j^{old}-
\frac{\alpha}{m}
\sum_{i=1}^{m}
(\hat{y}_i-y_i)x_{ij}
}
$$

---

## 5.5 Worked Example

Cost function:

$$
J(\beta_0,\beta_1)=\beta_0^2+2\beta_1^2
$$

Initial parameters:

$$
\beta_0=4,\qquad \beta_1=3
$$

Learning rate:

$$
\alpha=0.1
$$

Derivatives:

$$
\frac{\partial J}{\partial\beta_0}=2\beta_0
$$

$$
\frac{\partial J}{\partial\beta_1}=4\beta_1
$$

First update:

$$
\beta_0'=4-0.1(8)=3.2
$$

$$
\beta_1'=3-0.1(12)=1.8
$$

Second update:

$$
\beta_0''=3.2-0.1(6.4)=2.56
$$

$$
\beta_1''=1.8-0.1(7.2)=1.08
$$

### Result

$$
\boxed{
(\beta_0,\beta_1):
(4,3)\rightarrow(3.2,1.8)\rightarrow(2.56,1.08)
}
$$

---

# 6. Logistic Regression

## 6.1 Linear Score

$$
\boxed{
z=\beta_0+\sum_{j=1}^{p}\beta_jx_j
}
$$

---

## 6.2 Sigmoid Function

$$
\boxed{
\sigma(z)=\frac{1}{1+e^{-z}}
}
$$

Predicted probability:

$$
\boxed{
P(Y=1\mid X)=\sigma(z)
}
$$

---

## 6.3 Decision Rule

For threshold $t$:

$$
\boxed{
\hat{y}=
\begin{cases}
1 & P(Y=1\mid X)\ge t\\
0 & P(Y=1\mid X)<t
\end{cases}
}
$$

A typical threshold is:

$$
t=0.5
$$

---

## 6.4 Odds

$$
\boxed{
Odds=\frac{p}{1-p}
}
$$

---

## 6.5 Log-Odds / Logit

$$
\boxed{
\ln\left(\frac{p}{1-p}\right)=z
}
$$

For logistic regression:

$$
\boxed{
\ln\left(\frac{p}{1-p}\right)=
\beta_0+\sum_j\beta_jx_j
}
$$

---

## 6.6 Binary Cross-Entropy Loss

For one record:

$$
\boxed{
L=-[y\ln(p)+(1-y)\ln(1-p)]
}
$$

For $m$ records:

$$
\boxed{
J(\beta)=
-\frac{1}{m}
\sum_{i=1}^{m}
\left[
y_i\ln(p_i)+(1-y_i)\ln(1-p_i)
\right]
}
$$

---

## 6.7 Logistic Regression Gradient

$$
\boxed{
\frac{\partial J}{\partial\beta_j}
=
\frac{1}{m}
\sum_{i=1}^{m}
(p_i-y_i)x_{ij}
}
$$

Update:

$$
\boxed{
\beta_j^{new}=
\beta_j^{old}-
\alpha
\frac{\partial J}{\partial\beta_j}
}
$$

---

## 6.8 One-vs-Rest (OvR)

For $K$ classes:

$$
\boxed{
N_{\text{classifiers}}=K
}
$$

---

## 6.9 One-vs-One (OvO)

For $K$ classes:

$$
\boxed{
N_{\text{classifiers}}=
\frac{K(K-1)}{2}
}
$$

Example:

$$
K=5
$$

$$
N_{\text{OvO}}=\frac{5(4)}{2}=10
$$

---

# 7. Support Vector Machines (SVM)

## 7.1 Linear Hyperplane

$$
\boxed{
g(x)=w^Tx+b
}
$$

Decision boundary:

$$
\boxed{
w^Tx+b=0
}
$$

---

## 7.2 Classification Rule

$$
\boxed{
\hat{y}=\operatorname{sign}(w^Tx+b)
}
$$

For classes $-1$ and $+1$.

---

## 7.3 Weight Norm

$$
\boxed{
\|w\|=\sqrt{w_1^2+w_2^2+\cdots+w_p^2}
}
$$

---

## 7.4 Distance From a Point to the Hyperplane

$$
\boxed{
d(x)=\frac{|w^Tx+b|}{\|w\|}
}
$$

---

## 7.5 Margin Width

With the conventional SVM scaling:

$$
\boxed{
Margin=\frac{2}{\|w\|}
}
$$

Distance from the separating hyperplane to each margin boundary:

$$
\boxed{
d_{\text{margin}}=\frac{1}{\|w\|}
}
$$

---

## 7.6 Hard-Margin SVM Constraints

$$
\boxed{
y_i(w^Tx_i+b)\ge1
}
$$

For every training instance.

---

## 7.7 Hard-Margin SVM Objective

$$
\boxed{
\min_{w,b}\frac12\|w\|^2
}
$$

Subject to:

$$
y_i(w^Tx_i+b)\ge1
$$

---

## 7.8 Hinge Loss

$$
\boxed{
L_{\text{hinge}}=
\max(0,1-y_i(w^Tx_i+b))
}
$$

---

## 7.9 Soft-Margin SVM Objective

One common formulation:

$$
\boxed{
\min_{w,b}
\frac12\|w\|^2+
C\sum_{i=1}^{m}
\max(0,1-y_i(w^Tx_i+b))
}
$$

Where $C$ controls the penalty for margin violations.

---

## 7.10 Linear Kernel

$$
\boxed{
K(x,z)=x^Tz
}
$$

---

## 7.11 Polynomial Kernel

$$
\boxed{
K(x,z)=(\gamma x^Tz+r)^d
}
$$

---

## 7.12 RBF / Gaussian Kernel

$$
\boxed{
K(x,z)=e^{-\gamma\|x-z\|^2}
}
$$

---

# 8. Naive Bayes

## 8.1 Bayes' Theorem

$$
\boxed{
P(Y\mid X)=
\frac{P(X\mid Y)P(Y)}{P(X)}
}
$$

Definitions:

- $P(Y)$ = prior
- $P(X\mid Y)$ = likelihood
- $P(Y\mid X)$ = posterior
- $P(X)$ = evidence

---

## 8.2 Class Prior

$$
\boxed{
P(Y=c)=\frac{N_c}{N}
}
$$

---

## 8.3 Conditional Probability

For a categorical feature:

$$
\boxed{
P(X_j=v\mid Y=c)=
\frac{N_{v,c}}{N_c}
}
$$

---

## 8.4 Naive Conditional Independence

$$
\boxed{
P(X\mid Y)=
\prod_{j=1}^{p}P(X_j\mid Y)
}
$$

---

## 8.5 Naive Bayes Classification

$$
\boxed{
\hat{Y}=
\arg\max_c
P(Y=c)\prod_{j=1}^{p}P(X_j\mid Y=c)
}
$$

---

## 8.6 Posterior Normalization

For candidate classes $c$:

$$
Score(c)=P(Y=c)\prod_jP(X_j\mid Y=c)
$$

Then:

$$
\boxed{
P(Y=c\mid X)=
\frac{Score(c)}{\sum_kScore(k)}
}
$$

---

## 8.7 Laplace Smoothing

For a categorical feature with $V$ possible values:

$$
\boxed{
P(X_j=v\mid Y=c)=
\frac{N_{v,c}+1}{N_c+V}
}
$$

General additive smoothing:

$$
\boxed{
P(X_j=v\mid Y=c)=
\frac{N_{v,c}+\lambda}{N_c+\lambda V}
}
$$

Where $\lambda>0$.

---

## 8.8 Gaussian Naive Bayes

For a continuous feature assumed normally distributed within class $c$:

$$
\boxed{
P(X_j=x\mid Y=c)=
\frac{1}{\sqrt{2\pi\sigma_{jc}^2}}
\exp\left(
-\frac{(x-\mu_{jc})^2}{2\sigma_{jc}^2}
\right)
}
$$

Where:

- $\mu_{jc}$ = feature mean in class $c$
- $\sigma_{jc}^2$ = feature variance in class $c$

---

## 8.9 Log-Probability Form

To avoid multiplying many tiny probabilities:

$$
\boxed{
\ln Score(c)=
\ln P(Y=c)+
\sum_j\ln P(X_j\mid Y=c)
}
$$

Taking logs preserves the class ranking.

---

# 9. K-Nearest Neighbors (KNN)

## 9.1 Euclidean Distance

$$
\boxed{
d(x,y)=
\sqrt{\sum_{i=1}^{p}(x_i-y_i)^2}
}
$$

Two dimensions:

$$
\boxed{
d(x,y)=
\sqrt{(x_1-y_1)^2+(x_2-y_2)^2}
}
$$

---

## 9.2 Squared Euclidean Distance

$$
\boxed{
d^2(x,y)=\sum_{i=1}^{p}(x_i-y_i)^2
}
$$

---

## 9.3 Manhattan Distance

$$
\boxed{
d(x,y)=\sum_{i=1}^{p}|x_i-y_i|
}
$$

---

## 9.4 Minkowski Distance

$$
\boxed{
d_q(x,y)=
\left(
\sum_{i=1}^{p}|x_i-y_i|^q
\right)^{1/q}
}
$$

Special cases:

- $q=1$: Manhattan
- $q=2$: Euclidean

---

## 9.5 KNN Classification

$$
\boxed{
\hat{y}=
\operatorname{mode}
\{y_i:i\in N_K(x)\}
}
$$

Where $N_K(x)$ represents the $K$ nearest neighbours of $x$.

---

## 9.6 KNN Regression

$$
\boxed{
\hat{y}=
\frac{1}{K}
\sum_{i\in N_K(x)}y_i
}
$$

---

## 9.7 Min-Max Normalization

$$
\boxed{
x_{\text{scaled}}=
\frac{x-x_{\min}}{x_{\max}-x_{\min}}
}
$$

---

## 9.8 Z-Score Standardization

$$
\boxed{
z=\frac{x-\mu}{\sigma}
}
$$

Scaling is especially important for distance-based algorithms.

---

# 10. Artificial Neural Networks

## 10.1 Weighted Sum of a Neuron

$$
\boxed{
z=\sum_{i=1}^{p}w_ix_i+b
}
$$

Expanded:

$$
z=w_1x_1+w_2x_2+\cdots+w_px_p+b
$$

Bias can also be represented using a constant input:

$$
\boxed{
z=w_0(1)+w_1x_1+\cdots+w_px_p
}
$$

Where $w_0=b$.

---

## 10.2 Neuron Activation

$$
\boxed{
a=f(z)
}
$$

---

## 10.3 Step Activation

$$
\boxed{
f(z)=
\begin{cases}
1 & z\ge0\\
0 & z<0
\end{cases}
}
$$

---

## 10.4 Sigmoid Activation

$$
\boxed{
\sigma(z)=\frac{1}{1+e^{-z}}
}
$$

---

## 10.5 Sigmoid Derivative

$$
\boxed{
\sigma'(z)=
\sigma(z)(1-\sigma(z))
}
$$

If $a=\sigma(z)$:

$$
\boxed{
\sigma'(z)=a(1-a)
}
$$

---

## 10.6 ReLU

$$
\boxed{
ReLU(z)=\max(0,z)
}
$$

---

## 10.7 ReLU Derivative

$$
\boxed{
ReLU'(z)=
\begin{cases}
1 & z>0\\
0 & z<0
\end{cases}
}
$$

At $z=0$, the ordinary derivative is undefined; implementations choose a subgradient convention.

---

## 10.8 Hyperbolic Tangent (Tanh)

$$
\boxed{
\tanh(z)=
\frac{e^z-e^{-z}}{e^z+e^{-z}}
}
$$

Derivative:

$$
\boxed{
\frac{d}{dz}\tanh(z)=1-\tanh^2(z)
}
$$

---

## 10.9 Softmax

For output class $i$:

$$
\boxed{
P_i=
\frac{e^{z_i}}{\sum_{j=1}^{K}e^{z_j}}
}
$$

Properties:

$$
0<P_i<1
$$

$$
\boxed{\sum_{i=1}^{K}P_i=1}
$$

---

## 10.10 Forward Propagation

First hidden layer:

$$
\boxed{
z^{(1)}=W^{(1)}x+b^{(1)}
}
$$

$$
\boxed{
a^{(1)}=f(z^{(1)})
}
$$

Output layer:

$$
\boxed{
z^{(2)}=W^{(2)}a^{(1)}+b^{(2)}
}
$$

$$
\boxed{
\hat{y}=g(z^{(2)})
}
$$

---

## 10.11 Half-Squared Error

For one output:

$$
\boxed{
E=\frac12(t-o)^2
}
$$

For multiple outputs:

$$
\boxed{
E_{\text{total}}=
\frac12\sum_{k=1}^{K}(t_k-o_k)^2
}
$$

---

## 10.12 Categorical Cross-Entropy

For one-hot targets:

$$
\boxed{
L=-\sum_{k=1}^{K}y_k\ln(p_k)
}
$$

For $m$ records:

$$
\boxed{
J=-\frac1m
\sum_{i=1}^{m}
\sum_{k=1}^{K}
y_{ik}\ln(p_{ik})
}
$$

---

## 10.13 Sparse Categorical Cross-Entropy

For an integer class label $y$:

$$
\boxed{
L=-\ln(p_y)
}
$$

Where $p_y$ is the predicted probability of the correct class.

---

# 11. Backpropagation

## 11.1 Chain Rule

$$
\boxed{
\frac{\partial E}{\partial w}
=
\frac{\partial E}{\partial o}
\frac{\partial o}{\partial z}
\frac{\partial z}{\partial w}
}
$$

---

## 11.2 Output Error Signal

For sigmoid output with half-squared error:

$$
\boxed{
\delta_o=(o-t)o(1-o)
}
$$

---

## 11.3 Hidden-Layer Error Signal

For sigmoid hidden activation:

$$
\boxed{
\delta_h=
h(1-h)\sum_k w_{hk}\delta_k
}
$$

Where the weights $w_{hk}$ connect hidden neuron $h$ to neurons in the following layer.

---

## 11.4 Gradient for a Weight

$$
\boxed{
\frac{\partial E}{\partial w_{ij}}
=
a_i\delta_j
}
$$

Where $a_i$ is the input activation to that connection.

---

## 11.5 Weight Update

$$
\boxed{
w_{ij}^{new}=
w_{ij}^{old}-
\alpha a_i\delta_j
}
$$

---

## 11.6 Bias Update

$$
\boxed{
b_j^{new}=b_j^{old}-\alpha\delta_j
}
$$

---

## 11.7 Softmax With Cross-Entropy

For the output logits:

$$
\boxed{
\frac{\partial L}{\partial z_k}=p_k-y_k
}
$$

This is a useful simplification for multiclass neural networks using softmax and categorical cross-entropy.

---

## 11.8 Sigmoid With Binary Cross-Entropy

For the output logit:

$$
\boxed{
\frac{\partial L}{\partial z}=p-y
}
$$

---

## 11.9 Number of Dense-Layer Parameters

$$
\boxed{
Parameters=
(n_{\text{inputs}}n_{\text{neurons}})
+n_{\text{neurons}}
}
$$

Equivalently:

$$
\boxed{
Parameters=(n_{\text{inputs}}+1)n_{\text{neurons}}
}
$$

The extra 1 represents each neuron's bias.

### MNIST Assignment Example

Architecture:

$$
784\rightarrow300\rightarrow100\rightarrow10
$$

Layer 1:

$$
(784+1)(300)=235500
$$

Layer 2:

$$
(300+1)(100)=30100
$$

Output layer:

$$
(100+1)(10)=1010
$$

Total:

$$
\boxed{
235500+30100+1010=266610
}
$$

---

## 11.10 Epochs, Batches, and Steps

$$
\boxed{
StepsPerEpoch=
\left\lceil\frac{N}{BatchSize}\right\rceil
}
$$

$$
\boxed{
TotalSteps=
Epochs\times StepsPerEpoch
}
$$

### Example

$$
N=60000
$$

$$
BatchSize=32
$$

$$
Epochs=20
$$

$$
StepsPerEpoch=\frac{60000}{32}=1875
$$

$$
\boxed{
TotalSteps=20(1875)=37500
}
$$

---

# 12. Sampling and Ensemble Methods

## 12.1 Simple Random Sampling

For a population of size $N$, the probability of selecting one particular instance on a single uniform draw is:

$$
\boxed{
P(\text{select instance})=\frac1N
}
$$

---

## 12.2 Bootstrap Sampling

Sampling with replacement.

For $N$ draws from $N$ records, the probability that one specific record is never selected is:

$$
\boxed{
P(\text{not selected})=
\left(1-\frac1N\right)^N
}
$$

For large $N$:

$$
\boxed{
\left(1-\frac1N\right)^N\approx e^{-1}\approx0.368
}
$$

Expected proportion represented at least once:

$$
\boxed{
1-e^{-1}\approx0.632
}
$$

Approximately 63.2% of records are unique in a large bootstrap sample of size $N$.

---

## 12.3 Majority Voting

$$
\boxed{
\hat{y}=
\operatorname{mode}
\{h_1(x),h_2(x),\ldots,h_M(x)\}
}
$$

---

## 12.4 Weighted Voting

For binary predictions $h_t(x)\in\{-1,+1\}$:

$$
\boxed{
H(x)=
\operatorname{sign}
\left(
\sum_{t=1}^{M}\alpha_th_t(x)
\right)
}
$$

Where $\alpha_t$ is the weight of classifier $t$.

---

# 13. AdaBoost

## 13.1 Initial Instance Weights

For $N$ records:

$$
\boxed{
w_i^{(1)}=\frac1N
}
$$

---

## 13.2 Weighted Classification Error

$$
\boxed{
\epsilon_t=
\sum_{i:h_t(x_i)\ne y_i}
w_i^{(t)}
}
$$

Weights are assumed to sum to 1.

---

## 13.3 Classifier Weight

$$
\boxed{
\alpha_t=
\frac12\ln
\left(
\frac{1-\epsilon_t}{\epsilon_t}
\right)
}
$$

---

## 13.4 Instance Weight Update

For binary labels and predictions in $\{-1,+1\}$:

$$
\boxed{
w_i^{(t+1)}=
\frac{
w_i^{(t)}
e^{-\alpha_t y_i h_t(x_i)}
}{
Z_t
}
}
$$

Where $Z_t$ is the normalizing constant:

$$
\boxed{
Z_t=
\sum_i
w_i^{(t)}
e^{-\alpha_t y_i h_t(x_i)}
}
$$

---

## 13.5 Correctly Classified Instance

If:

$$
y_i=h_t(x_i)
$$

Then:

$$
y_ih_t(x_i)=1
$$

Therefore:

$$
\boxed{
w_i^{new}\propto w_i^{old}e^{-\alpha_t}
}
$$

---

## 13.6 Incorrectly Classified Instance

If:

$$
y_i\ne h_t(x_i)
$$

Then:

$$
y_ih_t(x_i)=-1
$$

Therefore:

$$
\boxed{
w_i^{new}\propto w_i^{old}e^{\alpha_t}
}
$$

---

## 13.7 AdaBoost Final Prediction

$$
\boxed{
H(x)=
\operatorname{sign}
\left(
\sum_{t=1}^{T}\alpha_th_t(x)
\right)
}
$$

### Worked Example

$$
\epsilon=0.3
$$

$$
\alpha=
\frac12\ln\left(\frac{0.7}{0.3}\right)
$$

$$
\boxed{\alpha\approx0.42365}
$$

Correct multiplier:

$$
e^{-0.42365}\approx0.65465
$$

Incorrect multiplier:

$$
e^{0.42365}\approx1.5275
$$

Misclassified instances receive greater relative weight.

---

# 14. Clustering

## 14.1 Euclidean Distance

$$
\boxed{
d(x,y)=\sqrt{\sum_{i=1}^{p}(x_i-y_i)^2}
}
$$

---

## 14.2 K-Means Centroid

For cluster $C_k$:

$$
\boxed{
\mu_k=\frac1{|C_k|}
\sum_{x\in C_k}x
}
$$

---

## 14.3 K-Means Assignment Rule

$$
\boxed{
Cluster(x)=
\arg\min_k\|x-\mu_k\|^2
}
$$

Assign each instance to its nearest centroid.

---

## 14.4 Within-Cluster Sum of Squared Errors (SSE)

$$
\boxed{
SSE=
\sum_{k=1}^{K}
\sum_{x\in C_k}
\|x-\mu_k\|^2
}
$$

Lower SSE means greater cohesion.

---

## 14.5 Overall Mean

$$
\boxed{
\mu=\frac1N\sum_{i=1}^{N}x_i
}
$$

---

## 14.6 Between-Cluster Sum of Squares (SSB)

$$
\boxed{
SSB=
\sum_{k=1}^{K}
|C_k|\|\mu_k-\mu\|^2
}
$$

Higher SSB means greater separation between centroids.

---

## 14.7 Total Sum of Squares (SST)

$$
\boxed{
SST=\sum_{i=1}^{N}\|x_i-\mu\|^2
}
$$

For Euclidean squared distances and mean-based centroids:

$$
\boxed{
SST=SSE+SSB
}
$$

---

## 14.8 K-Means Example

Dataset:

$$
D=\{1,2,4,5\}
$$

For $K=2$:

$$
C_1=\{1,2\}
$$

$$
C_2=\{4,5\}
$$

Centroids:

$$
\mu_1=\frac{1+2}{2}=1.5
$$

$$
\mu_2=\frac{4+5}{2}=4.5
$$

SSE:

$$
SSE=
(1-1.5)^2+(2-1.5)^2+
(4-4.5)^2+(5-4.5)^2
$$

$$
\boxed{SSE=1}
$$

Overall mean:

$$
\mu=3
$$

SSB:

$$
SSB=2(1.5-3)^2+2(4.5-3)^2
$$

$$
\boxed{SSB=9}
$$

Total:

$$
\boxed{SST=SSE+SSB=10}
$$

---

# 15. Hierarchical Clustering

## 15.1 Single Linkage — Distance

Minimum distance between points in different clusters:

$$
\boxed{
d_{\text{single}}(A,B)=
\min_{a\in A,b\in B}d(a,b)
}
$$

---

## 15.2 Complete Linkage — Distance

Maximum distance between points in different clusters:

$$
\boxed{
d_{\text{complete}}(A,B)=
\max_{a\in A,b\in B}d(a,b)
}
$$

---

## 15.3 Group Average Linkage — Distance

$$
\boxed{
d_{\text{average}}(A,B)=
\frac{1}{|A||B|}
\sum_{a\in A}\sum_{b\in B}d(a,b)
}
$$

---

## 15.4 Single Linkage — Similarity

If the problem provides similarities:

$$
\boxed{
s_{\text{single}}(A,B)=
\max_{a\in A,b\in B}s(a,b)
}
$$

---

## 15.5 Complete Linkage — Similarity

$$
\boxed{
s_{\text{complete}}(A,B)=
\min_{a\in A,b\in B}s(a,b)
}
$$

---

## 15.6 Group Average — Similarity

$$
\boxed{
s_{\text{average}}(A,B)=
\frac{1}{|A||B|}
\sum_{a\in A}\sum_{b\in B}s(a,b)
}
$$

### Important Exam Rule

**Distance matrix:**

- Single: minimum
- Complete: maximum
- Merge the smallest cluster distance

**Similarity matrix:**

- Single: maximum
- Complete: minimum
- Merge the largest cluster similarity

---

# 16. DBSCAN

## 16.1 Epsilon-Neighbourhood

$$
\boxed{
N_\epsilon(p)=
\{q\in D:d(p,q)\le\epsilon\}
}
$$

Where $\epsilon$ is the neighbourhood radius.

---

## 16.2 Core Point

$$
\boxed{
|N_\epsilon(p)|\ge MinPts
}
$$

The usual definition includes $p$ itself in its neighbourhood.

---

## 16.3 Border Point

A point $p$ is border if:

1. $p$ is not a core point.
2. $p$ is within distance $\epsilon$ of at least one core point.

---

## 16.4 Noise Point

A point is noise if:

1. It is not core.
2. It is not border.

---

# 17. Quick Formula Comparison

| Method | Main formula | Optimize / Select |
|---|---|---|
| Entropy | $-\sum p_i\log_2p_i$ | Lower impurity |
| Gini | $1-\sum p_i^2$ | Lower impurity |
| Classification Error | $1-\max p_i$ | Lower error |
| Information Gain | $H(D)-H_{\text{split}}$ | Maximum |
| Gain Ratio | $IG/SplitInfo$ | Generally higher |
| Linear Regression | $\hat y=\beta_0+\sum_j\beta_jx_j$ | Minimize prediction loss |
| Gradient Descent | $\theta'=\theta-\alpha\nabla J$ | Minimize cost |
| Logistic Regression | $\sigma(z)=1/(1+e^{-z})$ | Predict class probability |
| SVM | $w^Tx+b=0$ | Maximize margin / minimize regularized loss |
| Naive Bayes | $P(Y)\prod_jP(X_j\mid Y)$ | Maximum posterior |
| KNN | $d(x,y)$ | Nearest neighbours |
| Neural Network | $a=f(Wx+b)$ | Minimize loss |
| AdaBoost | $\alpha=\frac12\ln((1-\epsilon)/\epsilon)$ | Weight better classifiers |
| K-Means | $\mu_k=\frac1{|C_k|}\sum x$ | Minimize SSE |
| Single Linkage | $\min d(a,b)$ | Merge closest clusters |
| Complete Linkage | $\max d(a,b)$ | Merge closest clusters under complete-link distance |
| DBSCAN | $|N_\epsilon(p)|\ge MinPts$ | Identify dense regions |

---

# 18. Which Formula Do I Use?

| Question Wording | Formula |
|---|---|
| Find class impurity | Entropy / Gini / Classification Error |
| Find the best split | Information Gain |
| Find the entropy after splitting | Weighted Entropy |
| Calculate SplitInfo | Branch proportions and entropy formula |
| Calculate Gain Ratio | Information Gain / SplitInfo |
| Calculate model error | MSE / MAE / RMSE |
| Update a coefficient | Gradient Descent |
| Convert a score to a probability | Sigmoid |
| Find a separating hyperplane | SVM |
| Calculate a class probability | Bayes' Theorem |
| Prevent zero likelihoods | Laplace Smoothing |
| Find closest observations | Euclidean / Manhattan |
| Calculate a neuron output | Weighted Sum + Activation |
| Update neural weights | Backpropagation |
| Evaluate classification | Accuracy / Precision / Recall / F1 |
| Construct ROC curve | TPR and FPR |
| Weight an AdaBoost classifier | $\alpha_t$ |
| Update AdaBoost record weights | Exponential Weight Update |
| Find cluster centres | Mean / Centroid |
| Find cluster cohesion | SSE |
| Find cluster separation | SSB |
| Determine cluster merge order | Linkage Distance or Similarity |
| Identify density-based clusters | $\epsilon$ and MinPts |

---

# 19. Last-Minute Exam Reminders

1. **Entropy, Gini, and Classification Error** describe impurity.
2. **Information Gain** measures entropy reduction.
3. **SplitInfo** uses branch-size proportions.
4. **Gain Ratio** is Information Gain divided by SplitInfo.
5. **Gradient Descent** subtracts the learning rate times the gradient.
6. **Sigmoid** converts a real-valued score into a value between 0 and 1.
7. **Softmax** produces probabilities that sum to 1.
8. **Backpropagation** uses the chain rule to calculate weight gradients.
9. **Precision** uses $TP+FP$ in its denominator.
10. **Recall** uses $TP+FN$ in its denominator.
11. **AdaBoost** increases the relative importance of misclassified training examples.
12. **K-Means** updates centroids using the mean of assigned points.
13. **Single Linkage** uses the closest pair under distances.
14. **Complete Linkage** uses the farthest pair under distances.
15. **DBSCAN** uses density, not centroids.
16. 