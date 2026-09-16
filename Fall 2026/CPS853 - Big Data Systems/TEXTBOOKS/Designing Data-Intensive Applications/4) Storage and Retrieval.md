
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
	- Run a merging and compaction process in the background to combine segment files and discard overwritten or deleted values

- Merging segments work similar to mergesort algorithms
	- Copy the lowest key to the output file from left to right
	- Keep only the most recent key value
- Storage engine keeps a separate log on disk to which every write is appended
	- LSM storage engines
- Append a tombstone to a data file to delete a record

- Log-Structured Mergetree (LSM-tree)
	- Google's Bigtable paper
	- RocksDB
	- Cassandra
- Object storage with LSM
	- SlateDB
	- Delta Lake
- Database can delete the unfinished SSTable if crash

### Bloom Filters

- LSM storage still is slow to read a key that was last updated or DNE
- Bloom filter
	- Provides a fast but approximate way of checking whether a particular key appears in a SSTable
	- Probabilistic check on whether a key exists (hashing, bitmap, bitwise operation)

### Compaction Strategies

- Size-tiered compaction
	- Newer and smaller SSTables are successively merged into older and large tables
	- Performs better on mostly writes and few reads
- Leveled compaction
	- Keeps SSTable sizes fixed and groups them into increasing levels
	- When levels exceed a max size limit, one or more tables are merged
	- Performs better if workload is mostly reads

- Embedded databases
	- Do not expose a network API
	- Mobile apps
	- Per tenant
## B-Trees

- Keep key-value pairs sorted by key
- Indexes break the database into fixed size blocks or pages and can overwrite a page in place
- Pages use a page number, like a pointers
- Leaf pages contain individual pages
- References to child pages in one page is called the branching factor
	- Depends on space and range boundaries
- Tree remains balanced
	- A B-tree with n keys always has a depth of $O(logn)$

### Making B-trees reliable

- Overwrite does not change the location of the page
- Overwriting several pages at one, can result in errors
	- Orphan page
	- Torn page
- Write-ahead log (WAL)
	- Append only file of every B-tree modification before page application
- Buffer B-tree pages in memory first
### Using B-tree variants

- LMDB
	- Copy-on-write schema
	- Modified page is written to a different location
	- Pointers are redirected to new parent pages
	- Concurrency control
- Save pages by abbreviating the key
- Lay out leaf pages in sequential order on disk
- Additional pointers
	- Sibling pages
## Comparing B-Trees and LSM-Trees

- LSM
	- Better for write-heavy applications
- B-trees
	- Faster for reads
### Read Performance

- LSM
	- Reads check several SSTables
	- Bloom filter helps reduce disk operations
	- Range queries need to scan all segments
	- High write throughput can cause latency
	- Backpressure
		- Suspend all reads and write until memtable has been written to disk
- B-tree
	- Lookup involves reading one page at each level
	- Range queries are fast

### Sequential vs. Random write

- LSM
	- Sequential writes
		- Fewer larger writes
- B-tree
	- Random writes
		- Small, scattered write

- Disks have higher sequential write throughput than random
- Garbage collection (GC)
	- Controller must move pages containing valid data into other blocks
	- Removes the data that is no longer needed
- Sequential write workloads write larger chucks, and can remove whole blocks without GC

### Write amplification

- LSM
	- A value is written to the log
	- Memtable is written to disk
	- Repeated during compaction
- B-tree
	- Write every piece of data at least twice
		- Write-ahead log
		- Tree page

- Write amplification
	- Bytes written to disk in workload divided by number of bytes written by append-only log with no index
	- Issues in both LSM-trees and B-trees
	- LSM trees tend to have lower write amp. since they do not have to write entire pages, and can compress chunks of the SSTable
	- Wear on SSD
### Disk space usage

- LSM
	- Blocks of key-value pairs can be better compressed
	- A deleted record may still exist in the higher levels until the tombstone representing the deletion has been propagated through
	- Useful for snapshots
- B-tree
	- Becomes fragmented over time
	- Vacuum process to re locate pages
## Multicolumn and Secondary Indexes

- Secondary index
	- Indexed values are not necessarily unique
	- Make each value in the index a list of matching row identifiers
	- Make each entry unique by appending a row identifier to it
## Storing Values Within Index

- Clustered index
	- Data stored directly within the index structure
- Heap file
	- Stores unordered data by append-only
- Covering index or index with included columns

## Keeping Everything in Memory

- Advantages of disks
	- Durable
	- Lower cost per GB than RAM

- In-memory databases
	- Memcached
	- Writing periodic snapshots to disk or replicating the in memory state to other machines
	- Faster because they avoid the overheads of encoding in-memory data structures in a form that can be written to disk
	- Offers difficult data structures
		- Priority queues and sets

- Advantages of writing to disk
	- Easily backed up, inspected, and analyzed by external utilities
# Data Storage for Analytics

- Drill-down, slicing and dicing
	- Graphical data analysis tools that generate SQL queries, visualize the results
- Microsoft SQL Server
	- Support for transaction processing
- Hybrid transactional and analytical processing (HTAP) are becoming two separate storage and query engines

## Cloud Data Warehouses

- Data warehouse vendors
	- Teradata
	- Vertica
	- SAP HANA
- Cloud vendors
	- Google Could's BigQuery
	- Amazon Redshift
	- Snowflake
		- Scalable cloud infrastructure
		- More elastic because they decouple query computation from the storage layer
		- Data is persisted in object storage rather than on local disk
- Open source data warehouses
	- Apache Hive
	- Trino
	- Apache Spark

- Query engine
	- Parse SQL queries, optimize them into execution plans, and execute them again the data
	- Requires parallel, distributed data processing tasks
- Storage format
	- Determines how the rows of a table are encoded
		- Parquet
		- ORC
		- Lance
		- Nimble
	- Accessed by query engine, or other applications using the data lake
- Table format
	- Files written in a format are immutable once written
	- Define which files make up the table
	- Table formats are used to support row inserts and deletions
		- Apache Iceberg
		- Databricks's Delta
	- Advanced features
		- Time travel
		- GC
		- Transactions
- Data catalog
	- Defines which tables are contains in a database
	- Create, rename, and drop tables
	- Run as a standalone service that can be queries using a REST interface
	- Use when reading and writing tables

## Column-Oriented Storage

- Dimension tables are usually smaller and more manageable
- A typical data warehouse query accesses only 4 or 5 fact tables at one time
- In OLTP databases are stored in row-oriented fashion
	- Values from one row of a table are stored next to another
- Column-oriented (columnar) storage
	- Stores all the values from each column together
	- Query reads and parses only columns needed
	- Relies on each column storing the rows in the same order
	- Break table into blocks

### Column compression

- Bitmap encoding
- Run-length encoded
	- Involved counting consecutive )s or 1s and storing the counds
- Roaring bitmap
	- Switch between the two bitmap respresentations
- Used for queries that are commonin a data warehouse
- Used in graph queries

### 
### 
### 
### 

## Query Execution: Complication and Vectorization
## Materialization Views and Data Cubes
# Multidimensional and Full-Text Indexes

## Full-Text Search
## Vector Embeddings

