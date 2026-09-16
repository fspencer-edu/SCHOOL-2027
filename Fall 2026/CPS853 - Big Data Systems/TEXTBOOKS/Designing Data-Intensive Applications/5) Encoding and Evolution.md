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

- 


 
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

- Code generation tools

## Avro

### 
### 
## The Merits of Schemas

### 
### 

# Modes of Dataflow


### 
###

## Dataflow Through Databases
## Dataflow Through Services: REST and RPC
## Durable Execution and Workflows
## Event-Driven Architectures
