- Spark SQL
	- Provides the engine upon which the highest level Structured APIs we explored
	- Read and write data in a variety of structured formats
	- Query data using JDBC/ODBC connectors form external BI data sources
	- Provides a programmatic interface to interact with structured data stored as tables or views in a database from a Spark application
	- Offers an interactive shell to issue SQL queries on your structured data

<img src="/images/Pasted image 20261009214534.png" alt="image" width="500">

# Using Spark SQL in Spark Applications

- `SparkSession`
	- Provides a unified entry point for programming Spark with the Structured API
	- Access Spark functionality
- `spark.sql("SELECT * FROM myTableName")`

## Basic Query Examples

- Read data into a DataFrame and register the DataFrame as a temporary view

```python
from pyspark.sql import SparkSession

# Create a SparkSession
spark = (SparkSession
	.builder
	.appName("SparkSQLExampleApp")
	.getOrCreate()
)

# Path to data set
csv_file = "/databricks-datasets/learning-spark-v2/flights/departuredelays.csv"

# Read and create a temp view
# Infer schema
df = (spark.read.format("csv")
	.option("inferSchema", "true")
	.option("header", "true")
	.load(csv_file)
)
df.createOrReplaceTempView("us_delay_flights_tbl")

# In Python
schema = "`date` STRING, `delay` INT, `distance` INT, 
 `origin` STRING, `destination` STRING"
```

- US flight delays data
	- date
	- delay
	- distance
	- origin
	- destination

- Conduct common data analysis operations
- Spark manages all the complexities of creating and managing views and tables, both in memory and on disk

# SQL Tables and Views

- Tables hold data
- Associated with each tables in Sparks is its relevant metadata
	- Schema
	- Description
	- Table name
	- Database name
	- Column name
	- Partitions
	- Physical location
- Spark by default uses the Apache Hive metastore to persist all the metadata about tables

## Managed vs. UnmanagedTables

- Managed tables
	- Manages both the metadata and the data in the file store
		- Local filesystem, HDFS, or an object store (AWS S3 or Azure Blob)
- Unmanaged tables
	- Spark only manages the metatable
	- User manages the data in an external data source (Cassandra)

- A dropped manage table, deletes both the metadata and the data
- For an unmanaged tables, the same command will delete only the metadata

## Creating SQL Databases and Tables

- Tables reside within a database
- Spark creates tables under the `default` database
- Create you own database name
	- `learn_spark_db`

```python
spark.sql("CREATE DATABASE learn_spark_db")
spark.sql("USE learn_spark_db")
```

 - Any commands issued in the application to create tables will result in the tables being created in this database and residing under the database name `learn_spark_db`

### Creating a managed table

```python
spark.sql("CREATE TABLE managed_us_delay_flights_tbl (date STRING, delay INT,  
  distance INT, origin STRING, destination STRING)")
```

### Creating an unmanaged table

- Create unmanaged tables from your own data source

```python
spark.sql("""CREATE TABLE us_delay_flights_tbl(date STRING, delay INT, 
  distance INT, origin STRING, destination STRING) 
  USING csv OPTIONS (PATH 
  '/databricks-datasets/learning-spark-v2/flights/departuredelays.csv')""")

(flights_df
  .write
  .option("path", "/tmp/data/us_flights_delay")
  .saveAsTable("us_delay_flights_tbl"))
```

## Creating Views

- Spark can create views on top of existing tables
- Views can be global or session scoped
- View are temporary, disappear after Spark application terminates
- Creating views has a similar syntax to creating tables within database
- Views do not hold the data
- Tables persist after application terminates

```SQL
-- In SQL
CREATE OR REPLACE GLOBAL TEMP VIEW us_origin_airport_SFO_global_tmp_view AS
  SELECT date, delay, origin, destination from us_delay_flights_tbl WHERE 
  origin = 'SFO';

CREATE OR REPLACE TEMP VIEW us_origin_airport_JFK_tmp_view AS
  SELECT date, delay, origin, destination from us_delay_flights_tbl WHERE 
  origin = 'JFK'
```

```python
# In Python
df_sfo = spark.sql("SELECT date, delay, origin, destination FROM 
  us_delay_flights_tbl WHERE origin = 'SFO'")
df_jfk = spark.sql("SELECT date, delay, origin, destination FROM 
  us_delay_flights_tbl WHERE origin = 'JFK'")

# Create a temporary and global temporary view
df_sfo.createOrReplaceGlobalTempView("us_origin_airport_SFO_global_tmp_view")
df_jfk.createOrReplaceTempView("us_origin_airport_JFK_tmp_view")
```

- When accessing a global temporary view, use the prefix `global_temp.<view_name>`
- Spark create global temporary views in a global temporary database

```SQL
SELECT * FROM global_temp.us_origin_airport_SFO_global_tmp_view

SELECT * FROM us_origin_airport_JFK_tmp_view

// In Scala/Python
spark.read.table("us_origin_airport_JFK_tmp_view")
// Or
spark.sql("SELECT * FROM us_origin_airport_JFK_tmp_view")
```

### Temporary views vs. Global temporary views

- Temporary views
	- Tied to a single `SparkSession` within a Spark application
- Global temporary view
	- Visible across multiple `SparkSessions` within a Spark application

## Viewing the Metadata

- Spark manages the metadata associated with each managed or unmanaged table
- Captured in the `Catalog`
	- High level abstraction in Spark SQL for storing metadata
	- Access all the stored metadata through methods

```python
// In Scala/Python
spark.catalog.listDatabases()
spark.catalog.listTables()
spark.catalog.listColumns("us_delay_flights_tbl")
```

## Caching SQL Tables

- Like DataFrames, you can cache and uncache SQL tables and views
- Specify a table as `LAZY`
	- Should only be cached when it is first used instead of immediately

```SQL
CACHE [LAZY] TABLE <table-name>
UNCACHE TABLE <table-name>
```

## Reading Tables into DataFrames

- Data engineers build data pipelines as part of their


# Data Sources for DataFrames and SQL Tables
