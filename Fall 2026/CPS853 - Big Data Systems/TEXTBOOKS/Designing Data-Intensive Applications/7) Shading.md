- Distributed database
	- Stores a copy of the same data on multiple nodes
	- Splits data into smaller shards or partitions

<img src="/images/Screenshot 2026-09-19 at 10.19.57 PM.png" alt="image" width="500">

- Each shard's leader is assigned to one node, and its followers are assigned to other nodes
- Shard, partition, range, region, vBucket, vnode, token-range, tablet
- PostgreSQL
	- Paritioning
		- Split a large table into several files that are stored on the same machine
	- Sharding
		- Splits a dataset across multiple machines
# Pros and Cons of Sharding

- Scalability
	- Volume of data or the write throughput has become too great for a single node to handle
	- Read scaling for read throughput
- Sharding is used for horizontal scaling
	- Grow system capacity and not large machine
- Heavyweight solution that is most relevant at large scale
- Partition key
	- All records with eh same partition key are placed in the same shard
	- Works well for key-value data
	- More difficult for relational data
- A write may need to update related records in several shards
	- Distributed transaction
- Non-uniform memory access (NUMA)
	- Some banks of memory are closer to one CPU than to others
# Sharding for Multi-tenancy

- Multi-tenant
	- Each tenant is given a separate shard
	- Multiple small tenants are grouped into a larger shard
- Resource isolation
- Permission isolation
- Cell based architecture
	- Service and storage for a particular set of tenants are grouped into a self-contained cell
	- Fault isolation
- Per-tenant backup and restore
	- GDPR
	- CCPA
- Regulatory compliance
- Gradual schema rollout

- Challenges
	- Assumes that each individual tenant is small enough to fit on a single node
	- Creating a separate shard for each one may incur to much overhead
	- Difficult to support features that connect across tenants

# Sharding of Key-Value Data

- Spread the data and the query load evenly across nodes
- Rebalance after adding or removing a node
- Skewed
	- Sharding is less effective
	- Hot shard or hot spot
	- Hot key
- Key value store
	- Partition key is the key or the first part of the key
- Relational model
	- Partition key might be a column of a table

## Sharding by Key Range

- Manual key range sharding
- Automatic variant
- Keys are stored in sorted order
- Range scans are easy, and each key is concatenated to the index
- Many hot shards if there are write to nearby keys
### Rebalancing key-range sharded data

- Pre-splitting
	- Configure an initial set of shards on an empty database
- Merge adjacent shards if data is deleted
- Split/merge is triggered by reaching a configured size or write throughput
- Splitting a shard is an expensive operation
	- Requires all its data to be rewritten into new files
	- Split nodes that are under high load
## Sharding by Hash of Key

- Hash the partition key before mapping it to a shard
- Multi-tenant application
- Not needed to be grouped
- Hashes are evenly distributed across that range of numbers
### Hash modulo number of nodes

- mod N approach (modulo)
	- If node N change, most of the keys have to be moved

<img src="/images/Pasted image 20260921111910.png" alt="image" width="500">

- Leads to inefficient rebalancing from unnecessary movements or recrods from one more to another

### Fixed number of shards

- Create more shards than there are nodes and assign several shards to each node
	- hash(key) % 1000
- Only entire shards are moved between nodes
- Number of shads does not change, instead the assignment of shards to node changes
- Reassignment is not immediate
	- Old assignment of shards is used for reads and writes during transfer

<img src="/images/Pasted image 20260921112141.png" alt="image" width="500">

- Add or remove nodes easily
- If capacity is reached, then an expensive resharding operation is required
### Sharding by hash range

- Key-range sharding scheme
- Risk of hot spots when there are a lot of writes to nearby keys
- Combine key-range sharding with a hash function so that each shard contains a range of hash values rather than a range of keys
- Range queries over the partition key are not efficient
	- Cluster columns
	- Micro-partitions

<img src="/images/Screenshot 2026-09-21 at 11.26.08 AM.png" alt="image" width="500">

<img src="/images/Pasted image 20260921112748.png" alt="image" width="500">

- When nodes are added or removed, range boundaries are adjusted and shards are split or merged

### Consistent hashing

- A hash function that maps keys to a specified number of shards in a way that satisfies two properties
	- Number of keys mapped to each shard is roughly equal
	- Number of shards changes, as few keys as possible are moved from one shard to another
- Other consistent hashing algorithms
	- Highest random weight (rendezvous hashing)
	- Jump consistent hashing
## Skewed Workloads and Relieving Host Tops

- Consistent hashing ensures that keys are uniforming distributed, but not the actual load
- Define shards based on ranges of key can put an individual hot key in a shard by itself
- Add a random number to the beginning or end of the key
	- Splits the writes to the key across 100 keys
	- Requires bookkeeping
- Heat managed or adaptive capacity
## Operations: Automatic vs. Manual Rebalancing

- Automatic
	- Autoscale to adapt to workload
	- Unpredictable
	- Rebalancing is expensive operation
- Manual
- Generate a suggested shard assignment automatically
# Request Routing

- Request routing, similar to service discovery
- Services running application code
	- Instances that are stateless, and a load balancer can send a request to any of the instances
- Sharded databases
	- A request for a key can be handled only by a node that is a replica for the shard containing that key
	- Aware of the assignment from keys to shards and shards to nodes
- Allow clients to contact any node (round-robin load balancer)
- Send all requestts from clients to a routing tier, and determine the node to forward to
- Require that clients be away of the sharding and the assignment of shards to nodes

<img src="/images/Pasted image 20260921113554.png" alt="image" width="500">

- Split brain situations
- Routing tier must be updated on changes in the assignment
- Cutover period
	- New node has taken over, but requests to the old node are still router
- Consensus algorithms
	- Provide fault tolerance and protection against split brain
	- Each nodes registers itself, and maintains the authoritative mapping of shards to nodes
	- Routing tier or sharding-aware client, can subscribe to this information
	- ZooKeeper
		- HBase
		- SolrCloud
	- etcd
		- Kubernetes

<img src="/images/Pasted image 20260921113857.png" alt="image" width="500">

- MongoDB relies on its own config server implementation and mongos daemons as the routing tier
- Kafka, YugabyteDB, TiDB, and ScyllaDB
	- Use build-in implementations of the Raft consensus protocol
- Riak uses a gossip protocol to disseminate any changes in cluster state
- Clients find the IP addresses and can use DNS
- Sharded OLTP databases
- Analytical databases use sharding, but rather than executing in a single shard, query on many shards in parallel

# Sharding and Secondary Indexes

- Key-value data model
	- The partition key is the first part of the primary key
	- Use the partition key to determine the shard and and route reads and writes to the node that is responsible for that key

- A secondary index does not identify a record directly
- Searches for occurrences of a particular value
- Key-value stores do not have secondary indexes, but are a standard feature of relational databases and document databases
	- Raison d'etre of full text search engines
- Don't map neatly to shards
## Local Secondary Indexes

- Each shard independency maintains its own secondary indexes, cover
## Global Secondary Indexes
