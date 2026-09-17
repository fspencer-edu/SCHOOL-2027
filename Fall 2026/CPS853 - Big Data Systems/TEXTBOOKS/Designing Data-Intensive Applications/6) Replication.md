# Single-Leader Replication

## Synchronous vs. Asynchronous Replication

## Setting Up New Followers
## Handling Node Outages

### Follower failure: Catch-up recovery
### Leader failure: Failover

## Implementation of Replication Logs

### Statement based replication
### Write-ahead log shipping
### Logical (row-based) log replication

## Problem with Replication Lag

### Reading your own writes
### Monotonic reads
### Consistent prefix reads

## Solution for Replication Lag



# Multi-Leader Replication

## Geographically Distributed Operation

### Multi-leader replication topologies
### Problems with different topologies
## Sync Engines and Local-First Software
### Real-time collaboration, offline-first, and local-first apps
### Pros and cons of sync engines

## Dealing with Conflicting Writes
### Conflict avoidance
### Last write wins (discarding concurrent writes)
### Manual conflict resolution
### Automatic conflict resolution
### Conflict-free replicated datatype and operational transformation
### Types of conflict


# Leaderless Replication

## Writing to the Database When a Node Is Down

### Catching up on missed writes
### Using quorums for reading and writing
### Understanding and limitations of quorum consistency
### Monitoring staleness


## Single-Leader vs. Leaderless Replication Performance
## Multi-Region Operation
## Detecting Concurrent Writes

### The happens-before relation and concurrency
### Capturing the happens-before relationship

