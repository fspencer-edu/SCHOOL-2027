# Linearizability

## What Makes a System Linearizable?
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
