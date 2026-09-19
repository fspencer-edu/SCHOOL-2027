- Replication means keeping a copy of the same data on multiple machines that are connected via a network
	- Keep data geographically close to users
		- Reduce latency
	- Allow system to continue to work if some parts fail
		- Availability and durability
	- Scale out the number of machines

3 families of algorithms for replication

1) Single leader
2) Multi leader
3) Leaderless


- Almost all distributed databases use one of these approaches
- Synchronous or asynchronous replication
- Eventual consistency
- Read-your writes
- Monotonic reads
- Replicas
	- Reflect writes from one node on other nodes
- Backups
	- Store old snapshots of the data

# Single-Leader Replication

 - Each node that stores a copy f the database is called a replica
 - Every write to the database needs to be processed by every replica
 - Also called leader-based, primary-backup, or active/passive replication

1. One replicas is the leader
2. Other replicas are followers
	1. When the leader writes new data, it creates a replication log or change stream
	2. Each follower takes the log from the leader and updates their copy
3. A client reads from the database from either the leader or any followers
	1. Write are accepted only by leader

<img src="/images/Pasted image 20260917143950.png" alt="image" width="500">

- If the database is sharded, each shard has one leader
- Built-in feature of may relational databases
	- PostgreSQL
	- MySQL
	- Oracle Data Guard
	- MongoDB
	- Kafka
	- Raft
	- RabbitMQ

## Synchronous vs. Asynchronous Replication

<img src="/images/Screenshot 2026-09-17 at 2.41.18 PM.png" alt="image" width="500">

- Synchronous
	- Leader waits until follower 1 has confirmed, before reporting success to the user
	- Follow is guaranteed to have an up to data copy
	- If follower does not respond, then write cannot be processed
- Asynchronous (nonblocking)
	- Leader sends the message, but does not wait for a response from the follower
	- Leader can continue processing writes, if followers are behind
- Semi-synchronous
	- Only one synchronous and the others are asynchronous
- Quorum
	- A majority of replicas are updated synchronous, and remaining are asynchronous
	- Consensus protocol for automatic leader election
## Setting Up New Followers

1. Take a consistent snapshot of the leader's database
	1. Without locking entire database
2. Copy snapshot to new follower node
3. Follower node connects the leader and requests all data changes
	1. Snapshot is associated with an exact position in the leader's replication log
		1. Log sequence number
		2. Bin log coordinates
		3. Global transaction identifiers (GTIDs)
4. Caught up when follower has processed the backlog of data changes

- Object storage
	- Inexpensive to other cloud storage options
	- Multi-zone, dual region, or multi-region replication with high durability guarantees
	- Conditional write features
	- Compare-and-set (CAS) operation
		- Implement transactions and leadership election
	- Store data from multiple databases
	- Higher read and write latencies than disks or virtual block devices (Amazons ABS)
	- Objects are immutable
	- Do not offer standard filesystem interface
		- Filesystem in userspace (FUSE)
		- Lack POSIX features
			- Non-sequential writes
			- Symlinks
- Tiered storage
	- Place less frequently accessed data on object storages, while new or frequently accessed data on faster storage devices
- Zero-disk architecture (ZDA)
	- Persist all data to object storage and use disks and memory strictly for caching
	- Allows nodes to have no persistent state
		- WarpStream
		- Confluent Freight
		- Buf's Bufstream
		- Redpanda Serverless

## Handling Node Outages

### Follower failure: Catch-up recovery

- Each follower keeps a log of the data changes it has received from the leader
- Follower can recover from log by reconnecting to the follower log
- Leader can delete its log of writes after all followers have confirms they have processed it
	- Leader waits on unavailable followers
	- Delete the log that the unavailable follower has not ACK
### Leader failure: Failover

- One of the followers needs to be promoted to be the new leader
	- Clients are reconfigured to send writes to new leader
	- Other followers consume data from new leader
- Determining that the leader has failed
- Choosing a new leader
	- Election process (most up to date data)
	- Appointed by previously established controller node
- Reconfiguring the system to use the new leader

- Asynchronous
	- New leader may not have all writes before fail
- Discarding writs is dangerous if other storage systems outside of the database need to be coordinated with the database contents
	- GitHub
	- Auto-incrementing counter
- Split brain
	- Two nodes believe that they are the leader
	- No process for resolving conflicts, and data can be lost or corrupted
	- Fencing
		- Limiting or shutting down old leaders
	- Timeout

## Implementation of Replication Logs

### Statement based replication

- Leader logs every write request (statement)
- Any statement that calls a non deterministic function generates a different value on each replica
- Auto-incrementing columns must be executed in the same order
- Statements that have side effects
	- Triggers
	- Stored procedures
	- User-defined functions

- State machine replication
	- Replace non deterministic functions with a fixed return value
- MySQL uses row based replication for non determinism in a statement

### Write-ahead log (WAL) shipping

- Used in B-tree storage engines
- Used to restore indexes and heap to a consistent state on fail
- Used to build a replica on another node
- Sends log to the followers
	- PostgreSQL
	- Oracle
- Log describes the data at a low level
	- Changed bytes in the disk blocks
- Replication is tightly coupled to the storage engine
### Logical (row-based) log replication

- Replication log decoupled from the storage engine internals
- Logical log
	- A sequence of records describing writes to database tables at the granularity of a row
- Insert row
	- Log contains new values
- Deleted row
	- Log contains information to identify the row was deleted
	- Primary key, or old values
- Updated row
	- Log contains info to identify the updated row, and new values
- MySQL (binlog)
	- Separate logical replication log
- Easily kept backward compatible
- Change data capture
	- Send the contents of a database to an external system
		- Data warehouse
		- Specialized systems

## Problem with Replication Lag

- Online services
	- Mostly reads, with a small percentage of writes
- Create many followers, and distribute the read requests across those followers
- Removes load from the leader
- Read scaling architecture
	- Increase capacity for serving read-only requests by adding more followers
	- Asynchronous replication
		- May see outdated information
	- Eventual consistency

### Reading your own writes

- Submit data, then view the data
- View is read from a follower
- If user views the data shortly after making a write, the data may not have reached the replica

<img src="/images/Pasted image 20260918095428.png" alt="image" width="500">

- Read-after write consistency (read-you writes consistency)
- Read the user's own info from the leader, and other users' from a follower
- Monitor the replication lag on followers and prevent queries on any follower that is more than one minute
- Logical timestamp or system clock
	- Use time to track most recent writes
- Distributed replicas must be routed to the region that contains the leader
- Cross device read-after-write consistency
	- Centralized metadata
	- Route requests from all of a user's devices to the same region
- Availability zone
	- Cloud is made up of multiple zones
- Zones
	- Separate datacenter located in separate physical facility with its own power and cooling
	- Connection by high speed network connection
	- Survive zonal outages

### Monotonic reads

- Moving backward in time
- Monotonic reads
	- Provides a guarantee that old state is not written
	- Only one user makes several reads in sequence, not go backward
- Each user always makes their reads from the same replica

<img src="/images/Screenshot 2026-09-18 at 11.28.04 AM.png" alt="image" width="500">

### Consistent prefix reads

- Violation of causality
- Consistent prefix reads
	- If a sequence of write happened in a certain order, readers will see them in the same order
	- Issues in sharded databases
		- Different shards operate independently, no global ordering of writes
		- Writes that are causally related are written in the same shard

## Solution for Replication Lag

- Programming model
	- Linearizability
	- ACID transaction
	- Fault tolerance
	- High availability
	- Scalability

# Multi-Leader Replication

- Single leader replication
	- All write go through one leader
- Multi-leader (active/active or bidirectional)
	- Each node that processes a write must forward that data change to all other nodes
	- Asynchronous
	- Multi-region
## Geographically Distributed Operation

- Geographically distributed, geo distributed, geo replicated
<img src="/images/Screenshot 2026-09-18 at 11.34.04 AM.png" alt="image" width="500">

- Leader in each region
	- Regular leader-follower replication is used
	- Each region's leader replicates its change to the leaders in other regions
- Performance
	- Single leader
		- Every write goes over the internet
	- Multi leader
		- Write can be processed in the local region, and asynchronously replicated to the other regions
- Tolerance of regional outages
	- Each region can continue operation independently of the others
- Tolerance of network problems
	- Traffic between regions can be less reliable than traffic between zones in the same region
	- Can tolerate network problems
- Consistency
	- Single leader
		- Strong consistency
		- Serializable transactions
	- Multi-leader
		- Weaker consistency

- Challenges with multi-leader replications
	- Auto-incrementing keys
	- Triggers
	- Integrity constraints

### Multi-leader replication topologies

- Replication topology
	- Describes the communication paths along which writes are propagated from one node to another

<img src="/images/Screenshot 2026-09-18 at 11.39.12 AM.png" alt="image" width="500">


- Circular
- Star
- All-to-all
	- Every leader sends its write to every other leader
- 

### Problems with different topologies
## Sync Engines and Local-First Software
### Real-time collaboration, offline-first, and local-first apps
### Pros and cons of sync engines

## Dealing with Conflicting Writes
### Conflict avoidance
### Last write wins (discarding concurrent writes)
### Manual conflict resolution
### Automatic conflict resolution
### Conflict-free replicated datatype and operational transformation
### Types of conflict


# Leaderless Replication

## Writing to the Database When a Node Is Down

### Catching up on missed writes
### Using quorums for reading and writing
### Understanding and limitations of quorum consistency
### Monitoring staleness


## Single-Leader vs. Leaderless Replication Performance
## Multi-Region Operation
## Detecting Concurrent Writes

### The happens-before relation and concurrency
### Capturing the happens-before relationship

