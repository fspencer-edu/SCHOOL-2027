# Transmitting Event Streams

## Messaging Systems

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
