- Pipeline
	- A computer program that has clearly defined inputs and outputs
	- Runs on a schedule or continuously
- ML pipeline
	- Any pipeline that outputs ML artifacts
		- Outputs features, embeddings, a trained model, or predictions
# Building ML Systems with ML Pipelines

## Minimal Viable Prediction Service

- ML artifacts
	- Models
	- Features
	- Training data
	- Vector indexes
	- Model deployments
	- Predication/context logs
- Stateful objects that are produced by ML pipelines and are managed by the ML infrastructure service

- MVPs development process
	- Prediction problem
	- KPI metrics to improve
	- Data sources available for use
- ML proxy metric should be positively correlated with the KPI(s)

<img src="/images/Pasted image 20261031224241.png" alt="image" width="500">

- Implementation
	1. Develop a minimal feature pipeline that can both backfill historical data and write incremental production data to the feature store
	2. Develop a minimal training pipeline for a custom model
	3. Develop an inference to make prediction
	4. Develop a UI or dashboard

- Exploratory data analysis (EDA)
	- Understanding data, its quality, and dependency between any features and target variables
	- Develop domain knowledge
- FTI pipelines
- Kanban board
	- Visual tool that can track work through the MVPs process

<img src="/images/Pasted image 20261031224952.png" alt="image" width="500">

- Annotate the kanban lanes with nonfunctional requirements
	- Volumne
	- Velocity
	- Freshness
	- Service level objective (SLO)

## Writing Modular Code for ML Pipelines

- Source code maintenance
	- Set of features computed or the data they are computed from
	- How you train the model
	- Batch ML
		- Make predictions more frequently or changing the sink
	- Online ML
		- Change in the request latency of feature freshness requirements
	- LLM applications
		- Changes in context engineering, tools, or LLM versions

- Modularize the AI system into 3 or more pipelines
	- Feature
	- Training
	- Inference

- Test the code in notebooks to make sure any changes work before deploying them to production
- Refactor Python into functions or classes
- Store feature functions in Python modules to be independently unit tested and reused
- Refactor this code as feature functions that update a DataFrame containing the features
- For each feature computed, defined a new feature function

```python
@pytest.fixture
def get_spends(self) -> pd.DataFrame:
    return pd.DataFrame([[20, 40], [5, 4], [4, 10],
        columns=["spends", "signups", "acquisition_cost"])

def test_spend_per_signup (get_spends : Callable):
    df=get_spends()
    df["res"] = acquisition_cost(df["spends"], df["signups"])
    pd.testing.assert_series_equal(df["res"], df["acquisition_cost"])
```

- Functions are data transformations on a DataFrame in a feature pupeline
- Feature stores provide DataFrame APIs for ingesting DataFrames in a feature group
- Data can later be read from feature groups by training and inference pipelines

<img src="/images/Pasted image 20261031225925.png" alt="image" width="500">


# A Taxonomy for Data Transformations in ML Pipelines

- ML pipelines consist of a sequence of data transformations
- Feature store stores feature data that can be reused across many models
- Some data transformations, produce features that are not reusable across models
	- Encoding a categorical variable
	- Parameterized numerical variables
	- Normalized numerical variables
- Taxonomy organizes data transformations into 3 different classes
	- Model dependent
	- Model independent
	- On-demand transformations

## Feature Types and Model-Dependent Transformations

- Data type 
	- Defined the set of valid operations on the variable
- Feature types
	- Data type extensions that are used for understanding the set of valid transformations on a variables in ML
		- Encode a categorical variable
		- Tokenize a string input into LLM
		- Normalize, standardize, or scale a numerical value

- Vector embeddings
	- Fixed-size array of either floating point numbers or integers that stores a compressed representation of some higher-dimensional data
	- Lists and vector embeddings

<img src="/images/Pasted image 20261031230643.png" alt="image" width="500">

- Feature are supported in ML frameworks and libraries
	- Scikit-Learn
	- TensorFlow
	- XGBoost
	- PyTorch
- Transformations are specific to ML
- Normalization improves convergence of gradient-descent based ML algorithms
- Model dependent transformations (MDTs)
	- Transformations are not reusable across other models
	- Dependent on the model and/or its training data
	- Apply MDT twice
		- Training pipeline, when creating training data
		- Inference pipeline
	- Make sure no skew between the implementation of MDT's in the training and inference pipelines
- Transformed feature data is mot amenable to EDA
	- Recompute existing feature data
	- Write amplification

## Reusable Features with Model-Independent Transformations

- Data transformations
	- Windowing
	- Aggregations
	- Window counts
	- Transformations to create
		- Recency
		- Frequency
		- Monetary value (RFM)
- Model independent transformations (MITs)
	- Computer once in batch or streaming 

## Real-Time Features with On-Demand Transformations

- On-demand transformation (ODT)
- Implement as user-defined functions (UDFs)
## The ML Transformation Taxonomy and ML Pipelines

- Taxonomy
	- Model independent transformations that produce reusable features that are stored in a feature store
	- Model dependent transformations that produce features specific to a single model
	- On demand transformations that require request time data to be computed in online inference pipelines, but can also be computed in feature pipelines on historical data

<img src="/images/Pasted image 20261101230456.png" alt="image" width="500">

<img src="/images/Pasted image 20261101230514.png" alt="image" width="500">

- MITs are only performed in feature pipelines
- MDTs are performed in both training and inference pipelines
- Ensure there is no skew between the different implementation

# Feature Pipelines

- A feature pipeline is a program that orchestrates the execution of a dataflow graph of model-independent and on-demand data transformations
	- Extracting data from a source
	- Data validation and cleaning
	- Feature extraction, aggregation, dimensionality reduction
	- Binning
	- Feature crossing
- Batch or streaming feature pipelines can apply some or all of these types of data transformations to create features that are stored in a feature sture
- Vector embedding pipeline
	- Creates vector embeddings that are stored in a vector index
- Feature data validation pipeline
	- An asynchronous program that runs data validation rules against feature data stored in a feature store

<img src="/images/Pasted image 20261109094000.png" alt="image" width="500">

- Non functional requirements of a feature store
	- Backfilling or incremental data
	- Fault tolerance
	- Scalability
	- Feature freshness
	- Governance and security requirements
	- Data quality guarantees

- Output feature data is typically stored in a tabular format and in feature group(s)
	- Stores feature data in tables that are used by clients for both training and inference
- Idempotence
	- Produce the same result even if they are run more than once
- Atomicity
	- Updates should be applied all at once

- Pandas
	- Framework that processes less than 1 GB per execution
- Polars
	- 10 of GBs
- Apaches Spark and SQL
	- TB-scale workloads
- dbt
	- Adds modularity to SQL by enabling transformations to be defined in separate files as a form of pipeline
- Feldera
	- STream processing to compute feature
- Spark Structured Streaming

# Training Pipelines

- A training pipeline is a program that performs tasks
	- Reading feature data from a feature store
	- Applying model dependent transformations to the feature data
	- Training a model with a ML framework
	- Validating the trained model for performance and absence of bais
	- Publishing the model to a model registry
	- Deploying the model to production for inference

- Complete training pipelines
	- Performs all of the training pipeline tasks

<img src="/images/Pasted image 20261109094837.png" alt="image" width="500">

- Model deployment pipeline
	- Downloads a model from a model registry and deploys it for batch or online serving
	- A/B tests
- Model validation pipeline
	- Model is asynchronously evaluated for performance and compliance after being saved to the model registry
- Training dataset pipelines
	- Training pipeline is decomposed
	- Selects, filters, joins feature data from a feature store
	- Applies model dependent transformation to the feature data
	- Saves the final training data as files

# Inference Pipelines

- An inference pipeline is a program that reads in new feature data, applies transformations to the feature data, and outputs predictions with the model
	- Batch inference pipelines
	- Online inference pipelines
	- Agentic pipelines

<img src="/images/Pasted image 20261109095212.png" alt="image" width="500">

- Batch inference pipeline
	- Reads inference data as precomputed features from the feature store
	- Downloads the model from the registry
	- Outputs predictions using the the inference data
	- Implemented as Python programs using Pandas, Polars, or Spark
	- Run on a schedule by some orchestrator (Apache Airflow)
- Online inference pipeline
	- Takes request parameters
	- Reads any precomputed feature from the feature store
	- Performs any data transformations on the precomputed features
	- Calls the model with the feature vector
	- Logs prediction and feature
	- Returns the prediction to the client
	- Network hosted service that makes predictions in response to prediction requests
	- Deployment API
		- IDs for the entities the prediction is being made for
		- Parameters required to compute real-time feature for the model
		- IDs are used to retrieve precomputed features for the entities
			- KServe
			- FastAPI
- Agentic pipeline
	- Network hosted Python program
	- LlamaIndex, LangGraph, LangChain, or CrewAI
	- LLM and access to a set of tools along with a schema for each tool
	- A tool is an action the agent can execute

# Titanic Survival as an ML System Built with ML Pipelines

- Predicting the probability of a passenger surviving the sinking of the Titanic
	- Static dataset
	- ML model is trained and evaluated on the static dataset

<img src="/images/Pasted image 20261109095837.png" alt="image" width="500">


<img src="/images/Pasted image 20261109100111.png" alt="image" width="500">

- The synthetic passenger feature value are drawn from the same distribution as the original dataset
- Write the historic and new feature data to a single group in the Hopsworks feature store with a feature pipeline written in Python using Pandas
- Schedule the feature pipeline to run once per day, creating one new passenger for the Titanic for that day

```python
import pandas as pd
import hopsworks

BACKFILL=True

def get_new_synthetic_passenger():
    # see github repo for details

if BACKFILL==True:
    df = pd.read_csv("titanic.csv")
    # Remove columns that are not predictive of passenger survival
else:
    df = get_new_synthetic_passenger()

fs = hopsworks.login().get_feature_store()
fg = fs.get_or_create_feature_group(name="titanic", version=1, \
    primary_keys=['id'], description="Titanic passengers")
fg.insert(df)
```

- Feature view
	- Represents the input features and output labels/targets for the model
	- Read training data
	- Split 20/80 test/train
- XGBoost
	- A gradient boosted decision tree library
	- Trains the model
- Save the trained model to Hopsworks' model registry

```python
import xgboost
fg = fs.get_feature_group(name="titanic", version=1)
fv = fs.get_or_create_feature_view(name="titanic", version=1, \
    labels=['survived'], \
    query=fg.select_features()
)

X_train, X_test, y_train, y_test = fv.train_test_split(test_size=0.2)
model = xgboost.XGBClassifier()
model.fit(X_train, y_train)

model.save_model("model_dir/model.json")
mr = hopsworks.login().get_model_registry()
mr_model = mr.python.create_model(
    name="titanic",
    feature_view=fv,
)
mr_model.save("model_dir")
```

- Write a batch inference pipeline that is scheduled to run once per day
- Read any new synthetic passenger from the feature store, download trained model, and use the model to predict

```python
retrieved_model = mr.get_model(name="titanic", version=1)
saved_model_dir = retrieved_model.download()
model = xgboost.XGBClassifier()
model.load_model(saved_model_dir + "/model.json")
row_data = # get row of features for new passenger
prediction = model.predict(row_data)
```

- Counterfactual (what-if) prediction problem
