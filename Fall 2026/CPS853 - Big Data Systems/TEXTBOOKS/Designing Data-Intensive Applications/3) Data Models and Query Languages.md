
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
## Many-to-One and Many-to-Many Relationships
## Stars and Snowflakes: Schemas for Analytics
## When to Use Which Model
# Graph-Like Data Models

## Property Graphs
## The Cypher Query Language

## Graph Queries in SQL
## Triple Stores and SPARQL
## Datalog: Recursive Relational Queries

## GraphQL
# Event Sourcing and CQRS
# DataFrames, Matrices, and Arrays
