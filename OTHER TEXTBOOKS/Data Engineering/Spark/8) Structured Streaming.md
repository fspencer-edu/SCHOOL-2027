
- Data arrives continuously and needs to be processed in a real-time manner
# Evolution of the Apache Spark Stream Processing Engine

- Stream processing systems transitioned from single-node processing engines to multiple-node, distributed processing engines
- Record-at-a-time processing model

<img src="/images/Pasted image 20261015201610.png" alt="image" width="500">

- Not efficient at recovering from node failures and straggler nodes
- Either recover from a failure very fast with a lost of extra failover resources, or use minimal extra resources but recover slowly

## The Advent of Micro-Batch Stream Processing

- Streaming computation is modeled as a continuous series of small, map/reduce-style batch processing jobs on small chunks of the stream data

![[Pasted image 20261016094825.png]]

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

![[Pasted image 20261016095403.png]]

- Structured Streaming will automatically convert this batch-like query to a streaming execution plan
- Incrementalization
	- Structured Streaming figures out what state needs to be maintained to update the result each time a record arrives
	- Each time a trigger fires, Structured Streaming checks for new data and incrementally updates the results

![[Pasted image 20261016095553.png]]

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

![[Pasted image 20261016105918.png]]

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

- Restarted query will apply the filter on all

# Streaming Data Sources and Sings
# Data Transformations
# Stateful Streaming Aggregations
# Streaming Joins
# Arbitrary Stateful Computations

# Performance Tuning