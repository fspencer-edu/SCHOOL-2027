- MLib
	- Machine learning library in Apache Spark

# What Is ML?

- ML is a process for extracting patterns from your data, using statistics, linear algebra, and numerical optimization

## Supervised Learning

- Data consists of a set of input records, each of which has associated labels
- Predict the output labels given a new unlabeled input
	- Discrete or continuous
- 2 types of supervised ML
	- Classification
	- Regression
- Separate the inputs into a discrete set of classes or labels
- Binary classification
	- 2 discrete labels
- Multiclass/multinomial
	- More than 2 discrete labels
- Regression problems predicts a continuous value

- Classification and regression algorithms
	- Linear regression
	- Logistic regression
	- Decision trees
	- Gradient boosted trees
	- Random forest
	- Naive Bayes
	- Support vector machines (SVMs)

## Unsupervised Learning

- Unsupervised learning algorithms
	- K-eans
	- Latent Dirichlet Allocation (LDA)
	- Gaussian mixture models
## Why Spark for ML?

- 2 ML learning packages in spark
	- `spark.mllib` and `spark.ml`
- Focuses on O(n) scale-out, where the model scales linearly with the number of data points

## Designing ML Pipelines

- Pipeline API provides a high level API built on top of DataFrames to organize ML workflow
- Transformer
	- Accepts a DataFrame as input, and returns a new DataFrame with one or more columns appended to it
	- Does not learn any parameters
- Estimator
	- Learns parameters from the DataFrame via `.fit()` method and returns a `Model`, which is a transformer
- Pipeline
	- Organizes a series of transformers and estimators into a single model

## Data Ingestion and Exploration

```python
# In Python
filePath = """/databricks-datasets/learning-spark-v2/sf-airbnb/
sf-airbnb-clean.parquet/"""
airbnbDF = spark.read.parquet(filePath)
airbnbDF.select("neighbourhood_cleansed", "room_type", "bedrooms", "bathrooms", 
                "number_of_reviews", "price").show(5)

+----------------------+---------------+--------+---------+----------+-----+
|neighbourhood_cleansed|      room_type|bedrooms|bathrooms|number_...|price|
+----------------------+---------------+--------+---------+----------+-----+
|      Western Addition|Entire home/apt|     1.0|      1.0|     180.0|170.0|
|        Bernal Heights|Entire home/apt|     2.0|      1.0|     111.0|235.0|
|        Haight Ashbury|   Private room|     1.0|      4.0|      17.0| 65.0|
|        Haight Ashbury|   Private room|     1.0|      4.0|       8.0| 65.0|
|      Western Addition|Entire home/apt|     2.0|      1.5|      27.0|785.0|
+----------------------+---------------+--------+---------+----------+-----+
```

## Creating Training and Test Data Sets

- Split dataset into two groups
	- Train
	- Test
- 80/20

<img src="/images/Pasted image 20261018124519.png" alt="image" width="500">

- Training set consists of a set of features (X) and a label (y)
- X = n x d (data points x features)
- Measure of performance
	- Accuracy
- Set a random seed for reproducibility
	- Get same data point on training and test datasets

```python
# In Python
trainDF, testDF = airbnbDF.randomSplit([.8, .2], seed=42)
print(f"""There are {trainDF.count()} rows in the training set, 
and {testDF.count()} in the test set""")
```

 - Catalyst optimizer
	 - Determines the optimal way to partition data as a function of cluster resources and size of dataset
 - Split data once, then write it out to its own train/test folder
 - For exploratory analysis, cache the training dataset

## Preparing Feature with Transformers

- Linear regression requires that all the inputs features are contained within a single vector in the DataFrame
- Transformers accept a DataFrame and return a new DataFrame
- `VectorAssembler` transformer
	- Takes a list of input columns and creates a new DataFrame with an additional column, called `features`
	- Combined values of input columns into a single vector

```python
# In Python
from pyspark.ml.feature import VectorAssembler
vecAssembler = VectorAssembler(inputCols=["bedrooms"], outputCol="features")
vecTrainDF = vecAssembler.transform(trainDF)
vecTrainDF.select("bedrooms", "features", "price").show(10)
```

## Understanding Linear Regression

- Linear regression models a linear relationship between dependent (label) and one or more independent variables (features)
- Fit a linear regression model to predict the price of an Airbnb rental given the number of bedrooms
	- $y = mx + b$
- Dots indicate the true (x, y) pair from the dataset
- Solid line is the best fit for this dataset
	- $y \approx mx + b + \epsilon$
- $\epsilon$ is an error drawn independently per record x from some distribution
	- Gaussian or normally distributed
- Vertical lines above the regression line indicate positive residuals and below are negative residuals
- Find the line that minimizes the square of the residuals

<img src="/images/Pasted image 20261018143543.png" alt="image" width="500">

- Linear regression can also be extended to handle multiple independent variables
- Separate coefficient (or weight) for each feature

$x = [x_1, x_2, x_3]$
$y \approx w_0 + w_1x_1 + w_2x_2 + w_3x_3$

- The process of estimating the coefficients and intercept for out models is called learning the parameters for the model

## Using Estimator to Build Models

- `LinearRegression` is a type estimator
	- Takes in a DataFrame and returns a `Model`
	- Estimators learn parameters from data
	- Transformers are lazily evaluated

```python
from pyspark.ml.regression import LinearRegression
lr = LinearRegression(featuresCol="features", labelCol="price")
lrModel = lr.fit(vecTrainDF)
```

- `lr.fit()`
	- Returns a linear regression model
- Once the estimator has learned the parameters, the transformers can apply these parameters to new data points to generate predications

```python
m = round(lrModel.coefficients[0], 2)
b = round(lrModel.intercept, 2)
print(f"""The formula for the linear regression line is 
price = {m}*bedrooms + {b}""")
```

## Creating a Pipeline

- Prepare data in the same way as the training set
- Pipeline API
- Specify the stages for data to pass through

```python
from pyspark.ml import Pipeline
pipeline = Pipeline(stages=[vecAssembler, lr])
pipelineModel = pipeline.fit(trainDF)
```

- Determines which stages are estimators/transformers

```python
predDF = pipelineModel.transform(testDF)
predDF.select("bedrooms", "features", "price", "prediction").show(10)
```

- Categorical features take on discrete values and have no intrinsic ordering

### One hot encoding (OHE)

- Most ML models in MLlib expect numerical values as input, represented as vectors

```python
"Dog" = [ 1, 0, 0]
"Cat" = [ 0, 1, 0]
"Fish" = [0, 0, 1]
```

- Spark internally uses a `SparseVector`
	- When the majority of the entries are 0, it does not store them

```pyhon
DenseVector(0, 0, 0, 7, 0, 2, 0, 0, 0, 0)
SparseVector(10, [3, 5], [7, 2])
```

- Size of vector, indices, nonzero values
- `StringIndexer`
	- Convert categorical values into category indices
- `OneHotEncoder`
	- Maps a column of category indices to a column of binary vectors

```python
from pyspark.ml.feature import OneHotEncoder, StringIndexer

categoricalCols = [field for (field, dataType) in trainDF.dtypes 
                   if dataType == "string"]
indexOutputCols = [x + "Index" for x in categoricalCols]
oheOutputCols = [x + "OHE" for x in categoricalCols]

stringIndexer = StringIndexer(inputCols=categoricalCols, 
                              outputCols=indexOutputCols, 
                              handleInvalid="skip")
oheEncoder = OneHotEncoder(inputCols=indexOutputCols, 
                           outputCols=oheOutputCols)

numericCols = [field for (field, dataType) in trainDF.dtypes 
               if ((dataType == "double") & (field != "price"))]
assemblerInputs = oheOutputCols + numericCols
vecAssembler = VectorAssembler(inputCols=assemblerInputs, 
                               outputCol="features")
```

- `handleInvalid`
	- Specifies how to handle new categories found in test data
		- `skip, error, keep`
- `VectorIndexer`
	- Automatically detect all categorical variables
- `RFormula`
	- Provide a label and features to be included
	- Auto `StringIndex` and OHE
	- OHE is not recommended for all algorithms

```python
from pyspark.ml.feature import RFormula

rFormula = RFormula(formula="price ~ .", 
                    featuresCol="features", 
                    labelCol="price", 
                    handleInvalid="skip")
```

- Add a linear regression model using all the features as input

```python
lr = LinearRegression(labelCol="price", featuresCol="features")
pipeline = Pipeline(stages = [stringIndexer, oheEncoder, vecAssembler, lr])
# Or use RFormula
# pipeline = Pipeline(stages = [rFormula, lr])

pipelineModel = pipeline.fit(trainDF)
predDF = pipelineModel.transform(testDF)
predDF.select("features", "price", "prediction").show(5)
```

- The features column is represented as a `SparkVector`

## Evaluating Models

- Evaluators
	- Classification
	- Regression
	- Clustering
	- Ranking
	- Root mean square error (RMSE) - $R^2$

### RMSE

- RMSE is a metric that ranges from zero to infinity
	- Closer to zero is better
-  Compute different between true and predicated value
- Square the difference
- Sum the squared errors for all $n$ of the data points
- Normalize it by the number of records
- Take root of the MSE to get the error back on the scale of the original unit

$$
\text{Error} = y_i - \hat{y}_i
$$

$$
\text{Squared Error (SE)} = (y_i - \hat{y}_i)^2
$$

$$
\text{Sum of Squared Errors (SSE)} = \sum_{i=1}^{n}(y_i - \hat{y}_i)^2
$$

$$
\text{Mean Squared Error (MSE)} = \frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y}_i)^2
$$

$$
\text{Root Mean Squared Error (RMSE)} = \sqrt{\frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y}_i)^2}
$$
```python
from pyspark.ml.evaluation import RegressionEvaluator
regressionEvaluator = RegressionEvaluator(
  predictionCol="prediction", 
  labelCol="price", 
  metricName="rmse")
rmse = regressionEvaluator.evaluate(predDF)
print(f"RMSE is {rmse:.1f}")
```

### Interpreting the value of RMSE

- Build a simple baseline model and compute its RMSE to compare against
- Compute the average value of the label on the training set, then predict for every record in the test data set and compute the resulting RMSE
- Classification
	- Predict the most prevalent class as the baseline model

### $R^2$

- Range from negative infinity to 1

$$
R^2 = 1 - \frac{SS_{res}}{SS_{tot}}
$$

$$
SS_{tot} = \sum_{i=1}^{n}(y_i - \bar{y})^2
$$

$$
SS_{res} = \sum_{i=1}^{n}(y_i - \hat{y}_i)^2
$$

```python
r2 = regressionEvaluator.setMetricName("r2").evaluate(predDF)
print(f"R2 is {r2}")
```


- If a distribution is log normal, it means that if we take the logarithm of the value, the result looks like a normal distribution

## Saving and Loading Models

- Save a model to persistent storage

```python
pipelinePath = "/tmp/lr-pipeline-model"
pipelineModel.write().overwrite().save(pipelinePath)
```

- Specify the type of model loading back in
- Put transformers/estimators into a `Pipeline`

```python
from pyspark.ml import PipelineModel
savedPipelineModel = PipelineModel.load(pipelinePath)
```

- Cannot use the weights from this model as initialization parameters for training a new model
- No concept of warm starts

# Hyperparater Tuning

- A hyperparameter is an attribute that is defined about the model prior to training
- Not learned during the training process

## Tree Based Models

- Decision trees, gradient boosted trees, and random forests are simple models that are easy to interpret
### Decision Trees

- Decision trees are well suited to data mining
- Fast to build, highly interpretable, and scale invariant
- Series of if-then-else rules learned from data for classification or regression tasks
- The depth of a decision tree is the longest path from the root node to any given leaf node
- Trees that are deep are prone to overfitting, or memorizing noise in the training dataset
- Trees that are shallow will underfit the dataset
- Do not need to standardize or scale input features
- Naturally handle categorical variables

```python
from pyspark.ml.regression import DecisionTreeRegressor

dt = DecisionTreeRegressor(labelCol="price")

# Filter for just numeric columns (and exclude price, our label)
numericCols = [field for (field, dataType) in trainDF.dtypes 
               if ((dataType == "double") & (field != "price"))]

# Combine output of StringIndexer defined above and numeric columns
assemblerInputs = indexOutputCols + numericCols
vecAssembler = VectorAssembler(inputCols=assemblerInputs, outputCol="features")

# Combine stages into pipeline
stages = [stringIndexer, vecAssembler, dt]
pipeline = Pipeline(stages=stages)
pipelineModel = pipeline.fit(trainDF) # This line should error
```

- `maxBins`
	- Determines the number of bins into which your continuous features are discretized, or split
	- Workers have all the columns of the data, but only a subset of the rows

<img src="/images/Pasted image 20261018154057.png" alt="image" width="500">

- Every worker has to compute summary statistics for every feature and every possible split point
	- Statistics will be aggregated across the workers
	- Default value for `maxBins` is 32

```python
dt.setMaxBins(40)
pipelineModel = pipeline.fit(trainDF)

DecisionTreeRegressionModel: uid=dtr_005040f1efac, depth=5, numNodes=47,...
  If (feature 12 <= 2.5)
   If (feature 12 <= 1.5)
    If (feature 5 in {1.0,2.0})
     If (feature 4 in {0.0,1.0,3.0,5.0,9.0,10.0,11.0,13.0,14.0,16.0,18.0,24.0})
      If (feature 3 in
{0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,...})
       Predict: 104.23992784125075
      Else (feature 3 not in {0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,...})
       Predict: 250.7111111111111
...
```

- Extract the feature importance scores from our model to see the most important features

```python
import pandas as pd

featureImp = pd.DataFrame(
  list(zip(vecAssembler.getInputCols(), dtModel.featureImportances)),
  columns=["feature", "importance"])
featureImp.sort_values(by="importance", ascending=False)
```

### Random Forests

- Ensembles work by taking a democratic approach
- Random forests are an ensemble of decision trees with two key tweaks
	- Bootstrapping samples by rows
		- Simulating new data by sampling with replacement from original data
		- Bootstrap aggregating, or bagging
	- Random feature selection by columns
		- Consider a random subset of the columns

<img src="/images/Pasted image 20261018154625.png" alt="image" width="500">

```python
from pyspark.ml.regression import RandomForestRegressor
rf = RandomForestRegressor(labelCol="price", maxBins=40, seed=42)
```

- Pass new data point through the different trees trained in the ensemble
- Parallelize the work to find the optimal splits

<img src="/images/Pasted image 20261018154742.png" alt="image" width="500">

- Hyperparameter tuning
	- Value that contains the learning process or structure of the model

## K-Fold Cross-Validation

- 60/20/20 splits to generate training, validation, and test data
- Building model on training set
- Evaluate performance on validation set to select the best hyperparameter
- Apply model to the test set
- k-fold cross validation
	- Use the training data for both training and validation
	- Train model on k-1 folds, and validate on the remaining fold

<img src="/images/Pasted image 20261018155026.png" alt="image" width="500">

- Repeat process to identify the optimal one
- Doing a random search of hyperparameters outperforms a structured grid search
- Hyperopt
	- Help identify the optimal hyperparameter configuration
		- Define the `estimator` to evaluate
		- Specify which hyperparameters to vary, and respective values, 