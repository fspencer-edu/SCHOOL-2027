# Data Integration

## Combining Specialized Tools by Deriving Data

### Reasoning about dataflows
### Derived data vs. distributed transactions
### The limits of total ordering
### Ordering events to capture causality

## Batch and Stream Processing

### Maintaining derived state
### Reprocessing data for application evolution
### Unifying batch and stream processing

# Unbundling Databases

## Composing Data Storage Technologies

### Creating an index
### The meta-database of everything

### Making unbuilding work
### Unbundled vs. integrated systems

## Designing Applications Around Dataflow

### Application code as a derivation function
### Separation of application code and state
### Dataflow: Interplay between state changes and application code
### Stream processors and services

## Observing Derived State

### Materialized views and caching
### Stateful, offline, capable clients
### Pushing state changes to clients
### End-to-end event streams
### Reads are events too
### Multi-shard data processing


# Aiming for Correctness

## The End-to-End Argument for Databases

### Exactly-once execution of an operation
### Duplicate suppression
### Uniquely identifying requests
### End-to-end argument
### Applying end-to-end thinking in data

## Enforcing Constraints
### Uniqueness constraints require consensus
### Uniqueness in log-based messaging
### Multi-shard request processing
## Timeliness and Integrity

### Correctness of dataflow systems
### Loosely interpreted constraints
### Coordination-avoiding data systems

## Trust, but Verify

### Maintaining integrity in the face of software bugs
### Don't just blindly trust what they promise
### Designing for auditability
### The end-to-end argument again
### Tools for auditable data systems

