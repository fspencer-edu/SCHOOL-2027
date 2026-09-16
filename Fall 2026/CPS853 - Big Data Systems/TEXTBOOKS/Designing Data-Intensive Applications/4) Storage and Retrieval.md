
- OLTP
	- Log structured storage engines
		- Write out immutable data files
	- B-trees
		- Update data in place

- Both use key-value storage and secondary indexes

# Storage and Indexing for OLTP

- Cost of a look up is $O(n)$
- Index
	- Structure the data to make it faster to locate data
	- Additional structure that is derived from the primary data

## Log-Structured Storage

- Hashmap
	- Mapping every key to the byte offset
	- Free up disk space from old log entries to be overwritten
	- Not persisted
	- Fit in memory
	- Range queries are not efficient

### SSTable file format

- Hash tables are not used in database indexes
- Sorted by key
	- Sorted String Table
		- Store key-value pairs by a sorted key
- Spare
	- Store only some of the keys (blocks)
- Index stored using a B-tree, a trie, or another data structure for quick lookup
- Each block of records can be compressed

### Constructing and merging SSTable

- Better for reading, than append-only log
- Log-structured approach
	- Hybrid between an append only log and a sorted file
		- Add write in memory ordered map data structure (memtable)
			- Red black tree, skip list, or trie
			- Insert key in any other, and look up
			- Read in sorted order
		- When memtable gets larger than a certain threshold
			- Write it out to disk in sorted order as an SSTable file (segment)
			- Each segment has a index
			- Old memtable is freed
		- To read value
			- Find key in memtable, or most recent on-disk segment
			- Look at older segments
	- Run a merging and compaction process in the background to combine segment files and discard overwritten or deleted valeyes

- Merging segments work similar


## B-Trees

## Comparing B-Trees and LSM-Trees
## Multicolumn and Secondary Indexes
## Storing Values Within INdex
## Keeping Everything in Memory

# Data Storage for Analytics

## Cloud Data Warehouses
## Column-Oriented Storage
## Query Execution: Complication and Vectorization
## Materialization Views and Data Cubes
# Multidimensional and Full-Text Indexes

## Full-Text Search
## Vector Embeddings

