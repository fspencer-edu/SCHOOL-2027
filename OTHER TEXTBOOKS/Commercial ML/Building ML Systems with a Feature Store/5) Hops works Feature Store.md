
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
- Statistics are used for both EDA


# Feature Views



# Faster Queries for Feature Data


