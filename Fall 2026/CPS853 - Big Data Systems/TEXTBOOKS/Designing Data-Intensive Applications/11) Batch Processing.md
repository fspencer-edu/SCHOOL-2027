
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
- DFSs must expose a protocol or interface so that batch processing can read and write file
- POSIX-compliant filesystems
	- 

## Object Stores
## Distributed Job Orchestration

### Resource allocation
### Scheduling workflows
### Handling faults

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