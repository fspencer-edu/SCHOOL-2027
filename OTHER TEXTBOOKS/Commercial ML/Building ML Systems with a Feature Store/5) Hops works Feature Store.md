
- Hopsworks is a platform for the development and operation of batch, real-time, and LLM AI systems at scale
- Includes a feature store a complete MLOps and compute platforms

# Hopworks Projects

- A Hopsworks cluster is organized into projects, where each project has a unique name
- Secure spaces for teams to collaborate and manage data and models for AI
- Each project has
	- Feature store
	- Model registry
	- Model deployments
	- Datasets for general purpose file storage

- `hopsworks.login()`
	- API key
	- Hostname (IP) and port to cluster

## Storing Files in a Project

- Every project in Hopsworks has directories where you can store data
- From UI or datasets API, you can upload and download files

<img src="/images/Pasted image 20261109192749.png" alt="image" width="500">

## Access Control Within Projects

- Projects support role-based access control (RBAC) inside the project
- Each active project member has one of two possible roles
	- Data owner role
		- Administrator privileges
	- Data scientist role
		- Real only role for the feature store
		- Create training data and train models

<img src="/images/Pasted image 20261109192911.png" alt="image" width="500">

## Access Control at the Custer Level Using Projects

- Use projects to implement access control by placing users and data in different projects and selectively sharing access to data across project boundaries

<img src="/images/Pasted image 20261109193002.png" alt="image" width="500">

- Each project is the tenant in the Hopsworks cluster
- Hopsworks supports project-level multi-tenancy
- Hopsworks supports secure sharing of data with other projects
- Refactor projects into smaller projects that share feature groups with one another, but have tighter access control on the data

<img src="/images/Pasted image 20261109193239.png" alt="image" width="500">

- This type of data organization is known as a data mesh
	- Data ownership is distributed across different business domains
- Given read-only access to production data to development projects

# Feature Groups

- A feature group in Hopsworks is a table of features

<img src="/images/Pasted image 20261109193422.png" alt="image" width="500">


- Hopsworks' online store is RonDB, an open source, distributed, highly available, real-time database, developed by Hopsworks and forked from the open source MySQL NDB (network database) Cluster
- Offline store is a lakehouse table stored in S# compatible object store or Hopsworks' native distributed filesystem (HopsFS)
- Create an external feature group where the offline store is an external data warehouse
- Store vector embeddings in a vector index for a feature group
- Clients read data from feature groups using feature vies

```python
from hopsworks.hsfs import embedding
fs = hopsworks.login().get_feature_store()
df = # Read data into (Pandas/Polars/PySpark) DataFrame

# Use the default Embedding Index 
emb = embedding.EmbeddingIndex()
# Define the column that contains vector embeddings
emb.add_embedding(df['col_with_embedding']) 

expectation_suite = … # Define Data Validation Rules for ingestion

fg_cc_aggs = fs.create_feature_group(
    name="cc_trans_aggs_fg",
    version=1,
    description="Aggregated credit card transaction features",
    primary_key=['cc_num'],
    partition_key=['date'],
    event_time='datetime',
    online_enabled=True,
    time_travel_format='DELTA',
    embedding_index=emb,
    expectation_suite=expectation_suite,
)
fg_cc_aggs.insert(df)
```

- Feature group must have
	- a name
	- a version
	- a primary key
	- optional description
- Offline is set by default
- Format
	- HUDI
	- DELTA
	- ICEBERG

- Index columns
	- A mandatory primary key
	- An optional event time defined
	- An optional partition key defined
	- Optional foreign keys defined

- Hopsworks also supports data layout optimization for the offline tables, which can help speed up your queries
- Partition key determines the subdirectory to which the data files are written in the offline store
- Hive-style partitioning
	- A directory naming convention that organizes data files into nested subfolder using explicit key-value pairs
	- Works well with low cardinality
	- Using the `date` column
- Data skipping
	- When a query can skip reading many of the files

## Versioning

- Supports creating muliple versions of features groups
- Each version contains its own offline/online tables and vector indexes
- Supports data versioning with a given version of a feature group

### Data versioning in feature groups and time travel

- Hopsworks tracks mutation to feature groups as commits
- Each group of changes to the row in a feature group is called a commit
- Commit contains a set of updates to rows in the feature group
- Feature groups support time-travel and incremental queries
	- Time travel queries read data in the feature group `ASOF` a provided time-stamp or commit ID
	- Incremental queries read the data changed in commits to a feature group during a specified time range
- Provide the ingestion time as a parameter to the `as_of()` method to read the state

<img src="/images/Pasted image 20261109194453.png" alt="image" width="500">

- Ingestion time refers to the physical time at which commit was ingested into Hopsworks
- Ingestion time can be confusing because your feature group may also have an `event_time` column indicating the value of a feature as a point in time


<img src="/images/Pasted image 20261109194551.png" alt="image" width="500">


### Versioning feature groups

- Data versioning is only concerned with changes to the rows in feature groups
- The solution to breaking schema is to create a new version of the feature group with new feature(s)

<img src="/images/Pasted image 20261109194819.png" alt="image" width="500">


- When you create a new feature group version, new offline/online tables will be creates
- Backfill new tables from the old feature group version
- Avoid creating a new version of a feature group

<img src="/images/Pasted image 20261109195051.png" alt="image" width="500">


- Creating feature views is a metadata only operation
- Create a new feature view that uses all the feature from the feature view of the previous model, replacing the old feature with the new one

## Online Store

- By default, a table is not created in the online store
- A table is always created in the offline store

```python
fg.insert(df, 
    write_options={"start_offline_materialization":False}
)
```

- Hopsworks store online feature in memory or on disk

### Time to live (TTL)

- Online table only stores the latest feature values for each entity
- Write new feature data for an entity, the row containing the feature data for that entity is overwritten
- Rows are removed from the database when they exceed the specified TTL defined on the feature group
- Primary key constraint for the entity ID is dropped
- Lookback windows to queries
	- Feature value will be null if the following holds

```python
label.event_time - feature.event_time > TTL
```

### Vector index

- Vector embeddings enable approximate nearest neighbour (ANN) search for rows in online feature groups
- High dimensional data and pass it to an embedding model that then compresses the input data into a fixed-size array of floating point numbers
	- Retains semantic information about the original input data
	- Compute the vector embeddings using an embedding model
		- Sentence transformer
- Writing rows to a vector indexes is slow than writing to the online feature store

```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')

df = cc_fraud.read()
embedding_body = model.encode(df['explanation'])

df['embed_explanation'] = pd.Series(embedding_body.tolist())
emb = embedding.EmbeddingIndex()
emb.add_embedding('explanation', model.get_sentence_embedding_dimension())

cc_fraud_fg = fs.create_feature_group(
    name="cc_fraud_fg",
    version=1,
    description="Credit Card Fraud Data",
    primary_key=['tid'],
    event_time='datetime',
    embedding=emb
)
cc_fraud_fg.insert(df)

model = SentenceTransformer('all-MiniLM-L6-v2')
search_query = "Geographic attack in South Carolina"
cc_fraud_fg.find_neighbors(model.encode(search_query), k=3)
```


## Offline Store (Lakehouse Tables)

- Hopsworks supports 3 different types of lakehouse table
	- Apache Iceberg
	- Apache Hudi
	- Delta Lake

- Primary key uniqueness
- Data skipping
- Read changes

### External feature groups

- Create an external feature group from existing tables with feature data
- Offline table is the external data store or data warehouse

```python
data_source = fs.get_data_source("my_snowflake")
external_fg = fs.create_external_feature_group(
            name="sales",
            version=1,
            description="Physical shop sales features",
            primary_key=['account_id'],
            event_time='event_time',
            data_source=data_source
            ).save()
```

### Data statistics

- When you write data to the offline feature group, by default, Hopsworks computes and saves descriptive statistics for features
- Statistics are used for both EDA and monitoring for feature drift
- Hopsworks can compute histograms for categorical variables
- Correlation matrix
- Descriptive statistics for numerical features
- Sparsity of a feature through uniqueness

```python
fg_cc = feature_store.create_feature_group(name="cc_trans_fg",
    statistics_config={
        "enabled": True,
        "histograms": True,
        "correlations": True,
        "exact_uniqueness": False,
        "columns": ["feature1"]
    }
)
fg_cc.compute_statistics()
```

## Change Data Capture for Feature Groups

- Useful to build event-driven ML systems by executing actions when rows in a feature group have changed
- Change data capture (CDC) API
	- Make predictions for entities after changes in their feature values
- Feature groups are published to the Kafka topic, and consumers of the changes can subscribe to the Kafka topic to consume the rows that were updated

```python
kafka_api = project.get_kafka_api()
my_schema = kafka_api.create_schema(SCHEMA_NAME, schema)
my_topic = kafka_api.create_topic(
    TOPIC_NAME, SCHEMA_NAME, 1, replicas=3, partitions=8
)

fg_cc_ags = feature_store.create_feature_group(name="cc_trans_fg",
    notification_topic_name=TOPIC_NAME,
)
```

# Feature Views

- Feature view bridge the gap between feature groups and models by defining the model's interface as a list of input features and output labels/targets
	- Selecting the features and labels/targets that will be used by your model
	- Defining any MDTs you want to perform on your features
	- Creating the feature view from your feature selection and MDTs

- Main use cases for feature views
	- Creating training data for your model
	- Creating batch inference data for your model
	- Creating online inference data for your model

## Feature Selection

- Each feature view has at most one label feature group containing the labels
- Create a feature view without labels, for unsupervised learning
- Label feature group is the root feature group in a feature selection statement
	- `select_features()`
	- `select_all()`
	- `select_except(['f1', 'f2', ...])`
	- `select(['f1', 'f2'])`

- `select` methods return a `Query` object that represents the selection of feature

```python
aggs_subtree = aggs.select_features()
.join(bank.select_features())
.join(account.select_features())

selection = labels.select_features()
.join(merchant.select_features())
.join(aggs_subtree)
```

- Hopsworks looks for the columns in the left hand feature group with the same name and type as the primary key in the right hand feature group

```python
aggs.select_features().join(bank.select_features(),
left_on=["account_id"], right_on=["id"])
```

- If no match, explicitly define the join key
- If there is a clash between feature names, join with a prefix

## Model Dependent Transformations

- Declaratively attach a transformation function to any of the selected features in your feature view
- Transformation functions are executed in the client after data has been read form the feature store with a feature view

```python
from hopsworks.transformation_statistics import TransformationStatistics

@hopsworks.udf(float)
def f1(amount, days_until_expired, stats: TransformationStatistics):
    return (amount * days_until_expired) / stats.amount.mean
```

- Transformation functions can be defined either as Python user-defined functions (UDFs) or Pandas UDFs
- Pandas UDFs scale to process large data volumes, but add a small amount of latency in online inference pipelines
- Python UDFs scale poorly when data volumes increase, but have lower latency in online inference pipelines

## Creating Feature Views

```python
feature_view = fs.create_feature_view(
    name='cc_fraud',
    query=selection,
    labels=["is_fraud"],
    transformation_functions = [ min_max_scaler("amount") ],
    inference_helper_columns=['cc_expiry_date','prev_loc_transaction', 
'prev_ts_transaction']
)
```

- Create a feature view of one model or a family or related models
- Filter or filters are stored as metadata in the training dataset object
- A feature view does not have a primary key, instead it uses serving keys
	- Foreign keys in the label feature group for the feature view

```python
print(feature_view.serving_keys)
```

- Helper columns can be used an inputs to transformation functions, but they will not themselves be features
	- Use them to compute on-demand features

## Training Data as Either DataFrames or Files

- Read training data as Pandas DataFrame or create training data as files

<img src="/images/Pasted image 20261109213226.png" alt="image" width="500">

### Random, time-series, and stratified splits

- Read training data, split using a random split into training and test sets of features and labels

```python
X_train, X_test, y_train, y_test = fv.train_test_split(test_size=0.2)

X_train, X_test, y_train, y_test = fv.train_test_split(test_size=0.2)
```

- The train and validation split functions can also return a time-series split of the training data
- Never create a random split of time-series data
	- Specify a time range

```python
X_train, X_test, y_train, y_test = \
    fv.train_test_split(start_train_time="20240101", end_train_time="20240131",\
        start_test_time="20240201", end_test_time="20240207")
```

- Train a binary classifier
	- Imbalance ratio
	- Stratified split

```python
training_data = fv.training_data()
# apply custom splits into training and test/validation sets
```

- For binary classifiers, upsample or downsample one of the classes to improve balance between the classes

### Reproducible Training Data

- Hopsworks stores metadata about the training data created
	- Feature view
	- Filters
	- Training dataset ID
	- Random number see
	- Commit IDs

```python
X_train, X_test, y_train, y_test = fv.get_train_test_split(training_data_id=111)
```

## Batch Inference Data

- Read batches of inference data from the offline store with a feature view
- Read all new data that has arrived since the last batch ran

```python
last_run_timestamp = "2024-05-10 00:01"
fv = fs.get_feature_view(...)
fv.init_batch_scoring(training_data_version=1)
df = fv.get_batch_data(start_time=last_run_timestamp)
df["prediction"] = model.predict(df)
fv.log(df)
```

- Skip retrieving a pre-initialized feature view object from the model registry along with the model
- Read from the feature store a Pandas DataFrame, containing the transformed input feature data that arrived after the last timestamp
- Make predictions with the model
- Spine Group
	- Contains rows of serving keys for reading features for feature view
	- Timestamp value for every serving key
	- Only used in batch inference

```python
trans_spine = fs.get_or_create_spine_group(
    name="cc_trans_spine_fg",
    …
    dataframe=trans_df
)
```

- Include a DF to provide the schema for the feature group
- A Spine Group does not materialize any data to the feature store itself
	- Similar to a temporary feature group, that is replaced by a DataFrame when data is read from it

```python
df = # (serving keys, timestamp for label values)
X_train, X_test, y_train, y_test = 
feature_view.train_test_split(0.2, spine=df)

input_df = # (serving keys, timestamp for feature values)
output_df = feature_view.get_batch_data(spine=input_df)
predictions = model.predict(output_df)
```

## Online Inference Data

- Feature views are also used to retrieve rows of features from the onlien store at low latency


```python
feature_vector = feature_view.get_feature_vector(entry={"cc_num":
"1234", "merchant_id": 4321}, return_type = "pandas")

@hopsworks.udf(int, mode="python", drop=["expiry_date"])
def days_to_card_expiry(expiry_date):
    return (datetime.today().date() - expiry_date.date()).days
    
feature_vector = feature_view.get_feature_vector(\
    entry={"cc_num": "1234", "merchant_id": 4321}, return_type = "pandas")

cc_expiry = days_to_card_expiry(feature_vector["expiry_date"])
feature_vector = feature_vector.drop(columns=["expiry_date"])
prediction = model.predict(feature_vector)
```
# Faster Queries for Feature Data


- Applying filters can lead to huge performance improvements when reading a subset of feature data
- Projection pushdown
	- Read only the columns requested
- Pushdown filters
	- Read only the data for the filter value(s) you provide
	- Partition pruning and predicate pushdown
```python
X_features, y_labels = fv.training_data(extra_filter=fg.date=="2024-01-10")

df = fg.filter(fg.date > "2024-01-10").read()
```

- Chain filters that can all potentially be pushed down to the backing feature groups

```python
df = fv.training_data( extra_filter =
    ( Feature("date")=="2024-01-10" and Feature("country") == "Ireland")
)
```

- Partition pruning follows the order of the partition keys
	- Only prune based on the first key, not the second

- Pushdown predicate
	- Requires indexes on the underlying tables
	- Supports user-defined indexes on columns
	- B-tree-like indexes, optimized for in-memory layouts
- Apache Hudi tables
	- Z-ordered indexes
- Delta Lake
	- Liquid clustering indexes

- A well designed feature pipeline will ensure that Parquet file sizes are uniform and of reasonable size