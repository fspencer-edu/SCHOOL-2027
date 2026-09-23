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
- 

### Direct messaging from producers to consumers
### Message brokers
### Message brokers compared to databases

### Multiple consumers
### Acknowledgments and redelivery

## Log-Based Message Brokers

### Using logs for message storage
### Logs compared to traditional messaging
### Consumer offsets
### Disk space usage

### When consumers cannot keep up with producers
### Replaying old messages


# Databases and Streams

## Keeping Systems in Sync

## Change Data Capture

### Implementing CDC
### Initial snapshot
### Log compaction
### API support for change streams
### CDC vs. Event sourcing
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
