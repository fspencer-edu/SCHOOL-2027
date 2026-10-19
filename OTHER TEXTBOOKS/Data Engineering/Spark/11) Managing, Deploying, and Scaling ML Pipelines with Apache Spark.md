# Model Deployment

- Ensure that the model can be reproduced and its performance tracked
- Library versioning
- Data evolution
- Order of execution
- Parallel operations

## MLflow

- MLflow is an open source platform that helps developers reproduce and share experiments, manage models, and more
- Tracking
- Projects
- Models
- Registry

### Tracking

- Logging API that is agnostic to the libraries and environments that actually do the training
- Organized around the concept or funs
- Runs are aggregated into experiments

<img src="/images/Pasted image 20261018213826.png" alt="image" width="500">

- Parameters
	- Key/value inputs
- Metrics
	- Numeric values
- Artifacts
	- Files, data, and models
- Metadata
	- Information about the run
- Models
	- The models trained

```python
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer, VectorAssembler
from pyspark.ml.regression import RandomForestRegressor
from pyspark.ml.evaluation import RegressionEvaluator

filePath = """/databricks-datasets/learning-spark-v2/sf-airbnb/
sf-airbnb-clean.parquet"""
airbnbDF = spark.read.parquet(filePath)
(trainDF, testDF) = airbnbDF.randomSplit([.8, .2], seed=42)

categoricalCols = [field for (field, dataType) in trainDF.dtypes 
                   if dataType == "string"]
indexOutputCols = [x + "Index" for x in categoricalCols]
stringIndexer = StringIndexer(inputCols=categoricalCols, 
                              outputCols=indexOutputCols, 
                              handleInvalid="skip")

numericCols = [field for (field, dataType) in trainDF.dtypes 
               if ((dataType == "double") & (field != "price"))]
assemblerInputs = indexOutputCols + numericCols
vecAssembler = VectorAssembler(inputCols=assemblerInputs, 
                               outputCol="features")

rf = RandomForestRegressor(labelCol="price", maxBins=40, maxDepth=5, 
                           numTrees=100, seed=42)

pipeline = Pipeline(stages=[stringIndexer, vecAssembler, rf])

from mlflow.tracking import MlflowClient

client = MlflowClient()
runs = client.search_runs(run.info.experiment_id, 
                          order_by=["attributes.start_time desc"], 
                          max_results=1)

run_id = runs[0].info.run_id
runs[0].data.metrics

mlflow.run(
  "https://github.com/databricks/LearningSparkV2/#mlflow-project-example", 
  parameters={"max_depth": 5, "num_trees": 100})

# Or on the command line
mlflow run https://github.com/databricks/LearningSparkV2/#mlflow-project-example
-P max_depth=5 -P num_trees=100
```

# Model Deployment Options with MLlib

<img src="/images/Pasted image 20261018214038.png" alt="image" width="500">

- Batch processing
	- Generates predication on a regular schedule and writes the results out to persistent storage to be server elsewhere
	- Cheapest and easiest deployment
	- More efficient per data point
	- Less overhead when amortized across all predication
	- Latency
- Streaming
	- Continuously make predications on micro-batches of data and get your prediction in seconds to minutes
	- Pay for the VMs or computing resources you use to continually stay up and running
- Real time
	- Prioritizes latency over throughput
	- Support load balancing and scale to many concurrent requests

<img src="/images/Pasted image 20261018214305.png" alt="image" width="500">

## Batch

- Batch deployment represent the majority of use cases for deploying machine learning models
- Run a regular job to generate predications

```python
# Load saved model with MLflow
import mlflow.spark
pipelineModel = mlflow.spark.load_model(f"runs:/{run_id}/model")

# Generate predictions
inputDF = spark.read.parquet("/databricks-datasets/learning-spark-v2/
  sf-airbnb/sf-airbnb-clean.parquet")

predDF = pipelineModel.transform(inputDF)
```

- How frequent predictions are generated
- How often the model is retrained
- How to version the model

## Streaming

- Continuously perform inference on incoming data
- Convert batch predication to streaming predictions
- Need to define the schema prior to working with streaming data

```python
# Load saved model with MLflow
pipelineModel = mlflow.spark.load_model(f"runs:/{run_id}/model")

# Set up simulated streaming data
repartitionedPath = "/databricks-datasets/learning-spark-v2/sf-airbnb/
  sf-airbnb-clean-100p.parquet"
schema = spark.read.parquet(repartitionedPath).schema

streamingData = (spark
                 .readStream
                 .schema(schema) # Can set the schema this way
                 .option("maxFilesPerTrigger", 1)
                 .parquet(repartitionedPath))

# Generate predictions
streamPred = pipelineModel.transform(streamingData)
```

- Write predication out on any target location for retrieval later

## Model Export Patterns for Real-Time Inference

- Load balancing
- Geolocation in latency critical tasks
- AWS SageMaker
- Azure ML
- Reimplement the model natively in Python, C
- ONNX (Open Neural Network Exchange)
	- ML interoperability
	- Switch between libraries and languages
- PMML (Predictive Model Markup Language)
- XGBoost
	- Algorithms for structured data problems

```python
import xgboost as xgb
bst = xgb.Booster({'nthread': 4})
bst.load_model("xgboost_native_model")
```

# Leveraging Spark for Non-MLlib Models

## Pandas UDFs

- Create custom functions to apply your pretrained models at scale
- User defined functions (UDFs)
- Build a scikit-learn or TensorFlow model on a single machine and perform distributed inference on the entire dataset using Spark
- Define UDF to apply a model to each record of the DataFrame in Python

```python
import mlflow.sklearn
import pandas as pd

def predict(iterator):
  model_path = f"runs:/{run_id}/random-forest-model"
  model = mlflow.sklearn.load_model(model_path) # Load model
  for features in iterator:
    yield pd.DataFrame(model.predict(features))
    
df.mapInPandas(predict, "prediction double").show(3)

+-----------------+
|       prediction|
+-----------------+
| 90.4355866254844|
|255.3459534312323|
| 499.625544914651|
+-----------------+
```

- Use Pandas UDF to parallelize the process of building many models

```python
df.groupBy("device_id").applyInPandas(build_model, schema=trainReturnSchema)
```

## Spark for Distributed Hyperparameter Tuning

### Joblib

- A set of tools to provide lightweight pipelining in Python
- Spark backend to distributed tasks on a Spark cluster
- Used for hyperparameter tuning as it automatically broadcosts a copy of data to all works, that can create their own models with different hyperparameters

<img src="/images/Pasted image 20261018215317.png" alt="image" width="500">

```python
from sklearn.utils import parallel_backend
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
import pandas as pd
from joblibspark import register_spark

register_spark() # Register Spark backend

df = pd.read_csv("/dbfs/databricks-datasets/learning-spark-v2/sf-airbnb/
  sf-airbnb-numeric.csv")
X_train, X_test, y_train, y_test = train_test_split(df.drop(["price"], axis=1), 
  df[["price"]].values.ravel(), random_state=42)

rf = RandomForestRegressor(random_state=42)
param_grid = {"max_depth": [2, 5, 10], "n_estimators": [20, 50, 100]}
gscv = GridSearchCV(rf, param_grid, cv=3)

with parallel_backend("spark", n_jobs=3):
  gscv.fit(X_train, y_train)
  
print(gscv.cv_results_)
```

### Hyperopt

- Python library for serial and parallel optimization over awkward search spaces
	- Real-valued, discrete, and conditional dimension
- Using single machine Hyperopt with a distributed training algorithm
- Using distributed Hyperopt with single machine training algorithms with the `SparkTrials` class

```python
import hyperopt

best_hyperparameters = hyperopt.fmin(
  fn = training_function,
  space = search_space,
  algo = hyperopt.tpe.suggest,
  max_evals = 64,
  trials = hyperopt.SparkTrials(parallelism=4))
```

- Pandas
	- Popular data analysis and manipulation library in Python
	- Limited to a single machine
- Koalas
	- Open source library that implements the Pandas DataFrame API on top of Apache Spark

```python
# In pandas
import pandas as pd
pdf = pd.read_csv(csv_path, header=0, sep=";", quotechar='"')
pdf["duration_new"] = pdf["duration"] + 100

# In koalas
import databricks.koalas as ks
kdf = ks.read_csv(file_path, header=0, sep=";", quotechar='"')
kdf["duration_new"] = kdf["duration"] + 100
```