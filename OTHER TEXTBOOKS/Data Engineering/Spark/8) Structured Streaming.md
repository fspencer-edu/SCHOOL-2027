
- Data arrives continuously and needs to be processed in a real-time manner
# Evolution of the Apache Spark Stream Processing Engine

- Stream processing systems transitioned from single-node processing engines to multiple-node, distributed processing engines
- Record-at-a-time processing model

<img src="/images/Pasted image 20261015201610.png" alt="image" width="500">

- Not efficient at recovering from node failures and straggler nodes
- Either recover from a failure very fast with a lost of extra failover resources, or use minimal extra resources but recover slowly

## The Advent of Micro-Batch Stream Processing

- Streaming computation is modeled as a continuous series of small, map/reduce-style batch processing jobs on small chunks of the stream data

<img src="/images/Pasted image 20261016094825.png" alt="image" width="500">

- Breaks down the streaming computation into these small tasks
- Two advantages over continuous operator model
	- Quickly and efficiently recover from failures and straggler executors by rescheduling one or more copies of the task on any of the other executors
	- Deterministic nature of the task ensures that the output data is the same no matter how many times the task is re-executed
- Achieves latencies of a few seconds (slower)
- Pipeline does not need latencies lower than a few seconds
- There are larger delay in other parts of the pipeline
- DStream API was built upon Spark's batch RDD API
	- Same functional semantics and fault tolerance model as RDD

## Lessons Learned from Spark Streaming (DStreams)

- Lack of a single API for batch and stream processing
- Lack of separation between logical and physical plans
- Lack of native support for event time windows

## The Philosophy of Structured Streaming

- A single, unified programming model and interface for batch and stream processing
- A broader definition of stream processing
# The Programming Model of Structured Streaming

- Structured Streaming extends this concept to streaming applications by treating a stream as an unbounded, continuously appended table

<img src="/images/Pasted image 20261016095403.png" alt="image" width="500">

- Structured Streaming will automatically convert this batch-like query to a streaming execution plan
- Incrementalization
	- Structured Streaming figures out what state needs to be maintained to update the result each time a record arrives
	- Each time a trigger fires, Structured Streaming checks for new data and incrementally updates the results

<img src="/images/Pasted image 20261016095553.png" alt="image" width="500">

- Write output incrementally
	- Append mode
	- Update mode
	- Complete model

# The Fundamentals of a Structured Streaming Query

## 5 Steps to Define a Streaming Query

### Step 1 - Define input sources

- In batch data sources, `spark.read` creates a `DataFrameReader`
- In streaming sources, `spark.readSTream` creates a `DataStreamReader`

```python
# In Python
spark = SparkSession...
lines = (spark
  .readStream.format("socket")
  .option("host", "localhost")
  .option("port", 9999)
  .load())
```

- Only sets up the configuration for reading the data once the streaming query is started
- A streaming query can define multiple input sources, both streaming and batch

### Step 2 - Transform Data

```python
# In Python
from pyspark.sql.functions import *
words = lines.select(explode(split(col("value"), "\\s")).alias("word"))
counts = words.groupBy("word").count()
```

- `counts`
	- Streaming DataFrame that represents the running word counts that will be computed once the streaming query is started and the streaming input data is being continuously processed
- Two broad classes of data transformations
	 - Stateless transformations
		 - `select(), filter(), map()`
		 - Do not require any information from previous rows to process the next row
		 - Each row can be processed by itself
	 - Stateful transformations
		 - `count()`
		 - Requires maintaining state to combine data across multiple rows
		 - Any DataFrame operations involving grouping, joining, or aggregation are stateful

### Step 3 - Define output sink and output mode

- Define how to write the processed output data with `DataFrame.writeStream`
- Creates a `DataStreamWriter`
	- Has additional methods to specify the following
		- Output writing details
		- Processing details

```python
writer = counts.writeStream.format("console").outputMode("complete")
```

- Append mode
	- Only the new rows added to the result table/DataFrame since the last trigger will be output to the sink
	- Any row that is output is never going to be changed or updated by the query in the future
- Complete mode
	- All the rows of the result table will be output at the end of every trigger
	- Result table is much smaller than the input data and can be retained in memory
- Update mode
	- Only the rows of the result table that were updated since the last trigger will be output at the end of every trigger

- Structured Streaming natively supports streaming writes to files and Apache Kafka
- Write to arbitrary locations using the `foreachBatch()` and `foreach()` API methods
### Step 4 - Specify processing details

- Specify details of how to process the details

```python
# In Python
checkpointDir = "..."
writer2 = (writer
  .trigger(processingTime="1 second")
  .option("checkpointLocation", checkpointDir))
```

- Triggering details
	- Indicate when to trigger the discovery and processing of newly available streaming data
		- Default
			- Streaming query executes data in micro-batches where the next micro-batch is triggered as soon as the previous micro-batch has completed
		- Processing with the trigger interval
			- Specify the `ProcessingTime` trigger with an interval
		- Once
			- Streaming query will execute one micro-batch
			- Used with an external schedular
		- Continuous
			- Streaming query will process data continuously instead of in micro-batches
	- Checkpoint location
		- A directory in any HDFS compatible filesystem where a streaming query sabes its progress information

### Step 5 - Start the query

```python
# In Python
streamingQuery = writer2.start()
```

- `start()`
	- Is a nonblocking method
	- Return as soon as the query has started in the background

### Putting it all together

- Reading streams of text data over a socket, counting the words, and printing the counts to the console

```python
# In Python
from pyspark.sql.functions import *
spark = SparkSession...
lines = (spark
  .readStream.format("socket")
  .option("host", "localhost")
  .option("port", 9999)
  .load())

words = lines.select(explode(split(col("value"), "\\s")).alias("word"))
counts = words.groupBy("word").count()
checkpointDir = "..."
streamingQuery = (counts
  .writeStream
  .format("console")
  .outputMode("complete")
  .trigger(processingTime="1 second")
  .option("checkpointLocation", checkpointDir)
  .start())
streamingQuery.awaitTermination()
```

- After the query has started, a background thread continuously reads new data from the streaming source, processes it, and write it to the streaming sinks

## Under the Hood of an Active Streaming Query

- Sequence of steps transpires in the engine
- DataFrame operations are converted into a logical plan, which is an abstract representation for the computation that Spark SQL uses to plan a query
	- Spark SQL analyzes and optimizes this logical plan to ensure that it can be executed incrementally and efficiently on streaming data
	- Spark SQL starts a background thread that continuously executes the following loop
		- Based on configured triggers, the thread checks the streaming sources for the availability of new data
		- If available, the new data is executed by running a micro-batch
		- For every micro-batch, the exact range of data processed and any associated state are saved in the configured checkpoint location so that the query can deterministically reprocess the exact range if needed
	- Loop continues until the query is terminated
		- A failure
		- The query is explicitly stopped
		- Trigger is set to `once`

<img src="/images/Pasted image 20261016105918.png" alt="image" width="500">

- Using Spark SQL to execute the data
- The full power of Spark SQL's hyper-optimized execution engine is utilized to maximize the stream processing throughput, providing key performance advantages

## Recovering from Failures with Exactly-Once Guarantees

- To restart a terminated query in a completely new process, create a new `SparkSession`, redefine all the DataFrames, and start the streaming query on the final result using the same checkpoint location as the one used when the query was started
- Checkpoints have record-level information to track the data range the last incomplete micro-batch was processing
- End-to-end exactly once guarantees
	- Replayable streaming sources
	- Deterministic computations
	- Idempotent streaming sink
- Word count example does not provide exactly-once guarantees because the socket source is not replayable and the console sink is not idempotent
- Make minor modifications to a query between restarts
	- DataFrame transformations
		- Ignore lines that have corrupted bytes sequences that can crash the query
		- Add a filter in the transformation

```python
# In Python
# isCorruptedUdf = udf to detect corruption in string

filteredLines = lines.filter("isCorruptedUdf(value) = false")
words = lines.select(explode(split(col("value"), "\\s").alias("word"))
```

- Restarted query will apply the filter on all data processed since the restart

- Source and sink options
	- Not change the `host` and `port` options for the socket source if data is going to be sent to the host and port
- Processing details
	- Checkpoint location must not be changed between restarts

## Monitoring an Active Query

### Querying current status using StreamingQuery

- Query the current health of an active query using the `StreamingQuery` instance

#### Get current metrics using Streaming Query

- `lastProgress()`
	- Returns information on the last completed micro-batch
- `id`
	- Unique identifier tied to a checkpoint location
- `runId`
	- Unique identifier for the current (re)started instance of the query
- `numInputRows`
	- Number of input rows that were processed in the last micro-batch
- `inputRowsPerSecond`
	- Current rate at which input rows are being generated at the source
- `processedRowsPerSecond`
	- Current rate at which rows are being processed and written out by the sink
- `sources` and `sink`
	- Provides source/sink specific details of the data processed in the last batch
#### Get current Status using StreamingQuery.status()

- Provides information on what the background query thread is doing at this moment

### Publishing metrics using Dropwizard Metrics

- Spark supports reporting metrics via Dropwizard Metrics
- Allows metrics to be published to many popular monitoring frameworks
	- Ganglia
	- Graphite
- Set `spark.sql.streaming.metricsEnabled` to `true`
- Only a subset of the information available through `StreamingQuery.lastProgress()` is published through Dropwizard Metrics

### Publishing metrics using custom StreamingQuery  Listeners

- `StreamingQueryListener`
	- Event listener interface with which you can inject arbitrary logic to continuously publish metrics
	- Available only in Scala/Java
- Define custom listener
	- Start
	- Progress
	- Termination

```scala
// In Scala
import org.apache.spark.sql.streaming._
val myListener = new StreamingQueryListener() {
  override def onQueryStarted(event: QueryStartedEvent): Unit = {
    println("Query started: " + event.id)
  }
  override def onQueryTerminated(event: QueryTerminatedEvent): Unit = {
    println("Query terminated: " + event.id)
  }
  override def onQueryProgress(event: QueryProgressEvent): Unit = {
    println("Query made progress: " + event.progress)
  }
}

// In Scala
spark.streams.addListener(myListener)
```

- After adding listener, all events of streaming queries running on this `SparkSession` will start calling the listener's methods
# Streaming Data Sources and Sings

- Create DataFrames from streaming sources using `SparkSession.readStream()`
- Write output from a result DataFrame using `DataFrame.writeStream()`

## Files

- Structured Streaming supports reading and writing data streams to form files in the same formats as the ones supported in batch processing
	- Plain text
	- CSV
	- JSON
	- Parquet
	- ORC

### Reading from files

- Structured Streaming can treat files written into a directory as a data stream

```python
# In Python
from pyspark.sql.types import *
inputDirectoryOfJsonFiles =  ... 

fileSchema = (StructType()
  .add(StructField("key", IntegerType()))
  .add(StructField("value", IntegerType())))

inputDF = (spark
  .readStream
  .format("json")
  .schema(fileSchema)
  .load(inputDirectoryOfJsonFiles))
```

- Returned streaming DataFrame will have the specified schema
	- All the files must be of the same format
	- Each file must appear in the directory listing atomically
	- When there are multiple new files to process, it will select the files with the earliest timestamps

### Writing to fiels

- Structured Streaming supports writing streaming query output to files in the same formats as reads
- Only supports append mode
- Difficult to modify existing data files

```python
# In Python
outputDir = ...
checkpointDir = ...
resultDF = ...

streamingQuery = (resultDF.writeStream
  .format("parquet")
  .option("path", outputDir)
  .option("checkpointLocation", checkpointDir)
  .start())
```

- Specify the output directly directory as `start(outputDir)`
- Structured Streaming achieves end-to-end exactly once guarantees when writing to files by maintaining a log of the data files that have been written to the directly
- If you change the schema of the result DataFrame between restarts, then the output directly ill have data in multiple schemas
	- reconciled after

## Apache Kafka

- Apache Kafka is a popular publish/subscribe system that is widely used for storage of data streams
- Structured Streaming has built-in support for reading from and writing to Apache Kafka

### Reading from Kafka

- Use options to specify how to connect to the source

```python
# In Python
inputDF = (spark
  .readStream
  .format("kafka")
  .option("kafka.bootstrap.servers", "host1:port1,host2:port2")
  .option("subscribe", "events")
  .load())
```
### Writing to Kafka

- Structured Streaming expects the result DataFrame to have a few columns of specific names and types
- Write to Kafka in all 3 output modes
	- Complete mode is not recommended

```python
# In Python
counts = ... # DataFrame[word: string, count: long]
streamingQuery = (counts
  .selectExpr(
    "cast(word as string) as key", 
    "cast(count as string) as value")
  .writeStream
  .format("kafka")
  .option("kafka.bootstrap.servers", "host1:port1,host2:port2")
  .option("topic", "wordCounts")
  .outputMode("update")
  .option("checkpointLocation", checkpointDir)
  .start())
```
## Custom Streaming Sources and Sinks

- Read and write to storage systems that do not have built-in support in Structured Streaming

### Writing to any storage system

- `foreachBatch()`
	- Allows arbitrary operations and custom logic on the output of each micro-batch
- `foreach()`
	- Custom write logic on every row

#### Using foreachBatch()

- Specify a function that is executed on the output of every micr-batch of a streaming query
	- Takes a DataFrame or Dataset that has the output of a micro-batch and a unique identifier
- Use the connector's batch DataFrame support to write the output of each batch

```python
# In Python
hostAddr = "<ip address>"
keyspaceName = "<keyspace>"
tableName = "<tableName>"

spark.conf.set("spark.cassandra.connection.host", hostAddr)

def writeCountsToCassandra(updatedCountsDF, batchId):
    # Use Cassandra batch data source to write the updated counts
    (updatedCountsDF
      .write
      .format("org.apache.spark.sql.cassandra")
      .mode("append")
      .options(table=tableName, keyspace=keyspaceName)
      .save())
      
streamingQuery = (counts
  .writeStream
  .foreachBatch(writeCountsToCassandra)
  .outputMode("update")
  .option("checkpointLocation", checkpointDir)
  .start())
```

- `foreachBatch()`
	- Reuse existing batch data sources
		- Use existing batch data sources to write the output of streaming queries
	- Write to multiple locations
		- OLAP data warehouse and an OLTP database
		- Write the output DataFrame/Dataset multiple time
		- Cache the `batchOutputDataFrame`
			- Write it to multiple locations, then uncache it

```python
# In Python
def writeCountsToMultipleLocations(updatedCountsDF, batchId):
  updatedCountsDF.persist()
  updatedCountsDF.write.format(...).save()  # Location 1
  updatedCountsDF.write.format(...).save()  # Location 2
  updatedCountsDF.unpersist()
```

- Apply additional DataFrame operations
	- Many DataFrame API operations are not support on streaming DataFrames because Structured Stream does not support generating incremental plans to those cases
- Only provides at least once write guarantees

#### Using foreach()

- If `foreachBatch()` is not an option (batch data writer does not exist)
- Express your custom write logic
- Express the data writing logic by dividing it into three methods
	- `open()`
	- `process()`
	- `close()`

```python
# In Python
# Variation 1: Using function
def process_row(row):
    # Write row to storage
    pass

query = streamingDF.writeStream.foreach(process_row).start()  

# Variation 2: Using the ForeachWriter class
class ForeachWriter:
  def open(self, partitionId, epochId):
    # Open connection to data store
    # Return True if write should continue
    # This method is optional in Python 
    # If not specified, the write will continue automatically
    return True

  def process(self, row):
    # Write string to data store using opened connection
    # This method is NOT optional in Python
    pass

  def close(self, error):
    # Close the connection. This method is optional in Python
    pass

resultDF.writeStream.foreach(ForeachWriter()).start()
```

### Reading from any storage system

# Data Transformations

- Only the DataFrame operations that can be executed incrementally are supported in Structure Streaming
- Operations are broadly classified into stateless and stateful operations

## Incremental Execution and Streaming State

- Catalyst optimizer in Spark SQL converts all the DataFrame operations to an optimized logical plan
- Spark SQL planner recognizes that this is a streaming logical plan that needs to operate on continuous data streams
- Planner generates a continuous sequence of execution plans
- Plan processes only a chunk of new data from the input streams and possibly some intermediate

# Stateful Streaming Aggregations
# Streaming Joins
# Arbitrary Stateful Computations

# Performance Tuning