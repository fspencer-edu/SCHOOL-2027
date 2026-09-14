- Functional requirements
- Non-functional requirements
	- Performance
	- Reliability
	- Scalability
	- Maintenance
# Case Study: Social Network Home Timelines

## Representing Users, Posts, and Follows

- Home timeline
	- Displays recent posts by people the user is following
- Polling
	- User's client repeats a query every 5 seconds
## Materializing and Updating Timelines

- Server actively pushes new posts to any followers who are currently online
- Precompute the results of the query to be server from cache
- Fan-out
	- One initial request results in several downstream requests

<img src="/images/Pasted image 20260912133235.png" alt="image" width="500">

- Materialization
	- Precomputing and updating the results
	- Materialized views speed up reads, but will have to do more writes
# Describing Performance

- Response time
	- Elapsed time from the moment the user makes a request until they receive the requested answer
- Throughput
	- Number of requests per second, or data volume per second
- Queuing
	- A request arrives on a highly loaded system

<img src="/images/Pasted image 20260912133838.png" alt="image" width="500">

- Retry storm
	- When many failed requests are repeatedly retried at one, creating more load
- Metastable failure
	- A system enters a bad state that continues even after the original cause is gone
	- Internal load or retries keep the failure going
- Exponential backoff
	- A retry stategy where the delay increases after each failure
	- Double each time, to reduce pressure on a struggling service
- Circuit breaker algorithm
	- Stops requests to a failing service after repeated errors
	- Periodically test if service has recovered
- Token bucket algorithm
	- A rate-limiting algorithm where requests consume tokens that refill overtime, allowing controlled traffic bursts while limiting average request rate
- Load shedding
	- Intentionally rejecting or dropping some requests when overloaded so the system can continue serving higher priority or manageable traffic
- Backpressure
	- A mechanism where a slow or overloaded consumer signals upstream producers to slow down or stop sending more work
- Scalability
	- Maximum throughput can be significantly increased by adding computing resources

## Latency and Response Time

- Response time
	- What client sees
	- All delays incurred anywhere in the system
- Service time
	- Duration fro which the service is actively processing the client's request
- Queuing delays
	- Several points in the flow
	- GPU
	- Packet
- Latency
	- A request is not being actively processed

<img src="/images/Pasted image 20260912135040.png" alt="image" width="500">

- Head of line blocking
	- Slow requests hold up the processing of subsequent requests

## Average, Median, and Percentiles

<img src="/images/Pasted image 20260912135156.png" alt="image" width="500">

- Average response time
	- Arithmetic mean
- Percentiles
- Tail latencies (high response time percentiles)
	- Directly affect users's experience

## Use of Response Time Metrics

- Tail latency amplification
	- Small numbers of slow requests disproportionately increase the latency of an entire distributed operations
	- Specifically on parallel services
- Service level objectives (SLOs)
- Service level agreements (SLAs)

- Open source percentile estimation libraries
	- HdrHistogram
	- t-digest
	- OpenHistogram
	- DDSketch
# Reliability and Fault Tolerance

- Fault
	- Occurs when a particular part of a system stops working correctly
- Failure
	- Occurs when the system as a whole stops providing the required service to the user

## Fault Tolerance

- If the system continues providing the required service to users in spite of certain faults occurring
- Single point of failure (SPOF)
	- A fault escalates to cause a system failure
- Exactly once semantics
	- A guarantee that an operation or message has its effect applied once and only once, even if retires, duplicates, or failures occur
- Fault injection
	- Ensures fault tolerance machinery is continually exercised and tested
- Chaos engineering
	- Aims to improve confidence in fault-tolerance mechanisms through experiments
## Hardware and Software Faults

Failure Rate
- 2-5%, Magnetic hard drives
- 0.5-1%, SSD
- Data RAM

### Tolerating hardware faults through redundancy

- Add redundancy to the individual hardware components to reduce failure rate of the system
- RAID
- Dual power supplies
- Hot swappable CPUs
- Batteries and diesel generators for backup power
- Availability zones
	- Identify which resources are physically co-located
	- Resources in the same place are more likely to fail at the same time than geographically separated resources
- Rolling upgrade
	- Multi node fault-tolerant systems can be patched by restarting one node at a time, without affect the service for users

### Software faults

- Software faults are often very highly correctly
- Software bug
- A runaway process
- A service that the system depends on slows
- An interaction between different systems
- Cascading failures

## Humans and Reliability

- Technical measures to minimize human mistakes
	- Property testing
	- Rollback mechanisms
	- Gradual rollout
	- Detailed and clear monitoring
	- Observability
- Blameless postmortems
	- Shared full details about how an error occurred
# Scalability

- A system's ability to cope with increased load
## Understanding Load

- Measure of throughput
	- Requests per second
	- Number of GB of new data per day
	- Number of checkout per hour
- Ratio of reads to writes
- Hit rate on a cache
- Number of data items per user

- Determine the affect on system resources
- Keep the performance of the system within the requirements of the SLA while also minimizing the cost of running the system
- Linear scalability
	- Doubling the resources will enable to handle double the load
	- Performance the same

## Shared-Memory, Shared-Disk, and Shared-Nothing Architectures

- Vertical scaling/scaling up
	- Increasing the resources of a single machine
		- CPU, RAM, storage
- Horizontal scaling/scaling out
	- Adding more machines/instances to distribute the workload
- Share memory architecture
	- Processes belong to the same machine
- Shared disk architecture
	- Several machines with independent CPUs and RAM
	- Store data on an array of disks that are shared among machines
- Network attached storage (NAS)
- Storage area network (SAN)
	- On premises data warehousing workloads
- Shared nothing architecture/horizontal scaling
	- Distributed system with multiple nodes
		- Own CPUs, RAM, and disks
		- Scales linearly
		- Best price/performance ratio
## Principles for Scalability

- Autoscaling systems
	- Automatically adds or removes resources in response to demand
# Maintainability

- Operability
	- Organization can run the system smoothly
- Simplicity
	- New engineers and understand the system
	- Well understood, consistent patterns and structures
- Evolvability
	- Engineers can make changes to the system in the future

## Operability: Making Life Easy for Operations

- Monitoring tools
- Avoiding dependency on individual machines
- Good documentation
- Self-healing
- Predictable behaviour
## Simplicity: Managing Complexity

- Essential complexity
	- Inherent in the problem domain
- Accidental complexity
	- Arises only because of limitation of tooling

- Abstraction
	- Hides implementation detail
- Design patterns
- Domain driven design (DDD)

## Evolvability: Making Change Easy

- Agile
	- Framework for adapting to change
	- Test driven development (TDD)
	- Refactoring
	- Evolvability