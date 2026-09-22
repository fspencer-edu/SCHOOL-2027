
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

![[Pasted image 20260922151354.png]]

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

- When multiple timestamps are generated concurrently, t
## Linearizable ID Generators

### Implementing a linearizable ID generator
### Enforcing constraints using logical clocks

# Consensus

## The Many Faces of Consensus

### Single-value consensus
### Compare and set as consensus

### Shared logs as consensus
### Fetch and add on consensus
### Atomic commitment as consensus
## Consensus in Practice
### Using shared logs
### From single-leader replication to consensus
### Subtleties of consensus
### Pros and cons of consensus

## Coordination Services

### Allocating work to nodes
### Service discovery
