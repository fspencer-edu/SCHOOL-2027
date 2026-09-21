- Transactions are a mechanism of choice for simplifying issues
- A transaction is a way for an application to group several reads and writes together into a logical unit
	- Executed as one operation
	- Results in a commit
	- If fails, results in an abort or rollback
- Error handling become more simple
- Simplify the programming model for applications accessing a database
- Safety guarantees
- Concurrency control is relevant for both single node and distributed databases
- Race conditions
	- Read-committed
	- Snapshot isolation
	- Serializability
- Two-phase commit protocol

# What Exactly Is a Transaction?

- Large scale NewSQL
	- Combine sharding with consensus protocols
## The Meaning of ACID

- ACID
	- Atomicity
	- Consistency
	- Isolation
	- Durability
- Systems that do not been the ACID criteria are sometimes called BASE
	- Basically available, soft state, and eventual consistency
### Atomicity

- Atomic
	- Something that cannot be broken into smaller parts
- Multi-threading programming
	- No way another thread could see the half-finished result of the operation
- In ACID atomicity is not about concurrency
	- Describes what happens if a client wants to make several writes, but a fault occurs after some of the write
	- Integrity constraint is violated
	- If an error occurs partway through changes, it is difficult to identify what has been processed
### Consistency

- Other uses of consistency
	- Replica consistency
	- Eventual consistency
	- Consistent snapshot
	- Consistent hashing
	- Linearizability
- Consistency refers to an application specific notion of the database being in a good state
- Certain statements about data (invariants) that must always be true
- To enforce invariants, declare then as constraints in the schema
	- Foreign key constraints
	- Uniqueness constraints
	- Check constraints
	- Triggers
	- Materialized views
### Isolation

- Isolation means that concurrently executing transactions are isolated from each other
- Serializability
	- Each transaction can pretend that it is the only transaction running
	- Performance cost
	- Many databases use forms of isolation that are weaker than serializability
		- Allow concurrent transaction to interfere with each other in limited ways
			- Snapshot isolation (oracle)
### Durability

- Durability is the promise that after a transaction has committed, any data written will not be forgotten
- Single node
	- Data written to non-volatile storage (HDD, or SSD)
	- File writes are buffered in memory
	- Use `fsync` system call to ensure that the data has been written to disk
	- Write-ahead log to recover crash events
	- Store data with a checksum
		- Detects corrupted or incomplete log entires
- Data has been successfully copies to a number of nodes (replicated databases)
- Data on disk can gradually become corrupted

## Single-Object and Multi-Object Operations

- ACID

1) Atomicity
2) Consistency
3) Isolation
4) Durability

- Multiple object transactions require some way of determining which read and write operations belong to the same transactions
- Done on client's TCP connection to the database server
- Between `BEGIN TRANSACTION` and `COMMIT`
- Non-relational databases do not have a way of grouping operations together
	- Multi-object API
		- Key value store may have a multi-put operations
		- Not pure atomic transactions
### Single-Object writes

- Storage engines aim to provide atomicity and isolation on the level of a single object on one node
- Log for crash recovery
- Isolation using a lock on each object
- Increment operation (isolated or serializable increment)
	- Removes the need for read-modify-write cycle
- Conditional write operation
	- Allows a write to happen only if the value has not been concurrently changes by someone else
	- Compare-and-set
	- Compare-and-swap (CAS)
- Single-object operations prevent lost updates
- No guarantees across multiple objects
### The need for multi-object transactions

- Writes to several objects need to be coordinate with multi-object transactions
	- Relational data model
		- A row in one table has a foreign key reference to a row in another table
	- Graph like data model
		- Vertex has edges to other vertices
- Multiple object transactions allow you to ensure that references remain valid
	- Document data model
		- Fields that need to be updated are often within the same document
		- Treated as single object
	- Denormalization requires updates to multiple documents
	- Transactions can be used to prevent denormalized data from going out of sync
- Databases with secondary indexes
	- Indexes need to be updated every time a value is changed

### Handling errors and aborts

- Datastores with leaderless replication work on more of a "best effort" basis
	- If an error occurs, it wont repeat actions
- Object-relational mapping (ORM) frameworks
	- Does not retry aborted transactions
	- Error results in an exception bubbling up the stack, and use input is thrown away and error is thrown
	- Rails ActiveRecord
	- Django

- Error handling
	- If a transactions succeeds, but there is a network interuption during commit, retry the transaction causes it to be performanc

# Weak Isolation Levels

## Read Committed
### No dirty reads
### No dirty writes
### Implementing read-committed

## Snapshot Isolation and Repeatable Read

### Multi-version concurrency control
### Visibility rules for observing a consistent snapshot
### Indexes and snapshot isolation
### Snapshot isolation, repeatable read, and naming confusion
## Preventing Lost Updates

### Atomic write operations
### Explicit locking
### Automatically detecting lost updates
### Conditional writes (compare-and-set)

### Conflict resolution and replication

## Write Skew and Phantoms

### Characterizing write skew
### More examples of write skew
### Phantoms causing write skew

### Materializing conflicts

# Serializability

## Actual Serial Execution

### Encapsulating transactions in stored procedures
### Pros and cons of stored procedures
### Sharding
### Summary of serial execution
## Two-Phase Locking

### Implementation of 2PL
### Performance of 2PL
### Predicate locks
### Index-range locks

## Serializable Snapshot Isolation

### Pessimistic vs. optimistic concurrency control
### Decisions based on an outdated premise
### Detection of stale MVCC reads
### Detection of writes that affect prior reads
### Performance of serializable snapshot isolation

# Distributed Transactions

## Two-Phase Commit

### A system of promises
### Coordinator failure
### Three-phase commit
## Distributed Transactions Across Different Systems

### Exactly-once message processing
### XA transactions
### Holding locks while in doubt

### Recovering from coordinator failure
### Problems with XA transactions

## Database-Internal Distributed Transactions


## Exactly-Once Message Processing Revisited