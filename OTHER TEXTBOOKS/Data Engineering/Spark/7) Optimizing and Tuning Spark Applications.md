
# Optimizing and Tuning Spark for Efficiency

## Viewing and Setting Apache Spark Configurations

- Get and set Spark properties
	- Configuration files
	- Specify Spark configurations directly in your Spark application or on the command line when submitting the application with `spark-submit`, with the `--conf` flag
	- Programmatic interface via the Spark shell
	- Access Spark's current configuration through the Spark UI's Environment tab

## Scaling Spark for Large Workloads

- Large Spark workloads are often batch jobs
	- Nightly basis
	- Scheduled at regular intervals during the day
- Job failures
	- Source starvation
	- Gradual performance degradation
- Spark components
	- Spark driver
		- Coordinate with the cluster manager to launch executors in a cluster and schedule Spark tasks non them
	- Executor
	- Shuffle service

### Static vs. Dynamic resource allocation

- Dynamic resource allocation configuration
	- Driver can request more or fewer compute resources as the demand of large workflows and ebbs
- Streaming
	- Data flow volume may be uneven
- On demand data analytics
	- High volume of SQL queries during peak hours
- Multi-tenant environment
	- Spark may be developed alongside other applications or services in YARN, Mesos, or Kubernetes

### Configuring Spark Executors' memory and the shuffle service

- Amount of memory available to each executor is controlled by `spark.executor.memory`
	- Execution memory - 60%
	- Storage memory - 40%
	- Reserved memory - 300 MB

<img src="/images/Pasted image 20261015144820.png" alt="image" width="500">

- Execution memory
	- Spark shuffles, joins, sorts, and aggregations
- Storage memory
	- Used for caching user data structures and partitions derived from DataFrames
- Map and shuffle operation configurations
	- Map, spill, and merge processes
- Tuning the shuffle service running on each executors can aid in increasing overall performance for large workloads

### Maximizing Spark Parallelism

- read and process as much data in parallel as possible
- A partition is a way to arrange data into a subset of configurable and readable chunks or blocks of contiguous data on disk
- At least as many partitions as there are cores on the executor

<img src="/images/Pasted image 20261015145305.png" alt="image" width="500">

#### How partitions are created

- 

# Caching and Persistence of Data
# A Family of Spark Joins
# Inspecting the Spark UI
