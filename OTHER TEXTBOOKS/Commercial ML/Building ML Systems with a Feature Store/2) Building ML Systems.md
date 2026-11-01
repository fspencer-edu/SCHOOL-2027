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

## Real-Time Features with On-Demand Transformations
## The ML Transformation Taxonomy and ML Pipelines



# Feature Pipelines


# Training Pipelines
# Inference Pipelines
# Titanic Survival as an ML System Built with ML Pipelines