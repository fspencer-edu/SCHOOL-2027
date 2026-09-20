- Distributed database
	- Stores a copy of the same data on multiple nodes
	- Splits data into smaller shards or partitions

![[Screenshot 2026-09-19 at 10.19.57 PM.png]]

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

- mod N approach
	- If node N change, most of the keys have to be moved
### Fixed number of shards
### Sharding by hash range
### Consistent hashing
## Skewed Workloads and Relieving Host Tops
## Operations: Automatic vs. Manual Rebalancing
# Request Routing

## Local Secondary Indexes
## Global Secondary Indexes
# Sharding and Secondary Indexes