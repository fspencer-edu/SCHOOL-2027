
# Optimizing and Tuning Spark for Efficiency

## Viewing and Setting Apache Spark Configurations

- Get and set Spark properties
	- Configuration files
	- Specify Spark configurations directly in your Spark application or on the command line when submitting the application with `spark-submit`, with the `--conf` flag
	- Programmatic interface via the Spark shell
	- Access Spark's current configuration through the Spark UI's Environment tab

## Scaling Spark for Large Workloads

- Large Spark workloads are often batch jobs
	- Nightly basis
	- Scheduled at regular intervals during the day
- Job failures
	- Source starvation
	- Gradual performance degradation
- Spark components
	- Spark driver
		- Coordinate with the cluster manager to launch executors in a cluster and schedule Spark tasks non them
	- Executor
	- Shuffle service

### Static vs. Dynamic resource allocation

- Dynamic resource allocation configuration
	- Driver can request more or fewer compute resources as the demand of large workflows and ebbs
- Streaming
	- Data flow volume may be uneven
- On demand data analytics
	- High volume of SQL queries during peak hours
- Multi-tenant environment
	- Spark may be developed alongside other applications or services in YARN, Mesos, or Kubernetes

### Configuring Spark Executors' memory and the shuffle service

- Amount of memory available to each executor is controlled by `spark.executor.memory`
	- Execution memory - 60%
	- Storage memory - 40%
	- Reserved memory - 300 MB

<img src="/images/Pasted image 20261015144820.png" alt="image" width="500">

- Execution memory
	- Spark shuffles, joins, sorts, and aggregations
- Storage memory
	- Used for caching user data structures and partitions derived from DataFrames
- Map and shuffle operation configurations
	- Map, spill, and merge processes
- Tuning the shuffle service running on each executors can aid in increasing overall performance for large workloads

### Maximizing Spark Parallelism

- read and process as much data in parallel as possible
- A partition is a way to arrange data into a subset of configurable and readable chunks or blocks of contiguous data on disk
- At least as many partitions as there are cores on the executor

<img src="/images/Pasted image 20261015145305.png" alt="image" width="500">

#### How partitions are created

- By default, file blocks on data stores range in size from 64 MB to 128 MB
- Partitions are also created when you explicitly use certain methods of the DataFrame API


```scala
// In Scala
val ds = spark.read.textFile("../README.md").repartition(16)
ds: org.apache.spark.sql.Dataset[String] = [value: string]

ds.rdd.getNumPartitions
res5: Int = 16

val numDF = spark.range(1000L * 1000 * 1000).repartition(16)
numDF.rdd.getNumPartitions

numDF: org.apache.spark.sql.Dataset[Long] = [id: bigint]
res12: Int = 16
```

- Shuffle partitions
	- Created during the shuffle stage
- Wide transformations
	- `groupBy()`
	- `join()()`
	- Consume both network and disk I/O resources
- Scaling Spark for large workloads
	- Caching
	- Persisting frequently accessed DataFrames or tables

# Caching and Persistence of Data

- `cache()` and `persist()`
	- The latter provides more control over how and where data is stored
	- Serialized and unserialized

## DataFrame.cache()

- `cache()`
	- Store as many of the partitions read in memory across Spark executors as memory allows
	- DataFrames can be fractionally cached
	- Partitions cannot be fractionally cached

```scala
// In Scala
// Create a DataFrame with 10M records
val df = spark.range(1 * 10000000).toDF("id").withColumn("square", $"id" * $"id")
df.cache() // Cache the data
df.count() // Materialize the cache

res3: Long = 10000000
Command took 5.11 seconds

df.count() // Now get it from the cache
res4: Long = 10000000
Command took 0.44 seconds

```

- DataFrame is not fully cached until you invoke an action that goes through every record
- `take(1)` will only cache a portion of the data

<img src="/images/Pasted image 20261015173352.png" alt="image" width="500">

## DataFrame.persist()

- Data o disk is always serialized using either Java or Kryo serialization

<img src="/images/Pasted image 20261015173434.png" alt="image" width="500">

- Each `StorageLevel` has an equivalent `LEVEL_NAME_2`, which means replicate twise on two different Spark executors

```scala
// In Scala
import org.apache.spark.storage.StorageLevel

// Create a DataFrame with 10M records
val df = spark.range(1 * 10000000).toDF("id").withColumn("square", $"id" * $"id")
df.persist(StorageLevel.DISK_ONLY) // Serialize the data and cache it on disk
df.count() // Materialize the cache

res2: Long = 10000000
Command took 2.08 seconds

df.count() // Now get it from the cache 
res3: Long = 10000000
Command took 0.38 seconds
```

- Data is persisted on disk, not in memory
- Also cache the tables or views derived from the DataFrames

```scala
// In Scala
df.createOrReplaceTempView("dfTable")
spark.sql("CACHE TABLE dfTable")
spark.sql("SELECT count(*) FROM dfTable").show()

+--------+
|count(1)|
+--------+
|10000000|
+--------+

Command took 0.56 seconds
```

## When to Cache and Persist

- Access a large data set repeatedly for queries or transformations
	- DataFrames commonly used during iterative ML training
	- DataFrames accessed commonly for doing frequent transformations during ETL or building data pipelines

## When Not to Cache and Persist

- DataFrames that are too big to fit in memory
- An inexpensive transformation on a DataFrame not requiring frequent use, regardless of size

- Incur resource costs in serializing and deserializing

# A Family of Spark Joins

- Join tranformations
	- Inner joins
	- Outer joins
	- Left joins
	- Right joins
- All these operations trigger a large amount of data movement across Spark executors
- Shuffle
	- `groupBy()`
	- `join()`
	- `agg()`
	- `sortBy()`
	- `reduceByKey()`
- 5 distinct join strategies
	- Exchanges
	- Moves
	- Sorts
	- Groups
	- Merges
- Broadcast hash join (BHJ)
- Shuffle hash join (SHJ)
- Shuffle sort merge join (SMJ)
- Broadcast nested loop join (BNLJ)
- Shuffle and replicated nested look join (Cartesian product join)

## Broadcast Hash Join

- Also known as map-side-only join
	- Broadcast hash join is employed when two data sets, one small and another large enough to ideally be spared from movement, need to be joined
	- Smaller data set is broadcasted by the drivers to all Spark executors
	- Avoids large data exchange

<img src="/images/Pasted image 20261015174201.png" alt="image" width="500">

- Default use a broadcast join if the smaller data set is less than 10 MB
- Broadcast hash join is the easiest and fastest join Spark offers
	- Does not involved any shuffle od data set
	- All data is available locally to executor
	- Need enough memory on both the Spark driver's and the executors' side to hold the smaller data set in memory

### When to use a broadcast hash join

- When each key within the smaller and large data set is hashed to the same partition by Spark
- When on dataset is much smaller than the other
- When you only want to perform an equi-join, to combine two data sets based no matching unsorted keys
- When you are not worried by excessive network bandwidth usage or OOM errors

## Shuffle Sort Merge Join

- Efficient way to merge two large datasets over a common key that is sortable, unique, and can be assigned to or stored in the same partition
- Data is colocated or exchanged between executors
- 2 phases
	- Sort phase followed by a merge phase

```scala
// In Scala
import scala.util.Random
// Show preference over other joins for large data sets
// Disable broadcast join
// Generate data
...
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "-1")

// Generate some sample data for two data sets
var states = scala.collection.mutable.Map[Int, String]()
var items = scala.collection.mutable.Map[Int, String]()
val rnd = new scala.util.Random(42)

// Initialize states and items purchased
states += (0 -> "AZ", 1 -> "CO", 2-> "CA", 3-> "TX", 4 -> "NY", 5-> "MI")
items += (0 -> "SKU-0", 1 -> "SKU-1", 2-> "SKU-2", 3-> "SKU-3", 4 -> "SKU-4", 
    5-> "SKU-5")

// Create DataFrames
val usersDF = (0 to 1000000).map(id => (id, s"user_${id}",
    s"user_${id}@databricks.com", states(rnd.nextInt(5))))
    .toDF("uid", "login", "email", "user_state")
val ordersDF = (0 to 1000000)
    .map(r => (r, r, rnd.nextInt(10000), 10 * r* 0.2d,
    states(rnd.nextInt(5)), items(rnd.nextInt(5))))
    .toDF("transaction_id", "quantity", "users_id", "amount", "state", "items")

// Do the join 
val usersOrdersDF = ordersDF.join(usersDF, $"users_id" === $"uid")

// Show the joined results
usersOrdersDF.show(false)

+--------------+--------+--------+--------+-----+-----+---+---+----------+
|transaction_id|quantity|users_id|amount  |state|items|uid|...|user_state|
+--------------+--------+--------+--------+-----+-----+---+---+----------+
|3916          |3916    |148     |7832.0  |CA   |SKU-1|148|...|CO        |
|36384         |36384   |148     |72768.0 |NY   |SKU-2|148|...|CO        |
|41839         |41839   |148     |83678.0 |CA   |SKU-3|148|...|CO        |
|48212         |48212   |148     |96424.0 |CA   |SKU-4|148|...|CO        |
|48484         |48484   |148     |96968.0 |TX   |SKU-3|148|...|CO        |
|50514         |50514   |148     |101028.0|CO   |SKU-0|148|...|CO        |
|65694         |65694   |148     |131388.0|TX   |SKU-4|148|...|CO        |
|65723         |65723   |148     |131446.0|CA   |SKU-1|148|...|CO        |
|93125         |93125   |148     |186250.0|NY   |SKU-3|148|...|CO        |
|107097        |107097  |148     |214194.0|TX   |SKU-2|148|...|CO        |
|111297        |111297  |148     |222594.0|AZ   |SKU-3|148|...|CO        |
|117195        |117195  |148     |234390.0|TX   |SKU-4|148|...|CO        |
|253407        |253407  |148     |506814.0|NY   |SKU-4|148|...|CO        |
|267180        |267180  |148     |534360.0|AZ   |SKU-0|148|...|CO        |
|283187        |283187  |148     |566374.0|AZ   |SKU-3|148|...|CO        |
|289245        |289245  |148     |578490.0|AZ   |SKU-0|148|...|CO        |
|314077        |314077  |148     |628154.0|CO   |SKU-3|148|...|CO        |
|322170        |322170  |148     |644340.0|TX   |SKU-3|148|...|CO        |
|344627        |344627  |148     |689254.0|NY   |SKU-3|148|...|CO        |
|345611        |345611  |148     |691222.0|TX   |SKU-3|148|...|CO        |
+--------------+--------+--------+--------+-----+-----+---+---+----------+
only showing top 20 rows
```


- Spark UI shows 3 stages for the entire job
	- `Exchange`
	- `Sort`
	- `Merge`

<img src="/images/Pasted image 20261015174836.png" alt="image" width="500">

### Optimizing the shuffle sort merge join

- Eliminate the `Exchange` step from this schema if we create partitioned buckets for common sorted keys or columns on which w want to perform frequent equi-joins
- Create an explicit number of buckets to store specific sorted columns
- Pre-sorting and reorganizing data in this way boosts performance

```scala
// In Scala
import org.apache.spark.sql.functions._
import org.apache.spark.sql.SaveMode

// Save as managed tables by bucketing them in Parquet format
usersDF.orderBy(asc("uid"))
  .write.format("parquet")
  .bucketBy(8, "uid")
  .mode(SaveMode.OverWrite)
  .saveAsTable("UsersTbl")

ordersDF.orderBy(asc("users_id"))
  .write.format("parquet")
  .bucketBy(8, "users_id")
  .mode(SaveMode.OverWrite)
  .saveAsTable("OrdersTbl")

// Cache the tables
spark.sql("CACHE TABLE UsersTbl")
spark.sql("CACHE TABLE OrdersTbl")

// Read them back in
val usersBucketDF = spark.table("UsersTbl")
val ordersBucketDF = spark.table("OrdersTbl")

// Do the join and show the results
val joinUsersOrdersBucketDF = ordersBucketDF
    .join(usersBucketDF, $"users_id" === $"uid")

joinUsersOrdersBucketDF.show(false)
```

- The joined output is sorted by `uid` and `users_id`
	- Saved the tables sorted in ascending order

### When to use a shuffle sort merge join

- When each key within two large data sets can be sorted and hashed to the same partition by Spark
- When you want to perform only equi-joins to combine two datasets based on matching sorted keys
- When you want to prevent `Exchange` and `Sort` operations to save large shuffles across the network

- Boost performance of a shuffle sort merge join operations by using bucketing to avoid large exchanges of data
# Inspecting the Spark UI

- Details on memory usage, jobs, stages, tasks
- Timelines, logs, and various other metrics
- `spark-submit`
	- Launch the Spark UI
	- Connect to it on the local host or through the Spark driver

## Journey Through the Spark UI Tabs'

<img src="/images/Pasted image 20261015175621.png" alt="image" width="500">

### Jobs and Stages

- Spark breaks an application down into jobs, stages, and tasks
- View completion status and review metrics related to IO, memory consumption, duration of execution
- Event Timeline
	- Executors were added to or removed from the cluster
	- Tabular list of all completed jobs in the cluster
	- Duration column

<img src="/images/Pasted image 20261015175804.png" alt="image" width="500">

- Stages tab
	- Provides a summary of the current state of all stages of all jobs in the application
	- Access a details page for each stage, with DAG, and metrics on its tasks
	- Garbage collection (GC)
	- Number of shuffle bytes/records read
- High Shuffle Read Blocked Time
	- IO issues
- High GC time
	- Too many objects on the heap
- Stage's max task tie is larger than the median
	- Data skew caused by uneven data distributions in partitions

<img src="/images/Pasted image 20261015180020.png" alt="image" width="500">

- See aggregated metrics for each executor and a breakdown of the individual tasks on this page

### Executors

- Provides information on the executors created for the application
- View how memory is used by each individual executor, and for what purpose
- Examine resource usage when you have used the `cache()` or `persist()` method

<img src="/images/Screenshot 2026-10-15 at 6.01.08 PM.png" alt="image" width="500">
### Storage

<img src="/images/Screenshot 2026-10-15 at 6.03.41 PM.png" alt="image" width="500">
<img src="/images/Screenshot 2026-10-15 at 6.03.45 PM.png" alt="image" width="500">

### SQL

- Spark SQL queries that are executed as part of your Spark application are traceable and viewable through the SQL tab

<img src="/images/Pasted image 20261015180515.png" alt="image" width="500">

- Description of a query displays details of the execution plan with all the physical operators
### Environment

<img src="/images/Pasted image 20261015180609.png" alt="image" width="500">

### Debugging Spark Applications

