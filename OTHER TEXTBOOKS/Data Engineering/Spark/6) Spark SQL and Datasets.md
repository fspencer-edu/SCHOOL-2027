
- Salient aspects of Datasets
	- How strongly typed distributed collections are created, stored, and serialized and deserialized in Spark

# Single API for Jave and Scala

- Only Scala and Java are strongly typed
- Python and R support only the untyped DataFrame API
- Datasets are domain specific typed objects that can be operated on in parallel using functional programming or DSL operators

## Scala Case Classes and JavaBeans for Datasets

- Spark internal data types
	- `StringType`
	- `BinaryType`
	- `IntegerType`
	- `BooleanType`
	- `MapType`
- Create a case class the defined the object
- Names of the fields in the Scala case class or Java class definition must match the order in the data source
- Column names for each row in the data are automatically mapped to the corresponding names in the class and the types are automatically preserved

# Working with Datasets

- Create a Scala object with 3 fields
	- `uid`
	- `uname`
	- `usage`

## Creating Sample Data

```scala
// In Scala
import scala.util.Random._
// Our case class for the Dataset
case class Usage(uid:Int, uname:String, usage: Int)
val r = new scala.util.Random(42)
// Create 1000 instances of scala Usage class 
// This generates data on the fly
val data = for (i <- 0 to 1000) 
  yield (Usage(i, "user-" + r.alphanumeric.take(5).mkString(""),
  r.nextInt(1000)))
// Create a Dataset of Usage typed data
val dsUsage = spark.createDataset(data)
dsUsage.show(10)

+---+----------+-----+
|uid|     uname|usage|
+---+----------+-----+
|  0|user-Gpi2C|  525|
|  1|user-DgXDi|  502|
|  2|user-M66yO|  170|
|  3|user-xTOn6|  913|
|  4|user-3xGSz|  246|
|  5|user-2aWRN|  727|
|  6|user-EzZY1|   65|
|  7|user-ZlZMZ|  935|
|  8|user-VjxeG|  756|
|  9|user-iqf1P|    3|
+---+----------+-----+
only showing top 10 rows
```

## Transforming Sample Data

- Datasets are strongly typed collections of domain specific objects
- Objects can be transformed in parallel using functional or relational operations

### Higher Order Functions and Functional Programming

```scala
// In Scala
import org.apache.spark.sql.functions._
dsUsage
  .filter(d => d.usage > 900)
  .orderBy(desc("usage"))
  .show(5, false)
```


- Create a Scala case class or JavaBean class, `UsageCost`, with an additional field or column named `cost`
- Define a function to compute the `cost` and use it in the `map()` method

```scala
// In Scala
// Create a new case class with an additional field, cost
case class UsageCost(uid: Int, uname:String, usage: Int, cost: Double)

// Compute the usage cost with Usage as a parameter
// Return a new object, UsageCost
def computeUserCostUsage(u: Usage): UsageCost = {
  val v = if (u.usage > 750) u.usage * 0.15 else u.usage * 0.50
    UsageCost(u.uid, u.uname, u.usage, v)
}

// Use map() on our original Dataset
dsUsage.map(u => {computeUserCostUsage(u)}).show(5)

+---+----------+-----+------+
|uid|     uname|usage|  cost|
+---+----------+-----+------+
|  0|user-Gpi2C|  525| 262.5|
|  1|user-DgXDi|  502| 251.0|
|  2|user-M66yO|  170|  85.0|
|  3|user-xTOn6|  913|136.95|
|  4|user-3xGSz|  246| 123.0|
+---+----------+-----+------+
only showing top 5 rows
```

- Higher order functions and Datasets
	- JVM objects as arguments to functions
	- Dot notation to access individual fields
	- Functions and lambda signatures can be type-sage, ensuring compile time error detection
	- Code is readable, expressive, and concise
	- Datasets use encoders
		- Efficiently convert data between JVM and Spark's internal binary

### Converting DataFrames to Datastes

- Convert DataFrames to Datasets

```Scala
// In Scala
val bloggersDS = spark
  .read
  .format("json")
  .option("path", "/data/bloggers/bloggers.json")
  .load()
  .as[Bloggers]
```

# Memory Management for Datasets and DataFrames

- Spark is an intensive in-memory distributed big data engine
	- RDD-based Java objects for memory storage, serialization, and deserialization
		- Expensive in terms or resources and slow
		- Storage was allocated on the Java heap
	- Project Tungsten
		- Internal row-based format to lay out Datasets and DataFrames in off heap memory, using offsets and pointers
		- Encoders to serialize and deserialize between the JVM and its internal Tungsten format
	- Second generation Tungsten engine
		- Whole stage code generation and vectorized column based memory layout
# Dataset Encoders

- Encoders convert data in off-heap memory from Spark's internal Tungsten format to JVM Java objects
- Serialize and deserialize Dataset objects from Spark's internal format to JVM objects, including primitive data types
- Built-in support for automatically generating encoders for primitive types

```python
Encoder<UsageCost> usageCostEncoder = Encoders.bean(UsageCost.class);
```

## Spark's Internal Format vs. Java Object Format

- Java objects have large overheads
	- Header info
	- Hashcode
	- Uniode info
- Spark allocates off-heap Java memory to lay out their data and employs encoders to convert the data from in-memory representation to JVM

<img src="/images/Pasted image 20261013135416.png" alt="image" width="500">

- Data is stored in a continuous manner and accessible through pointer arithmetic and offsets

## Serialization and Deserialization (SerDe)

- Serialization and derserialization
	- Process by which a typed object is encoded into a binary presentation or format by the sender and decoded from binary format into its respective data-typed object by the received
	- Data that travels over the network
- Dataset encoders
	- Tungsten binary format stored objects off the Java heap memory, and it's compact so those objects occupy less space
	- Encoders can quickly serialize by traversing across the memory using simple pointer arithmetic with memory addresses and offsets
	- On the receiving end, encoders can quickly deserialize the binary representation into Spark's internal representation

<img src="/images/Pasted image 20261013135727.png" alt="image" width="500">
# Costs of Using Datasets

- When Datasets are passed to higher order functions that take lambdas and functional arguments, there is a cost associated with deserializing from Spark's internal Tungsten format into the JVM object

## Strategies to Mitigate Costs

- Use DSL expressions in queries
- Avoid excessive use of lambdas as anonymous functions as arguments to higher-order functions
- Chain queries that minimize serialization and deserialization

```scala
// In Scala
Person(id: Integer, firstName: String, middleName: String, lastName: String,
gender: String, birthDate: String, ssn: String, salary: String)

personDS
  .filter(year($"birthDate") > earliestYear) // Everyone above 40
  .filter($"salary" > 80000) // Everyone earning more than 80K
  .filter($"lastName".startsWith("J")) // Last name starts with J
  .filter($"firstName".startsWith("D")) // First name starts with D
  .count()
```