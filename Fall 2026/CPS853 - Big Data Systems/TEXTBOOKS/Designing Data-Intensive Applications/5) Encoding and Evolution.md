- Relational database assume that all data conform to a schema
- Schema on read do not enforce a schema
	- Database can contain a mix of older and newer formats
- Rolling update/staged rollout
	- Deploying the new version of a few nodes at a time
	- Gradually working through all nodes

- Backward compatibility
	- Ensures that newer code can read data written by older code
- Forward compatibility
	- Ensures that older code can read data written by newer code
# Formats for Encoding Data

- 2 representations of data
	- In memory
		- Objects, structs, lists, arrays, hash tables, trees
		- Optimized for efficient access and manipulation by CPU
	- Data to a file or over the network
		- Self contained sequence of bytes

- Encoding
	- Serialization
	- Marshalling
	- Translation from in memory to byte sequence
- Decoding
	- Parsing
	- Deserialization
	- Unmarshalling
	- Reverse of encoding

- Zero copy data forms
	- Used both data formats at runtime on disk without conversion
		- Cap'n Proto
		- Flatbuffers
## Language-Specific Formats

- Jave
	- `jave.io.Serializable`
- Python
	- `pickle`
- Ruby
	- `Marshal`

- Issues with encoding libraries
	- Tied to a particular language
	- Decoding is needed to restore data
	- Versioning data is difficult
	- Decreased efficiency
## JSON, XML, and Binary Variants

- Standardized encodings
	- JSON
	- XML
	- CSV
- Issues with textual encoded formats
	- XML is verbose
	- Ambiguity of data types
	- Integers cannot be represented in an IEEE 745 double precision floating point
	- JSON and XML have support for Unicode strings, but not binary strings
	- XML and JSON schema are complicated
	- CSV does not have a schema

### JSON Schema

- Widely used in web services
	- OpenAPI web service specification
	- Standard primitive types
		- `string, number, integer, object, array, boolean, null`
- Offers separate validation specification that allows defined constraints on fields
- Open or closed content model
- Open
	- Model permits any field not defined n the schema with any datatype
	- `additionalProperties=true`
	- Default
	- Does 
- Closed
	- Only allows fields that are explicitly defined
	- 
- Does not have a map or dictionary type for integer keys
- Always use strings as keys
- Keep JSON schema so keys can contain only digit value

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "patternProperties": {
    "^[0-9]+$": {
      "type": "string"
    }
  },
  "additionalProperties": false
}
```

- Supports conditional `if/else` schema logic, named types, references to remote schemas

### Binary encodings

- Binary encodings for JSON
	- MessagePack
	- CBOR
	- BSON
	- BJSON
	- UBJSON
	- BISON
	- Hessian
	- Smile
- Binary encodings for XML
	- WBXML
	- Fast Infoset

- Extend the set of datatype
	- Integers
	- Floating point
	- Binary strings

```json
{
    "userName": "Martin",
    "favoriteNumber": 1337,
    "interests": ["daydreaming", "hacking"]
}
```

<img src="/images/Pasted image 20260916175450.png" alt="image" width="500">

## Protocol Buffers

- Protocol buffers (protobuf)
	- Binary encoding library developer at Google
	- Similar to Apache Thrift
	- Require a schema for any data that is encoded
	- Describe the schema in the Protocol Buffers interface definition language (IDL)

```
syntax = "proto3";

message Person {
    string user_name = 1;
    int64 favorite_number = 2;
    repeated string interests = 3;
}
```

- Takes a schema definition and produces classes that implement the schema in various programming languages
- Call generated code to encode or decode records that conform to the schema

<img src="/images/Pasted image 20260916190148.png" alt="image" width="500">

- Encoded data contains field tags
- Fields tags are like aliases for fields
- Saves more space by packing the field type and tag number into a single byte

### Field tags and schema evolution

- Add new fields to the schema, if you give each field a new tag
- datatype annotation allows the parser to determine how many bytes it needs to skip while preserving the unknown fields
- Changing the datatype of a field is possible by risks truncated values

## Avro

- Apache Avro
	- Binary encoding format
	- Two schema language
		- Avro IDL
			- Human editing
		- Based on JSON
			- Machine readable

```avro
record Person {
    string               userName;
    union { null, long } favoriteNumber = null;
    array<string>        interests;
}
```

```json
{
    "type": "record",
    "name": "Person",
    "fields": [
        {"name": "userName",       "type": "string"},
        {"name": "favoriteNumber", "type": ["null", "long"], "default": null},
        {"name": "interests",      "type": {"type": "array", "items": "string"}}
    ]
}
```

- Use schema to determine the datatype of each field
- Binary data can be decoded only with the exact same schema

![[Pasted image 20260917120827.png]]

### The writer's schema and the reader's schema

- Writer's schema
	- Schema that is compiled into the application
- Two schemas
	- Writer's schema
	- Reader's schema
- Resolves the differences by comparing the two and translating the data from writer's to reader's schema

![[Pasted image 20260917121027.png]]

- Ignores fields that appear in the writer's schema but not reader's schema
- If a writer's schema is missing, it is fields in the a default value

![[Pasted image 20260917121141.png]]
### Schema evolution rules

- Writer can use older and newer version
- Change the datatype of the field
- Change the name of the field through aliases
### But what is the writer's schema?

- Large files with lots of records
	- Store files encoded with the same schema
	- Includes just one schema at the beginning of the file
- Database with individually written records
	- Include a version number at the beginning of every encoded record
- Sending records over a network connection
	- RPC protocol
	- Negotiate the schema version on connection setup
### Dynamically generated schemas

- Schema does not contain tag numbers
- Dynamically generated schemas
	- Generate record schema for each database table, and each column becomes a field in that record
	- Generate a new Avro schema from the updated database schema and export data int he new schema
## The Merits of Schemas

- Protocol Buffers and Avro are based on ANS.1
	- Define network protocols, and its binary encodings (DER)
	- SSL certificates (X.509)
	- Evolution of tag numbers
- Data systems implement proprietary binary encodings for their data
	- ODBC
	- JCBD
- Binary formats
	- More compact
	- Schema is a valuable form of documentation
	- Check forward and backward compatibility
	- Able to generate code from schema
	- Type checking at compile time

# Modes of Dataflow

## Dataflow Through Databases

- 
### 
###

### Different values written ad different times
### 
## Dataflow Through Services: REST and RPC

### 
### 
## Durable Execution and Workflows
### 
### 
## Event-Driven Architectures

### 
### 
