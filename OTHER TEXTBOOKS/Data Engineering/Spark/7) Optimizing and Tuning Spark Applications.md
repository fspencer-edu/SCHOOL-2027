
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
	- 
# Caching and Persistence of Data
# A Family of Spark Joins
# Inspecting the Spark UI
