
- MDTs
	- Data transformations that are performed on data after it has been read from the feature store and that create features that are specific to one model
		- Feature transformations
			- Numerical and categorical features
			- One-hot encoding
		- Transformations that are tightly coupled to only one model
			- Encoding for an LLM

- Prevent skew between MDTs that are applied separately
	- Scikit-Learn pipelines
	- PyTorch transforms
	- Transformation functions in feature view for Hopsworks
- (ODTs) On-demand transformations

# Feature Transformations

- Feature transformations can enhance the performance and convergence of various types of ML models
- Most ML algorithms cannot accept strings as inputs, and need a numerical input

## Encoding Categorical Variables

- Each one-hot encoded array represents a category with a 1 in the category's position in the array and 0 in all other positions
- Not recommended for high cardinality
- Ordinal encoder preserves ordering in the transformed categories

<img src="/images/Pasted image 20261110135217.png" alt="image" width="500">

<img src="/images/Pasted image 20261110135238.png" alt="image" width="500">

- Feature hashing
	- Reduces dimensionality by mapping cateogies to a fixed-size hash table
	- Risk of hash collisions
- Label encoding
	- Encoding the target/label variables as integers
	- Preserves orders
	- Scikit-Learn's logistic regression
	- XGBoost's multiclass classification
- CatBoost
	- Tree-based algorithms
	- Handles categorical variables with high cardinatliy

## Distribution of Numerical Variables

- Many ML algorithms only work well when a numerical feature follows a particular data distribution
- If data is skewed, and ML uses gradient descent, you should standarized the data
	- Standardization transforms the numerical variable's distribution to have a mean of zero and a unit variance (standard deviation) of one
	- Improve convergence speed and model stability

<img src="/images/Pasted image 20261110135607.png" alt="image" width="500">

- Distribution types
	- Normal
	- Uniform
	- Binomial
	- Poisson
	- Exponential
	- Bimodal
	- Log-normal


## Transforming Numerical Variables

- Standarizing numerical feature distributions is a common tansformation
	- Gradient descent
	- kNN
	- Support vector machines (SVMs)
	- Transforms distribution shape
- Normalization (min-max scaling)
	- Improve model convergence speed
	- Rescales values to a fixed range, such as 0 to 1
	- Preserves original distribution shape

- Normalization
	- Neural networks
	- Original feature distribution is important
	- Outliers are meaningful
- Standarization
	- Linear models
	- Distance based algorithms
	- Assume feature should be normally distributed


- Log transformation
	- Reduce skewness
	- Compress the range of value
	- Right skew data
	- Log is undefined for data containing zeros
- No need to transform numerical feature for tree-based models
	- Gradient-boosted decision trees
	- Random forestes

- Normalization

$x_{norm}=\frac{x-x_{min}}{x_{max}-x_{min}}$

- Standarization

$x_{stand.} = \frac{(x-\micro)}{\sigma}$

- Log transformation

$x_{log}=ln(x)$

- Reciprocal transformation

$x_{rec} = \frac{1}{x}$

- Exponential transformation

$x_{exp} = a \times e^{b \times x}$

- Box-Cox transformation

$x_{box-cox}(\lambda)=\frac{x^{\lambda} -1}{\lambda}$


## Storing Transformed Feature Data in a Feature Group

- Should not store transformed feature data in feature groups
- Cannot reuse by models and introduces write amplification when new data is written
- Precomputing can help with predication request latency
- Transformed feature group should be online only

# Model-Specific Transformations

- Model specific transformations
	- Catchall for any data transformation that is not a feature transformation, but is specific to one model
	- Compute mean/median/mode for features in the training data and replace the missing value with one of the computed value
	- Determine how to transform timestamps for features so that they are aligned with the timestamp for targets/labels

## Outlier Handling Methods

- Outlier detection
	- Identifies and handles anomalous data point that can skew model training and lead to poor predictions
- Preferable to not ingest anomalous data point into a feature group
	- Great Expectations to identify and remove then in feature pipelines
- Scikit-Learn
	- Univariate approach
		- Statistical techniques
			- Z-score
			- Interquartile range (IQR)
	- Multivariate approaches
		- Isolation Forest
		- Local Outlier Factor (LOF)

```python
Q1 = df['amount'].quantile(0.002)
outliers = df[(df['amount'] < Q1)]
```

- A log transformation can help reduce their influence by compressing high value


## Imputing Missing Values

<img src="/images/Pasted image 20261110141124.png" alt="image" width="500">

```python
df_forward_filled = 
    df.sort_values("event_time").groupby("cc_num")["amount"].ffill()
    
df["amount"] = df.sort_values("event_time").groupby("cc_num")["amount"].bfill()
```

- Forward filling
	- Last valid non-missing value
- Backward filling
	- Takes the next valid non-missing value

- In PySpark use a window function to implement forward and backward filling
	- Expensive operation
	- Requires shuffling and sorting the data over all workers

```python
window_spec = Window.partitionBy("cc_num").orderBy("event_time")
    .rowsBetween(Window.unboundedPreceding, Window.currentRow)
# Forward fill the 'amount' column with missing values
df_forward_filled = df.withColumn(
    "filled_amount", F.last("amount", ignoreNulls=True).over(window_spec)
)

window_spec_back = Window.partitionBy("cc_num").orderBy("event_time")
    .rowsBetween(Window.currentRow, Window.unboundedFollowing)

# Backward fill the 'amount' column with missing values
df_backward_filled = df.withColumn(
    "filled_amount", F.first("amount", ignoreNulls=True).over(window_spec_back))
```

- Impute missing value using classes in their `impute` model
- Replaces all missing value with the mean value computed over the selected columns in the DF

```python
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
pipeline = Pipeline(steps=[
    ('imputer', SimpleImputer(strategy='mean'))
])

df_imputed = pd.DataFrame(
    pipeline.fit_transform(df[["amount"]]),
    columns=[”amount”]
)
```

- Hopworks

```python
from hopsworks.hsfs.builtin_transformations import min_max_scaler

feature_view = fs.create_feature_view(
    name='transactions_view',
    query=query,
    labels=["fraud_label"],
    transformation_functions = [min_max_scaler("amount")]
)
# missing values will be imputed during training data creation
feature_view.create_training_data(test_size=0.2)
```

## Data Cleaning and Model-Based Transformations

- Data cleaning can be guided by heuristics, training data statistics, or a model trained on the data
- Pretraining
	- Removes noise from low-quality tokens
	- Kullback-Leibler divergence
		- Filters out documents containing excessive numbers of outlier tokens
		- NSFW filters
		- Semantic deduplication approaches
		- Text classifiers
- Data cleaning is needed before training
	- Make predictions on unclean data
- Cleanlab
	- Identifies and correct label errors in the training dataset
	- Providing confidence estimates for the correctness of each label
- Lightly
	- Open library for computer vision
	- Creates image embeddings and then uses clustering and similarity search to help select, prioritize, and pseudo-label samples

## Target/Label Dependent Transformations

- Label dependent transformation
	- `time_since_last_transaction`
	- Calculated relative to the current transaction's timestamp and the timestamp for the most recent previous transaction

```python
def time_since_last_transaction(event_time, prev_ts_transaction):
    return event_time - prev_ts_transaction
```

## Expensive Features are Computer When Needed

- 


# Transformations in Scikit-Learn Pipelines



# Transformations in Feature Views
# On-Demand Transformations
# PyTorch Transformations

# Using pytest

