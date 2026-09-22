# Faults and Partial Failures

- Single computer hardware errors are deterministic
- Long lived network partitions
	- Single data center (DC)
	- Power distribution unit (PDU) failures
	- Switch failures
	- Power cycles of whole racks
	- Whole-DC backbone failures
- Partial failure
	- Non deterministic
- Distributed systems must deal with partial failures
	- Rolling upgrades
	- Rebooting one node
# Unreliable Networks

- Shared nothing systems
	- Machines connected by a network
	- Use replication across separate machines for redundancy
- Internet and most internal networks are asynchronous packet networks
	- Lost request
	- Waiting in queue
	- Failed remote node
	- Temporarily stopped
	- Response is lost
	- Response is delayed
- Timeout
	- Give up waiting and assume response has not arrived

## The Limitations of TCP

 - Network packets have a max size (kb)
 - Transmission Control Protocol (TCP)
	 - Establish a connection that breaks large data streams into individual packets and assembles them on the receiving side
- Alternative transport protocols
	- QUIC
	- Stream Control Transmission Protocol (SCTP)
	- BitTorrent uTP protocol
- Congestion control, flow control, backpressure

- TCP cannot tell if the outbound packet or the acknowledgement was lost
- TCP's deduplication and retransmission capabilities apply to only a single connection

## Network Faults in Practice

- Network partition (netsplit)
	- Part of the network is cut off from the rest from a network fault
## Fault Detection

- Load balancer stops sending requests to a dead node
- In a single-leader replication, if leader fails, one of the followers is promoted
## Timeout and Unbounded Delays

- When a node is dead, its responsibilities need to be transferred to other nodes
	- If false negative, can cause a cascading failure
- Asynchronous networks have unbounded delays
	- Deliver packets as quickly as possible, with no upper limit on time

### Network congestion and queuing

- Network congestion
	- Queued in incoming data
- Queued in OS
- Queued in buffered VM monitor
- Queued at the sender from TCP limi
### Variability of network delays

## Synchronous vs. Asynchronous Networks

### Can we not simply make network delays predictable?
### Combining circuit switching and packet switching
# Unreliable Clocks

## Monotonic vs. Time-of-Day Clocks

### Time-of-day clocks
### Monotonic clocks

## Clock Synchronization and Accuracy

## Relying on Synchronized Clocks

### Timestamps for ordering events
### Clock reading with a confidence interval
### Synchronized clocks for global snapshots

## Process Pauses

### Providing response time guarantees
### Limiting the impact of garbage collection

# Knowledge, Truth, and Lies

## The Majority Rules
## Distributed Locks and Leases

### Fencing with multiple replicas

## Byzantine Faults

### Uses of Byzantine fault tolerance
### Weak forms of lying

## System Model and Reality

### Defining the correctness of an algorithm
### Distinguishing between safety and liveness
### Mapping system models to the real world
## Formal Methods and Randomized Testing

### Model checking and specification languages
### Fault injection

### Deterministic simulation testing

