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

![[Pasted image 20260923195926.png]]

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

![[Pasted image 20260923200437.png]]

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

![[Pasted image 20260923201656.png]]
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

![[Pasted image 20260923202029.png]]

- Update with a null value (tombstone) indicates that a key was deleted and is removed during log compaction
- Rebuild a derived data system
	- Start a new consumer from offset 0
	- Sequentially scan over all messages in the log

### API support for change streams

### CDC vs. Event sourcing

- C
## State, Streams, and Immutability

### Advantages of immutable events
### Deriving several views from the same event log
### Concurrency control
### Limitations of immutability

# Processing Streams

## Uses of Stream Processing

### Complex event processing
### Stream analytics
### Maintaining materialized views
### Search on streams
### Event driven architectures and RPC
## Reasoning About Time

### Event time vs. processing time
### Handling straggler events
### Whose clocks are you using, anyway?
### Types of windows

## Stream Joins

### Stream-stream join (window join)
### Stream-table join (stream enrichment)
### Table-table join (materialized view maintenance)
### Time dependence of joins

## Fault Tolerance

### Microbatching and checkpoint
### Atomic commit revisited
### Idempotence

### Rebuilding state after a failure
