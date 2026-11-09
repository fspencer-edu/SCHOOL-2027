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
	- 


# Data Models for Feature Groups
# Feature Store Data Model for Inference
# Reading Feature Data with a Feature View


