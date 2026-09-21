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
- Cons
### Isolation
### Durability

## Single-Object and Multi-Object Operations
### Single-Object writes
### The need for multi-object transactions
### Handling errors and aborts

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