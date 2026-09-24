# Data Integration

- Storage engines
	- Log structured
	- B-trees
	- Column oriented storage
- Replication
	- Single-leader
	- Multi-leader
	- Leaderless approaches

## Combining Specialized Tools by Deriving Data

- Common to need to integrate an OLTP database with a full-text search index in order to handle queries for arbitrary keywords
- Keep data in analytical systems
- Maintain caches or denormalized versions of objects
- Pass data through ML, classification, ranking, or recommendation systems

### Reasoning about dataflows

### Derived data vs. distributed transactions

- Distributed transactions
	- An atomic commit protocol
- Log based
	- Deterministic retry and idempotence
### The limits of total ordering

- Limitations of systems at scale
	- Throughput through a single leader
	- Geographically distributed regions
	- Microservices
	- Client-side state and offline application
- Total order broadcast
	- Deciding total order of events
	- Consensus algorithms
### Ordering events to capture causality

- Logical timestamps can provide total ordering without coordination
- Log events to record the state of the system
- Conflict resolution algorithms

## Batch and Stream Processing

- Consuming inputs
- Transforming
- Joining
- Filtering
- Aggregating
- Training models
- Evaluating
- Writing to outputs

- Stream processors operate on unbounded datasets
- Batch process inputs have an finite size

### Maintaining derived state

- Batch processing
	- Immutable inputs and outputs
- Stream processing
	- Managed, fault tolerant state

- Secondary indexes often cross shard boundaries
	- Send writes to multiple shards or send reads to all shards
	- Reliable on asynchronous systems

### Reprocessing data for application evolution

- Stream processing
	- Changes in the input are reflected in derived views with low delay
- Batch processing
	- Large amounts of historical data can be reprocessed in order to derive new views onto a dataset

- Gradual evolution
	- Restructure a dataset
	- Do not perform migration as a sudden process

### Unifying batch and stream processing

- Lambda architecture
	- Early proposal for unifying batch and stream processing
- Kappa architecture
	- Batch computation and stream computation implemented in the same system

- Ability to replay historical events through the same processing engine that handles the stream of recent events
	- Log based message brokers
- Exactly once semantics for stream processors
- Tools for windowing by event time, not by processing time

# Unbundling Databases

- Store some data, and process and query that data
- Filesystems
	- Cannot handle many small files
- Unix
	- Low-level hardware abstraction
- Relational databases
	- High level abstraction of data structures on disk, concurrency, crash recovery

## Composing Data Storage Technologies

- Secondary indexes
	- Efficiently search for records based on the value of a field
- Materialized views
	- Precomputed caches of query results
- Replication logs
	- Copies of the data on other nodes
- Full text search indexes
	- Keyword search in text
	- Build in some relational databases

### Creating an index

 - Reprocesses the existing database and derives the index as a new view onto the existing dataset
### The meta-database of everything

- Federated databases (unifying reads)
	- Also known as polystore
	- Foreign data wrapper (PostgreSQL)
	- Applications that needs a specialized data model or query interface can access the underlying storage engines directly
	- Users that want to combine data can use a federated interface
		- High level language with complicated implementation
	- Read only querying
- Unbundled databases (unifying writes)
	- Small tools that communicate through a uniform low-level API (pipes)
	- Composed using a higher level language

### Making unbuilding work

- Loose coupling in log based integration
	- Asynchronous event streams
	- Easier to deploy, improve, and maintain software components
### Unbundled vs. integrated systems

## Designing Applications Around Dataflow

### Application code as a derivation function

- A secondary index is a kind of derived dataset with a straightforward transformation function
- A full text search index is created by applying various NLP functions
	- Language detection
	- Word segmentation
	- Stemming or lemmatization
	- Spelling correction
	- Synonym identification
	- And building a data structure for efficient lookups (inverted index)
- ML model is derived from the training data after various feature extraction and statistical analysis functions
- Cache contains an aggregation of data in the form in which it is going to be displayed in UI
### Separation of application code and state

- Deployment and cluster management tools
	- Kubernetes
	- Docker
	- Mesos
	- YARN
- Most web applications are deployed stateless services
- Observer pattern
	- Reader of the variable do not get notified of the change

### Dataflow: Interplay between state changes and application code

- Log based message brokers
	- Order of state change
	- Fault tolerance
### Stream processors and services

- Service oriented architecture has loose coupling
- Dataflow approach is faster than service architecture
	- Uses database query and caching to get state instead of processing a query
	- Subscribing to a stream of changes

## Observing Derived State

- Write path
	- When a piece of information is written, it can go through multiple stages of batch and stream processing

![[Pasted image 20260924102944.png]]

- Read path
	- Read from the derived dataset

### Materialized views and caching

- Precompute the search results for only a fixed set of most common queries
	- Serve quickly without having to go to the index
- Caches, indexes, and materialized views shift the boundary between the read path and the write path
### Stateful, offline, capable clients

- Cache of state on the server
- Pixels on the screen are a materialized view of the model objects in the client app
- Model objects are the local replica of state in a remote datacenter

### Pushing state changes to clients

- Communication channels by which a web browser can keep an open TCP connection to a server
	- Server-sent events
	- WebSockets
- Consumer offsets help during offline changes
	- Log based message broker can reconnect and update changes
### End-to-end event streams

### Reads are events too

- Possible to represent read requests as streams of events and send both the read events and the write events through a stream processor
- Stream-table join
### Multi-shard data processing

- Treating queries as streams provides an option for implementing large-scale applications that run against the limits of conventional solutions

# Aiming for Correctness

## The End-to-End Argument for Databases

### Exactly-once execution of an operation

- Exactly once
	- Arranging the computation such that the final effect is the same as if no faults had occurred
### Duplicate suppression

- TCP
	- Uses sequence numbers on packets to put them in the correct order at the recipient and to determine whether any packets where lost or duplicated
- 2PC breaks the one-to-one mapping between a TCP connection and a transaction
	- Uses transaction coordinator
### Uniquely identifying requests

### End-to-end argument

- Suppressing duplicate transactions
- Transaction identifier
	- End user to database
### Applying end-to-end thinking in data

- 

## Enforcing Constraints
### Uniqueness constraints require consensus
### Uniqueness in log-based messaging
### Multi-shard request processing
## Timeliness and Integrity

### Correctness of dataflow systems
### Loosely interpreted constraints
### Coordination-avoiding data systems

## Trust, but Verify

### Maintaining integrity in the face of software bugs
### Don't just blindly trust what they promise
### Designing for auditability
### The end-to-end argument again
### Tools for auditable data systems

