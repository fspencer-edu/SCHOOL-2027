
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

- Relational databases
	- Queries by SQL
- Document databases
	- Key-value access by primary key
	- Secondary indexes
	- XML
		- XQuery
		- XPath
	- JSON
		- JSON Pointer
		- JSONPATH

### Convergence of document and relational databases

- Relational-document hydrids
- Relational model with JSON within a relational schema
	- Nonsimple domains
	- A value in a row does not have to be a primitive datatype
	- Nested relation

# Graph-Like Data Models

- Vertices (nodes/entities)
- Edges (relationships/arcs)

1) Social graphs
2) Web graph
3) Road or rail networks

- Adjacency list model
	- Each vertex stores the IDs of its neighbours
	- Graph traverals
- Adjacency matrix
	- 2-dim array in which each row and column correspond to a vertex
	- Machine learning

- Property graph model
	- Neo4j
- Triple store model
	- Datomic
- Query languages for graphs
	- Cypher
	- SPARQL
	- Datalog
	- GraphQL
	- Gremlin

## Property Graphs

- Property/labeled property graph model
- Each vertex consists of the following
	- ID
	- Label to describe the type of objects this vertex represents
	- A set of outgoing edges
	- A set of incoming edges
	- Key-value pairs
- Each edge consists
	- ID
	- Vertex at edge start (vertex tail)
	- Vertex at edge ends (head vertex)
	- Label of the relationships between two vertices
	- Key-value pairs
- Any vertex can have an edge connecting it with any other vertex
- Given any vertex, traverse the graph
- Store several kinds of information in a single graph
- Edge can associate only two vertices with each other
	- Relational join tables can represent 3-way or higher-degree relationships (hypergraph)
- Good for evolvability
	- Extend data structures

## The Cypher Query Language

- Cypher is a query language for property graph
- Each vertex is given a symbolic name
	- Stored internally within the query to create edges between the vetices
	- Arrow notation creates an edge

```graphql
CREATE
  (namerica :Location {name:'North America',  type:'continent'}),
  (usa      :Location {name:'United States',  type:'country'  }),
  (idaho    :Location {name:'Idaho',          type:'state'    }),
  (lucy     :Person   {name:'Lucy' }),
  (idaho) -[:WITHIN ]-> (usa)  -[:WITHIN]-> (namerica),
  (lucy)  -[:BORN_IN]-> (idaho)
  
MATCH
  (person) -[:BORN_IN]->  () -[:WITHIN*0..]-> (:Location {name:'United States'}),
  (person) -[:LIVES_IN]-> () -[:WITHIN*0..]-> (:Location {name:'Europe'})
RETURN person.name
```

## Graph Queries in SQL

- Every edge traversed in a graph query  is effectively a join with the `edges` table
- Variable length traversal paths
	- Recursive common table expressions (`WITH RECURSIVE`)

- Breadth first
- Depth first traversal
- Graph Query Language (GQL) ISO

## Triple Stores and SPARQL

- Triple store model is mostly equivalent to the property graph model
- All information is stored in the form of a simple 3-part statement
	- (subject, predicate, object)
	- Store additional data on each tuple

```SPARQL
@prefix : <urn:example:>.
_:lucy     a       :Person.
_:lucy     :name   "Lucy".
_:lucy     :bornIn _:idaho.
_:idaho    a       :Location.
_:idaho    :name   "Idaho".
_:idaho    :type   "state".
_:idaho    :within _:usa.
_:usa      a       :Location.
_:usa      :name   "United States".
_:usa      :type   "country".
_:usa      :within _:namerica.
_:namerica a       :Location.
_:namerica :name   "North America".
_:namerica :type   "continent".
```

- Linked data structures
	- JSON-LD
	- Facebook's Open Graph protocol

### RDF data model

- Turtle language
	- Encoding data in the Resource Description Framework (RDF)
	- Semantic Web
	- XML

```xml
<rdf:RDF xmlns="urn:example:"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

  <Location rdf:nodeID="idaho">
    <name>Idaho</name>
    <type>state</type>
    <within>
      <Location rdf:nodeID="usa">
        <name>United States</name>
        <type>country</type>
        <within>
          <Location rdf:nodeID="namerica">
            <name>North America</name>
            <type>continent</type>
          </Location>
        </within>
      </Location>
    </within>
  </Location>

  <Person rdf:nodeID="lucy">
    <name>Lucy</name>
    <bornIn rdf:nodeID="idaho"/>
  </Person>
</rdf:RDF>
```

- Subject, predicate, and object of a triple are often URIs

### The SPARQL query language

- SPARQL is a query language for triple stores using the RDF data model

```SPARQL
PREFIX : <urn:example:>

SELECT ?personName WHERE {
  ?person :name ?personName.
  ?person :bornIn  / :within* / :name "United States".
  ?person :livesIn / :within* / :name "Europe".
}
```

- RDF does not distinguish between properties and edges
- Uses predicates for both
## Datalog: Recursive Relational Queries

- Complex queries
	- Datomic
	- LogicBlox
	- CozoDB
- Based on a relational data model, but has recursive queries on graph
- Contents are known as facts
- Each fact corresponds to a row in a relational table
- Allows complex queries to be built up rule by rules

```Datalog
location(1, "North America", "continent").
location(2, "United States", "country").
location(3, "Idaho", "state").

within(2, 1).    /* US is in North America */
within(3, 2).    /* Idaho is in the US     */

person(100, "Lucy").
born_in(100, 3). /* Lucy was born in Idaho */
```
## GraphQL

- Query language that is more restrictive than others
- OLTP
	- Allow clients software to request a JSON document with a particular structures
	- Contains fields necessary for UI rendering
- Change queries in client code without changing server side APIs
- Need tooling to convert the queries into requests to internal services (REST or GPRC)
- Challenging for authorization, rate limiting, and performance
- Does not allowed recursive queries
- Does not allow arbitrary search conditions

```graphql
query ChatApp {
  channels {
    name
    recentMessages(latest: 50) {
      timestamp
      content
      sender {
        fullName
        imageUrl
      }
      replyTo {
        content
        sender {
          fullName
        }
      }
    }
  }
}
```

# Event Sourcing and CQRS

- Write data in one form and then derive from it representations that are optimized for different types of reads
	- Event log
	- Materialized views/projections/read models
	- Event sourcing
		- Using source of truth and expressing every state change
		- Command query responsibility segregation (CQRS)
- Better communicate the intent of an event
- Materialized views are derived from the event log in a reproducible way
- Multiple materialized views that are optimized
- Build new materialized easily
- rRite a subsequent deletion event to reverse an error event
- Audit logs
- Handle higher write throughput than databases from sequential access
- Events are immutable
	- Crypto shredding
- Reprocessing events requires more work if there are visible side effects

- Message brokers
	- Store event log
- Stream processors
	- Keep materialized views up to date
# DataFrames, Matrices, and Arrays

- DataFrame
	- Similar to a table in a relational database
	- Relational like operators
	- Manipulated through commands that modify its structure and content
	- Transform data from a relational-like representation into a matrix or multi-dimensional array
- One hot encoding
	- Create a column for each possible categorical value
- TileDB
	- Specialize in storing large multi-dimensional arrays of numbers (array databases)
- Time series data