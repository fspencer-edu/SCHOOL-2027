# The Genesis of Spark

## Big Data and Distributed Computing at Google

- Google File System (GFS)
	- Fault tolerant
	- Distributed filesystem
- MapReduce (MR)
	- Parallel programming paradigm, based on functional programming
- Bigtable
	- Scalable storage of structured data across GFS

- MapReduce System
	- Workers in the cluster aggregate the intermediate computations and produce a final appended output from the reduce function
	- Reduces network traffic and keeps most of the input.output (IO) local to disk rather than distributing it over the network

## Hadoop at Yahoo!

- Hadoop File System (HDFS)
	- Apache Software Foundation (AFS)
- Apache Hadoop related modules
	- Hadoop Common
	- MapReduce
	- HDFS
	- Apache Hadoop YARN

<img src="/images/Pasted image 20261008205313.png" alt="image" width="500">

- Apache Hive, Storm, Impala, Giraph, Drill, Mahout

## Spark's Early Years at AMPLab

- Spark
	- In memory storage for intermediate results
	- Composable APIs in multiple languages as a programming model
	- Support workloads in a unified manner
- Databricks and the community worked to release Apache Spark 1.0
# What Is Apache Spark?

- Apache Spark is a unified engine designed for large scale distributed data processing, on premises in data centers or in the cloud
- In memory storage for intermediate computations
- Faster than Hadoop MapReduce
- Composable APIs for ML (MLlib)
- SQL for interactive queries (Spark SQL)
- Stream processing (Structured Streaming)
- Graph processing (GraphX)

- 4 key characteristics
	- Speed
	- Each of use
	- Modularity
	- Extensibility

## Speed

- Builds it query computations as a directed acycle graph (DAG)
- DAG scheduler and query optimizer construct an efficient computational graph that can usually be decomposed into tasks that are executed in parallel across workers on clusters
- Uses whole stage code generation to generate compact code for execution
## Each of Use

- Provides a fundamental abstraction of a simple logical data structure called a Resilient Distributed Dataset (RDD)
- Which all other higher level structured data abstractions are constructed
	- DataFrames
	- Datasets
## Modularity

- Supported programming languages
	- Scala
	- Java
	- Python
	- SQL
	- R
- Unified libraries that include the following modules as core components
	- Spark SQL
	- Spark Structured Streaming
	- Spark MLlib
	- Graph X
## Extensibility

- Hadoop
	- Includes both storage and compute
- Spark
	- Read data stored in other sources and process it all in memory

<img src="/images/Pasted image 20261008210246.png" alt="image" width="500">

# Unified Analytics

- Association for Computing Machinery (ACM)
- Spark replaces all the separate batch processing, graph, stream, and query engines like Storm, Impala, Dremel, Pregel with a unified stack of components that addresses diverse workloads under a single distributed fast engine

## Apache Spark Components as a Unified Stack

- 4 components as libraries for diverse workloads
	- Spark SQL
	- Spark MLlib
	- Spark Structured Streaming
	- GraphX

<img src="/images/Pasted image 20261008210506.png" alt="image" width="500">

### Spark SQL

- Works well with structured data
- Read data stored in a RDBMs table from file formats (CSV, text, JSON, Avro, ORC, Parquet)
- Construct permanent or temporary tables in Spark
- Combine SQL-like queries to query the data in the Spark DataFrame
### Spark MLlib

- Library containing common ML algorithms
- `spark.mllib`
	- RDD based API
- `spark.ml`
	- DataFrame based API
- Extract or transform features, build pipelines, and persist models during deployment
- Linear algebra operations and statistics
- Low level ML primitives
	- Gradient descent optimization
### Spark Structured Streaming

- New model views a stream as a continually growing table, with new rows of data appended at the end
### GraphX

- A library for manipulating graphs and performing graph-parallel computations
- Standard graph algorithms
	- Analysis
	- Connections
	- Traversal
	- PageRank
	- Connected Components
	- Triangle Counting
## Apache Spark's Distributed Execution

- Spark application consists of a driver program that is responsible for orchestrating parallel operations on the Spark cluster
- Driver accesses the distributed components in the cluster
- `SparkSession`
	- Spark executors and cluster manager

<img src="/images/Pasted image 20261008211239.png" alt="image" width="500">


### Spark Driver

- Communicate with the cluster manager
- Request resources from the cluster manager for Spark's executor (JVMs)
- Transforms all Spark operations into DAG computations, schedules them, and distributes their execution as tasks
### SparkSession

- Unified conduit to all spark operations and data
- Create JVM runtime parameters, define DataFrames and Datasets, read from data sources, access catalog metadata, and issue Spark SQL queries
### Cluster Manager

- Responsible for managing and allocating resources for the cluster of nodes on which Spark application runs
- 4 cluster managers
	- Built-in standalone cluster manager
	- Apache Hadoop YARN
	- Apaches Mesos
	- Kubernetes
### Spark executor

- Runs on each worker node in the cluster
- Communicates with the driver program and are responsible for executing tasks on the works
- In most deployment modes, only a single executor run per node
### Deployment modes

- Supports many deployment modes for different configurations and environments
- Local
	- SIngle JVM
- Standalone
	- Run on any node in the cluster
	- Each node will launch its own executor JVM
- YARM (client)
	- Runs on a client
	- YARN's NodeManager's container
- YARN (cluster)
	- Rubs with the YARN Application Master
- Kubernetes
	- Runs in the Kubernetes pod
	- Each worker runs within its own pod
### Distributed data and partitions

- Actual physical data is distributed across storage as partitions residing in either HDFS or cloud storage

<img src="/images/Pasted image 20261008211933.png" alt="image" width="500">

- Partitioning allows for efficient parallelism
- Spark executors only processes data that is close to them, minimizing network bandwidth

<img src="/images/Pasted image 20261008212031.png" alt="image" width="500">

# The Developer's Experience

## Who Uses Spark, and for What?

### Data science tasks

- Spark's MLlib
	- Estimators, transformers, and data featurizers
- Spark SQL
	- Interactive and ad hoc exploration of data
- Project Hydrogen
	- Fault tolerant needs of training and scheduling deep learning models in a distributed manner
	- GPU resource collection
### Data engineering tasks

- Continuous applications with Structured Streaming
- Complex data pipelines to ETL data in both real time and static data sources
- Catalyst optimizer for SQL
- Tungsten
	- Compact code generation
### Popular Spark use cases

- Processing in parallel large data sets distributed across a cluster
- Performing ad hoc or interactive queries to explore and visualize data sets
- Building, training, and evaluating ML models
- Implementing end to end data pipelines from different streams of data
- Analyzing graph data sets and social network
## Community Adaption and Expansion

