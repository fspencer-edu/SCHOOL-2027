
- Two broad classes of storage solutions
	- Databases
	- Data laks
	- Lakehouses
# The Importance of an Optimal Storage Solution

- Properties in a storage solution
	- Scalability and performance
	- Transaction suport
	- Support for diverse data formats
	- Support for diverse workloads
	- Openness
# Databases

## A Brief Introduction to Databases

- Databases are designed to store structured data as tables
- 2 categories
	- Online transaction processing (OLTP)
	- Online analytical processing (OLAP)
- Apache Spark is a query engine primarily designed for OLAP, not OLTP

## Reading from and Writing to Databases Using Apache Spark

- Connects to databases that have JDBC drivers
- Dedicated connections for modern databases
	- Azure Cosmos DB
	- Snowflake

## Limitations of Database

- Growth in data sizes
- Growth in the diversity of analytics

- Database limitations
	- Expensive to scale out
	- Do not support non-SQL based analytics well
# Data Lakes

- A data lake is a distributed storage solution that runs on commodity hardware and easily scales out horizontally

## A Brief Introduction to Data Lakes

- Decouples the distributed storage system from the distributed compute system
- Data is saved as files with open formats
- Hadoop File System (HDFS)
- Building a data lake
	- Storage system
	- File format
		- Structured
			- Parquet
			- ORC
		- Semi structured
			- JSON
		- Unstructured
			- Text, images, audio, video
	- Processing engines

- Data lakes provide a cheaper solution than databases

## Reading from and writing to Data Lakes using Apaches Spark

- Support for diverse workloads
- Support for diverse file formats
- Support for diverse filesystems
- Cloud storage systems often do not have the same file operation semantics expected from a standard filesystem, which can lead to inconsistent results

## Limitations of Data Lakes

- Lack of transactional guarantees
	- Atomicity and isolation
	- Consistency
- Work arounds
	- Large collection of data files in data lakes are partitioned by subdirectories based on a column's value
	- Schedules of data update jobs and data querying jobs

# Lakehouses - The Next Step in the Evolution of Storage Solutions

- Lakehouse is a new paradigm that combines the best elements of data lakes and data warehouses for OLAP workloads
- New system design that provides data management features similar to databases at the low cost, and scalability used for data lakes
	- Transaction support
	- Schema enforcement and governance
	- Support for diverse data types in open formats
	- Support for diverse workloads
	- Support for upserts and deletes
	- Data governance

- Open source systems
	- Apache Hudi, Apache Iceberg, Delta Lake
	- Store large volumes of data in structured file formats on scalable filesystems
	- Maintain a transaction log to record a timeline of atomic changes to the data
	- Use the log to define versions of the table data and provide snapshot isolation
	- Suport reading and writing to tables using Apache Spark

- 

# Building Lakehouses with Apache Spark and Delta Lake