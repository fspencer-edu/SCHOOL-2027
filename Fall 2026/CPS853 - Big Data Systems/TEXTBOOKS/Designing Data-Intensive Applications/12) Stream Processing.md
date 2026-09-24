- Batch processors must artificially divide the data into chunks of fixed duration
- Stream processing
	- Data that is incrementally made available over time
- Event streams
	- Unbounded, incrementally processed counterpart to batch data

# Transmitting Event Streams

- In a stream processing context, a record is known as an event
	- Small self contained, immutable object containing the details of something that happened at a point in time
	- Event may be encoded as text string, JSON, or binary form
	- Append to file, insert to relational table, or write to a document database
- Event is generated once by a producer (published/sender) and processed by multiple consumers (subscribers/recipients)
- Related events are group together in a topic of stream
- Relational databases use triggers
	- React to change

## Messaging Systems

- Messaging system
	- A producers sends a message containing the event and is pushed to consumers
- Flow control
	- Blocks the producer from sending more messages to the subscriber
		- Backpressure
	- Queued
- Offline nodes

### Direct messaging from producers to consumers

- UDP multicast
	- Stock market feeds
- Brokerless messaging libraries
	- ZeroMQ
	- Nanomsg
- StatD
	- Collection agents
- Webhooks
	- Consumer exposes a service on the network
	- Procedures can make a direct HTTP or RPC request
### Message brokers

- Message broker/queue
	- Database that is optimized for handling message streams
- Consumers are asynchronous
### Message brokers compared to databases

- Two phase commit protocols using XA or JTA
	- Keep data until explicitly deleted
	- Secondary indexes

### Multiple consumers

- Load balancing
	- Each message is delivered to one of the consumers
	- Messages are expensive to process
- Fan out
	- Each message is delivered to all the consumers

<img src="/images/Pasted image 20260923195926.png" alt="image" width="500">

- Combined load balancing and fan out
	- Consumer groups in Kafka

### Acknowledgments and redelivery

- Acknowledgements
	- A client must explicitly tell the broker when it has finished processing a message to be remove from queue
- Redelivery
	- Wasted resources
	- Resource starvation
	- Permanent blockages in a stream
- Dead letter queues (DLQs)
	- Message is moved to a different queue to unblock consumers

## Log-Based Message Brokers

- AMQP/JMS message brokers
	- Transient messaging
	- Delete messages after they have been delivered
- Databases and filesystems
	- Permanently record a log
- Log based message brokers

### Using logs for message storage

<img src="/images/Pasted image 20260923200437.png" alt="image" width="500">

- Within each shard (partition), the broker assigns a monotonically increasing sequence number or offset to every message
### Logs compared to traditional messaging

- Log based approach supports fan out messaging
	- Several consumers can independently read the log
	- Broker assign entire shards to nodes in the consumer group instead of assigning individual messages to consumer clients
### Consumer offsets

- Log sequence number
	- Follower can reconnect to a leader after being disconnected and resume replication
### Disk space usage

- Log is divided into segments
- Old segments are deleted or moved to archive storage
- Log implements a bounded size buffer that discards old messages when it gets full
	- Circular buffer
	- Ring buffer
### When consumers cannot keep up with producers

### Replaying old messages

# Databases and Streams

## Keeping Systems in Sync

- Update
	- Database
	- Cache
	- Search indexes
	- Data warehouse
- Dual write
	- Application code explicitly writes to each of the systems when the data changes
	- Race conditions
	- Fault tolerance problems

## Change Data Capture

- Change data capture (CDC)
	- The process of observing all data changes written to a database and extracting them in a form in which they can be replicated to other systems

<img src="/images/Pasted image 20260923201656.png" alt="image" width="500">
### Implementing CDC

- Derived data system
	- Data stored in the search index and data warehouse is just a view onto the data in the system
- CDC ensures all changes are also reflected in the derived data systems
- Source connectors
- CDC is asynchronous
	- The system or record database does not wait for a change to be applied to consumers before committing it
### Initial snapshot

- DBlog watermarking algorithm
	- Provides incremental snapshots
### Log compaction

- Log compaction
	- Storage engines periodically looks for log records with the same key
	- Removes duplicate
	- Keeps most recent updates for each key
	- Merges segments

<img src="/images/Pasted image 20260923202029.png" alt="image" width="500">

- Update with a null value (tombstone) indicates that a key was deleted and is removed during log compaction
- Rebuild a derived data system
	- Start a new consumer from offset 0
	- Sequentially scan over all messages in the log

### API support for change streams

### CDC vs. Event sourcing

- CDC
	- Application uses the database in mutable ways
		- Updating and deleting
		- Avoids race conditions by extracting logs in order of write
- Event sourcing
	- Built on immutable events that are written to an event log
	- Append only
	- Events are designed to reflect changes on the application level rather than low level state change

- Outbox pattern
	- Decouple internal from external schemas
	- Outboxes are tables with their own schema and exposed to the CDC system rather than the internal domain model in the database
	- Outboxes keep both write in the same system
		- Allows both writes to appear in a single transaction
	- Increases data that the database has to write to storage
- Log compaction for CDC
	- Log compaction can discard previous events for the same key
- Event sourcing
	- Events are modeled at a higher level

## State, Streams, and Immutability

- Changelog
	- Represents the evolution of state over time

<img src="/images/Pasted image 20260923202950.png" alt="image" width="500">

### Advantages of immutable events

- Help to diagnose bugs
- Capture more information that the current state
### Deriving several views from the same event log

### Concurrency control

- Downside of CQRS is that the consumers of the event log are asynchronous
	- User cloud make a write to the long
	- Read from a derived view and not see the changes
- Perform the updates of the read view synchronously with appending the event to the log
### Limitations of immutability

- Excision/shunning
	- Rewrite history and pretend that the data was never written
- Crypto shredding
	- Data that will be deleted is stored encrypted, and then loss the encryption key
- Puncturable encryption

# Processing Streams

- Processing streams to produce other derived streams
	- Operator or a job
- A stream processor consumes input streams in a read-only fashion and writes its output to a different location

## Uses of Stream Processing

- Monitoring purposes
	- Fraud detection
	- Trading systems
	- Manufacturing systems
	- Military and intelligence

### Complex event processing

- Complex event processing (CEP)
	- Analyzing event streams
	- Event patterns (regular expressions)
	- Specify rules to search for certain patterns of events in a stream
	- High level declarative query language
- Complex event
- Queries are stored long-term
- When an event arrives, the engine checks whether it has now seen an event pattern that matches any of its standing queries
	- Esper
	- Apama
	- TIBCO StreamBase
### Stream analytics

- Measuring the rate of a ertain type of event
- Calculating the rolling average of a value over a time period
- Comparing current statistics to previous time intervals

- Probabilistic algorithm
	- Bloom filters for set membership
	- HyperLogLog for cardinality estimation
	- Percentile estimation algorithms
- Produce approximate results

### Maintaining materialized views

- Stream of changes to a database can be used to keep derived data systems up to date
- Materialized view maintenance
	- Poor efficiency
		- All data is reprocessed every time the view is updated
	- Data freshness
		- Changes in source data are not reflected in a materialized view until its query is run again, during its next update

- Incremental view maintenance (IVM)
	- Convert queries written in SQL into operators capable of incremental computations
	- Ingest streams of events to expose materialized views in real time

### Search on streams

- Queries are stored, and documents are evaluated again every query
- Index the queries and documents to narrow the set of matches
### Event driven architectures and RPC

- Actor framework is a managing concurrency and distributed execution of communicating modules
- Stream processing is primarily a data management technique
- Communication between actors is often ephemeral and one-to-one
- Event logs are durable and multi-subscriber
- Actors can communicate in different ways
	- Cyclic request/response
- Stream processors are acyclic pipelines

- Distributed RPC
	- Allows user queries to be farmed out to a set of nodes that also process event streams
	- Queries are interleaved with events from the input streams

## Reasoning About Time

- Timestamps
	- Allows the processing to be deterministic
	- Running the same process on the same input produces the same result
- Processing time
	- Determines windowing
	- Used if creation and event processing is negligibly short
	- Breaks if there is processing lag

### Event time vs. processing time

### Handling straggler events

- Straggler events
	- Ignore
	- Publish a correction later
### Whose clocks are you using, anyway?

- Log offline device clocks
	- Time that the event occurred
	- Time that the event was sent to the server
	- Time that the event was received by the server

- Offset between the device clock and server clock = 3rd timestamp from 2nd timestamp
- Apply offset to event timestamp to estimate the true time

### Types of windows

- Defining windows
	- Count events or to calculate the average of values within the window
- Tumbling window
	- Fixed length
	- Every event belongs to one window
- Hopping windows
	- Fixed length
	- Overlap between consecutive windows to provide smoothing
- Sliding windows
	- Contains all the events that occur within a certain interval
- Session windows
	- Has no fixed duration
	- Defined by grouping together all events for the same user that occur closely together in time

- Window operations maintain temporary state

## Stream Joins

- Stream-stream joins
- Stream-table joins
- Table-table joins

### Stream-stream join (window join)

- Combines events from two independent continuous data streams in real time using a shared key and a defined time window
### Stream-table join (stream enrichment)

- Enriching the activity events with information from the database
- Hash join
	- Load a copy of the database into the stream processor so that it can be queries locally without a network round trip
- Batch job uses a point-in-time snapshot of the database as input
- Stream processor is a long running and database can change overtime

### Table-table join (materialized view maintenance)

- Combines data from two separate database tables into a single result set using a shared related column
	- INNER JOIN
	- LEFT (OUTER) JOIN
	- RIGHT (OUTER) JOIN
	- FULL (OUTER) JOIN
### Time dependence of joins

- All joins require the stream processor to maintain a state derived from one join input and to query that state from the other input
- Slowly changing dimension (SCD)
	- Addressed by using a unique identifier for a particular version of the joined record
	- Deterministic join
	- Log compaction is not possible

## Fault Tolerance

- Exactly-once semantics

### Microbatching and checkpoint

- Batch size is typically around one second
- Smaller batches incur greater scheduling and coordination overhead
- Larger batches result in longer delay
- Provides a tumbling window equal to the batch size
- Jobs that require larger windows are carry over state
- Another approach is to periodically generate rolling checkpoints of state and write to durable storage
### Atomic commit revisited

- Implementations do not provide transactions across heterogeneous databases
- Keep the transactions internal by managing both state changes and messaging within the stream processing framework
### Idempotence

- An idempotent operation is one that you can perform multiple time and has the same effect as if you performed it only once
- Deleting a key in a key value store
- Made idempotent with extra metadata
	- Monotonically increasing offset
- Restarting a failed task must replay the same message in the same order
- Processing must be deterministic
- Fencing
### Rebuilding state after a failure

- Keep the state in a remote datastore and replicate it
- Keep state local to the stream processor and replicate it periodically
- Can be rebuild from input streams