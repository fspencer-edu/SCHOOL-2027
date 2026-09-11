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
	- 
## Systems of Record and Derived Data

# Cloud vs. Self-Hosting

## Pros and Cons of Cloud Services
## Cloud Native System Architecture
## Operations in the Cloud Era

# Distributed vs. Single-Node Systems

## Problems with Distributed Systems
## Microservices and Serverless
## Cloud Computing vs. Supercomputing

# Data Systems, Law, and Society