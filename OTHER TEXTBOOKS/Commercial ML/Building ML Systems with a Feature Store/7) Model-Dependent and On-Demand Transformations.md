
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

- If all of the features can be implemented as MDTs, it can eliminate feature pipelines, and reduce operational burden

## Tokenizers and Chat Templates for LLMs

- Every LLM has its own tokenizer, and the process is know as tokenization
- Llama 3's tokenizer
	- On average, tokenizes one work into two or three tokens
- Tokenization is an MDT
	- Tightly coupled to the version of the LLM
	- Encounter skew between training and inference time, due to different version of tokenizers
- Hugging Face (HF) chat tamplet
	- Tightly coupled with the tokenizer
	- Define a conversation as a single string that can be tokenized in the format expected by the model

```python
from transformers import AutoTokenizer
tokenizer=AutoTokenizer.from_pretrained("meta-llama/Meta-Llama-3-8B")

chat = [
   {"role": "user", "content": 
    "How do I prevent training/inference skew for tokenization in LLMs?"},
   {"role": "assistant", "content": "A chat template can help"}
]
tokenized_prompt = tokenizer.apply_chat_template(chat, tokenize=True)
```

- Text chunking
	- Breaks documents into pieces
		- Pages, paragraphs, sentences
	- MIT performed in a feature pipeline
- Chunked data can then be reused at inference time with RAG
- Text tokenization
	- Model dependent, and performed in training and inference pipelines

# Transformations in Scikit-Learn Pipelines

- Scikit-Learn provides library of transformers
	- Pickle and save the pipeline object in a model registry

```python
import joblib
X_train, X_test, y_train, y_test = fv.train_test_split(test_size=0.2)
categorical_features = \
    [ col for col in X_train.columns if X_train[col].dtype == object ]
numerical_features = \
    [ col for col in X_train.columns if X_train[col].dtype != object ]

numeric_transformer = Pipeline(
    steps=[
        ("imputer", SimpleImputer(strategy="median")), 
        ("scaler", StandardScaler()),
    ]
)
categorical_transformer = Pipeline(
    steps=[
        ("encoder", OneHotEncoder(handle_unknown="ignore")),
    ]
)

preprocessor = ColumnTransformer(
    transformers=[
        ("num", numeric_transformer, numerical_features),
        ("cat", categorical_transformer, categorical_features),
    ]
)

clf = Pipeline(
    steps=[
        ("preprocessor", preprocessor),
        ("classifier", LogisticRegression()),
    ]
)

clf.fit(X_train, y_train)
joblib.dump(clf, "cc_fraud/cc_fraud.pkl")
mr_model = mr.register_sklearn_model(name=”cc_fraud”, feature_view=fv,..)
mr_model.save("cc_fraud")
```

- joblib
	- More efficient than pickle library to save/load the large NumPy arrays
	- Read a batch of feature values to score from the feature store
	- Download the pipeline object

```python
model_dir = mr.download_model(name="cc_fraud", version=1)
clf = joblib.load(os.path.join(model_dir, "cc_fraud.pkl"))

# Get feature data arrived since yesterday for scoring
df = fv.get_batch_data(start_time=datetime.now()-timedelta(days=1))
df["predicted_fraud"] = clf.predict(df)
```

- `model.predict()`
	- Applies all the pipeline transformations before calling `predict` on the model
- `SimpleImputer`
	- Univariate algorithm that imputes missing value for a feature using only non-missing value for that feature
- `IterativeUmputer`
	- Model-based imputation and uses all feature to estimate a missing feature
- Generate multiple imputations and apply an analysis pipeline to the imputations

- `OneHotEncoder`
	- Categorical variables with low or medium cardinality
- `OrdinalEncoder`
	- Categories with a natural ordering
- `TargetEncoder`
	- Encoding unordered categories with high cardinality

- `StandardScaler`
	- Standardizes a numerical feature
	- Implements Transformer API to compute the mean and standard deviation of a training set
	- Saved in the `Pipeline` object
- `MinMaxScaler`
	- Scales feature to lie between zero and one, preserving the shape of the distribution
- `MaxAbsScaler`
	- Better at preserving sparsity than `MinMaxScaler`


- Monotonic transformation
	- A way to change a set of numbers or a function into a new set while preserving the original order
	- Gaussian distribution

- Scikit-Learn's preprocessing package operate on NumPy arrays and do not natively support Arrow-backed DF
	- Scalable for large datasets

# Transformations in Feature Views

- Feature views in Hopsworks support the execution of transformation functions when reading features from the feature store

```python
from hopsworks.hsfs.builtin_transformations \
    import min_max_scaler, label_encoder, one_hot_encoder

fv = fs.create_feature_view(
    name='transactions',
    query=fg_credit_card.select_features(),
    labels=["fraud"],
    transformation_functions = [
        one_hot_encoder("category"),
        min_max_scaler("amount"),
        label_encoder("fraud")
    ]
)
```

- Each entry in the list contains the name of the transformation function and the names of features from the feature view as input parameters
- Include index columns or helper columns as parameters to a transformation function
- Transformation functions are univariate functions that take a single feature as input and return a transformed value as output
- Multivariate functions

```python
X_train, X_test, y_train, y_test = fv.train_test_split(test_size=0.1)

features = fv.get_batch_data(
    start_date=(datetime.now() - timedelta(1)), transformed=False
)

features = fv.get_feature_vector(serving_keys={"cc_num": "1234 0432 0122 9833"})
```

- Transformation function can change the schema of the feature data read from the feature view
- Feature view, ensures that the number and order of columns in the returned data will be consistent when reading training and inference data
- Define custom transformations for feature views as user-defined transformation functions
	- Python or Pandas UDF with the hopsworks.udf annotation
- Pandas UDF
	- Scaled to process large volumes of data
- Python UDFs
	- Do not scale well
	- Lower latency in online inference pipeline
- Mixed-mode UDF
	- Run as either Pandas UDFs or Python UDFs

```python
stats = TransformationStatistics("amount") 
@hopsworks.udf(float)
def transaction_amount_deviation(amount, statistics=stats):
    return amount / statistics.amount.mean
```

- In a training pipeline, `amount` is a `pd.Series` and `statistics.amount.mean` is a scalar
	- Executes as a vectorized function in Pandas
- Explicitly define a user-defined transformation function to run in Pandas mode in both training and inference

```python
@hopsworks.udf(return_type=int, mode="pandas")
def days_to_card_expiry(cc_expiry_date, event_time):
    return (cc_expiry_date - event_time).dt.days
```

<img src="/images/Pasted image 20261110143904.png" alt="image" width="500">

# On-Demand Transformations

- The same transformation functions used in feature view can be used as ODTs
	- Do not include training data statistics as parameter
	- Request-time parameters
	- Precomputed features read the feature view
	- Inference helper columns
		- Provide precomputed feature data that is used to compute an ODTs
- Feature vie know which of their features are computed as ODTs and compute then in online inference pipelines

```python
fg = feature_store.create_feature_group(name="cc_trans_fg",
                version=1,
                description="Transaction Features",
                online_enabled=True,
                primary_key=['id'],
                event_time='event_time'
                transformation_functions=
                    [days_to_card_expiry("cc_expiry_date", "event_time")]
                )

fg.insert(df) # transformation functions are run on insertion

@hopsworks.udf(return_type=float, drop=["cc_expiry_date"])
```

# PyTorch Transformations

- ML systems trained with unstructured data typically use deep learning algorithms and transform the data into tensors for model input
- Convolutional neural networks (CNNs)
- Transformer architecture

<img src="/images/Pasted image 20261110145054.png" alt="image" width="500">

- Image augmentation
	- Create many variations on the same input image for training data
	- Helps CNNs generalize better

```python
import torchvision.transforms.v2 as v2

class ImageAugmentation(nn.Module):
    def __init__(self, flip_prob=0.5, rotation_range=(-30, 30)): 
        self.flip_prob = flip_prob 
        self.rotation_range = rotation_range

    def forward(self, img):
        …

on_demand_transforms = v2.Compose([
    v2.Resize(...),
    v2.CenterCrop(...),
])
model_independent_transforms = v2.Compose([
    v2.Resize(...),
    v2.CenterCrop(...),
    ImageAugmentation(...)
])
model_dependent_transforms = v2.Compose([
    v2.ToImage(...),
    v2.ToDtype(...),
    v2.Normalize(...)
])
```

- PyTorch provides datasets as a data structure to store features and labels
- Pre-created datasets
- Apply the transformations to a dataset in PyTorch before training a model

```python
dataset = datasets.ImageFolder(root='images/train', 
    transform=model_independent_transforms )
dataloader = DataLoader(dataset, batch_size=32, num_workers=4)
for images, labels in dataloader:
    # Your training code goes here
```

# Using pytest

- Transformation functions and feature functions from feature pipelines create features
- Unit tests help ensure that developers do not make unexpected changes to how features are computed

## Unit Tests

```python
def days_to_card_expiry(cc_expiry_date, event_time):
    return (cc_expiry_date - event_time).dt.days
```

- Log transformations are undefined if the value is zero or negative

```python
def days_to_card_expiry(cc_expiry_date, event_time):
    days_remaining = (cc_expiry_date - event_time).dt.days
    return max(days_remaining, 1)
```

```python
import pytest
def test_days_to_future_expiry():
    future_date = datetime.date.today() + datetime.timedelta(days=30)
    assert days_to_card_expiry(future_date, datetime.date.today()) == 30

def test_days_to_today_expiry():
    today_date = datetime.date.today()
    assert days_to_card_expiry(today_date, today_date) == 0

def test_expired_card():
    past_date = datetime.date.today() - datetime.timedelta(days=10)
    with pytest.raises(ValueError, match="Credit card is expired."):
        days_to_card_expiry(past_date, datetime.date.today())

```

### Implementing pytest unit tests

- Unit tests are defined on Python functions
- Factor code so that each feature is computed by a single function
- Use a unit test to validate that the code computes a feature correctly follows a specification defined by the unit test itself

- Invariant
	- A condition that remains true throughout the lifetime of the function
- Precondition
	- Must be true before a function can be executed correctly
- Postcondition
	- A condition or set of conditions that must hold true after a function o method compeltes its execution

<img src="/images/Pasted image 20261110145859.png" alt="image" width="500">

- Test functions
- Assertions
- Test setup

- Unit tests may be written either as functions or as methods in classes
- Pytest has a naming convention to automatically discover test modules/classes/functions
- Run unit tests in development environment before you create a pull request (PR)
- Pytest is run during development as offline tets
	- Not when pipelines have been deployed to prduction

### Running pytest as part of a GitHub Action


```yaml
name: Credit Card Fraud Test
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - name: Check out repository code
      uses: actions/checkout@v3
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.12'
    - name: Install dependencies
      run: |
        cd ccfraud
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    - name: Run tests
      run: |
```

## A Testing Methodology

- Arrange, act, assert pattern
	- Arranges the inputs and targets
	- Acts on the target behaviour
	- Asserts expected outcomes
- Testing is not always required for all features

1. Write unit test for all features and transformation function
	1. Check test code coverage
2. Test feature pipelines, training pipelines, and batch inference pipelines with end-to-end tests
3. Write unit test for utility functions and other important untested code paths

- 