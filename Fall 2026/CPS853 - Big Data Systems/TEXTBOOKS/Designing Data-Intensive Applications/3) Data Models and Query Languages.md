
Layers of An Application

1. Real world objects or data structures
	1. Business application
2. General purpose data model
	1. JSON
	2. HML
	3. Relational databases
	4. Vertices and edges in a graph
3. Representation of database
4. Bytes

- Declarative
	- Specify the pattern of the data
	- More concise
	- Better in parallel application
		- SQL
		- Cypher
		- SPARQL
		- Datalog
- Imperative
	- instructions on how to execute
		- Python
		- Have

# Relational vs. Document Models

- Data storage models
	- Relational
	- Network
	- Hierarchical
	- NoSQL
	- NewSQL

- Document models
	- Represent data s JSON
	- MongoDB
	- Couchbase

## The Object-Relational Mismatch

- Most application development is done in object oriented programming
- Translation layer required between the objects in the application code and the database models
	- Impedance mismatch

### Object-relational mapping (ORM)

 - ActiveRecord
 - Hibernate
 - Reduce boilerplate code required for translation layer
	 - Complex
	 - Used only for OLTP app development
	 - Work only with relational OLTP
	 - Automatically generate relational schemas
	 - Accidentally write inefficient queries
	 - Caching the results of database queries
	 - Managing schema migrations

### Document data model for one-to-many relationships

- JSON representation has better locality than the multi-table schema

## Normalization, Denormalization, and Joins

- Standardized lists
	- Consistent styles
	- Avoided ambiguity
	- Ease of updating
	- Localization support
	- Better search functionality
- Normalized = Use ID
- Denormalized = translate to human readable format

### Trade offs of normalization

- Denormalization
	- Self contained
	- Faster to read
	- More expensive to write
	- Analytical systems
- Normalized
	- Needs a references
	- Faster to write
	- Slower to query
	- Better for OLTP

### Denormalization in the social networking case study

- Hydrading
	- Looking up the human readable information by ID
- Denormalizing this information into the materialized timeline is too slow
- Storage cost increases by denormalization

## Many-to-One and Many-to-Many Relationships

- Associative table/join table
- Better represented in a normalized format
- Many-to-many relationships often need to be queries in both directions
	- Store ID references on both sides (denormalized)
	- Stores ID in only one place and relies on secondary indexes (normalized)
## Stars and Snowflakes: Schemas for Analytics

- Data warehouses are usually relational
- Optimized for business analysts
	- Star schema
		- Fact table
			- Can include metadata
		- Other columns in the fact table are foreign key references (dimension tables)
		- Consist of mostly many-to-one relationships
	- Snowflake schema
		- Dimensions are further broken into sub-dimensions
		- More normalized than star schemas
	- Dimensional modeling
	- One big table (OBT)
- ETL processes translate data from operational systems into the selected schema

## When to Use Which Model

- Document data model
	- Shredding
		- Splitting a document like structure into multiple tables leads to complicated application code

### Schema flexibility in the document model

- Document databases are schemaless (implicit)
	- JSON
	- XML
- Schema on read (interpreted when read)
	- Dynamic runtime
	- Advantageous if items are heterogeneous
- Schema on write (relational databases)
	- Compile time type checking

### Data locality for reads and writes

- Document storage as a single continuous string, or binary (BSON) has faster locality
- If split, multiple index lookups are required for retrieval
- Updates to a document, need the entire document to be rewritten
	- Multi table index cluster tables
	- Wide column data
	- Column families


### Query languages for documents

- 

# Graph-Like Data Models

## Property Graphs
## The Cypher Query Language

## Graph Queries in SQL
## Triple Stores and SPARQL
## Datalog: Recursive Relational Queries

## GraphQL
# Event Sourcing and CQRS
# DataFrames, Matrices, and Arrays
