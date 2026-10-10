
- Local mode
	- All the processing is done on a single machine in a Spark shell
- Large data sets
	- YARN
	- Kuberenetes
# Step 1 - Downloading Apache Spark

- Hadoop related binaries
- PySpark
	- `pip install pyspark`
- Install Java 8 or above on your machine and set the `JAVA_HOME` environment variable
# Step 2 - Using the Scala or PySpark Shell

- Spark comes with four widely used interpreters that act like interactive shells and enable ad hoc data analysis
	- `pyspark`
	- `spark-shell`
	- `spark-sql`
	- `sparkR`

## Using the Local Machine

- Spark computations are expressed as operations
- Operations are then converted into low-level RDD-based bytecode and tasks

```spark
-- scala shell
val string = spark.read.text("../README.md")

strings.show(10, false)

strings.count()

-- python shell
strings = spark.read.text(../READMD.md")
strongs.show(10, truncate=False)
strings.count()
```

- Every high level structured APIs is decomposed into low level optimized and generated RDD operations and then converted into Scala bytecode for the executors's JVMs
# Step 3 - Understanding Spark Application Concepts

- Application
	- A user program build on Spark using its APIs
	- A driver program and executors on the cluster
- SparkSession
	- An object that provides a point of entry to interact with underlying Spark functionality and allows programming Spark with its API
- Job
	- A parallel computation consisting of multiple tasks that gets spawned in response to a Spark action
- Stage
	- Each job gets divide into smaller sets of tasks called stages that depend on each other
- Task
	- A single unit of work or execution that will be sent to a Spark executor

## Spark Application and SparkSession

- Spark driver program creates a `SparkSession` object

<img src="/images/Pasted image 20261009113404.png" alt="image" width="500">

## Spark Jobs

- Driver converts Spark application into one or more Spark jobs
- Transforms each job into a DAG
- Each node within a DAG could be a single or multiple Spark stages

<img src="/images/Pasted image 20261009113500.png" alt="image" width="500">

## Spark Stages

- Stages are created based on what operations can be performed serially or in parallel
- Not all Spark operations can happen in a single stage, may be divided into multiple stages
- Stages are delineated on the operator's computation boundaries

<img src="/images/Pasted image 20261009113614.png" alt="image" width="500">

## Spark Tasks

- Each stage is comprised of Spark tasks (a unit of execution)
- Federated across each Spark executor
- task maps to a single core and works on a single partition of data

<img src="/images/Pasted image 20261009113706.png" alt="image" width="500">

# Transformations, Actions, and Lazy Evaulation

- Spark operations
	- Transformations
		- Transform a Spark DataFrame into a new DataFrame without altering the original data
		- Immutability
		- `select()` or `filter()`
		- Evaluated lazily
		- Remembered as a lineage
	- Actions
		- Triggers are lazy evaulation of all recorded transfromations

<img src="/images/Pasted image 20261009113849.png" alt="image" width="500">

- Lazy evaluation
	- Optimizes queries by peeking into changed transformations
- Lineage and data immutability
	- Provides fault tolerance

```spark
-- Transformations
orderBy()
groupBy()
filter()
select()
join()

-- Actions
show()
take()
count()
collect()
save()
```

- The actions and transformations contribute to a Spark query plan
- Nothing in a query plan is executed until an action is involved

```python
strongs = spark.read.text("../README.md")
filtered = strings.filter(strings.value.contains("Spark"))
filtered.count()
20
```

```scala
import org.apache.spark.sql.function._
val srings = spark.read.text("../README.md")
val filtered = strings.filter(col("value").contains("Spark"))
filtered.count()
20
```

## Narrow and Wide Transformations

- Transformations can be classified as having either narrow dependencies or wide dependencies
- Any transformation where a single output partition can be computed from a single input partition is a narrow transformation
	- `filter()`
	- `contains()`
- Wide transformations combine data from other partitions
	- `groupBy()`
	- `orderBy()`
	- Require output from other partitions to compute the final aggregation

<img src="/images/Pasted image 20261009133541.png" alt="image" width="500">

# The Spark UI

- Spark includes a GUI
	- A list of scheduler stages and tasks
	- A summary of RDD sizes and memory usage
	- Information about the environment
	- Information about the running executors
	- All the Spark SQL queries

- Databrciks
	- Company that offers a managed Apache Spark platform in the could

# Your First Standalone Application

## Counting M&Ms for the Cookie Monster

```python
# Import the necessary libraries.
# Since we are using Python, import the SparkSession and related functions
# from the PySpark module.
import sys

from pyspark.sql import SparkSession

if __name__ == "__main__":
   if len(sys.argv) != 2:
       print("Usage: mnmcount <file>", file=sys.stderr)
       sys.exit(-1)

   # Build a SparkSession using the SparkSession APIs.
   # If one does not exist, then create an instance. There
   # can only be one SparkSession per JVM.
   spark = (SparkSession
     .builder
     .appName("PythonMnMCount")
     .getOrCreate())
   # Get the M&M data set filename from the command-line arguments
   mnm_file = sys.argv[1]
   # Read the file into a Spark DataFrame using the CSV
   # format by inferring the schema and specifying that the
   # file contains a header, which provides column names for comma-
   # separated fields.
   mnm_df = (spark.read.format("csv") 
     .option("header", "true") 
     .option("inferSchema", "true") 
     .load(mnm_file))

   # We use the DataFrame high-level APIs. Note
   # that we don't use RDDs at all. Because some of Spark's 
   # functions return the same object, we can chain function calls.
   # 1. Select from the DataFrame the fields "State", "Color", and "Count"
   # 2. Since we want to group each state and its M&M color count,
   #    we use groupBy()
   # 3. Aggregate counts of all colors and groupBy() State and Color
   # 4  orderBy() in descending order
   count_mnm_df = (mnm_df
     .select("State", "Color", "Count")
     .groupBy("State", "Color")
     .sum("Count")
     .orderBy("sum(Count)", ascending=False))
   # Show the resulting aggregations for all the states and colors;
   # a total count of each color per state.
   # Note show() is an action, which will trigger the above
   # query to be executed.
   count_mnm_df.show(n=60, truncate=False)
   print("Total Rows = %d" % (count_mnm_df.count()))
   # While the above code aggregated and counted for all 
   # the states, what if we just want to see the data for 
   # a single state, e.g., CA? 
   # 1. Select from all rows in the DataFrame
   # 2. Filter only CA state
   # 3. groupBy() State and Color as we did above
   # 4. Aggregate the counts for each color
   # 5. orderBy() in descending order  
   # Find the aggregate count for California by filtering
   ca_count_mnm_df = (mnm_df
     .select("State", "Color", "Count")
     .where(mnm_df.State == "CA")
     .groupBy("State", "Color")
     .sum("Count")
     .orderBy("sum(Count)", ascending=False))
   # Show the resulting aggregation for California.
   # As above, show() is an action that will trigger the execution of the
   # entire computation. 
   ca_count_mnm_df.show(n=10, truncate=False)
   # Stop the SparkSession
   spark.stop()
```

