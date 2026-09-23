
- Eventual consistency
	- Used with multi=leader and leaderless replication
- Strong consistency
	- Application should not worry about internal detail of replication
	- Act as a single node
	- Performance cost
# Linearizability

- Linearizability (atomic consistency, strong consistency, immediate consistency, external consistency)
	- Make a system appear as if there is only one copy of the data, and all operations are atomic
	- All clients reading from the database must be able to see the value just written
	- Guarantee that the value read is the most recent
		- Recency guarantee

## What Makes a System Linearizable?

- After any one read has returned the new value, all following reads must also return the new value
- CAS (Compare and set) operation

<img src="/images/Pasted image 20260922141634.png" alt="image" width="500">

- Test systems linearizability
	- Record the timings of all requests and responses and check if they can be arranged into a valid sequential order

- Serializability
	- Isolation level of transactions
	- Every transaction may read and write multiple objects
- Linearizability
	- Guarantee on reads and writes of a register (individual object)
	- Does not group operations together into transaction
	- Recency guarantee

- Strict serializability or strong one-copy serializability (strong-1-SR)
	- Database provides both serializability and linearizability
- Single nodes are linearizable
- Distributed database use optimistic methods like SSI (serializable snapshot isolation)

## Relying on Linearizability

### Locking and leader election

- Single leader replication needs to ensure that there is indeed only one leader, not several (split brain)
- Use a lease to elect a leader
	- The node that successfully acquires a lease wins
- Oracle Real Application Clusters (RAC)
	- Use a lock per disk page
	- Multiple nodes sharing access to the same disk storage system
### Constraints and uniqueness guarantees

- Loose constraints
- Hard uniqueness constraint
	- Relational databases
	- Requires linearizability
### Cross-channel timing dependencies

<img src="/images/Pasted image 20260922142657.png" alt="image" width="500">

- Two communication channels between the web server and the transcoder
	- File storage
	- Message queue
## Implementing Linearizable Systems

- Single leader replication (potentially linearizable)
	- Assumes the leader is known
- Consensus algorithm (likely linearizable)
	- Single leader replication with automatic leader election and failover
	- Allows reads on a node without checking that it is still the leader
- Multi-leader replication (not linearizable)
	- Concurrently process writes on multiple nodes
	- Asynchronously replicate to other nodes
- Leaderless replication (probably not linearizable)
	- LWW are non-linearizable because clock timestamps cannot be guaranteed to be consistent with actual event ordering because of clock skew
	- Dynamo-style quorums for linearizable, but reduced performance

## The Cost of Linearizability

- Network partition on multi-leader database
	- Each region can continue operating normally
	- Writes are queued up and exchanges with network is restored
- On single leader
	- Clients connected to follower region cannot contact the leader (unavailable)
	- Make stale reads

### The CAP theorem

- Requires linearizability
	- Some replicas are disconnected from the other replicas because of the network problem
	- Consistent under network partitions (CP)
- Does not require linearizability
	- Each replica can process requests independently, even if disconnected
	- Remain available
	- Available under network partitions (AP)

- PACELC principle
	- System designed might choose to weaken consistency when network is up to reduce latency
	- During partition (P) choose between availability (A) and consistency (C)
	- Else (E), where there is no partition, choose between latency (L) and consistency (C)

- CAP
	- Consistency, availability, partition tolerance
	- Pick two out of three
	- Either consistent of available when partitioned
### Linearizability and network delays

- RAM on a modern multi-core CPU is not linearizable
	- Every CPU core has its own memory cache and store buffer
# ID Generators and Logical Clocks

- In single node databases it is common to use an auto-incrementing integer
- Fetch and add operation
- Use atomic increment instruction on CPI
- Not fault-tolerant
- Slow for a record in another region
- Single node could become a bottleneck

- Alternative options for ID generators
	- Sharded ID assignment
		- Only even or odd numbers
	- Preallocated blocks of IDs
		- Each node can independently hand out IDs from its block
		- Does not ensure correct ordering
	- Random UUIDs
		- Universally unique identifiers (UUIDs)
		- Also known as globally unique identifiers (GUIDs)
		- Generated locally without communication
		- Requires more space (128 but)
	- Wall clock timestamp made unique
		- Correct NTP
- Reduce ordering inconsistencies by relying on high precision clock synchronization

## Logical Clocks

- Logical clock
	- An algorithm that counts the events that have occurred
	- Compares two timestamps from a logical clock
	- Timestamps are compact and unique
	- Order is consistent with causality
		- Yes for single node ID generators
		- Not for distributed ID generators

### Lamport timestamps

- Lamport clock
	- A simple method for generating logical timestamps is consistent with causality
	- Do not provide linearizability
	- Assign IDs to events and determines their order
	- A pair of (counter, node ID)

<img src="/images/Pasted image 20260922151354.png" alt="image" width="500">

- Timestamp order
	- (1, “Aaliyah”) < (1, “Caleb”) < (2, “Bryce”)

### Hybrid logical clocks

- Limitations of Lamport timestamps
	- No direct relation to physical time
	- If two nodes never communicate, one node's counter increments will never be reflected in the other
- Hybrid logical clock
	- Counts seconds or ms
	- When one node sees a timestamp from another that is greater, it moves it own logical value forward to match their timestamp
	- Timestamp from a time-of-day clock with a ordering property

### Lamport/hybrid logical clocks vs. vector clocks

- When multiple timestamps are generated concurrently, they are not in order
- Vector clock
	- Keeps a counter for each mode and stores all the counter values with each write
## Linearizable ID Generators

### Implementing a linearizable ID generator

- Single node for ID assignment that is linearizable
	- Atomically increment a counter and return its value
	- Persist the counter value
	- Replicate for fault tolerance
- Avoid performing a disk write and replication on every single request
- ID generator can write a record describing a batch of IDs
	- Node can then hand out Ids to clients in sequence
- Google's Spanner
	- Synchronized clocks for global snapshots
	- Relies on a physical clock that returns a range of timestamps

### Enforcing constraints using logical clocks

# Consensus

- The standard formulation of consensus involves getting multiple nodes to agree on a single value
- Consensus algorithms
	- Viewstamped Replication
	- Paxos
	- Raft
	- Zab
- Non-Byzantine system model
	- Network communication may be arbitrary delayed or dropped, but assume correct behaviour
- Byzantine tolerant nodes
	- Used in blockchains
- FLP result
	- Proves no algorithm is always able to reach consensus if there is a risk that a node may crash
	- Assumes a deterministic algorithm
	- Cannot use clocks or timeouts

## The Many Faces of Consensus

Consensus can be expressed as:

- Single value consensus
	- Locks, leases, and uniqueness constraints
- Append only log
	- Formalized as total order broadcast
	- State machine replication, leader-based replication, event sourcing
- Fetch and add (atomic increment)
- Atomic commitment
	- Requires all participant agree on whether to commit or abort the transaction

- All are equivalent
- Convert an algorithm into a solution for any of the others
### Single-value consensus

- One or mode nodes may propose values
- Consensus algorithm decides on one of those value

- A consensus algorithm must satisfy
	- Uniform agreement
		- No two nodes decide differently
	- Integrity
		- Cannot change the value after decision has been made
	- Validity
		- If a node decides value v, then v was proposed by a node
	- Termination
		- Every node that does not crash eventually decides a value

- Termination property assumes that fewer than half of the nodes are unreachable

### Compare and set (CAS) as consensus

- Set all object to a null value
- Any CAS invocations whose proposed value was not decided returns an error, and submits again

### Shared logs as consensus

- Log entries
- Shared log
	- Multiple nodes can request that entries be appended
	- Can request that a value be added to the log
	- Can read the entries in the log
		- Eventual append
		- Reliable delivery
		- Append only
		- Agreement
		- Validity

- Implemented using a total order broadcast protocol (atomic broadcast or total multicast protocol)
- Every nodes want to propose a value requests that it be added to the log
- The value that is read back is the decided one
- CAS and shared logs solve consensus for any number of nodes ($∞$)

### Fetch and add on consensus

- Fetch and add operation
	- Atomically increments a counter and returns the old counter value
	- Read the counter value, perform CAS, and the new value is that value + 1
	- Less efficient than native fetch and add operation with contention
- Consensus problem for two nodes

### Atomic commitment as consensus

- Atomic commitment problem
	- Ensure that the databases or shards involved in a distributed transaction all either commit or abort a transaction
- Atomic commitment requires the following
	- Uniform agreement
	- Integrity
	- Validity
	- Non-triviality
		- If all nodes vote to commit, and no communication timeouts occur, then all nodes must commit
	- Termination

## Consensus in Practice

- Single-value consensus, CAS, shared logs, and atomic commitment are all equivalent
### Using shared logs

- A shared log is used for databased replication
- Every log entry represents a write to the database
- Every replica processes the same write in the same order by deterministic logic
- All replicas have consistent data
- State machine replication
- Transactions are serializable

### From single-leader replication to consensus

- Epoch number
	- Also called ballot number, view number, and term number
	- Guarantee that within each epoch, the leader is unique
- Leader with the highest epoch number wins
- 2 rounds of voting
	- Choosing a leader
	- Vote on a leader's proposal for the next entry to append to the log (quorum)

### Subtleties of consensus

- A vote by a quorum of nodes elects a leader, and then another quorum vote is requires for every entry that the leader wants to make
- Ensures that the new leader honours any log entries already appended by the older leader before fail
	- New leader is up to date with any confirmed log entries
- Weaken the consensus properties to recover from a leader failure more quickly
	- Unclean leader election (Kafka)
		- Allows any replica to become leader
- Assume a fixed set of nodes
- Reconfiguration features
	- More or less nodes during system migration
### Pros and cons of consensus

- Consensus algorithms always require a strict majority to operate
- Every operation requires a quorum
- If there is a network partition, only the alive nodes are available to vote
- Rely on timeouts to detect failed nodes
- Sensitive to network problems

## Coordination Services

- Coordination services
	- ZooKeeper
	- etcd
	- Consul
- Not designed for high write volumes or general purpose data storage
- Designed to coordinate among nodes of another distributed system
	- Kubernetes uses etcd
	- Spark and Flink use ZooKeeper
- Modeled after Google's Chubby lock service
	- A consensus algorithm with several other fatures
		- Locks and leases
		- Support for fencing
		- Failure detection
		- Change notification
- Configuration parameters
	- Timeouts
	- Thread pool sizes
### Allocating work to nodes

- A coordination service is useful for single-leader databases and job schedular of other stateful systems
- Sharded resource and data assignment
- Use of atomic operations, ephemeral nodes, and notifications in the coordination service
	- Apache Curator
- Not intended to store data that may change thousands of times per second
- Better to use a conventional database a replicate the fast changing internal state
### Service discovery

- Service discovery
	- Find IP address to connect to
- Caches may also be refreshed periodically using time-to-live (TTL) confuration
