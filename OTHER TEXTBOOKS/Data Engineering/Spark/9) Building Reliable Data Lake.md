
- Two broad classes of storage solutions
	- Databases
	- Data laks
	- Lakehouses
# The Importance of an Optimal Storage Solution

- Properties in a storage solution
	- Scalability and performance
	- Transaction suport
	- Support for diverse data formats
	- Support for diverse workloads
	- Openness
# Databases

## A Brief Introduction to Databases

- Databases are designed to store structured data as tables
- 2 categories
	- Online transaction processing (OLTP)
	- Online analytical processing (OLAP)
- Apache Spark is a query engine primarily designed for OLAP, not OLTP

## Reading from and Writing to Databases Using Apache Spark

- Connects to databases that have JDBC drivers
- Dedicated connections for modern databases
	- Azure Cosmos DB
	- Snowflake

## Limitations of Database

- Growth in data sizes
- Growth in the diversity of analytics

- Database limitations
	- Expensive to scale out
	- Do not support non-SQL based analytics well
# Data Lakes

- A data lake is a distributed storage solution that runs on commodity hardware and easily scales out horizontally

## A Brief Introduction to Data Lakes

- Decouples the distributed storage system from the distributed compute system
- Data is saved as files with open formats
- Hadoop File System (HDFS)
- Building a data lake
	- Storage system
	- File format
		- Structured
			- Parquet
			- ORC
		- Semi structured
			- JSON
		- Unstructured
			- Text, images, audio, video
	- Processing engines

- Data lakes provide a cheaper solution than databases

## Reading from and writing to Data Lakes using Apaches Spark

- Support for diverse workloads
- Support for diverse file formats
- Support for diverse filesystems
- Cloud storage systems often do not have the same file operation semantics expected from a standard filesystem, which can lead to inconsistent results

## Limitations of Data Lakes

- Lack of transactional guarantees
	- Atomicity and isolation
	- Consistency
- Work arounds
	- Large collection of data files in data lakes are partitioned by subdirectories based on a column's value
	- Schedules of data update jobs and data querying jobs

# Lakehouses - The Next Step in the Evolution of Storage Solutions

- Lakehouse is a new paradigm that combines the best elements of data lakes and data warehouses for OLAP workloads
- New system design that provides data management features similar to databases at the low cost, and scalability used for data lakes
	- Transaction support
	- Schema enforcement and governance
	- Support for diverse data types in open formats
	- Support for diverse workloads
	- Support for upserts and deletes
	- Data governance

- Open source systems
	- Apache Hudi, Apache Iceberg, Delta Lake
	- Store large volumes of data in structured file formats on scalable filesystems
	- Maintain a transaction log to record a timeline of atomic changes to the data
	- Use the log to define versions of the table data and provide snapshot isolation
	- Support reading and writing to tables using Apache Spark

## Apache Hudi

- Initially bilt by Uber Engineering
- Hadoop Update Delete and INcremental
	- Incremental upserts and deletes over key/value-style data
- Data is stored as a combination of columnar formats and row based formats
- Upserting with fast, pluggable indexing
- Atomic publishing of data with rollback support
- Reading incremental changes to a table
- Savepoints for data recovery
- File size and layout management using statistics
- Async compaction or row and columnar data

## Apache Iceberg

- Originally build at Netflix
- General purpose data storage that scales to petabytes in the single table and has schema evolution properties
- Schema evolution by adding, dropping, updating, renaming, and reordering of columns, fields, and/or nested structures
- Hidden partitioning
- Partition evolution
- Time travel
- Rollback to previous versions to correct errors
- Serializable isolation

## Delta Lake

- Open source project hosted by the Linux Foundation
- Transactional guarantees and enables schema enforcement and evolution
- Streaming reading from and writing to tables using Structured Streaming sources and sinks
- Update, delete, and merge operations
- Schema evolution either by explicitly altering the table schema or by implicitly merging a DataFrame's schema to the table's during the DataFrame's write
- Time travel
- Rollback
- Serializable isolation

# Building Lakehouses with Apache Spark and Delta Lake

- Reading and writing Delta Lake tables using Apache Spark
- How Delta Lake allows concurrent batch and streaming writes with ACID guarantees
- How Delta Lake ensures better data quality by enforcing schema on all writes, while allowing for explicit schema evolution
- Building complex data pipelines using update, delete, and merge operations, all of which ensure ACID guaranteees
- Auditing the history of operations that modified a Delta Lake table and traveling back in time by querying earlier version of the table

## Configuring Apache Spark with Delta Lake

- Interactive shell

```python
pyspark --packages io.delta:delta-core_2.12:0.7.0

```

- Standalone Scala/Java project using Maven coordinates

```python
  <dependency>
  <groupId>io.delta</groupId>
  <artifactId>delta-core_2.12</artifactId>
  <version>0.7.0</version>
</dependency>
```

## Loading Data into a Delta Lake Table

- Migrate existing workloads to use the Delta Lake format
- Change all the DataFrame read and write operations to use `format("delta")` instead of `format("parquet")`

```python
# In Python
# Configure source data path
sourcePath = "/databricks-datasets/learning-spark-v2/loans/
  loan-risks.snappy.parquet"

# Configure Delta Lake path
deltaPath = "/tmp/loans_delta"

# Create the Delta Lake table with the same loans data
(spark.read.format("parquet").load(sourcePath) 
  .write.format("delta").save(deltaPath))

# Create a view on the data called loans_delta
spark.read.format("delta").load(deltaPath).createOrReplaceTempView("loans_delta")

// Loans row count
spark.sql("SELECT count(*) FROM loans_delta").show()

+--------+
|count(1)|
+--------+
|   14705|
+--------+

// First 5 rows of loans table
spark.sql("SELECT * FROM loans_delta LIMIT 5").show()

+-------+-----------+---------+----------+
|loan_id|funded_amnt|paid_amnt|addr_state|
+-------+-----------+---------+----------+
|      0|       1000|   182.22|        CA|
|      1|       1000|   361.19|        WA|
|      2|       1000|   176.26|        TX|
|      3|       1000|   1000.0|        OK|
|      4|       1000|   249.98|        PA|
+-------+-----------+---------+----------+
```

## Loading Data Streams into a Delta Lake Table

- Easily modify your existing Structured Streaming jobs to write and read from a Delta Lake table by setting the format to `"delta"`

```python
newLoanStreamDF = ...   # Streaming DataFrame with new loans data
checkpointDir = ...     # Directory for streaming checkpoints
streamingQuery = (newLoanStreamDF.writeStream 
    .format("delta") 
    .option("checkpointLocation", checkpointDir) 
    .trigger(processingTime = "10 seconds") 
    .start(deltaPath))
```

- Advantages of Delta Lake
	- Writes from both batch and streaming jobs into the same table
	- Allows multiple streaming jobs to append data in the same table
	- ACID guarantees even under concurrent writes

## Enforcing Schema on Write to Prevent Data Corruption

- All write to a Delta Lake table can verify whether the data being written has a schema compatible with that of the table
- Spark will throw an error before any data is written and comitted to the table

```python
from pyspark.sql.functions import *

cols = ['loan_id', 'funded_amnt', 'paid_amnt', 'addr_state', 'closed']
items = [
(1111111, 1000, 1000.0, 'TX', True), 
(2222222, 2000, 0.0, 'CA', False)
]

loanUpdates = (spark.createDataFrame(items, cols)
  .withColumn("funded_amnt", col("funded_amnt").cast("int")))
loanUpdates.write.format("delta").mode("append").save(deltaPath)
```

## Evolving Schemas to Accomodate Changing Data

- Add a new column to a table

```python
(loanUpdates.write.format("delta").mode("append")
  .option("mergeSchema", "true")
  .save(deltaPath))
```

## Transforming Existing Data

- Delta Lake supports the DML commands `UPDATE, DELETE, MERGE` to build complex data pipelines

### Updating data to fix errors

- Fixing errors in the data
	- Copy all the rows that are not affected into a new table
	- Copy all of the rows that are affected into a DataFrame, then perform the data modification
	- Insert the previously noted DataFrame's rows into the new table
	- Remove the old table and rename the new table to the old table name

```python
# In Python
from delta.tables import *

deltaTable = DeltaTable.forPath(spark, deltaPath)
deltaTable.update("addr_state = 'OR'",  {"addr_state": "'WA'"})
```

### Deleting user-related data

- General Data Protection Regulation (GDPR)

```python
# In Python
deltaTable = DeltaTable.forPath(spark, deltaPath)
deltaTable.delete("funded_amnt >= paid_amnt")
```

### Upserting change data to a table using merge()

- Change data capture
	- Replicate row changes made in an OLTP table to another table for OLAP workloads

```python
# In Python
(deltaTable
  .alias("t")
  .merge(loanUpdates.alias("s"), "t.loan_id = s.loan_id") 
  .whenMatchedUpdateAll() 
  .whenNotMatchedInsertAll() 
  .execute())
```

### Deduplicating data while inserting using insert-only merge

- Advanced merge operations in Delta Lake
	- Delete actions
	- Clause conditions
	- Optional actions
	- Star syntax

```python
# In Python
(deltaTable
  .alias("t")
  .merge(historicalUpdates.alias("s"), "t.loan_id = s.loan_id") 
  .whenNotMatchedInsertAll() 
  .execute())
```
## Auditing Data Changes with Operation History

- All changes are recorded as commits in the table's transactionlog
- Every operation is automatically versioned

```python
deltaTable.history().show()

(deltaTable
  .history(3)
  .select("version", "timestamp", "operation", "operationParameters")
  .show(truncate=False))
```

## Querying Previous Snapshots of a Table with Time Travel

```python
(spark.read
  .format("delta")
  .option("timestampAsOf", "2020-01-01")  # timestamp after table creation
  .load(deltaPath))

(spark.read.format("delta")
  .option("versionAsOf", "4")
  .load(deltaPath))
```

- Reproducing ML experiments and reports by rerunnign the job on a specific table version
- Comparing the data changes between different versions for auditing
- Rolling back incorrect changes by reading a previous snapshot as a DataFrame and overwriting the table with it