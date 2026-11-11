
- Inference pipelines define the type of AI system
	- Batch inference
	- Online inference
	- Agentic workflows
- Inference pipelines
	- Program that acquires inference data, applies transformations, and produce one or more feature vectors
	- Feeds feature vectors to one or more models that output prediction

# Batch Inference Pipelines

- Batch inference pipelines make non-time-critical predictions, run on a schedule, and output predictions to some kind of inference store
- Inference store
	- Any data store that stores predictions from batch inference pipelines
- In production, dashboards are created from prediction in the inference store, while operational systems and monitoring systems also consume prediction in the inference store

- Bach inference pipeline
	- Read/query precomputed inference data with a feature view
	- Apply MDTs to the inference data
	- Call `model.predict()` with the transformed inference data

## Batch Predictions for a Time range

- Use a feature view to retrieve both training data and batches of inference data for time ranges
- Each batch data is read using a query
	- v1 - Includes start and end times for the training data
	- v2 - Query also includes a filter for data where the `country` is the `US`

<img src="/images/Pasted image 20261111093346.png" alt="image" width="500">

```python
model_mr = model_registry.get_model(name="cc_fraud", version=1)
model_dir = model_mr.download()
model.load_model(model_dir + "/cc_fraud.json")
fv = model_mr.get_feature_view()
df = fv.get_batch_data(start_time ="YYYYMMDD HH:mm", end_time="YYYYMMDD HH:mm")
predictions = model.predict(df)
```

- Model returns a feature view that has been initialized with the `training_dataset_version` registered with the model

```python
feature_view.init_batch_scoring(
    training_dataset_version=training_dataset_version
)

feature_view.init_serving(training_dataset_version=training_dataset_version)
```

## Batch Predictions for Entities

- Lakehouse tables that store the offline feature data for batch inference are often partitioned by time
- Efficient querying of feature data by time range
- A full table scan is expensive if the table contains a large number of rows
- Execute a SQL query directly on the lakehouse tables

```python
df = feature_view.get_batch_data(latest_features=True)

WITH latest_transactions AS (
    SELECT cc_num, ts, amount, merchant_id
    FROM (
        SELECT 
            cc_num, ts, amount, merchant_id,
            ROW_NUMBER() OVER (PARTITION BY cc_num ORDER BY ts DESC) AS rn
        FROM cc_trans_fg
    ) t
    WHERE rn <= 3
)
SELECT 
    t.cc_num,
    t.ts,
    t.amount,
    t.merchant_id,
    m.avg_daily_spend
FROM latest_transactions t
ASOF LEFT JOIN merchants_fg m
    ON t.merchant_id = m.merchant_id
    AND m.merchants_ts <= t.ts
ORDER BY t.cc_num, t.ts DESC;
```

- The query processes all row
- Add a Z-order secondary index to a column
- Sort ordering to a partitioned table
	- All files will be read qith this query
- Liquid clustering
	- Add secondary index, to help improve query performance for queries based on `cc_num`
- Spine DataFrame

```python
input_df = cc_transactions_fg.filter(Feature('merchant_id')==12)\
            .select(['cc_num', 'merchant_id', 'ts']).read()
output_df = feature_view.get_batch_data(spine=input_df)
predictions = model.predict(output_df)
```

## Scaling Batch Inference with PySpark

- Scale out batch inference with a distributed data processing framework like PySpark or Ray
- Spark executor
	- Download a local copy of the model from the model registry
	- Read a partition of the batch inference data from the feature groups
	- Make predictions with the model and save them to an inference store

<img src="/images/Pasted image 20261111094017.png" alt="image" width="500">

- Read the model in the driver and then broadcast the serialized model to executors
- XGBoost models are not natively fully serializable

```python
model_name = "example_model"  
mr_model= model_registry.get_model(name=model_name, version=1)
fv = mr_model.get_feature_view()
model_dir = mr_model.download_model() # Download into hopsfs-FUSE client path

model_path = f"{model_dir}/{model_name}.json"
broadcasted_model_path = spark.sparkContext.broadcast(model_path)

@pandas_udf(returnType=FloatType())
def pred_udf(features: pd.Series) -> pd.Series:
    xgb_model = xgb.XGBClassifier()
    xgb_model.load_model(broadcasted_model_path.value)
    feature_array = pd.DataFrame(features.tolist()).values
    predictions = xgb_model.predict(feature_array)
    return pd.Series(predictions, dtype=float)

yesterday=datetime.today() - timedelta(days=1)
df = fv.get_batch_data(start_date=yesterday, primary_key=True)
df = df.select("id", pred_udf(struct(col("f1"), col("f2"))).alias("prediction"))

# store inference results in an inference store feature group
fg = fs.get_or_create_feature_group(name="inference_store", version=1,
              description = "Inference store for predictions", 
primary_key=["id"])
fg.insert(df)
```

## Data Modeling for Batch Inference

- Batch inference programs typically only process data from lakehouse tables
- Understand properties of open table formats (OTFs) to the design more efficient data models
- Write amplification
	- Updating a single row could cause an entire Parquet file to be rewritten
- OTFs support accumulating updates in row-oriented files
	- Merges Avro files with Parquet files known as merge on read
- Background compaction job or table service can be scheduled to run to merge the Avro files into the Parquet files and merge any small Parquet files
- Refactor data model to isolate updates to small tables

<img src="/images/Pasted image 20261111094416.png" alt="image" width="500">

- Queries for training data and batch inference data with new feature views will ahve an additional join operation for the new table
## Batch Inference for Neural Networks

- Data is loaded in batched, preprocessed into tensors, and passed through the model in evaluation model to disable dropout
- Download and unpickle model weights, and MDTs, and retrieve hyperparameters

```python
model_mr = model_registry.get_model("mnist", version=1)
artifact_dir = model_mr.download()
state = joblib.load(os.path.join(artifact_dir, "model.pkl"))
transform = joblib.load(os.path.join(artifact_dir, "transform.pkl"))
fv = model_mr.get_feature_view()
layer_sz = model_mr.training_metrics.get("layer_sz")
dropout = model_mr.training_metrics.get("dropout")

model = CustomMnist(layer_sz=layer_sz, dropout=dropout) # from Chapter 10
model.load_state_dict(state)
model.eval() # disable Dropout

df = fv.get_batch_data(start_time="19980301 00:00")  # inference images
dataset = ImageDataset(transform, df) # from Chapter 10
loader = DataLoader(dataset, batch_size=64, shuffle=False)

top1_probs = []
with torch.inference_mode(): # disable gradient computation
    for imgs in loader:
        logit_preds = model(imgs)
        probs = torch.softmax(logit_preds, dim=1)
        top1_probs.extend(probs.max(dim=1).values.tolist())
print(top1_probs)
```


# Batch Inference for LLMs

- Write batch inference programs with Pandas, Polars, or PySpark


- Zero-shot
	- Gives the LLM only the task description with no examples
- Single-shot
	- Gives the LLM on example before the task description
- Few-shot
	- Gives the LLM multiple examples before the task description

- Prompt template
	- Easier to add examples to the context window
- Context window
	- Contains the query sent to the LLM and includes the task description and any examples or additional context information

- LLM batch inference pipeline step
	- Read batch inference data from data sources
	- For each row of batch inference data, use the prompt template to build a query
	- Send queries one at a time to the LLM API
	- Save LLM responses to an inference store for analysis/processing or eagerly execute actions

```python
from tenacity import retry, wait_exponential, stop_after_attempt
from openai import OpenAI

questions_fg = fs.get_feature_group("questions", version=1)
responses_fg = fs.get_feature_group("responses", version=1)
openai_api_key = proj.get_secrets_api().get_secret("OPENAI_API_KEY").value
client = OpenAI(api_key=openai_api_key)

ten_minutes_ago = datetime.now(timezone.utc) - timedelta(minutes=10)
df = questions_fg.filter(questions_fg["ts"] > ten_minutes_ago).read()

model = "gpt-5"
max_tokens = 500
temperature = 0.7

def generate_prompt(question, example):
    return (
        "Answer the question clearly and accurately.\n\n"
        f"Example: \n{example}\n"
        f"Q: {question}\nA:"
    )

@retry(wait=wait_exponential(min=4, max=60), stop=stop_after_attempt(5))
def single_predict(question, example):
    prompt = generate_prompt(question, example)
    response = client.responses.create(
                model=model,
                input=prompt,
                max_output_tokens=max_tokens,
                temperature=temperature,
                reasoning={"effort": "minimal"}
    )
    return response.output_text.strip()

df['response'] = df.apply( \
    lambda row: single_predict(row['question'], row['example']), axis=1)
responses_fg.insert(df[["question", "response"]])
```



- Code sends prediction requests a one at a time to the LLM API endpoint
- Single-short prompt
- Write the answers to a separate feature group
- Annotation
	- Defined using the tenacity library
	- Prevent from exceeding API rate limits and token quotas
		- Max amount of number of tokens permitted within a specified time frame

# Online Inference Pipelines

- Online inference pipeline
	- An operational service
	- Accepts prediction requests and outputs predictions and logs

## Ensure Offline-Online Consistency for Libraries

- Ensure that the libraries used by the ODTs/MDTs in the feature/training/feature pipelines are compatible with one another
- 


<img src="/images/Pasted image 20261111095202.png" alt="image" width="500">


## Model Deployments with FastAPI

<img src="/images/Pasted image 20261111095601.png" alt="image" width="500">

- FastAPI
	- High performance web framework for building HTTP-based servive APIs in Python
	- Pydantic framework

```python
from fastapi import FastAPI
from pydantic import BaseModel
app = FastAPI()

mr = hopsworks.login().get_model_registry()
model_dir = mr.get_model("simple_model", version=1).download()
model = XGBRegressor()
model.load_model(os.path.join(model_dir, "model.json"))

class PredictionRequest(BaseModel):
    features: list[float]

class PredictionResponse(BaseModel):
    prediction: float


@app.post("/predict", response_model=PredictionResponse)
def predict(request: PredictionRequest):
    prediction = model.predict([request.features])[0]
    return PredictionResponse(prediction=float(prediction))
```

- Model is downloaded from the model registry, and loaded as an XGBoost regression model from model.json
- Deployment API and the model signature are identical

## LLM Deployments

- Pretrained model
- Hugging Face
	- Marketplace for pretrained models
	- Use transformers library to download models directly from their websites
	- Download a model and its tokenizer and then register both of them together in Hopworks' model registry

```python
from transformers import AutoTokenizer, AutoModelForCausalLM

tokenizer = AutoTokenizer.from_pretrained("deepseek-ai/DeepSeek-V3")
model = AutoModelForCausalLM.from_pretrained("deepseek-ai/DeepSeek-V3")

deepseek_local_dir = "deepseek_dir"
model.save_pretrained(deepseek_local_dir)
tokenizer.save_pretrained(deepseek_local_dir)

deepseek = mr.llm.create_model(
    name="deepseek-V3",
    description="DeepSeek-V3 671B model (via HF)"
)
deepseek.save(deepseek_local_dir)
```

## Deployment API for Models and Feature Views

- The model deployment API and model signature differ
	- Not all features come via the prediction request
- Feature may be retrieved from the feature store or computed on demand
- Serving keys
	- Used to read precomputed features from the online feature store
- Request parameters
	- Used as either parameters to ODTs or passed feature

<img src="/images/Pasted image 20261111100106.png" alt="image" width="500">

```python
class Predictor():
    def __init__(self):
        mr = hopsworks.login().get_model_registry()
        mr_model = mr.get_model("cc_model", version=1)
        self.model = XGBClassifier()
        self.model.load_model(os.path.join(mr_model.download(), "model.json"))
        self.fv = mr_model.get_feature_view()

    def predict(self, inputs):
        features = self.fv.get_feature_vector(
            serving_keys = {"cc_num": inputs[0]["cc_num"], 
                            "merchant_id": inputs[0]["merchant_id"]}, 
            passed_features = {"amount": inputs[0]["amount"], 
                      "card_present": inputs[0]["card_present"]},
            request_parameters = {"ts": inputs[0]["ts"], 
                                  "ip_addr": inputs[0]["ip_addr"]}
        )
        prediction = self.model.predict(features)
        self.fv.log(features, predictions = prediction)
        return prediction
```


- Predictor script
	- Implements the online inference pipeline
	- Downloads the model and retrieves the feature view

1. Retrieve the precomputed features from the online feature store
2. Merge precomputed and passed feature values
3. Compute ODTs using `request_parameters` and precomputed feature
4. Compute MDTs defined on the feature view
5. Drop any index columns and/or inference helper columns
6. Return the transformed feature vector as a DF or list

- Inference helper columns

```python
deployment = model.deploy(passed_features=["amount","card_present"])

print(deployment.schema)
```

- Create a feature view as a deployment in Hopsworks, without a model
- Predictor script
	- Deployed to model serving infrastructure

-  Information hiding principle
	- API should be more stable than the model signature
	- Model version can change over time without breaking the client
	- Upgrade an XGBoost model or replace a precomputed feature with an on-demand computed feature ithout requiring changes to the client
- Create feature view deployments that are accessible by external clients via a REST or gRPC API

```python
fv_deployment = fv.deploy(passed_features=["amount","card_present"],
        resources={"instances"="1", "cores": 0.5, "memory_mb": 1024*2})
```


- The code to deploy a model or feature view also allocates the container for the deployment

# Model Serving Frameworks with KServe

- FastAPI lacks
	- GPU allocation
	- Elastic scalability
	- Authentication
	- Access control
	- Auditing
- KServe
	- Open source Kubernetes-based model serving platform that supports a variety of backends for different ML frameworks

- A pluggable model-serving backend
	- Lightweight framework
- A/B testing
	- Route requests between two version of a model
- Multimodel serving
	- Multiple models can be deployed in a single container
- Serverless deployments
	- Deployments are autoscaled based on request load, including scaling down to zero and scaling out by creating container instances and load balancing over them
- Metrics, monitoring, and logging
	- Provide observability for model deployments

- Decompose online inference pipelines into two programs
	- Transformer
	- Predictor

<img src="/images/Pasted image 20261111111419.png" alt="image" width="500">

- KServe's supported backends
	- TensorFlow Serving
	- TorchServe
	- ONNX Runtime
	- Python server
	- NVIVIA Triton Inference Server
	- vLLM

```python
path_to_config_file = "deepseek_vllmconfig.yaml"
deepseek_depl = deepseek.deploy(
    name="deepseek-V3",
    config_file=path_to_config_file,
    resources={"num_instances": 1, 
    "requests": {"cores": 24, "memory_mb": 1024*512, "gpus": 8}},
)
```

# Performance and Failure Handling

## Mixed-Mode UDFs

```python
import numpy as np

@hopsworks.udf(float)
def max_param(param1, param2, param3):
    result = np.maximum.reduce([param1, param2, param3])
    return result

# Example usage as a Python UDF 
result_python = max_param.invoke(1.0, 2.0, 3.0)

batch_size = 2500000
data = pd.DataFrame(np.random.rand(batch_size, 3), 
                      columns=['param1', 'param2', 'param3'])

# Example usage as a Pandas UDF on a batch of rows
results_batch = \
    max_param.invoke(data['param1'], data['param2'], data['param3'])
```

- Python interpreter infers the type of parameters
- Transformation logic cannot be written such that is can be executed in mixed mode

```python
def process_rows_array(rows, sort_column_index):
    sorted_rows = sorted(rows, key=lambda x: x[sort_column_index], reverse=True)
    return sorted_rows[:5]

def process_rows_pandas(df, sort_col_name):
    return df.sort_values(sort_col_name, ascending=False).head(5)

rows, cols = 250, 20
col_names, data, sort_col_name, sort_col_index = generate_sample_data(rows, cols)
top5_array = process_rows_array(data, sort_col_index)
df = pd.DataFrame(data, columns=col_names)
top5_pandas = process_rows_pandas(df, sort_col_name)
```

## Native UDFs and Log-and-Wait

- Implement in C, C++, or Rust for the lowest latency UDFs or ODTs
## Handling Feature in Online Inference Pipelines

- Model deployments are operational services that need to be robust to data problems, failing, and request failures
- Online programs contain logic and read data from potentially many different source
- Log action in code to standard output and standard error
- Online inference pipelines can receive data from different sources
	- Request values may be missing
	- Precomputed features may be missing or delayed
	- Precomputed features or RAG data may be missing due to the feature store or vector index being inaccessible
	- ODTs may have missing or invalid parameter values
	- MDTs may have missing or invalid parameter values
	- Third party API calls may time out or return bad data

- Missing values
	- Imput
		- Mean/median/mode from the training dataset
		- Model-based imputation
	- Replace missing values with default values
	- Use cached or historical values
	- Fall back to a simpler model if data is missing

## Model Deployment SLOs

- Model prediction latency can be slow when testing, but high in a deployed model

<img src="/images/Pasted image 20261111112142.png" alt="image" width="500">

- KServe
	- Split InferenceService into transformer and predictor containers
	- Issues parallel primary key lookups to tables for multiple serving keys in a feature view
	- Pushing down `LEFT JOIN` to RonDB when you have a snowflake schema data model
	- Pushing down projections in RonDB to only read features needed
	- Pushing down aggregations to RobDB for request-time aggregations
	- Asynchronous non-blocking logging in a separate thread of control

- RAG
	- Reduce k, the number of responses in similarity search

# Inference with Embedded Models

- Real-time systems are characterized primarily by their requirement that operations complete within a fixed time interval
- Ensure bounded latency
	- Ambedded model
	- Host-local model
- Remove dependencies on unreliable network or distributed services
- Add models to the container
- Download the models from a model registry to local storage

<img src="/images/Pasted image 20261111112536.png" alt="image" width="500">


## Embedded AI-Enabled Applications

- Most high performance and edge applications are not written in Python, but rather in compiled languages such as C/C++, Rust, Go, and Java
- C++ libraries and Java Native Interface (JNI)

## Stream-Processing AI-Enabled Applications

- Stream processing programs can use embedded models to make predictions on streams of incoming data
- Network intrusion detection systems process real-time network traffic logs/events from an event streaming platform to predict whether the current network activity is anomalous or normal


```python
# to enable workers to reuse the cached model persists across tasks, set
# spark.conf.set("spark.python.worker.reuse", "true")

schema = StructType([
    StructField("duration", FloatType(), True),
    StructField("src_bytes", FloatType(), True),
    StructField("dst_bytes", FloatType(), True),
    StructField("flag", StringType(), True)
])

xgb_path = # path to model on S3 or HopsFS
bcast_model_path = spark.sparkContext.broadcast(xgb_path)

_xgb_model = None

# Load the model once per worker, instead of once per partition
def _get_model_once():
    global _xgb_model
    if _xgb_model is None:
        m = xgb.XGBClassifier()
        m.load_model(bcast_model_path.value)
        _xgb_model = m
    return _xgb_model
    
@pandas_udf(DoubleType())
def predict_udf(duration, src_bytes, dst_bytes, flag):
    features_df = pd.DataFrame({
        'duration': duration,
        'src_bytes': src_bytes,
        'dst_bytes': dst_bytes,
        'flag': flag
    })

    model = _get_model_once()
    predictions = model.predict(features_df)
    return pd.Series(predictions, dtype="float64")

raw_stream = spark.readStream.format("kafka") \
    .option("kafka.bootstrap.servers", "IP_ADDRESS_KAFKA_BROKER:9092") \
    .option("subscribe", "network-traffic") \
    .option("startingOffsets", "latest") \
    .load()

json_stream = raw_stream.selectExpr("CAST(value AS STRING) as json") \
    .select(from_json(col("json"), schema).alias("data")) \
    .select("data.*")

predictions_stream = json_stream.withColumn("prediction",
    predict_udf(
        col("duration"), col("src_bytes"), col("dst_bytes"), col("flag")
    )
)

fg_sink = fs.get_feature_group("predictions_fg", version=1)
query = fg_sink.insert_stream(predictions_stream)

query.awaitTermination()
```

## UIs for AI-Enabled Applications in Python

- Heavyweight production approach is to deploy model on model-serving infrastructure and write a UI in JavaScript
- Write a UI in Python, download the model, and perform inference locally in the Python program
	- Gradio
	- Streamlit
	- Taipy

```python
import streamlit as st

@st.cache_data()
def download_model():
    …
@st.cache_resource()
def read_batch_inference_data():
     …

if submit_button:
    df["prediction"] = model.predict(df)
    st.dataframe(df)
```

- Decorators are used to cache function outputs so that they do not get recomputed on every rerun