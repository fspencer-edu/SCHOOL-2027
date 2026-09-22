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
- Queued at the sender from TCP limits

- TCP detects and automatically retransmits a lost packet
- Video chat and Voice over IP (VoIP) use UDP
	- Does not perform flow control and retransmit lost packets
	- Delayed data
	- More reliable

### Variability of network delays

- Choose timeouts experimentally
	- Measure the distribution of network round-trip times over an extended period, and over machines
	- Determine trade off between failure detection delay and risk or premature timeouts
- Systems can measure response times and their variability (jitter) and adjust timeouts according to the observed response time distribution
	- Phi Accrual failure detector

## Synchronous vs. Asynchronous Networks

- Telephone networks establish a circuit
	- A fixed, guaranteed amount of bandwidth along the entire route of two users
	- Synchronous
	- Data passes through routers, and does not suffer from queueing
	- Bounded delay

### Can we not simply make network delays predictable?

- Packets of a TCP connection opportunistically use available network bandwidth
- Ethernet and IP are. packet switched protocols
	- Unbounded delays
	- Optimized for bursty traffic
		- Adapts the rate of data transfer to the available network capacity
		- Consequence of dynamic resource partitioning
		- Maximizes utilization of the write
- If resources are statically partitioned there can be latency guarantees
	- Reduced utilization
### Combining circuit switching and packet switching

- Asynchronous Transfer Mode (ATM)
	- Support both circuit and packet switching
- Quality of service (QoS)
	- Prioritization
	- Scheduling of packets
	- Admission control
- New network algorithms
	- Low Latency
	- Low loss
	- Scalable Throughput (L4S)
	- TC (Linux's traffic controller)

# Unreliable Clocks

- Timeouts
- Queries per second
- Time user spent on site
- Published
- Data and time to send
- Expire of cache entry
- Timestamp on error message

- Durations
- Points in time

- Each machine on the network has its own clock
	- Quartz crystal oscillator (not accurate)
- Network Time protocol (NTP)
	- Computer clocks adjust according to the time reported by a group of servers
	- Server gets time from GPS received

## Monotonic vs. Time-of-Day Clocks

- Time of day clock
- Monotonic clock

### Time-of-day clocks

- Returns current data and time
- Synchronized with NTP
### Monotonic clocks

- Suitable for measuring duration (time intervals)
	- Timeout
	- Service response times
- 

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

