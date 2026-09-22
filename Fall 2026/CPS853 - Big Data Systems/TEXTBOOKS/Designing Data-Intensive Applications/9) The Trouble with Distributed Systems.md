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
- Guaranteed to always move forward
- A server with multiple CPU sockets, may have separate timer per CPU (and may not be synchronized)
- NTP may adjust the frequency at which the monotonic clock moves forward (slewing the lock)

## Clock Synchronization and Accuracy

- Quartz clock
	- Drifts depending on temperature of machine
- Firewalled node from NTP server
- Network congestion with NTP
- NTP servers are misconfigured
- Leap seconds
- VM hardware clock is virtualized
- Precision Time Protocol (PTP)

## Relying on Synchronized Clocks

- Any nodes whose clock drifts too far from the others should be declared dead and removed

### Timestamps for ordering events

- Last write wins (LWW)
	- Keep the write with the greatest timestamp for a given key
- Avoid additional round trop and use client clock's timestamp
- Database write can disappear
- Cannot distinguish between writes that occurred sequentially and concurrent
- Two nodes can independently generate writes with the same timestamp
- Logical clocks
	- Based on incrementing counters are safer for alternative for ordering events
	- Do not measure time of day or number of seconds
	- Only relative ordering of events
- Physical clocks
	- Time of day and monotonic clocks
### Clock reading with a confidence interval

- TrueTime API in Google Spanner
- Amazon ClockBound
- Get earliest and latest possible timestamp for a time interval
### Synchronized clocks for global snapshots

- MVCC
	- Allows read-only transactions to see a snapshot of the database
	- A consistent state at a point in time, without locking and interfering with read/write transactions
- Monotonic increasing transaction ID
- A global monotonic increasing ID is difficult to generate and coordinate
- Use clock's confidence interval
	- In doubt if intervals overlap
	- Waits for the length of the confidence interval before committing a read/write transaction
	- Clock uncertainty as small as possible
	- Atomic clock in each datacenter

## Process Pauses

- Leader objects a lease from the other nodes
	- Similar to a lock with a timeout
	- Node can hold the least at any one time until expired or renewed
- Reasons a thread is paused
	- Contention among threads accessing a shared resource
		- Lock or queue
	- Garbage collection that stops all running threads (JVM)
	- VM can be suspended and resumed
		- Live migration
			- One host to another without a reboot
	- End user devices may be suspended
	- OS system context switches to another thread
	- Synchronous disk access
	- OS swaps to disk (paging)
	- Unix process is paused with `SIGSTOP` signal


- All of these occurrences can preempt the running thread at any point and resume later, without the thread noticing
- Tools for thread-safety
	- Mutexes
	- Semaphores
	- Atomic counters
	- Lock-free data structures
	- Blocking queues

### Providing response time guarantees

- Real time systems
	- Software must respond by a specified deadline
- Real time operating system (RTOS)
	- Allows processes to be scheduled with a guaranteed allocation of CPU time in specified intervals
	- Documents worst-case executions
	- Restricts or disallows dynamic memory allocation

### Limiting the impact of garbage collection

- Java runtime GC
	- Concurrent mark sweep (CMS)
	- Garbage first (G1)
	- Z garbage collector (ZGC)
	- Epsilon
- Swift
	- Uses automatic reference counting to determine when memory can be freed
	- No GC
- Rust and Mojo
	- Track object lifetimes via the type system
- Objects can be stored and reused in pools rather than discarded
- Data can be allocated off-heap
- Treat GC as a planned outage of a node
- Use the GC for only short live objects (fast to collect) and restart processes periodically

# Knowledge, Truth, and Lies

- Distributed systems
	- No shared memory
	- Message passing via an unreliable network with variable delays
	- Partial system failures
	- Unreliable clocks
	- Processing pauses
- System model
	- State the assumption and design the system that meets those assumptions

## The Majority Rules

- A distributed system cannot exclusively rely on a single node
- Distributed algorithms rely on a quorum (voting among nodes)
- Decision require a minimum number of votes from several nodes to reduce the dependence on one node
- Absolute majority of more than half the nodes
## Distributed Locks and Leases

- Locks and leases in distributed applications are prone to misuse
- Client 1 believes that it still has a valid lease, even though it has expired, and results in a corrupt file
- A message from a former leaseholder might be delayed for a long time and arrive after another node has taken over the lease
### Fencing with multiple replicas

- Zombie
	- A former leaseholder that has not found out that it lost the least
	- Ensure they cannot do damage with split brain
	- Fencing off the zombie
- Shoot the other node in the head (STONITH)
	- Does not protect against the large network delays
- Making access to storage safe by allowing writes only in the order of increasing fencing tokens
	- Sequencers
	- Epoch numbers
- Consensus algorithms
	- Ballot number
	- Term number
- Conditional writes (Amazon S3)
- Conditional headers (Azure Blob Storage)
- Request preconditions (Cloud Storage)

### Fencing with multiple replicas

- Do not need lock service if clients write to only one storage service that supports conditional writes
- Put the writer's fencing token in the most significant bits or digits of the timestamp
	- Used to protect writes to a leaderless replicated database

## Byzantine Faults

- Fencing tokens can detect and block a node that is inadvertently acting in error
- A node that casts multiple contradictory votes int he same election
- Problem of reaching consensus in an untrusting environment is a Byzantine Generals Problem
	- Generalization of the two generals problem
	- n generals need to agree
	- Traitors confuse the other by sending fake or untrue messages

### Uses of Byzantine fault tolerance

- Byzantine fault tolerant
	- Continues to operate correctly if some nodes are malfunctioning and not obeying the protocol
	- Attackers interfering with the network
- CPU register corrupted by radiation
- A system with multiple participating parties
- Multitenant systems have mutally untrusting tenants
	- Isolated from one another via firewalls, virtualizations, and access control polices
- Web applications
	- Input validation
	- Sanitization
	- Output escaping
	- Preventing SQL injection
	- Cross site scripting
- Byzantine fault tolerant algorithms require a supermajority of more than two-thrids of the nodes
### Weak forms of lying

- Invalid messages dur to hardware issues
- Software bugs
- Misconfiguration

- Corrupt network packets
	- Checksums in application level protocol
- Sanitize user input
	- SQL injection attacks
	- Denial of service through large memory allocation

## System Model and Reality

- Algorithms must be written in a way that does not depend too heavily on the details of the hardware and software configuration
- System model
	- Abstraction that describes an algorithm's assumptions
- Synchronous model
	- Assumes bounded network delay
	- Clock drift, pauses, and delay will never exceed a fixed upper bound
- Partially synchronous model
	- Sometimes exceeds the bounds for network delay
- Asynchronous model
	- Not allowed to make any timing assumptions

- Common system models
	- Crash stop faults
		- Nodes can only fail in one way
	- Crash recovery faults
		- Assume that nodes may crash at any moment
		- Nodes have stable storage, but in memory state is lost
	- Degraded performance and partial functionality
		- Nodes may slow down
	- Byzantine (arbitrary) faults
		- Nodes my trick and deceive other nodes

### Defining the correctness of an algorithm
### Distinguishing between safety and liveness
### Mapping system models to the real world
## Formal Methods and Randomized Testing

### Model checking and specification languages
### Fault injection

### Deterministic simulation testing

