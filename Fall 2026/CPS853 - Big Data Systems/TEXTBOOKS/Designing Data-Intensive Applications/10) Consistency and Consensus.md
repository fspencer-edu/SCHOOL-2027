
- Eventual consistency
	- Used with multi=leader and leaderless replication
- Strong consistency
	- Application should not worry about internal detail of replication
	- Act as a single node
	- Performance cost
# Linearizability

- Linearizability (atomic consistency, strong consistency, immediate consistency, external consistency)
	- Make a system appear as if there is only one copy of the data, and all operations are atomic
	- All clients reading from the database must be able to see the value just written
	- Guarantee that the value read is the most recent
		- Recency guarantee

## What Makes a System Linearizable?

- After any one read has returned the new value, all following reads must also return the new value
- CAS (Compare and set) operation

![[Pasted image 20260922141634.png]]

- Test systems
## Relying on Linearizability

### Locking and leader election
### Constraints and uniqueness guarantees
### Cross-channel timing dependencies

## Implementing Linearizable Systems

## The Cost of Linearizability

### The CAP theorem
### Linearizability and network delays

# ID Generators and Logical Clocks

## Logical Clocks

### Lamport timestamps

### Hybrid logical clocks
### Lamport/hybrid logical clocks vs. vector clocks
## Linearizable ID Generators

### Implementing a linearizable ID generator
### Enforcing constraints using logical clocks

# Consensus

## The Many Faces of Consensus

### Single-value consensus
### Compare and set as consensus

### Shared logs as consensus
### Fetch and add on consensus
### Atomic commitment as consensus
## Consensus in Practice
### Using shared logs
### From single-leader replication to consensus
### Subtleties of consensus
### Pros and cons of consensus

## Coordination Services

### Allocating work to nodes
### Service discovery
