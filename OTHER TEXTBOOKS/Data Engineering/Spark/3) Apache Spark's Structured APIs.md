# Spark - What's Underneath an RDD?

- RDD (Resilient Distributed Datasets) is the most basic abstraction in Spark
	- Dependencies
	- Partitions
	- Compute functions

- A list of dependencies that instructs Spark how an RDD is constructed with its inputs is required
- Spark can recreate an RDD from these dependencies and replicate operations on it
- Partitions provide the ability to split the work to parallelize computation on partitions across executors
- Compute function that produces an `Iterator[T]` for the data that will be stored in the RDD
- Spark does not know what the compute function is doing
	- Sees a lambda expression
	- Spark only knows `Iterator[T]` is a generic object in Python
# Structuring Spark

- Express computations by using common patterns in data analysis
	- Filtering
	- Selecting
	- Counting
	- Aggregating
	- Averaging
	- Grouping
- Common operators in DSL
- Arrange data in a tabular format

## Key Merits and Benefits

- Benefits of structure
	- Expressivity
	- Simplicity
	- Composability
	- Uniformity

```python
# In Python
# Create an RDD of tuples (name, age)
dataRDD = sc.parallelize([("Brooke", 20), ("Denny", 31), ("Jules", 30), 
  ("TD", 35), ("Brooke", 25)])
# Use map and reduceByKey transformations with their lambda 
# expressions to aggregate and then compute average

agesRDD = (dataRDD
  .map(lambda x: (x[0], (x[1], 1)))
  .reduceByKey(lambda x, y: (x[0] + y[0], x[1] + y[1]))
  .map(lambda x: (x[0], x[1][0]/x[1][1])))
  
# Structure
# In Python 
from pyspark.sql import SparkSession
from pyspark.sql.functions import avg
# Create a DataFrame using SparkSession
spark = (SparkSession
  .builder
  .appName("AuthorsAges")
  .getOrCreate())
# Create a DataFrame 
data_df = spark.createDataFrame([("Brooke", 20), ("Denny", 31), ("Jules", 30), 
  ("TD", 35), ("Brooke", 25)], ["name", "age"])
# Group the same names together, aggregate their ages, and compute an average
avg_df = data_df.groupBy("name").agg(avg("age"))
# Show the results of the final execution
avg_df.show()

+------+--------+
|  name|avg(age)|
+------+--------+
|Brooke|    22.5|
| Jules|    30.0|
|    TD|    35.0|
| Denny|    31.0|
+------+--------+
```

# The DataFrame API

- DataFrames
	- Distributed in-memory tables with named columns and schemas
	- Each column has a specific data type
		- Integer, string, array, map, real, date, timestamp
- Immutable and keeps a lineage of all transformations
- Add or change the names and data types of the columns

## Spark's Basic Data Types

- Spark supports basic internal data types

## Spark's Structured and Complex Data Types

- Complex data types
	- Maps
	- Arrays
	- Structs
	- Dates
	- Timestamps
	- Fields

## Schemas and Creating DataFrames

- Schema
	- Defined the column names and associated data types for a DataFrame
- Benefit of schema before instead of on read approach
	- Relieve Spark from the onus of inferring data types
	- Prevent Spark from creating a separate job to read a large portion of file
	- Detect errors early if data does not match the schema

### 2 Ways to define a schema

- Define it programmatically
- Data Definition Language (DDL)

```python
# In Python programmatically
from pyspark.sql.types import *
schema = StructType([StructField("author", StringType(), False),
  StructField("title", StringType(), False),
  StructField("pages", IntegerType(), False)])
  
# DDL
schema = "author STRING, title STRING, pages INT"
```

## Columns and Expressions

- List all the columns by their names
- Columns are objects with public methods
- Use logical or mathematical expressions on columns
- `Column` objects in a DataFrame cannot exist in isolation
- Each column is part of a row in a record and all rows together make a DataFrame

## Rows

- A row is a generic `Row` object
	- Containing one or more columns

## Common DataFrame Operations

- Load DataFrame from a data source that holds your structured data
- `DataFrameReader`
	- Enables you to read data into a DataFrame from sources in formats such as JSON, CSV, Parquet, Text, Avro, ORC
- `DataFrameWriter`
	- To write a DataFrame back to a data source

### Using DataFrameReader and DataFrameWriter

- Spark can infer schema from a sample at a lesser cost

```scala
// In Scala
val sampleDF = spark
  .read
  .option("samplingRatio", 0.001)
  .option("header", true)
  .csv("""/databricks-datasets/learning-spark-v2/
  sf-fire/sf-fire-calls.csv""")
```

- Parquet
	- Uses snappy compression to compress the data

### Saving a DataFrame as a Parquet file or SQL table

- Persisting a transformed DataFrame is as easy as reading it
- Save it as a table, which registers metadata with the Hive metastore

```python
# In Python to save as a Parquet file
parquet_path = ...
fire_df.write.format("parquet").save(parquet_path)

# In Python
parquet_table = ... # name of the table
fire_df.write.format("parquet").saveAsTable(parquet_table)
```

## Transformation and Actions

### Projections and filters

- Projection
	- Return only the rows matching a certain relational condition by using filters
	- `select(), filter(), where()` method

```python
# In Python
few_fire_df = (fire_df
  .select("IncidentNumber", "AvailableDtTm", "CallType") 
  .where(col("CallType") != "Medical Incident"))
few_fire_df.show(5, truncate=False)

# In Python, return number of distinct types of calls using countDistinct()
from pyspark.sql.functions import *
(fire_df
  .select("CallType")
  .where(col("CallType").isNotNull())
  .agg(countDistinct("CallType").alias("DistinctCallTypes"))
  .show())
```

### Renaming, adding, and dropping columns

```python
new_fire_df = fire_df.withColumnRenamed("Delay", "ResponseDelayedinMins")
(new_fire_df
  .select("ResponseDelayedinMins")
  .where(col("ResponseDelayedinMins") > 5)
  .show(5, False))
```

- Renaming a column results in a new DataFrame while retaining the original with the old column name

```python
fire_ts_df = (new_fire_df
  .withColumn("IncidentDate", to_timestamp(col("CallDate"), "MM/dd/yyyy"))
  .drop("CallDate") 
  .withColumn("OnWatchDate", to_timestamp(col("WatchDate"), "MM/dd/yyyy"))
  .drop("WatchDate") 
  .withColumn("AvailableDtTS", to_timestamp(col("AvailableDtTm"), 
  "MM/dd/yyyy hh:mm:ss a"))
  .drop("AvailableDtTm"))

# Select the converted columns
(fire_ts_df
  .select("IncidentDate", "OnWatchDate", "AvailableDtTS")
  .show(5, False))
```

- Convert the existing column's data type from string to a Spark-supported timestamp
- Use the new format specified in the format string where appropriate
- After converting to the new data type, `drop()` the old column and append the new one specified in the first argument to the `withColumn()` nethod
- Assign the new modified DataFrame to `fire_ts_df`

### Aggregations

```python
(fire_ts_df
  .select("CallType")
  .where(col("CallType").isNotNull())
  .groupBy("CallType")
  .count()
  .orderBy("count", ascending=False)
  .show(n=10, truncate=False))
```

- `collect()`
	- For extremely large DataFrames
	- Resource-heavy and dangerous
	- Cause out-of-memory (OOM) exception

### Other common DataFrame operations

- Descriptive statistical methods
	- `min(), max(), sum(), avg()`
	- `stat(), describe(), correlation(), covariance(), sampleBy(), approxQuantile(), frequentItems()`

```python
import pyspark.sql.functions as F
(fire_ts_df
  .select(F.sum("NumAlarms"), F.avg("ResponseDelayedinMins"),
    F.min("ResponseDelayedinMins"), F.max("ResponseDelayedinMins"))
  .show())
```

# The Dataset API

- Datasets take on two characteristics
	- Typed and untypes APIs

<img src="/images/Pasted image 20261009140950.png" alt="image" width="500">

- A DataFrame in Scala is an alias for a collection of generic objects
- `Dataset[Row`
	- `Row` is a generic untyped JVM object that may hold different types of fields
- A Dataset, by contrast, is a collection of strongly typed JVM objects in Scala or a class in Java

## Types Objects, Untyped Objects, and Generic Rows

- Datasets make sense only in Have and Scala
	- Types are bound to variables and objects at compile time
- Python uses DataFrames
	- Python and R are not compile-time type-safe
	- Types are dynamically inferred or assigned during execution, not during compile time

- `Row`
	- A generic object type in Spark
	- Holding a collection of mixed types that can be accessed using an index
	- Manipulates `Row` objects, converting them to equivalent types
- Typed objects are actual Java or Scala class objects in the JVM

## Creating Datasets

- For large data sets inferring schema is expensive
- JavaBean classes are used

### Scala - Case classes

```scala
{"device_id": 198164, "device_name": "sensor-pad-198164owomcJZ", "ip": 
"80.55.20.25", "cca2": "PL", "cca3": "POL", "cn": "Poland", "latitude":
53.080000, "longitude": 18.620000, "scale": "Celsius", "temp": 21, 
"humidity": 65, "battery_level": 8, "c02_level": 1408,"lcd": "red", 
"timestamp" :1458081226051}

case class DeviceIoTData (battery_level: Long, c02_level: Long, 
cca2: String, cca3: String, cn: String, device_id: Long, 
device_name: String, humidity: Long, ip: String, latitude: Double,
lcd: String, longitude: Double, scale:String, temp: Long, 
timestamp: Long)
```

## Dataset Operations

- Perform transformations and actions on DataFrames
- Express `filter()` conditions as SQL-like DSL operations
- With Datasets, use language-native expressions
- Underlying Spark SQL engine handles the creation, conversion, serialization, and deserialization of the JVM objects of Datasets

# DataFrames vs Datasets

- DataFrames
	- Want to tell Spark what to do, not how to do it
	- Processing dictates relational transformations similar to SQL-like queries
	- Unification, code optimization, and simplification of APIs across Spark components
	- Using R or python
	- Space and speed efficiency
- Datasets
	- Strict compile time safety
	- Take advantage of and benefit from Tungsten's efficient serialization with Encoders
- Both
	- Rich semantics, high level abstractions, and DSL operations
	- Processing demands high level expressions, filters, maps, aggregations, computing averages or sums, SQL queries, columnar access, relational, or semi-structured data

<img src="/images/Pasted image 20261009142146.png" alt="image" width="500">


## When to Use RDD

- RDD API will continue to be supported
- Future development will continue to have a DataFrame interface and semantics rather than using RDDs
- Using RDDs
	- Using a third party package that is written using RDD
	- Forgo the code optimization, efficient space utilization, and performance benefits
	- Want to precisely instruct Spark how to do a query

- `df.rdd`
	- DataFrames and Datasets are built on top of RDDs
	- Get decomposed to compact RDD code during whole-stage code generation
# Spark SQL and the Underlying Engine

- Spark Sql has evolved into a substantial engine upon which many high level structured functionalities have been built
- Unified Spark components and permits abstractions to DataFrames/Datasets
- Connects to the Apache Hive metastore and tables
- Reads and write structured data with a specific schema from structured file formats and converts data into temporary tables
- Offers an interactive Spark SQL shell for quick data exploration
- Provides a bridge to (and from) external tools via standard database JDBC/ODBC connectors
- Generates optimized query plans and compact code for the JVM, for final execution$

<img src="/images/Pasted image 20261009142818.png" alt="image" width="500">

- Spark SQL engine uses Catalyst optimizer and Project Tungsten
- Support high level DataFrame and Dataset APIs and SQL queries

## The Catalyst Optimizer

- Takes a computational query and converts it into an execution plan
- 4 transformational phases
	- Analysis
	- Logical optimization
	- Physical planning
	- Code generation


<img src="/images/Screenshot 2026-10-09 at 2.30.22 PM.png" alt="image" width="500">

<img src="/images/Screenshot 2026-10-09 at 2.30.29 PM.png" alt="image" width="500">

### Phase 1: Analysis

- The Spark SQL engine beings by generating an abstract syntax tree (AST) for the SQL or DataFrame query
- Columns or table names will be resolved by consulting an internal `Catalog`
	- Programmatic interface to Spark SQL that holds a list of names of columns, data types, functions, tables, databases
### Phase 2: Logical Optimization

- 2 internal stages
	- Standard rule based optimization approach
	- Catalyst optimizer will first construct a set of multiple plans
	- Using its cost based optimizer (CBO) it assigns costs to each plan
		- Process of constant folding, predicate pushdown, projection pruning, Boolean expression simplification
	- Logical plan is the input into the physical plan
### Phase 3: Physical Planning

- Spark SQL generates an optimal physical plan for the selected logical plan
### Phase 4: Code Generation

- Generating efficient Java bytecode to run on each machine
- Spark can use state-of-the-art compiler technology for code generation to speed up execution
- 