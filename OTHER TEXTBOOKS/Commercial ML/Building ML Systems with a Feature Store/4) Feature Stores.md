- Data management is the most challenging aspect of building and operating AI systems
- Feature stores
	- What is a feature group
	- How to design a data model for feature groups
	- How to read feature data spread over many feature groups for training or inference

- Data store types
	- Columnar store
	- A row-oriented store
	- Vector index

# A Feature Store for Fraud Predication


<img src="/images/Pasted image 20261109131148.png" alt="image" width="500">


- Build a feature store
	- Identify entities and features for those entities
	- Organize entities into tables of features and identify relationships between feature groups
	- Select the features for a model, from potentially different feature groups, in a feature view
	- Retrieve data for model training and batch/online inference with the feature view

# Brief History of Feature Stores

- Uber's Michelangelo feature store
	- Feature store
	- A model registry
	- Model serving capabilities
	- Domain specific language (DSL)
- Feature platform
	- Describe feature stores that support managed feature pipelines
- AI lakehouse
	- A feature store that uses lakehouse tables as its offline store and has an integrated online store for building real-time ML systems

# The Anatomy of a Feature Store

- Feature store
	- A factory that produces and stores feature data
	- Faster production of higher quality features by managing the storage and transformation of data for training and inference
	- Reuse features in any model

<img src="/images/Pasted image 20261109131600.png" alt="image" width="500">

- Feature pipelines
	- Feed a feature store with feature data
	- Take new or historical data as input and transform it into reusable feature data
	- Model independent transformations (MITs)
	- Batch or streaming programs
	- Stores mutable feature data
- Feature stores enable versioned training datasets by taking a point-in-time consistent snapshot of feature data
	- Applying model-dependent transformations (MDTs) to the features
- A feature store also provide low-latency feature data to online applications or services
- Model deployments receive prediction requests, and parameters from the prediction request can be used to compute on-demand features and retrieve precomputed rows of feature data from the feature store

- MITs (model independent transformations)
	- Applied only in feature pipelines on new or historical data to produce reusable feature data
- ODTs (on-demand transformation)
	- Special class of MIT that is applied in both feature pipelines and online inference pipelines
- MDTs (model dependent transformations)
	- Applied in training pipelines, batch inference pipelines, and online inference pipelines

- Feature stores support MITs, MDTs, and ODTs in pipeline by enforcing the constraint that MDTs always come after model independent transformation
	- Last transformations in a directed acyclic graph (DAG)
- ODTs come after MITs

# When Do You Need a Feature Store?

## For Context and History in Real-Time ML Systems

- Real-time prediction, but the prediction request has low information content
- Enrich the prediction request at runtime with history and context information
## For Time-Series Data

- Retail, telecommunications, and financial ML systems are build on time-series data
- Time series data is a sequence of data point for successive point in time

<img src="/images/Pasted image 20261109132638.png" alt="image" width="500">


- Query data with temporal joins
- Data leakage
	- Lead data from your test set or any external dataset into your training dataset
- Future data leakage
	- Build training datasets from time-series data and incorrectly introduce one or more feature data point from the future
- Stale features
	- A feature value that is older than the actual feature value at the tine of an observation

## For Improved Collaboration with the FTI Pipeline Architecture

<img src="/images/Pasted image 20261109132939.png" alt="image" width="500">

- Conway's Law
	- An organization's software architecture will mirror its internal communication structure
	- Shared platform for collaboration when building and operating AI systems
	- Decompose an AI system into modular pipelines that use the feature store
		- Acting as the shared data layer connecting the pipeline
- Data scientists and data engineers
	- Collaborate to build and operate feature pipeline
- Data scientists
	- Train and evaluation the models
-  Data scientists and operations engineers
	- Write inference pipelines and integrate models with external systems

## For Governance of ML Systems

- Feature stores help ensure that an organization's governance processes keep feature data secure and accountable throughout its lifecycle
- Auditing actions and tracking lineage from source data to features to models
- Feature store management
	- Regulatory requirements
		- European Union's AI Act
	- Lineage for compliance
	- Access control

## For Discovery and Reuse of AI Assets

- Computed features are stored in the feature store and published to a feature registry
- Enabling users to easily discovery and understand features
- The feature registry is a component in a feature store that has an API and UI to brows and search for available features, feature definitions, statistics on feature data, and metadata describing features

## For Elimination of Offline-Online Feature Skew

- Feature skew occurs when significant differences exist between the data transformation code in either an ODT or an MDT in an offline pipeline
- Silently degraded model performance
- Model not generalizing well to new data during inference
- Feature stores support the definition and management of ODTs and MDTs, and they ensure that the same function is applied in the offline and inference pipelines

## For Centralizing Your Data for AI in a Single Platform

- Offline store and an online store
	- Vector index to store vector embeddings and support similarity search

- Row-oriented data store
	- Low latency
	- High throughput CRUD operations
	- Support for primary key to retrieve feature for specific engines
	- Support for time to live (TTL) for tables or expire stale feature data
	- High availability through replication and data integrity through ACID translations
	- Support for secondary indexes to support more complex queries
- Column-oriented data stores
	- Central data platforms that store historical data for analytics
	- Provide low-cost storage for large volumes of data at the cost of high latency for row-based retrieval of data
	- Enable faster complex queries than do-oriented store through efficient data pruning and data movement

- Lakehouse
	- Combination of data lake for storage and a data warehouse for querying the data
	- Open platform that separates the storage of columnar data from the query engines that use it
	- Open table formats (OTFs) for data storage
		- Apache Iceberg
		- Delta Lake
		- Apache Hudi
			- Parquet files and metadata that enables ACID updates
			- Commit for every batch operation
			- Commit history and time-travel support
- Vector embeddings in a vector index
	- Nearest neighbour (ANN) search for feature data
	- Separate standalone vector database
		- Weaviate
		- Pinecone
	- Row-oriented database
		- Postgres PGVector
		- OpenSearch
		- MongoDB

# Feature Groups

- Features stores use feature groups to hide the complexity of writing and reading data to/from the different offline and online data stores
- Feature groups
	- Tables in which the features are columns and the feature data is stored in offline and online stores
	- Also called feature sets or feature tables
- Feature group
	- Schema
	- Metadata
	- A table in an offline store
	- An optional table in an online store
	- Optional vector index

```python
name
version
entity_enabled
online_enabled
event_time
# tags to help with discovery and governance

foreign_key
partition_key
vector embedding
feature definitions
```

<img src="/images/Pasted image 20261109155935.png" alt="image" width="500">

- First 4 columns are index columns
- Features can also be labels
- Perform inserts, updates, and deletes on feature groups
	- Batch API
	- Streaming API
- Feature store defines the set of supported data types for features
- Natural key
	- Email address
	- SIN
- Surogate key
	- Sequential number

## Feature Groups Store Untransformed Feature Data

- Feature pipelines write untransformed feature data to feature groups
- Un transformed feature date become transformed feature data after MDTs are applied in training and inference pipelines
- Feature groups should not store transformed feature values
	- Feature data is not reusable across models
	- It can introduce write amplification
	- Exploratory data analysis works bets with unencoded feature data


## Feature Definitions and Feature Groups

- Feature definition
	- Source code that defines the data transformations used to create one or more features in a feature group
	- Source code for MITs and ODTs

## Writing to Feature Groups

- Feature stores provide an API to ingest feature data
- Offline store is normally a lakehouse table
	- Provides change data capture (CDC) APIs
	- Read the data changes for the latest commit
	- Periodically or continually reads new commits and copies to the online store and/or vector index

<img src="/images/Pasted image 20261109160612.png" alt="image" width="500">

- A batch API and a stream API
- Clients can use the batch API to write to only the offline store
- If a feature group is online, clients can write to the stream API
- Feature data is available at lower latency in the online store via the stream API
	- Stream API enables fresher features

<img src="/images/Pasted image 20261109160703.png" alt="image" width="500">

### Feature Freshness

- Freshness
	- Defined as the total time taken from when an event is first read by a feature pipelines to when the computed feature becomes available for use in an inference pipeline
	- Time taken for feature data to land in the online feature store and read from the online store

<img src="/images/Pasted image 20261109160932.png" alt="image" width="500">

### Data Validation

- Data validation
	- Specify constraints for valid feature data values
	- Data validation helps avoid problems with data quality in feature groups

# Data Models for Feature Groups

- Data modeling for feature stores is the process of deciding
	- What features to create for which entities and what feature to include in feature groups
	- What relationships between the feature group look like
	- What the freshness requirements for feature data is
	- What type of queries will be performed on the feature groups
- Data model
	- How to decompose data into different feature groups
		- Ensuring the integrity of the data
		- Improving the performance of writing the data
		- Improving the performance of read (querying) the data
		- Improving the scalability of the system as data volumes and/or throughput increases

- An entity maps to a feature group and relationships map to foreign keys in a feature group
- Normalization
	- Reduce data redundancy and improve data integrity
	- Eliminate redundant data
	- Lower data storage cost
	- Higher query complexity
- Denormalization
	- Improve query performance by increasing data redundancy and endangering data integrity
	- Include redundant data
	- Higher data store cost
	- Lower query complexity

- Denormalized data models are more prevalent
	- Efficiently compress redundant data
		- Run-length encoding
- Row-oriented data stores cannot compress, and favour normalized data model

- AI systems
	- Batch ML systems
		- Feature groups only need to store data in their offline store
		- Columnar stores
		- Star schema
		- Snowflake schema
	- Real-time ML systems (LLM/agent)
		- Groups groups with tables in both offline and online store
- Star and snowflake schema
	- Data models that organize data into a fact table that connects to dimension tables
- Star schema
	- Columns in the dimenion tables can be redundant
- Snowflake schema
	- Extends the star schema to enable dimension tables to be connected to other dimension tables
	- Normalized data with no redundant data
- Data vault model
	- Handle data ingestion, where data can arrive late and schema changes happen frequently
- One big table (OBT) data model
	- Simplifies data modeling by storing as much data as possible in a single wide table

## Dimension Modeling with a Credit Card Data Mart

- Dimension modeling
	- Categorizes data as facts and dimensions
- Facts
	- Measure quantities, but can also be qualitative
- Dimensions
	- Attribute of facts
- Slowly changing dimensions (SCD)
	- Some dimensions change in value over time
- Data mart
	- Subset of a data warehouse or lakehouse that contains data focused on specific business line, team, or product

<img src="/images/Pasted image 20261109162133.png" alt="image" width="500">

- Fact table
	- Store `credit_card_transactions`
- Dimension tables
	- `card_details`
	- `account_details`
	- `bank_details`
	- `merchant_details`

- Credit card transactions table is populated using the event sourcing patterns

### Labels are facts, and features are dimensions

- Facts are the labels
	- Immutable events that have a timestamp associated with them
- Features are dimensions for the labels
	- Mutable data
	- SCDs (Slowly Changing Dimensions), but in real time ML systems, they might be fast-changing dimensions
	- Save all values for features at all points in time

### Feature stores and SCD types

- 5 well known ways to implement SCDs
	- Each new feature value replaces the old feature value
	- There are a limited number of query patterns for reading feature data
	- Feature stores do not need to support all 5 SCDs types

<img src="/images/Pasted image 20261109162707.png" alt="image" width="500">

- Feature stores hide the complexity of designing a data model that implements these 3 SCD types by implementing the data models in their read/write APIs
- AWS SageMaker
	- Specify `event_time` when defining a feature group

```python
feature_group.create(
    description = "Some info about the feature group",
    feature_group_name = "feature_group_name",
    event_time_feature_name = event_time_feature_name,
    enable_online_store = True,
    ...
    tags = ["tag1","tag2"]
)
```

- Feature data in a key-value store
	- ElastiCache
	- DynamoDB
- Historical feature data in a columnar store
	- Apache Iceberg

## Real-Time Credit Card Fraud Detection ML System

- Service-level objects (SLO) of ml latency or lower
- Receives a prediction request with the credit card transaction details, retrieves precomputed features from the feature store, compute ODT, merges the precomputed and real-time features in a single feature vector, applies any MDTs, makes the prediction, logs the prediction and the features, and returns the prediction to the client

- Write a streaming feature pipeline to create feature directly from the events from Kafka
- Windowed aggregations
	- Compute an aggregation over events that happen in a window of time
- Create real time features from the input request data with ODTs
	- Geographic fraud attacks

### Data model for our real-time fraud detection ML system


<img src="/images/Pasted image 20261109163430.png" alt="image" width="500">

- Feature groups will need to be stored in both online and offline stores

### Star Schema Data Model

- The feature group that contains the labels for the credit card transaction is known as the label feature group
- A label feature group is a normal feature group

<img src="/images/Pasted image 20261109163536.png" alt="image" width="500">

- Feast feature store
- Spine DataFrame contains the same data as the label feature, but is not persisted to the feature store
- These feature groups are all updated independently in separate feature pipelines

### Snowflake schema data model

- Snowflake schema
	- Data model that, like the star schema, consists of tables containing labels and features
	- Feature data is normalized
	- Suitable as a data model for both online and offline tables
	- Feature is split until it is normalized

<img src="/images/Pasted image 20261109163909.png" alt="image" width="500">

# Feature Store Data Model for Inference

## Online Inference

- For online inference
	- Prediction request includes as parameters entity IDs, any passed feature values, and any parameters needed to compute on-demand features
	- Feature stores provide either language-level APIs or REST API to retrieve the precomputed features

<img src="/images/Pasted image 20261109164220.png" alt="image" width="500">

## Batch Inference

- Read all feature data that has arrived in a given time frame
- Read all the latest feature data for a batch of entities (such as all active users)
- Allow batch inference clients to provide a Spine DataFrame containing the foreign key and timestamp for features

# Reading Feature Data with a Feature View

- Feature stores do not provide full SQL query support
- Provide language level API and/or REST API for retrieving training data, batch inference data, and online inference data
- Feature stores provide an abstraction that hides the complexity of retrieving/computing features for training and inference for a specific model called a feature view
	- Selection of features, and labels to be used by one or more models for training and inference
		- Retrieve point-in-time correct training data
		- Retrieve point-in-time correct batch inference data
		- Retrieve precomputed features using foreign keys (entity IDs)
		- Apply MDTs to feature when reading feature data for training and inference
		- Apply ODTs in online inference pipelines

- Feature view prevents skew between training and inference by ensuring that the same ordered sequence of features is returned when reading training and inference data
- Feature views also apply ODTs in online inference pipelines and ensure that they are consistent with the feature pipeline

- Other names for feature store
	- FeatureLookup (Databricks)
	- FeatureService (Feast, Tecton)
- A feature view can either be deployed as a network service or embedded inside a model deployment
- Extended to support client-side transformations

## Point-in-Time Correct Training Data with Feature Vies

- Every feature value joined to a label must be the one that was available at the label's event time
- Without including feature data or stale values
	- Temporal join
		- Starts from the table containing labels, then joins in features from other tables based on matching entity IDs, and event time alignment
			- `ASOF LEFT JOIN`
				- Ensures that there is no future data leakage for the joined feature values
			- `LEFT JOIN`
				- Ensures that label rows are preserved even when no matching feature row exists

<img src="/images/Pasted image 20261109165155.png" alt="image" width="500">

```python
SELECT
    label.amount,
    aggs.last_week,
    bank.country,
    bank.credit_rating AS b_rating,
    merchant.chrgbk,
    label.fraud
FROM cc_trans_fg AS label
ASOF LEFT JOIN cc_trans_aggs_fg AS aggs
    ON label.cc_num = aggs.cc_num
    AND aggs.event_ts <= label.event_ts
ASOF LEFT JOIN bank_fg AS bank
    ON aggs.bank_id = bank.bank_id
    AND bank.event_ts <= label.event_ts
ASOF LEFT JOIN merchant_fg AS merchant
    ON label.merc_id = merchant.merc_id
    AND merchant.event_ts <= label.event_ts
WHERE label.event_ts > '2022-01-01 00:00';
```

## Online Inference with a Feature View

- In online inference, the feature view provides APIs for retrieving precomputed features, similarity search ith vector indexes, and computing ODTs and MDTs
- 