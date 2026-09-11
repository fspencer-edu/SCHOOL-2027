- Data intensive
	- Data management is a primary challenge
	- Consistency
- Compute intensive
	- Parallelizing a large computation is the primary challenge

- Common application functionality
	- Databases
	- Caches
	- Search indexes
	- Stream processing
	- Batch processing

- Enterprise software
	- The software needs and engineering practices of large organizations, corporations, and governments

- Frontend
	- Client side code
- Backend
	- Server side code
	- Stateless
	- Persistent data needs to be stored either on the client or in the server data infrastructure

# Operational vs. Analytical Systems

Backend engineeers
- Build services that handle requests for reading and updating data
	- Business analysts
	- Data scientists

- Operational systems
	- Backend services and data infrastructure where data is created
- Analytical systems
	- Contain a read-only copy of the data from the operational system
	- Optimized for data processes needed for anayltics

- Data engineers
	- Integrate the operational and analytical systems
- Analytics engineers
	- Model and transform data for BI

## Characterizing Transaction Processing and Analytics

- Transaction
	- A group of reads and writes that form a logical unit
- Point query
	- Small number of records by a key
- Online transaction processing (OLTP)
- Online analytical processing (OLAP)

- Product analytics/real time analytics
	- Queries that aggregate over many records but embedded into user-facing products

## Data Warehousing

- Stop using OLTP systems for analytics purposes
- Run the analytics on a separate database warehouse
- Data silos
	- Data of interest is spread across multiple operational systems
	- Difficult to combine datasets in a single query
- Data warehouse
	- A separate database that analysts can query without affecting OLTP
	- Contain read only copy of data
	- Periodic data dump or continuous stream of updates
	- Transformed into analysis friendly schema, cleaned
	- Extract-transform-load (ETL)

![[Pasted image 20260911132529.png]]

- ETL for SaaS APIs is implemented by data connector services
	- Fivetran
	- Singer
	- Air-byte
- Hybrid transactional/analytical processing (HTAP)
	- Enable OLTP and analytics in a single system without ETL

### From data warehouse to data lake

- Data warehouse
	- Relational data
- Transforming data that is used to train ML models
	- Vector or matrix values called features
		- Feature engineering
	- Custom code that can not be expressed using SQL
- Natural language processing (NLP) techniques on textual data

- Data lake
	- A centralized data repository that hold a copy of any data that might be useful for analysis
	- Obtained from operational systems via ETL processes
	- Contains files, with no specific file format, data model, or schema
	- Encoded
		- Avro
		- Parquet
	- Cheaper than relational data storage
	- Commoditized file storage such as object stores
	- Contains raw data

- ETL have been generalized to data pipelines

### Beyond the data lake

- DataOps
	- Management of operations of analytical systems and data pipelines
	- Governance, privacy, and regulations with General Data Protection Regulation (GDPR) and California Consumer Privacy Act (CCPA)
- Stream processing allows analytical systems to respond faster than traditional analytical processing
- Reverse ETL
	- Analytical systems available to operational systems
	- ML models deployed to operational systems
		- TFX
		- Kubeflow
		- MLflow

## Systems of Record and Derived Data

- System of record
	- Source of truth
	- Hold the authoritative or canonical version of data
	- Normalized
- Derived data systems
	- Result of taking existing data form another system and transforming it
	- Re created from original source
	- Cache
		- Data can be served from the cache if present, but if not falls back to underlying database
	- Denormalized values, indexes, materialized views
	- Transform data representations
	- Trains models
	- Redundant

- Analytical systems are usually derived data systems
- Operational services can contain a mixture of systems or records and derived data systems
- Data integration
	- Compose multiple data systems to achieve more than one system

# Cloud vs. Self-Hosting

- Core competency or a competitive advantage should be done in house
- Non-core, routing or commonplace should be left to a vendor
- On the shelf software (open source or commercial) that you self-hold, or deploy

## Pros and Cons of Cloud Services

- Cloud providers
	- Save time and money
	- Allow you to move faster compared to personal infrastructure
	- Valuable if load on system varies over time

## Cloud Native System Architecture

- Cloud native
	- An architecture that is designed to take advantage of cloud services

### Layering of cloud services

| Category             | Self-hosted systems            | Cloud native systems                                         |
| :------------------- | :----------------------------- | :----------------------------------------------------------- |
| **Operational/OLTP** | MySQL, PostgreSQL,<br>MongoDB  | AWS Aurora, Azure SQL DB<br>Hyperscale, Google Cloud Spanner |
| **Analytical/OLAP**  | Teradata,<br>ClickHouse, Spark | Snowflake, Google BigQuery, Azure<br>Synapse Analytics       |
|                      |                                |                                                              |

- Self-hosted data systems
	- Run on OS
	- Store data as files
	- Communicate via network protocols (TCP/IP)
	- Use generic computing resources

- Cloud
	- IaaS environment
	- One or more VM (instances)
	- Provisioned faster with a greater varies of machine sizes

- Object storage services
	- Amazon S3, Azure Blob Storage, Cloudflare R2
	- Distributes the data across many machines

### Separation of storage and compute

- RAID is used to maintain copies of the data on several disks attached to the same machine
- Compute instances may also have local disks attached
	- Ephemeral cache
	- Virtual disk storage
		- Amazon EBS, Azure managed disks, Google Cloud
	- Block device
		- Where each block is typically 4 KiB
		- Run traditional disk-based software in the cloud
		- Emulation introduces overheads that can be avoided
		- Sensitive to network glitches

- In cloud native systems, storage and computation are disaggregated
- Transfer data over network
- Multitenant
	- Data and computation from multiple customers are handled on the same shared hardware by the same service
	- Better hardware utilization
	- Easier scalability
	- Easier management

## Operations in the Cloud Era

- Database administrators (DBAs) or systems administrators (sysadmins)
- DevOps
	- Backend services and data infrastructure
		- Setting up automation
		- Using ephemeral VMs rather than long running servers
		- Enabling frequent application updates
		- Learning from incidents
		- Preserving the organization's knowledge about the system
# Distributed vs. Single-Node Systems

- Distributed system
	- A system that involved several machines communicating via a network
	- Each process participates as a node
- Use case
	- Inherent distribution
	- Requests between cloud services
	- Fault tolerance/high availability
	- Scalability
	- Latency
	- Elasticity
	- Specialized hardware
	- Legal compliance
	- Sustainability

## Problems with Distributed Systems

- Every request and API call travels through the network and must deal with possible failure
- Faster to bring the computation to the machine that already has the data
- Troubleshooting a distributed system is more difficult
- Tracing tools
	- OpenTelemetry
	- Zipkin
	- Jaeger
- Maintaining consistency of data across services
	- Distributed transactions
		- Run counter to the goal of making services independent

## Microservices and Serverless

- Clients make requests to the servers
- Service-oriented architecture (SOA)
- Microservices architecture
	- A service has a one well-defined purpose
	- Each service exposes an API that can be called by clients via the network
	- Each service has one team that is responsible for its maintenance
	- Decomposed into multiple interacting services
- Each service can be updated independently
- Assigned specific hardware resources
- Each service has its own databases and do not share between services

- Serverless, of function as a service (FaaS)
	- Deploying services, in which the management of the infrastructure is outsources to a cloud vendor
	- Automatically allocates and frees hardware resources as needed

## Cloud Computing vs. Supercomputing

- High performance computing (HPC), also known as supercomputing
	- Computationally intensive scientific computing tasks
	- Runs large batch jobs
	- Communicate through shared memory and RDMA
		- High bandwidth and low latency
		- Specialized topologies
		- Nodes are close together
	- Cloud datacenter networks are often based on IP and Ethernet
		- Clos topologies to provide high bisection bandwidth
		- Multiple geographic regions

# Data Systems, Law, and Society

- Data minimization
	- Personal data may be collected only for a specified, explicit purpose
	- Cannot later be used for any other purpose
	- Must not be kept for longer than necessary
- Payment Card Industry (PCI)
- Service Organization Control (SOC)