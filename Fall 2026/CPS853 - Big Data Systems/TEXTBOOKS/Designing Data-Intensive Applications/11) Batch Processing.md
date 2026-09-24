
- Online systems
	- Requesting a page on the web
	- Service calling a remote API
	- Databases
	- Caches
	- Search indexes
- Offline systems
	- Process larger amounts of data
	- Batch processing jobs
- Takes input and produces output data
- Does not mutate data like a read/write
- Output is derived from the input
- Time travel
	- Roll back to previous versions
	- Minimizing irreversibility
- Data integration
	- Composing multiple data systems to achieve things that one system alone cannot do
	- ETL
- An alternative to batch processing is stream processing
	- The job does not finish running when it has processed the input
	- Continues watching the input and processes changes in the input

- Batch processing
	- MapReduce
		- Batch processing algorithm from Google
		- Implemented in Hadoop, CouchDB, and MongoDB
- Modern frameworks
	- Spark
	- Flink
	- Warehouse query engines
	- Rely on shading, parallel execution, caching, and execution strategies
- Job and workflow orchestration
	- Oozie
	- Azkaban
- Batch storage layers in cloud computing are changing from distributed filesystems (DFSs) like HDFS (Hadoop Distributed File system) to object storage systems like S3

# Batch Processing with Unix Tools

## Simple Log Analysis

- Read log file
- Split each line into fields
- Alphabetically sort the list of requested URLs
- `uniq` filter out repeated lines
- Sort by number
- Print `head` outputs

## Chain of Commands vs. Custom Program

```python
from collections import defaultdict

counts = defaultdict(int) 

with open('/var/log/nginx/access.log', 'r') as file:
    for line in file:
        url = line.split()[6] 
        counts[url] += 1 

top5 = sorted(((count, url) for url, count in counts.items()),
              reverse=True)[:5] 

for count, url in top5:  
    print(f"{count} {url}")
```
## Sorting vs. In-Memory Aggregation

- Working set
	- Memory to which the job needs random access

# Batch Processing in Distributed Systems

- Unix tools for processing log data
	- Storage devices that are accessed through the OS filesystem
	- Schedular that determines when processes get to run and how to allocate CPU resouces
	- A series of Unix programs whose standard input and standard output are connected by pipes

## Distributed Filesystems

- Layers of OS
	- Block device drivers speak to the disk and allow the layers above to read and write raw blocks
	- Page cache that keeps recently accessed blocks in memory
	- Block API is wrapped in a filesystem layer that breaks large files into blocks and tracks metadata
	- OS exposes filesystems to application through API called virtual filesystem (VFS)

- Most physical storage devices cannot write partial blocks
- OS requires writes to use an entire block

- DFS blocks are read by network requests to a machine in a cluster
- Each machine runs a daemon, with an API to read and write blocks as files as a remote process
	- Data nodes
- Reads and writes go through each data nodes's OS
- ext4 and XFS
	- Keeps track of storage metadata
		- Free space
		- File block locations
		- Directory structures
		- Permission settings
- DFS must expose a protocol or interface so that batch processing can read and write file
- POSIX-compliant filesystems
- Filesystem in Userspace (FUSE) or the Network File System (NFS) protocol are used to integrate into VFS
- Amazon Elastic File System (EFS) and Archil
	- Provide NFS compatible distributes filesystem implementations
- Erasure coding
	- Allows lost data to be recovered with lower storage overhead than full replication
	- Reed-Solomon

## Object Stores

- Amazon S3
- Google Cloud Storage
- Azure Blob Storage
- OpenStack Swift

- FUSE drivers allow users to treat object stores such as S3 as a filesystem

- Each object in an object store has a URL
	- Bucket
	- Object key
- Objects are read using a `get` call and written using a `put`
- Objects are immutable once written

- DFS
	- Hard links
	- Symbolic links
	- File locking
	- Atomic renames
- HDFS
	- Allow computing tasks to run on the machine that stores a copy of the file

## Distributed Job Orchestration

- Batch processing frameworks send a request to an orchestrator's schedular to run a job
	- Number of tasks to execute
	- Amount of memory, CPU, and disk needed for each task
	- A job identifier
	- Access creditials
	- Job parameters
		- Input and output data
	- Required hardware details
	- Location of job's executable code
- Task executors
	- NodeManager (YARN)
	- Kubelet (Kubernetes)
	- Running a job tasks, sending heartbeat to signal their liveness, and tracking task status and resource allocation on the node
	- Monitors the process
	- Work with OS to provide security and performance isolation
		- cgroup
- Resource manager
	- Stores metadata about each node
		- Hardware availability
		- Task statuses
		- Network location
		- Node status
- Scheduler
	- Centralized subsystem which receives requests to start, stop, or check on the status of a job

### Resource allocation

- Gang scheduling
	- Run all of one job's task, then the second
- Starvation
	- Cluster does not have resources for a long time
- Preempt
	- Kill some of the first's job tasks for the second job
- NP-hard
	- Slow to calculate an optimal solution for all but the smallest examples
- Schedulers use heuristics to make non-optimal, but reasonable decisions
	- FIFO
	- Dominant resource fairness (DRF)
	- Priority queues
	- Capacity or quota-based
	- Bin-packing

### Scheduling workflows

- Output from one job needs to become the input to one or more other jobs
- Workflow or directed acyclic graph (DAG)
- Workflow schedulers have management features that are useful when maintaining a large collection of batch jobs
- Handles dependencies between job executions
### Handling faults

- Spot instances (Amazon EC2)
- Spot virtual machines (Azure)
- Preemptible instances (Google Cloud)

- Preemption during on task priority levels
- MapReduce
	- Execution of parallel tasks are independent
	- Writes intermediate data back to the DFS and waits before the next task is able to read it

# Batch Processing Models

- MapReduce and dataflow engines have evolved into
	- Low-level programmatic APIs
	- relational query languages
	- DataFrame APIs

## MapReduce

- Read a set of input fields and break it into records
	- Saved in Parquet or Avro
- Call the mapper function to extract a key and value from each input
- Sort all the key-value pairs
- Call the reducer to iterate over
	- Combine overlapping keys
- Mapper
	- Called once for every input record
	- Extract the key and value from the record
	- Run in parallel on different parts of input
	- Prepare the data by putting it into a form that is suitable for sorting
- Reducer
	- Takes the key-value pairs by mappers, collects all values belonging to the same key
	- Produces output records
	- Process the data that has been sorted

- File based IO prevents job pipelining

## Dataflow Engines

- Spark and Flink
	- Handle an entire workflow as one job
	- Support low level API that repeatedly calls a user-defined function to process on record at a time
	- Higher level operators
		- Join
		- Group by
	- Use relational style building blocks to express a computation
		- Joining
		- Grouping
		- Filtering
		- Aggregating
		- Summing
- Operations are implemented using the shuffle algorithms
	- Expensive work is performed only in places where it is required
	- Several operators that do not change the sharding of the dataset can be combined
	- Optimize from explicitly declared data dependencies in a workflow
	- Intermediate states can be kept in memory or written to local disk
	- Operators can start executing when input is ready
	- Existing processes can be reused to run new operators, reducing startup overheads compared to MapReduce
## Shuffling Data

- Shuffle
	- Produces a sorted order, with no randomness
	- Used in batch processors
		- Joins and aggregations

<img src="/images/Pasted image 20260923183104.png" alt="image" width="500">

- Two mappers output with the same key are processed by the same reducer task
- Each mapper creates a separate output file on its local disk for every reducer
- Log structured storage
	- Batches of key-value pairs are first collected in a sorted data structure in memory, then written out as sorted segment files, and smaller segments files are progressively merged into larger ones

## Join and Grouping

- Shuffle brings together all the key-value pairs with the same key to the same reducer
- Secondary sort
	- Sort data by a primary key and then a secondary key
	- Optimize data grouping and reduce memory overhead
	- Sorted by mapper, and in reducer
- Sort merge join
	- An algorithm that first sorts two large datasets by a shared join key and then merges them by scanning both sorted streams simultaneously

<img src="/images/Pasted image 20260923183718.png" alt="image" width="500">
## Querying Languages

- BigQuery
	- DataFrame library
- Snowflake
	- Snowpark library
## DataFrames

- A DataFrame is similar to a table in a relational database
	- Collection of rows
	- Values in the same column have the same type
	- Users call functions corresponding to relational operators to perform operations
- Local DF are usually indexed and ordered
- Distributed DF are not

# Batch Use Cases

## Extract-Transform-Load (ETL)

- A data processing pipeline extracts data from a production database, transforms it, and loads the results into a downstream system
- Workflow schedulers, orchestrators, and debug ETL data pipeline jobs
- Data mesh, data contract, and datafabric
	- Practices provide standards and tools to help teams safely publish data for consumption
## Analytics

- Data lakehouse
	- Architecture that combines the flexible, low cost storage of a data lake with the reliability, governance and query performance of a data warehouse
- Pre aggregation queries
	- Data is rolled up into OLAP cubes or data marts to speed up queries
	- Queried in the warehouse or pushed to a purpose build real time OLAP system
		- Druid
		- Pinot
	- take place at a scheduled interval
- Ad hoc queries
	- Queries that answer specific business, operational, and user behaviour
## Machine Learning

- Feature engineering
	- Raw data is filtered and transformed into data that models can be trained on
- Model training
	- The training data is the input to the batch process
	- Weights of the trained model are the output
- Batch interference
	- Make predication in bulk if datasets are large and real time results are not required

- Apache Spark's MLlib
- Apache Flink's FlinkML
- ML applications such as recommendation engines and ranking systems also use graph processing
- Bulk synchronous parallel (BSP)
	- Batch processing graph
	- Apache Giraph
	- Spark's GraphX API
	- Flink's Gelly API
	- Pregel model
- Batch processing frameworks
	- Kubeflow
	- Flyte
	- Ray
- Libraries
	- PyTorch
	- TensorFlow
	- XGBoost

## Serving Derived Data

- Batch jobs push precomputed datasets to streams
- Streaming systems are optimized for sequential writes
- Streaming systems can act as a buffer between the batch job and the production databases
- The output of a single batch job can be consumed by multiple downstream systems
- Demilitarized zone (DMZ)
	- Between batch processing and production network
- Batch jobs must send notifications to downstream systems that the job is finished and can be served
- Bulk import tools
	- TiDB's Lightning
	- Apache Pinot's Hadoop import jobs
	- Build a brand-new database inside the batch job and bulk load files directly into the database from a DFS
- 