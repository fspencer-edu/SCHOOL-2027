
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
- Spot virtual machines 
- Preemptible instances (Google Cloud)

# Batch Processing Models

## MapReduce
## Dataflow Engines
## Shuffling Data

## Join and Grouping
## Querying Languages
## DataFrames

# Batch Use Cases

## Extract-Transform-Load
## Analytics
## Machine Learning
## Serving Derived Data