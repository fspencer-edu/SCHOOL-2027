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

- Data engineers build data pipelines as part of their regular data ingestion and ETL processes
- Populate Spark SQL databases and tables with cleansed data for consumption by applications downstream
- Use SQL to query the table and assign the returned result to a DataFrame

```python
# In Python
us_flights_df = spark.sql("SELECT * FROM us_delay_flights_tbl")
us_flights_df2 = spark.table("us_delay_flights_tbl")
```

- Read data in other formats using Spark's built-in data sources

# Data Sources for DataFrames and SQL Tables

- Spark SQL provides an interface to a variety of data sources

## DataFrameReader

- Core construct for reading data from a data source into a DataFrame

```python
DataFrameReader.format(args).option("key", "value").schema(args).load()
```

- Only access a `DataFrameReader` through a `SparkSession` instance
- Cannot create an instance of `DataFrameReader`

- Parquet metadata usually contains the schema and is inferred when read
- For streaming data sources, provide a schema
	- Columnar storage
	- Fast compression algorithm

## DataFrameWriter

- `DataFrameWriter` does the reverse
- Saves or writes data to a specified built-in data source
- Access its instance from the DataFrame to save

```python
DataFrameWriter.format(args)
  .option(args)
  .bucketBy(args)
  .partitionBy(args)
  .save(path)

DataFrameWriter.format(args).option(args).sortBy(args).saveAsTable(table)

val location = ... 
df.write.format("json").mode("overwrite").save(location)
```

## Parquet

- Parquet is an open source columnar file format that offers many I/O optimizations

### Reading Parquet files into a DataFrame

- Parquet files are stored in a directly structure that contains the data file, metadata, and number of compressed files, and status files
- Metadata in the footer contains the version of the file format, the schema, and column data

```parquet
_SUCCESS
_committed_1799640464332036264
_started_1799640464332036264
part-00000-tid-1799640464332036264-91273258-d7ef-4dc7-<...>-c000.snappy.parquet

# In Python
file = """/databricks-datasets/learning-spark-v2/flights/summary-data/parquet/
  2010-summary.parquet/"""
df = spark.read.format("parquet").load(file)
```

### Reading Parquet files into a Spark SQL table

- Create a Spark SQL unmanaged table or view directly

```python
-- In SQL
CREATE OR REPLACE TEMPORARY VIEW us_delay_flights_tbl
    USING parquet
    OPTIONS (
      path "/databricks-datasets/learning-spark-v2/flights/summary-data/parquet/
      2010-summary.parquet/" )
      
# In Python
spark.sql("SELECT * FROM us_delay_flights_tbl").show()
```

### Writing DataFrame to Parquet files

```python
# In Python
(df.write.format("parquet")
  .mode("overwrite")
  .option("compression", "snappy")
  .save("/tmp/data/parquet/df_parquet"))
```

### Writing DataFrames to Spark SQL tables

- Writing a DataFrame to a SQL table is as easy as writing to a file

```python
# In Python
(df.write
  .mode("overwrite")
  .saveAsTable("us_delay_flights_tbl"))
```

## JSON

- JavaScript Object Notation (JSON)
	- Single line mode
	- Multi-line mode

### Reading a JSON file into a DataFrame

- Read a JSON file into a DataFrame

```python
# In Python
file = "/databricks-datasets/learning-spark-v2/flights/summary-data/json/*"
df = spark.read.format("json").load(file)
```

### Reading a JSON file into a Spark SQL table

```SQL
-- In SQL
CREATE OR REPLACE TEMPORARY VIEW us_delay_flights_tbl
    USING json
    OPTIONS (
      path  "/databricks-datasets/learning-spark-v2/flights/summary-data/json/*"
    )
```

### Writing DataFrames to JSON files

```python
# In Python
(df.write.format("json")
  .mode("overwrite")
  .option("compression", "snappy")
  .save("/tmp/data/json/df_json"))
```

### JSON data source options

## CSV

- Common text file format captures each datum or field delimited by a comma

### Reading a CSV file into a DataFrame

```python
# In Python
file = "/databricks-datasets/learning-spark-v2/flights/summary-data/csv/*"
schema = "DEST_COUNTRY_NAME STRING, ORIGIN_COUNTRY_NAME STRING, count INT"
df = (spark.read.format("csv")
  .option("header", "true")
  .schema(schema)
  .option("mode", "FAILFAST")  # Exit if any errors
  .option("nullValue", "")     # Replace any null data field with quotes
  .load(file))
```

### Reading a CSV file into a Spark SQL table

```SQL
-- In SQL
CREATE OR REPLACE TEMPORARY VIEW us_delay_flights_tbl
    USING csv
    OPTIONS (
      path "/databricks-datasets/learning-spark-v2/flights/summary-data/csv/*",
      header "true",
      inferSchema "true",
      mode "FAILFAST"
    )
```

### Writing DataFrame to CSV files

```python
df.write.format("csv").mode("overwrite").save("/tmp/data/csv/df_csv")
```

### CSV data source options

## Avro

- Message serializing and deserializing
- Direct mapping to JSON, speed and efficiency, and bindings available for many programming languages

### Reading an Avro file into a DataFrame

```python
# In Python
df = (spark.read.format("avro")
  .load("/databricks-datasets/learning-spark-v2/flights/summary-data/avro/*"))
df.show(truncate=False)
```

### Reading an Avro file into a Spark SQL table

```SQL
-- In SQL 
CREATE OR REPLACE TEMPORARY VIEW episode_tbl
    USING avro
    OPTIONS (
      path "/databricks-datasets/learning-spark-v2/flights/summary-data/avro/*"
    )

spark.sql("SELECT * FROM episode_tbl").show(truncate=False)
```

### Writing DataFrames to Avro Files

```python
# In Python
(df.write
  .format("avro")
  .mode("overwrite")
  .save("/tmp/data/avro/df_avro"))
```

## ORC

- Vectorized reader
	- Reads blocks of rows instead of one row at a time
	- Streamlining operations and reducing GPU usage for intensive operations like scans, filters, aggregations, and joins
- Hive ORC SerDe

### Reading an ORC file into a DataFrame

```python
file = "/databricks-datasets/learning-spark-v2/flights/summary-data/orc/*"
df = spark.read.format("orc").option("path", file).load()
df.show(10, False)
```

### Reading an ORC file into a Spark SQL table

```SQL
-- In SQL
CREATE OR REPLACE TEMPORARY VIEW us_delay_flights_tbl
    USING orc
    OPTIONS (
      path "/databricks-datasets/learning-spark-v2/flights/summary-data/orc/*"
    )
```

### Writing dataFrames to ORC files

```python
# In Python
(df.write.format("orc")
  .mode("overwrite")
  .option("compression", "snappy")
  .save("/tmp/data/orc/flights_orc"))
```

## Images

- Images files
	- Support deep learning and ML frameworks
		- TensorFlow
		- PyTorch

### Reading an image file into a DataFrame

```python
# In Python
from pyspark.ml import image

image_dir = "/databricks-datasets/learning-spark-v2/cctvVideos/train_images/"
images_df = spark.read.format("image").load(image_dir)
images_df.printSchema()
```

## Binary Files

- Converts each binary file into a single DataFrame that contains the raw content and metadata of the file
- Binary file data source produces a DataFrame
	- path: StringType
	- modificationTime: TimestampType
	- length: LongType
	- content: BinaryType

### Reading a binary file into a DataFrame

```python
# In Python
path = "/databricks-datasets/learning-spark-v2/cctvVideos/train_images/"
binary_files_df = (spark.read.format("binaryFile")
  .option("pathGlobFilter", "*.jpg")
  .load(path))
binary_files_df.show(5)
```

