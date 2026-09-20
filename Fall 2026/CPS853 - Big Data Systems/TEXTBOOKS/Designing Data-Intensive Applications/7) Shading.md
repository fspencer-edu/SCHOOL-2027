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
	- Volumne of data or the write throughput has become too great for a single node to handle
	- 

# Sharding for Multi-tenancy

# Sharding of Key-Value Data

## Sharding by Key Range
### Rebalancing key-range sharded data

## Sharding by Hash of Key
### Hash modulo number of nodes
### Fixed number of shards
### Sharding by hash range
### Consistent hashing
## Skewed Workloads and Relieving Host Tops
## Operations: Automatic vs. Manual Rebalancing
# Request Routing

## Local Secondary Indexes
## Global Secondary Indexes
# Sharding and Secondary Indexes