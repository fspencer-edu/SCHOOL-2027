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
	- Each node receives writes from one node and forwards those writes to one other node
	- Each node has a unique identifier, to prevent infinite replication loops
- Star
	- One root node forwards writes to all the other nodes
- All-to-all
	- Every leader sends its write to every other leader
	- Some links may be faster than others, and overtake other messages
### Problems with different topologies

- Version vectors
	- Order events correctly
## Sync Engines and Local-First Software

- Multi leader replication is used when an application needs to be disconnected from the internet
- Every device has a local database replica that acts as a leader
- Asynchronous multi leader replication when connected back (sync)
### Real-time collaboration, offline-first, and local-first apps

- Real time collaboration
	- Application receives change from collaborators, and merges then into the user's local copy of the file
	- Conflict resolution logic
	- Sync engine
- Offline first
	- Users can continue editing a file while offline
- Local first software
	- Collaborative apps that are not only offline-first, but are also designed to continue if software shuts down online services
	- Sync engine with an open standard sync protocol
	- Git
### Pros and cons of sync engines

- Building web apps
	- Keep little persistent state on the client
- Sync engine
	- Persistent state stays on the client, and communication with server is moved into a background process
	- UI can respond faster
	- Simplifies the programming model for frontend apps
	- Reactive programming model
		- Display edits from other users in real time
- Also called netcode in game development

## Dealing with Conflicting Writes

- Concurrent writes on different leaders can cause conflicts that need to be resolved
### Conflict avoidance

- Geo-replicated server systems
	- Requests from a particular user are always routed to the same region and use the leader in that region
- Auto incrementing counter
	- Leaders generate odd and event numbers
### Last write wins (discarding concurrent writes)

- Attach a timestamp to each write
- Last write wins (LWW)
	- When the same record is concurrently written on different leaders, one of those writes is randomly chosen to be the winner and the other writes are silently discarded
- Real time clock (Unix timestamp)
	- Used for writes for clock synchronization
### Manual conflict resolution

- Siblings
	- Databases store all the concurrently written values for a given record
	- Database returns all those values rather than the latest one
	- Resolve, automatically in application code
- API changes are difficult to read
- Verifying merges is a lot of work
- Merging sibling can lead to unwanted results
- If multiple nodes observe the conflict and concurrently resolve it, it can lead to a new conflict

### Automatic conflict resolution

- Use an algorithm that automatically merges concurrent writes into a consistent state
- Strong eventual consistency
- Text
	- Detect characters that have been inserted or deleted
	- Merges results preserve all the insertions and deletions from siblings
- Collection of items
	- Tracks items that were deleted
- Integer
	- Detect increments and decrements that happened on each sibling and add together
- Key value mapping
	- Merge updates to the same key by applying one of the conflict resolution algorithms to the value under that key

### Conflict-free replicated datatype and operational transformation

<img src="/images/Pasted image 20260919131118.png" alt="image" width="500">

- Conflict free replicated datatypes (CRDTs)
	- Give each character a unique, immutable ID and determine the position of insertion/deletions, instead of indexes
- Operational transformation (OT)
	- Record index at which characters are inserted or deleted
	- Exchange their operations
	- Transform index of each operation to account for concurrent operations
### Types of conflict

# Leaderless Replication

- Also known as Dynamo-style
- Used by
	- Amazon's Dynamo
	- Riak
	- Cassandra
	- ScalaDB
- Clients directly sends its writes to several replicas
- A coordinator node does this on behalf of the client

## Writing to the Database When a Node Is Down

<img src="/images/Pasted image 20260919141020.png" alt="image" width="500">

- Read requests are sent to several nodes in parallel
	- Mitigates state data
	- Every value that is written needs to be tagged with a version number of timestamp
### Catching up on missed writes

- Read repair
	- Detects stale responses from nodes in parallel
- Hinted handoff
	- Another replicate may store writes on a unavailable nodes behalf in the form of hints
	- Replica sends hints to the recovering replica
	- Handoff process
- Anti entropy
	- Background process periodically looks for differences in the data
	- Does not copy writes in order
### Using quorums for reading and writing

- If there are n replicas, every write must be confirmed by w nodes to be considered successful, and must query at least r nodes for each read
$w =$ confirmed nodes (write)
$r =$ queried nodes for read
$n =$ replicas
- $w + r > n$
- Reads and writes that obey these r and w values are called quorum reads and writes
- Minimum number of votes required for read and writes to be valid
- Allows the system to tolerate unavailable nodes
	- $w < n$
		- Still process writes if a node is unavailable
	- $r < n$
		- Still process reads if a node is unavailable
	- $n = 3, r = 2$
		- tolerate one unavailable node
	- $n = 5,w = 3, r = 3$
		- Tolerate two unavailable nodes

<img src="/images/Pasted image 20260919142054.png" alt="image" width="500">

- Normally, reads and writes are always sent to all n replicas in parallel
- If fewer than the required w or r nodes are available, writes or reads return an error

### Understanding and limitations of quorum consistency

- Every read returns the most recent value written for a key
- Set of nodes that are read and written from overlap
- $w + r \leq n$
	- Reads and writes will still be sent to n nodes, but a smaller number of successful responses is required for the operations to succeed
- Smaller w and r
	- More likely to read stale values
	- Read will not include the node with the latest value
	- Lower latency
	- Synchronous (blocking) replication
### Monitoring staleness

- Leader-based replication
	- Exposes metrics for replication log
	- Each node has a position in the replication log
	- Subtracting follower's current position from the leader's current position
- Leaderless replication
	- Number of hints that a replica stores for handoff
## Single-Leader vs. Leaderless Replication Performance

- Leader-based replicated systems
	- Read throughput is limited by the leader's capacity to handle requests
	- Wait for a failed leader
	- Sensitive to performance problems on the leader
- Leaderless architecture
	- Request hedging
		- Client uses the fastest responses
	- Gray failures
		- Node is not down, but is running in a degraded state that is slow to handle requests
		- Node is overloaded
	- Replicas need to detect when other nodes are unavailable
	- Larger size of quorum and more responses to wait with more replicas
	- Network interruption can make it impossible to form a quorum
	- Sloppy quorom
		- Any reachable replica can accept writes
## Multi-Region Operation

- Coordinator node
	- Client sends write to the node in its region
	- Forwards the write to all replicas in its own region and to one replica in every other region
	- Avoids cross-region request multiple times
	- Choose consistency levels
## Detecting Concurrent Writes

- Leaderless databases allow concurrent write to the same key, resulting in conflict
	- Detecting during
		- Read repair
		- Hinted handoff
		- Anti-entropy
- Replicas should converge toward the same value
- LWW
	- Each write is tagged with a timestamp

### The happens-before relation and concurrency

- Non concurrent nodes
	- B is causally dependent on A
- Concurrent nodes
	- Each client starts the operation
	- No causal dependency between the operations
	- Neither operation happens before the other

### Capturing the happens-before relationship

- Server maintains a version number for very key, increments the version number very time that key is written, and stores the new version number along with the value written
- When a client reads a key, the server returns all siblings
- When a client writes a key, includes a version number from the prior read
- When the server receives a write with a particular version number, it can overwrite all values with that version number of below

<img src="/images/Pasted image 20260919150719.png" alt="image" width="500">

- Arrows indicate which operation happen before which other operation

### Version vector

- Multiple replicas
- Use a version number per replica as well as per key
- Each replica increments its own version number when processing a write, and keeps trakc of the version number from each of the other replicas
- Dotted version vector
	- Rias 2.0
- Sent from the database replicas to clients when values arw read
- Sent back to the database when value is written
- Also called a vector clock