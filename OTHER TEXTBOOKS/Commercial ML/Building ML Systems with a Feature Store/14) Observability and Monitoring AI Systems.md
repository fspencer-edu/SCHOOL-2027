
- Observability
	- Metrics
		- Numerical measurements of the performance of infrastructural services and ML pipelines
		- Data quality
		- Latency
		- Throughput
		- KPIs
		- Costs
		- SLOs
		- Elastic AI systems that auto scale up/down
	- Logging
		- Structured and unstructured text outputs and traces from infrastructural services and ML pipeline
		- Internal state
		- Error traces
		- Fine-grained performance

# Logging and Metrics for ML Models

- Observability
	- Metrics, logging, tracing

<img src="/images/Pasted image 20261113112622.png" alt="image" width="500">

## Logging for Batch and Online Models

- Metrics are typically stored in a metrics store (Prometheus)
	- Logs from inference pipelines are stored in tables for downstream analysis and monitoring
- Logs related to a given prediction should be unified before storage
	- Store prediction requests with all inputs, useful intermediate states, and outputs to a single table

<img src="/images/Pasted image 20261113112814.png" alt="image" width="500">

- Storing log data
	- A lakehouse table
		- Low-cost storage and easy analysis with SQL, PySpark, or Polars/Pandas
	- An online enabled feature gorup with TTL
		- Real time ML systems
	- A document store
		- OpenSearch
		- Datadog
	- A relational database
		- Postgres
			- Low operational overhead
			- Challenges in scalability and cost
	- SaaS logging/monitoring services

- Online logging
	- Network write to an SaaS platform
		- Adds latency to prediction request
	- Integrated with model deployments to log to the feature

<img src="/images/Pasted image 20261113113018.png" alt="image" width="500">

- Databricks
	- AI Gateway-enabled inference tables
	- Store the inputs and predictions from online inference pipeline requests in a lakehouse table
	- Monitor model performance and data drift
	- Mix metrics with deployment API inputs and output
		- HTTP status codes
		- Model execution time
- AWS SageMaker
	- Enabled data capture on a model deployment endpoint
	- Logging of deployment API requests and response value to a table in S3
	- Monitor request, response, and outcomes

- Hopsworks
	- Unified logging platform for real-time and batch ML systems

<img src="/images/Pasted image 20261113113350.png" alt="image" width="500">

- Online models
	- Serving keys
	- Parameters for on-demand transformations

## Metrics for Online Models

- Metrics measure the load and resource consumption of inference pipeline as well as their performance
- Used to calculate service level indicators
- Trigger autoscaling
- Metrics can be scraped at the infrastructure level and application layer

<img src="/images/Pasted image 20261113113545.png" alt="image" width="500">

- Metrics registry scrapes custom metrics from the metrics endpoint in KServe model deployment

```python
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
# Define a Prometheus counter for request counting
PREDICTION_REQUESTS = Counter('requests_total', 'Total num requests')

def predict():
    PREDICTION_REQUESTS.inc() 
    input_data = request.get_json()
    prediction = model.predict(input_data)
    return prediction

@app.route("/metrics")  # Expose Prometheus metrics
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
```

- Metrics server
	- Prometheus Adapter
	- Kubernetes-based Event Driven Autoscaler (KEDA)

```yaml
apiVersion: "serving.kserve.io/v1beta1"
kind: "InferenceService"
metadata:
  name: "sklearn-v2-iris"
  annotations:
    serving.kserve.io/deploymentMode: "RawDeployment"
    serving.kserve.io/autoscalerClass: "keda"
spec:
  predictor:
    minReplicas: 1
    maxReplicas: 5
    model:
      modelFormat:
        name: sklearn
      protocolVersion: v2
      runtime: kserve-sklearnserver
  autoscaling:
    scaleTargetRef:
      kind: Service
      name: sklearn-predictor
    triggers:
      - type: prometheus
        metadata:
          serverAddress: "http://prometheus-server.monitoring.svc:80"
          metricName: "http_server_requests_seconds_count"
          query: |
            sum(rate(requests_total{app="sklearn-predictor", 
                route="/metrics"}[1m]))
          threshold: "100"
```


- OpenTelemetry
	- Unified the exporting of metrics, traces, and logs to Prometheus

## Metrics for Batch models

- Autoscaling of batch jobs is different from autoscaling deployments
	- Feature pipelines and batch inference
- Restarting the job with more or fewer resources

<img src="/images/Pasted image 20261113113833.png" alt="image" width="500">

- Every Spark execution publishes an event to Apache Kafka
- Apache Samza job extracts driver/executor metrics and generate aggregate operational signals that are stored in MySQL
- Use an LLM to parse metrics and error logs to suggest right sizing the resource requirements for a batch job
	- SparkMeasure

# Monitoring Features and Models

- Drift
	- Change in the data distribution of features, labels, or their relationships that can negatively impact model performance over time
- Models are trained on a static snapshot of feature/label data that captures the relationship between the target (label) and the distributions of feature values in the training dataaset
- Scheduled retraining with recent data can recover model performance

<img src="/images/Pasted image 20261113132102.png" alt="image" width="500">

- New fraud schemes emerge, and model becomes progressively worse as it cannot recognize new fraud patterns
- Constantly monitor inputs and outputs
- Monitoring is an operational service that typically involves running a job on a schedule to compute statistical information about features and predictions

<img src="/images/Pasted image 20261113132253.png" alt="image" width="500">

- For features, X, compute distribution over
	- $N(X)$
		- New batches of feature data to be written to feature groups
	- $F(X)$
		- Feature data in feature groups
	- $P(X)$
		- Feature data in training datasets
	- $I(X)$
		- Batches of recent inference feature data
- For labels, y, compute distribution
	- $N(y)$
		- New batches of label data written to feature groups
	- $F(y)$
		- Label data in feature groups
	- $P(y)$
		- Label data in training datasets
	- $Q(\hat{y})$
		- Batches of recent predictions
	- $Q(y)$
		- Batches of recent outcomes (labels)


- If both distributions are identical, there is not drift
	- Reference distribution
	- Detection distribution
<img src="/images/Screenshot 2026-11-13 at 1.25.54 PM.png" alt="image" width="500">

- Drift algorithms typically first compute statistics over distributions of feature/label data
- Drift monitoring libraries and service
	- NannyML
	- Evidently AI
	- Arize
- Feature drift/covariate shirt
	- Implies that the relationships between feature and labels remains the same
	- N(X) and F(X) for features or N(y) and F(y) for labels differ

- Data ingestion drift
	- Distribution of new features or labels written to a feature group different from the existing data, subset of data, in the feature group
- Feature drift
	- Changes in the distribution in a recent batch of inference feature data for a model
	- I(X) is different from P(X)
	- Biased predictions, degraded model performance, or poor generalization
- Concept drift
	- Model is no longer accurate at predicting
	- Relationship between input features and label/target has changed over time
	- Reduced prediction accuracy
	- ROC AUC for classification
	- MES for regression
- Prediction drift
	- Change in the distribution of a recent time range of predicted target/label values, compared with label in the training dataset
	- $Q(\hat{y})$ differs from P(X)
	- Effect classification tasks
- Label shift
	- Occurs when there is a change in the distribution of a recent time range of production value
- KPI degradation
	- KPIs for the client of the prediction degrade
	- Downstream clients of the model are performing worse
	- False positive, or false negative predictions

- Statistical hypothesis testing
	- Compare a reference and detection distribution
	- Reference window is early in the time rage, and detection is for a later time range


<img src="/images/Pasted image 20261113133231.png" alt="image" width="500">

- Compute statistics over both windows of data
- Capture distribution information about both windows

- Second approach is model based drift detection
	- Train a model that can discriminate between the reference and detection datasets
		- Label all rows in the reference dataset as True
		- Label all rows in the detection dataset as False
		- Combine the two dataset and train a binary classifier using the same features the production model sees
		- Evaluate the classifier
		- If there is a high separation score (ROC AUC >> 0.5), there is drift

- Reference and detection data should be indistinguishable if there is not drift

<img src="/images/Pasted image 20261113133442.png" alt="image" width="500">

## Data Ingestion Drift

- Data ingestion drift
	- Uses a subset of data from a feature group as the reference dataset
	- Detection set on new batch (eager detection) or recent batch already written to the feature group (lazy detection)
- Drift detection being too sensitive to small batch sizes
	- Abrupt drift (not incremental or recurring drift)

- Abrupt drift
	- A sudden change in the data distribution
- Incremental drift
	- Small, incremental changes that accumulate over time
- Recurring drift
	- Periodic patterns that appear in and disappear from detection sets

```python
fg_some_monitoring_reference_sliding = trans_fg.create_feature_monitoring(
    name="fg_transactions",
    feature_name="amount",
    cron_expression="0 8,28,48 * ? * * *",
    description="Daily feature monitoring"
).with_detection_window(
    time_offset="3h", 
    row_percentage=0.8,
).with_reference_window(
    time_offset="1w1d", 
    window_length="7d",
    row_percentage=0.8,
).compare_on(
    metric="mean",
    threshold=0.1,
    relative=True,
).save()
```

## Univariate Feature Drift

- Reference window is the training dataset for a model
- Detection window is a batch of inference data, read from the log data for the model
- Univariate feature drift
	- Significant change in the distribution of a single variable or feature over time
	- Kullback-Leibler divergence
	- Wasserstein distance
	- L-infinity
	- Kolmogorov-Smirnov test
	- Deviation from the mean
- Deviation from the mean only works well if the reference distribution is roughly Gaussian

```python
model_mr.create_feature_monitoring(
    name="fv_amount",
    cron_expression="10 * ? * * *",
    trigger=alert_obj,
    feature_name="amount",
).with_detection_window(
    time_offset="1h", # fetch data from the last hour
    row_percentage=0.2,
).compare_on(
    metric="mean",
    threshold=0.1,
)
```

## Multivariate Feature Drift

- Multivariate feature drift
	- Change in the join distribution of multiple variables over time
	- Represented by the points changing shape, orientation, or position in the multidimensional space
- NannyML
	- Data reconstruction using principal component analysis (PCA)
		- Evaluates structural changes in data distribution
	- Domain classifier
		- Focuses on discriminative performance

- PCA
	- Finds the axes that best represent the spread of the data point in the original feature space
	- Orthogonal to each other
	- Capture the directions of maximum variance in the data
	- Creates new space that retain the most significant information by projecting the data onto these axes
	- Dimensionality reduction

```python
drdc = nml.DataReconstructionDriftCalculator(
    column_names=[feature.name for feature in fv.features if not feature.label],
    timestamp_column_name='event_time',
    chunk_period='h',
)
features_df, _ = fv.training_data()
drdc.fit(features_df)
inference_df = logging_fg.filter(event_time>=1hr_ago).select(fv.features).read()
multivariate_data_drift = drdc.calculate(inference_df)

drift_df = multivariate_data_drift.data
    
max_drift = drift_df['reconstruction_error'].value.max()
if max_drift > alert_threshold: # for any chunk 
    alert(...)
```

- Domain classifier
	- Detects multivariate feature drift by training a classier to distinguish between training data and a batch of logged inference data
	- Sensitive to any kind of drift
		- Non-linear
		- Interaction-based
		- Localized changes

## Monitoring Vector Embeddings

- Drift detection is challenging for vector embeddings
- Not easily interpretable
- Distributional properties of embeddings can be monitored
	- Norm distribution and centroid drift
	- Easier to monitor for significant changes in the values of an interpretable feature
		- `amount`
- Embedding drift
	- Create vector embeddings from non-stationary data
- Recompute the embeddings on a schedule
- Train a domain classifier model on the reference dataset to identify drift in a detection dataset
	- ROC AUC metric

## Model Monitoring with NannyML

- Model monitoring for concept drift where the outcomes are available at an acceptable delay is relatively straightforward
- Read the predictions from the log data and the outcomes from another table
- Monitor KPIs for the client that are correlated with the quality of predictions
- Confidence-Based Performance Estimation (CBPE)
	- Estimates the performance of classification models by using predicted probabilities to infer metrics
		- Accuracy
		- Precision
		- Recall
- Direct Loss Estimation (DLE)
	- Estimates a model's performance by directly modeling the expected loss based on prediction scores
	- Estimates the performance of regression models, loss function can be calculate for a single observation and turned into performance metrics
- CBPE
	- Only works for classification problems with predicted probabilities
	- Does not requires additional model training
	- Expects a timestamp that defines the temporal order of observations
	- Evaluates metrics in time-based chunks
- DLE
	- Requires additional work of training a supervised model

- Use the predicted probability of fraud


```python
# Training pipeline 
import nannyml as nml
X_train, X_test, y_train, y_test = feature_view.train_test_split(...)

# Train your model
model.fit(X_train, y_train)

# Construct reference dataset and predict probabilities on test data
reference = pd.concat([X_test, y_test], axis=1)

# Generate predicted labels using a threshold (e.g., 0.5)
reference['y_pred_proba'] = model.predict_proba(X_test)[:, 1]
reference['y_pred'] = (reference['y_pred_proba'] > 0.5).astype(int)

# NannyML expects binary ints for targets and predictions
reference['is_fraud'] = y_test['is_fraud'].astype(int)

# CBPE expects: y_pred_proba, y_pred, y_true, and timestamp column
cbpe = nml.performance_estimation.CBPE(
    y_pred_proba='y_pred_proba',
    y_pred='y_pred',
    y_true='is_fraud',
    timestamp_column_name='event_time',
    metrics=['roc_auc', 'f1', 'precision', 'recall'],
    chunk_size='7d'
)

cbpe.fit(reference) # Fit statistical model on reference (labeled) data
# Then save cbpe to Model Registry
```

## When to Retrain or Redesign a Model

- If you can acquire outcomes within an acceptable delay, monitor for concept drift by comparing predictions with outcomes
- If you do not have outcomes, start with model-based monitoring
- If you do not have obviously correlated features, start with multivariate feature monitoring
- For feature monitoring, start by triggering alerts that humans inspect

<img src="/images/Pasted image 20261113182325.png" alt="image" width="500">

# Logging and Metrics for Agents

- Logging usually happens at the agent level
- Agents execute steps in response to the user input
- LLMs model language and the work, which is relatively stable
- Error analysis
	- Helps improve agent's performance by providing insights to improve prompt templates, guardrails, RAG, tool usage, and agent workflows
- Agent traces
	- Capture the bigger performance picture

<img src="/images/Pasted image 20261113182554.png" alt="image" width="500">

- LRM and chain of thought prompting can also produce intermediate queries/responses that can also be stored

## From Logs to Traces with Agents

- Traces
	- A hierarchical structure of spans
- Spans
	- Contain logs, measurements, and events
	- Steps are called spans in most observability platforms
- Actions performed by an agent are logged as spans within a single graph run
- Metrics are used to quickly identify spikes in error rates and agent performance via latency and to help estimate cost by measuring the number of LLM tokens generated by the agent

<img src="/images/Pasted image 20261113182957.png" alt="image" width="500">

```python
from opik import Opik
client = Opik(project_name="Opik translator")
trace = client.trace( name="translate_trace",.. )
trace.span( name="llm_call", type="llm",
    input={"prompt": "Translate the following text to Swedish: Hello"},
    output={"response": "Hej"}
)
client.log_traces_feedback_scores( scores=[
    {"id": trace.id, "name": "accuracy", "value": 0.99, "reason": "Easy one."}
  ]
)
trace.end()
```

## Error Analysis

- Error analysis
	- Process of studying the types and sources of their mistakes
- Improve
	- Performance
	- Reliability
	- Interpretability

- Decompose errors by task
	- Subjective tasks
	- Object tasks
	- Instruction following errors
	- Harmful or unsafe output error
	- Style and communication errors
	- Factuality errors
	- Format errors
	- Reasoning correctness errors
	- Instruction following errors
	- Context faithfulness error
	- Factuality errors


## Guardrails
## Online A/B Testing
## Jailbreaking and Prompt Injection
## LLM Metrics