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

![[Pasted image 20260917143950.png]]

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

![[Screenshot 2026-09-17 at 2.41.18 PM.png]]

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

- 

## Implementation of Replication Logs

### Statement based replication
### Write-ahead log shipping
### Logical (row-based) log replication

## Problem with Replication Lag

### Reading your own writes
### Monotonic reads
### Consistent prefix reads

## Solution for Replication Lag



# Multi-Leader Replication

## Geographically Distributed Operation

### Multi-leader replication topologies
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

