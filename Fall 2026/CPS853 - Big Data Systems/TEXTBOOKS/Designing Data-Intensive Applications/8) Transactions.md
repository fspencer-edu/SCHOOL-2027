# What Exactly Is a Transaction?


## The Meaning of ACID
### Atomicity
### Consistency
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
### 
### 
### 
# Distributed Transactions

## Two-Phase Commit
## Distributed Transactions Across Different Systems

## Database-Internal Distributed Transactions
## Exactly-Once Message Processing Revisited