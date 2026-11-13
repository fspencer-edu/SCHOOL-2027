
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
- Incremental drift
- Recurring drift



## Univariate Feature Drift
## Multivariate Feature Drift
## Monitoring Vector Embeddings
## Model Monitoring with NannyML
## When to Retrain or Redesign a Model
# Logging and Metrics for Agents

## From Logs to Traces with Agents
## Error Analysis
## Guardrails
## Online A/B Testing
## Jailbreaking and Prompt Injection
## LLM Metrics