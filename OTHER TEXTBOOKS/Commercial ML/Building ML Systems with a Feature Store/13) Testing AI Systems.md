
- MLOps
	- Set of best practices for automated testing, versioning, and monitoring of ML pipelines

# Offline Testing

- Small bugs in the data or code can easily cause an ML model to silently make incorrect predictions
- Require significant engineering effort to test and validate to produce high-quality predictions

<img src="/images/Pasted image 20261111132150.png" alt="image" width="500">

# From Dev to Prod

- Code for ML pipelines should go from development to staging to production
- Infrastructure support and different environments

- Infrastructure services for developing and testing
	- Version control
	- CI/CD service
	- Artifact reponsitory
		- PyPI server
	- A container register to store the containers for the ML pipelines
	- Feature store and model registry to act as sources and sinks for pipeline integration tests
	- Model serving infrastructure to run model deployment tesets
	- Agent deployment infrastructure to run evals against agent deployments

- GitHub Actions
- Jenkins

<img src="/images/Pasted image 20261111132445.png" alt="image" width="500">


- Hopsworks
	- Projects have their own feature store, model registry, and model serving
	- Artifacts do not migrate from one environment to another
- PR triggers the execution of all automated tests by the CI/CD service
- Tests and test-launching code are often parameterized by an environment variable indicating whether they are run in development, staging, or production environment
- Pre-commit hooks
	- Commands that run automatically right before a commit is made to version control
	- Identify syntax errors
	- Unused imports
	- Style issues with a linter
	- Detect security vulnerabilities

# Automatic Containerization and Jobs

- Defined ML pipelines as source code
- Define and install dependencies and resources
- Package ML pipeline code, and dependencies in a container

- Write a Dockerfile that includes program's source code, dependencies, and how it is started
	- Environment variables
- Compile a container image from the Dockerfile
- Test container on local environment with Docker
- Register the container image with a container registry
- Write a program for an orchestrator to schedule the execution of your container on a container runtime like Kubernetes

- Automatic containerization
	- Methods that transparently build containers for programs
	- Base Docker image
	- Base Python environment


<img src="/images/Pasted image 20261111132932.png" alt="image" width="500">
## Environments and Jobs in Hopsworks

- Base containers
	- Feature pipelines
		- Pandas/Polars
		- PySpark
	- Training pipeline
		- XGBoost
		- Transformers
		- PyTroch
	- Batch inference
		- Pandas
		- PySpark
	- Online inference
		- KServe/XGBoost
		- Transformers/vLLM
	- Agents
		- LlamaIndex

- Clone and customize the based environments
- Prefer to write code to configure environments and create jobs or model/agent deployments that run in those environment

```python
proj = hopsworks.login()

# This code normally goes in the Program itself, not in the Job Creation
# Assume the book’s repo is already cloned into the Jupyter dir in your project
repo = git_api.get_repo("mlfs-book",f"/Projects/{proj.name}/Jupyter/mlfs-book" )
repo.checkout_branch("v1") # Run v1 of job
repo.checkout("v1") # Run v1 of job
repo.pull("v1")

env_api = proj.get_environment_api()
env = env_api.get_environment("spark-feature-pipeline-v1")
env.install_requirements("/Jupyter/mlfs-book/spark-requirements.txt")

# Create a Spark Job to run in the env pyspark_feature_pipeline
job_api = proj.get_job_api()
spark_config = job_api.get_configuration("PYSPARK")

spark_config.update({
    "spark.driver.memory" : 2048,
    "spark.driver.cores" : 1,
    "spark.executor.memory" : 8192,
    "spark.executor.cores" : 2,
    "spark.executor.instances" : 20,
    "environmentName" : "spark-feature-pipeline-v1",
    "appPath" : "/Resources/my_feature_pipeline.py"
})
job = job_api.create_job("my_spark_feature_pipeline", spark_config)

# Run the Spark job now
execution = job.run()
out_log_path, err_log_path = execution.download_logs()

# Run the Spark job on a schedule every day at 5:00 AM
job.schedule(
    cron_expression="0 0 5 * * ?",  # quartz cron syntax
    start_time=datetime.datetime.now(tz=timezone.utc)
)
```

- Install Python dependencies from a requirements text
- Define a PySpark job, resources, and workers

<img src="/images/Pasted image 20261111133219.png" alt="image" width="500">

- Airflow
	- Run larger ML pipelines as DAGs of jobs

## Modal Jobs

- Modal supports program-level automatic containerization
- Define a Debian container image, and define any OS dependencies with `apt`
- Install Python dependencies

```python
image = (
    modal.Image.debian_slim(python_version="3.12")
    .apt_install("ffmpeg")
    .pip_install(["hopsworks", "ffmpeg-python"])
)
@app.function(image=image, ...)
def my_function():
    ...
```

# CI/CD Tests for AI Systems

- Development tests
	- Executed offline when building ML pipeline
- Operational tests
	- Run as part of the system operation

<img src="/images/Pasted image 20261111133411.png" alt="image" width="500">

- Testing libraries
	- pytest
	- Great Expectation
	- KServe
	- NannyML

## Feature Pipeline Tests

- Feature pipelines write featurized DataFrames to one or more feature group
- Refactor it into separate function

```python
def read_data_source(fs, start_ts, end_ts):
    fg = fs.get_feature_group("transactions", version=1)
    return fg.filter((fg.ts > start_ts) & (fg.ts <= end_ts)).read()

def fg2_expectations():
    expectation_suite = ge.core.ExpectationSuite(expectation_suite_name="ge_fg")
    expectation_suite.add_expectation(
        ge.core.ExpectationConfiguration(
        expectation_type="expect_column_values_to_be_between",
        kwargs={"column":"amount", "min_value": 0, "max_value": 1000000}) 
    )
    return expectation_suite

def create_feature_group(fs):
    suite = fg2_expectations()
    fg = fs.create_feature_group("cc_aggs_trans", version=1,
        primary_key=["cc_num"], expectation_suite=suite
    )
    return fg

# This function is run by the pipeline test
def pipeline(fs, df):
    fg2 = fs.get_feature_group("cc_aggs_trans", version=1)
    if not fg2:
        fg2 = create_feature_group(fs)
    return fg2.insert(df)
    
def test_pipeline():
    fs = hopsworks.login().get_feature_store() 
    # Make sure the target feature group is empty for this test
    fg2 = fs.get_feature_group("cc_aggs_trans", version=1)
    if fg2:
        fg2.delete()
        # Run the pipeline with simulated data for testing
    df = pd.read_csv("sample_transactions.csv")
    job, validation_report = pipeline(fs, df)

    # Fetch the feature group created and perform required validation
    fg2 = fs.get_feature_group("cc_aggs_trans", version=1)


    # Sample data should fail one data validation rule, 
    assert validation_report.statistics\
        ["unsuccessful_expectations"]== 1
    job._wait_for_job()

    df2 = fg2.read()
    # Test that the data read is the same as the data written
    assert len(df) == len(df2)

```

- Feature pipeline test requires the development feature store to be available
- Source data from a` sample_transaction.csv`, providing synthetic data
- Store sampled data, checked into the source code repository, to remove any dependency on an external data source when running the integration test

<img src="/images/Pasted image 20261111133756.png" alt="image" width="500">

- If the test pass, the developer can then create a PR to the staging branch

## Training Pipeline Tests for Model Performance and Bias

- Testing training pipelines is different than feature pipelines
- Output of training pipeline is one or more trained model
- Model training is time-consuming
- Model validation steps include checking that model performance falls within an expected range, after every run

```python
fv = fs.get_feature_view('cc_fraud', version=1)
X_train, X_test, y_train, y_test = \
    fv.train_test_split(test_size=0.2, seed=42)

model.fit(X_train, y_train)
y_pred = pd.DataFrame(
    model.predict(X_test),
    columns=y_test.columns,
    index=X_test.index
)

# calculate y_pred for online and offline merchants
pred_df = pd.concat([X_test, y_pred], axis=1) 
y_pred_online = pred_df[pred_df['card_present']].loc[:, y_test.columns]
y_pred_offline = pred_df[~pred_df['card_present']].loc[:, y_test.columns]

# calculate y_test for online and offline merchants
test_df = pd.concat([X_test, y_test], axis=1)
y_test_online = test_df[test_df['card_present']].loc[:, y_test.columns]
y_test_offline = test_df[~test_df['card_present']].loc[:, y_test.columns]

f1_online = f1_score(y_test_online, y_pred_online)
f1_offline = f1_score(y_test_offline, y_pred_offline)

_, X_test_offline, _, y_test_offline = fv.filter(Feature("card_present") == \
    True).train_test_split(test_size=0.2, seed=42)
_, X_test_online, _, y_test_online = fv.filter(Feature("card_present") == \
    False).train_test_split(test_size=0.2, seed=42)
```

- Training pipeline integration test need access to sample data to run
- Connected directly to the feature store

<img src="/images/Pasted image 20261111134012.png" alt="image" width="500">

## Testing Model Deployments

- Test a new model version with production traffic
- A/B tests
	- Splits the prediction requests into X% that go to the production model and Y% that go to the challenger model
	- Testing the model's effect on the application that uses the new version of the model
	- Click-through rate, engagement, revenue lift, conversion rate, and task/session success/failure rates
- Blue/green tests
	- Tests the correctness and performance of the model directly
	- Send 100% of requests to the production (blue) and Y% of requests to the challenger (green) model
	- Risk-free testing for the clients that use it
	- Detect problems before exploring clients to the new model

<img src="/images/Pasted image 20261111134301.png" alt="image" width="500">

- If there is a large amount of traffic on the production model, send only a small percentage of production traffic to the challenger model, and slowly increase the percentage
- If the challenger outperforms the production mode, replace the production model with the challenger model

## A/B Tests for Batch Inference

- Batch inference AI systems should also be A/B tested before upgrading a model version
- Perform A/B test by backtesting a model with historical data and comparing the challenger's model performance ith the current production model
- Measure performance as a single scalar value

```python
model = mr.get_best_model(name='model', metric='performance', direction='max')
```

## Evals for Agents

- LLM applications and agents are more complex to test than model deployments
- LLM used
- System prompt
- RAG queries
- RAG data source updates

- Evaluate the agent's responses to a curated set of prompts
- Use evals to score the agents responses with the expected responses

<img src="/images/Pasted image 20261111134713.png" alt="image" width="500">

- Evals are tabular datasets
- Leverage the feature store to store evals and the responses to running the evals
- Evals are run against an agent deployment in a staging environment
- Agent outputs traces for all the steps taken
	- RAG request/responses
	- LLM request/responses
	- Prompt templates used
	- Final responses to the original request
- Store traces as logging feature groups in Hopsworks

- Evaluator
	- Program that processes the traces and expected responses
	- Store then as eval runs
	- Use LLM as a judge if subjective
	- Objective task
		- Results can be measured

- Hallucinations
	- Context adherence, correctness, and uncertainty
- Safety
	- Toxicity, bias, PII< tone, and prompt injection

- Binary classification
	- Faster scoring
- Likert scale (1 to 5)
	- Track gradual improvements
	- Small scale

- Best evals are application specific
	- Test both edge cases and common cases for use input
	- Possible to write separate evals for RAG queries, with measurements of the quality of RAG responses
		- Chunk attribution
		- Chunk utilization
		- Context relevance
		- Completeness

- Opik for LLM-as-a-judge

```text
User

You are an impartial AI judge. Evaluate if the assistant’s output effectively addresses the user’s input. Consider: accuracy, completeness, and relevance. Provide a score (1-5) and explain your reasoning in one clear sentence.

INPUT:

{{input}}

OUTPUT:

{{output}}
```

- 


### LLM-assisted synthetic eval generation

### Historical evals require point-in-time correct RAG data

# Governance

## Schematized Tags
## Lineage
## Versioning
## Audit Logs