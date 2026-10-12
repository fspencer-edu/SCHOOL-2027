- Use user-defined functions for both Apache Hive and Apache Spark
- Connect with external data sources such as JDBC and SQL databases, PostgresQL, MySQL, Tableau, Azure Cosmos DB, and MS SQL Server
- Work with simple and complex types, higher order functions, and common relational operators
# Spark SQL and Apache Hive
]
- Shark was originally built on the Hive codebase on top of Apache Spark
- Fast as an enterprise data warehouse, and scaling a well as Hive/MapReduce

## User Defined Functions (UDFs)

### Spark SQL UDFs

- Wrap an ML model within UDF so that a data analyst can query its predications in SPark SQL without necessarily understanding the internal of the model

```python
# In Python
from pyspark.sql.types import LongType

# Create cubed function
def cubed(s):
  return s * s * s

# Register UDF
spark.udf.register("cubed", cubed, LongType())

# Generate temporary view
spark.range(1, 9).createOrReplaceTempView("udf_test")
```

### Evaluation order and null checking in Spark SQL

- Spark SQL does not guarantee the order of evaluation of subexpressions
- To perform proper `null` checking
	- Make the UDF `null` aware and do `null` checking inside the UDF
	- Use `IF` or `CASE WHEN` expressions to do the `null` check and invoke the UDF in a conditional branch

### Speeding up and distributing PySpark UDFs with Pandas UDFs

- PySpark UDFs had slower performance than Scala
	- PySpark UDFs required data movement between the JVM and python
	- PandasUDF (vectorized UDFs) were introduced
	- Uses Apache Arrow to transfer data and Pandas to work with the data
- Pandas UDFs were split into two API categories
	- Pandas UDFs
		- Infer the Pandas UDF type
	- Pandas Function APIs
		- Directly apply a local Python function to a PySpark DataFrame where both the input and output are Pandas instances

```python
# Import pandas
import pandas as pd

# Import various pyspark SQL functions including pandas_udf
from pyspark.sql.functions import col, pandas_udf
from pyspark.sql.types import LongType

# Declare the cubed function 
def cubed(a: pd.Series) -> pd.Series:
    return a * a * a

# Create the pandas UDF for the cubed function 
cubed_udf = pandas_udf(cubed, returnType=LongType())
```

- Using a vectorized UDF will result in the execution of Spark jobs
- Previous function executed only on the Spark driver
- The job starts with the `parallelize()` to send local data to executors and calls `mapPartitions()` to convert the Arrow binary batches to Spark's internal data format

# Querying with Spark SQL Shell, Beeline, and Tableau

- Query Apache Spark
	- Spark SQL shell
	- Beeline CLI utility
	- Tableau and Power BI

## Using the Spark SQL Shell

- STS (Spark Thrift Server)
	- Allows JDBC/ODBC clients to execute SQL queries over JDBC and OCBD protocols on Apache Spark

```cli
./bin/spark-sql
spark-sql> CREATE TABLE people (name STRING, age int);
INSERT INTO people SELECT name, age FROM ...

spark-sql> INSERT INTO people VALUES ("Michael", NULL);
Time taken: 1.696 seconds
spark-sql> INSERT INTO people VALUES ("Andy", 30);
Time taken: 0.744 seconds
spark-sql> INSERT INTO people VALUES ("Samantha", 19);
Time taken: 0.637 seconds
spark-sql>

spark-sql> SHOW TABLES;
default   people     false
Time taken: 0.016 seconds, Fetched 1 row(s)

spark-sql> SELECT * FROM people WHERE age < 20;
Samantha  19
Time taken: 0.593 seconds, Fetched 1 row(s)
```


## Working with Beeline

- Beeline is a common utility for running HiveQL queries against HiveServer2
- Beeline is a JDBC client based on the SQLLine CLI
- By default, Beeline is in non-secure mode
	- Username is the login and password is blank

```cli
./sbin/start-thriftserver.sh

./sbin/start-all.sh

./bin/beeline

!connect jdbc:hive2://localhost:10000

0: jdbc:hive2://localhost:10000> SHOW tables;

+-----------+------------+--------------+
| database  | tableName  | isTemporary  |
+-----------+------------+--------------+
| default   | people     | false        |
+-----------+------------+--------------+
1 row selected (0.417 seconds)

0: jdbc:hive2://localhost:10000> SELECT * FROM people;

+-----------+-------+
|   name    |  age  |
+-----------+-------+
| Samantha  | 19    |
| Andy      | 30    |
| Michael   | NULL  |
+-----------+-------+
3 rows selected (1.512 seconds)

0: jdbc:hive2://localhost:10000>

./sbin/stop-thriftserver.sh
```

## Working with Tableau

# External Data Sources

## JDBC and SQL Databases

- Specify the JDBC driver from your JDBC data source and it will need to be on the Spark classpath
- Tables from the remote database can be loaded as a DataFrame or Spark SQL temporary view

```SQL
user, passowrd
url
dtable
query
driver
```

### The importance of partitioning

- Partition data source
- All data is going through the one driver connection, which can saturate the slow down the performance of your extraction

```sql
numPartitions
partition
Column
lowerBound
upperBound
```

- A good starting point for `numPartitions` is to use a multiple of the number of Spark workers
- Maximize the number of concurrent requests to the source system
- For systems lacking processing windows (OLTP), reduce the the number of concurrent requests to prevent saturation of the source system
- Calculate the `lowerBound` and `upperBound` based on the minimum and maximum `partitionColumn` action value
- Choose a `partitionColumn` that can be uniformly distributed to avoid data skew
## PostgreSQL

```python
bin/spark-shell --jars postgresql-42.2.6.jar

# In Python
# Read Option 1: Loading data from a JDBC source using load method
jdbcDF1 = (spark
  .read
  .format("jdbc") 
  .option("url", "jdbc:postgresql://[DBSERVER]")
  .option("dbtable", "[SCHEMA].[TABLENAME]")
  .option("user", "[USERNAME]")
  .option("password", "[PASSWORD]")
  .load())

# Read Option 2: Loading data from a JDBC source using jdbc method
jdbcDF2 = (spark
  .read 
  .jdbc("jdbc:postgresql://[DBSERVER]", "[SCHEMA].[TABLENAME]",
          properties={"user": "[USERNAME]", "password": "[PASSWORD]"}))

# Write Option 1: Saving data to a JDBC source using save method
(jdbcDF1
  .write
  .format("jdbc")
  .option("url", "jdbc:postgresql://[DBSERVER]")
  .option("dbtable", "[SCHEMA].[TABLENAME]") 
  .option("user", "[USERNAME]")
  .option("password", "[PASSWORD]")
  .save())

# Write Option 2: Saving data to a JDBC source using jdbc method
(jdbcDF2
  .write 
  .jdbc("jdbc:postgresql:[DBSERVER]", "[SCHEMA].[TABLENAME]",
          properties={"user": "[USERNAME]", "password": "[PASSWORD]"}))
```

## MySQL

- Build or download the JDBC jar from Maven or MySQL

```python
bin/spark-shell --jars mysql-connector-java_8.0.16-bin.jar

# In Python
# Loading data from a JDBC source using load 
jdbcDF = (spark
  .read
  .format("jdbc")
  .option("url", "jdbc:mysql://[DBSERVER]:3306/[DATABASE]")
  .option("driver", "com.mysql.jdbc.Driver") 
  .option("dbtable", "[TABLENAME]")
  .option("user", "[USERNAME]")
  .option("password", "[PASSWORD]")
  .load())

# Saving data to a JDBC source using save 
(jdbcDF
  .write 
  .format("jdbc") 
  .option("url", "jdbc:mysql://[DBSERVER]:3306/[DATABASE]")
  .option("driver", "com.mysql.jdbc.Driver") 
  .option("dbtable", "[TABLENAME]") 
  .option("user", "[USERNAME]")
  .option("password", "[PASSWORD]")
  .save())
```

## Azure Cosmos DB

```pyhon
bin/spark-shell --jars azure-cosmosdb-spark_2.4.0_2.11-1.3.5-uber.jar

# In Python
# Loading data from Azure Cosmos DB
# Read configuration
query = "SELECT c.colA, c.coln FROM c WHERE c.origin = 'SEA'"
readConfig = {
  "Endpoint" : "https://[ACCOUNT].documents.azure.com:443/", 
  "Masterkey" : "[MASTER KEY]",
  "Database" : "[DATABASE]",
  "preferredRegions" : "Central US;East US2",
  "Collection" : "[COLLECTION]",
  "SamplingRatio" : "1.0",
  "schema_samplesize" : "1000",
  "query_pagesize" : "2147483647",
  "query_custom" : query
}

# Connect via azure-cosmosdb-spark to create Spark DataFrame
df = (spark
  .read
  .format("com.microsoft.azure.cosmosdb.spark")
  .options(**readConfig)
  .load())

# Count the number of flights
df.count()

# Saving data to Azure Cosmos DB
# Write configuration
writeConfig = {
 "Endpoint" : "https://[ACCOUNT].documents.azure.com:443/",
 "Masterkey" : "[MASTER KEY]",
 "Database" : "[DATABASE]",
 "Collection" : "[COLLECTION]",
 "Upsert" : "true"
}

# Upsert the DataFrame to Azure Cosmos DB
(df.write
  .format("com.microsoft.azure.cosmosdb.spark")
  .options(**writeConfig)
  .save())
```

## MS SQL Server

```python
bin/spark-shell --jars mssql-jdbc-7.2.2.jre8.jar

# In Python
# Configure jdbcUrl
jdbcUrl = "jdbc:sqlserver://[DBSERVER]:1433;database=[DATABASE]"

# Loading data from a JDBC source
jdbcDF = (spark
  .read
  .format("jdbc") 
  .option("url", jdbcUrl)
  .option("dbtable", "[TABLENAME]")
  .option("user", "[USERNAME]")
  .option("password", "[PASSWORD]")
  .load())

# Saving data to a JDBC source
(jdbcDF
  .write
  .format("jdbc") 
  .option("url", jdbcUrl)
  .option("dbtable", "[TABLENAME]")
  .option("user", "[USERNAME]")
  .option("password", "[PASSWORD]")
  .save())
```

## Other External Sources

- Apache Cassandra
- Snowflake
- MongoDB

# Higher-Order Functions in DataFrames and Spark SQL

- Manipulating complex data types
	- Exploring the nested structure into individual rows, applying some function, and then recreating the nested structure
- Building a user-defined function

- Utility functions
	- `get_json_object()`
	- `from_json()`
	- `to_json()`
	- `explode()`
	- `selectExpr()`

## Option 1 - Explode and Collect

- `explode(values)`
	- Creates a new row for each element within `values`

```SQL
-- In SQL
SELECT id, collect_list(value + 1) AS values
FROM  (SELECT id, EXPLODE(values) AS value
        FROM table) x
GROUP BY id
```

## Option 2 - User-Defined Function

- Create a UDF that uses `map()` to iterate through each element and perform the additional operations

```SQL
// In Scala
def addOne(values: Seq[Int]): Seq[Int] = {
    values.map(value => value + 1)
}
val plusOneInt = spark.udf.register("plusOneInt", addOne(_: Seq[Int]): Seq[Int])
```

- `collect_list()`
	- May cause executors to experience out-of-memory issues for large datasets
	- Using UDFs would alleviate these issues

## Built-in Functions for Complex Data Types

```SQL
array_distinct(array<T>): array<T>

array_intersect(array<T>, array<T>): array<T>

array_union(array<T>, array<T>): array<T>

array_except(array<T>, array<T>): array<T>

array_join(array<String>, String[, String]): String

array_max(array<T>): T

array_min(array<T>): T

array_position(array<T>, T): Long
```

## Higher Order Functions

- Higher order functions that take anonymous lambda functions as arguments

```SQL
-- In SQL
transform(values, value -> lambda expression)
```

- `transform()`
	- Takes an array and anonymous function as input
	- Creates a new array by applying the anonymous function to each element, and then assigning the result to the output array

```python
# In Python
from pyspark.sql.types import *
schema = StructType([StructField("celsius", ArrayType(IntegerType()))])

t_list = [[35, 36, 32, 30, 40, 42, 38]], [[31, 32, 34, 55, 56]]
t_c = spark.createDataFrame(t_list, schema)
t_c.createOrReplaceTempView("tC")

# Show the DataFrame
t_c.show()

spark.sql("""
SELECT celsius, 
 transform(celsius, t -> ((t * 9) div 5) + 32) as fahrenheit 
  FROM tC
""").show()

+--------------------+--------------------+
|             celsius|          fahrenheit|
+--------------------+--------------------+
|[35, 36, 32, 30, ...|[95, 96, 89, 86, ...|
|[31, 32, 34, 55, 56]|[87, 89, 93, 131,...|
+--------------------+--------------------+
```

- `filter()`
	- Produces an array consisting of only the elements of the input array for which the Boolean function is `true`

```python
// In Scala/Python
// Filter temperatures > 38C for array of temperatures
spark.sql("""
SELECT celsius, 
 filter(celsius, t -> t > 38) as high 
  FROM tC
""").show()

+--------------------+--------+
|             celsius|    high|
+--------------------+--------+
|[35, 36, 32, 30, ...|[40, 42]|
|[31, 32, 34, 55, 56]|[55, 56]|
+--------------------+--------+
```

- `exists()`
	- Returns `true` if the Boolean function holds for any element in the input array

```python
// In Scala/Python
// Is there a temperature of 38C in the array of temperatures
spark.sql("""
SELECT celsius, 
       exists(celsius, t -> t = 38) as threshold
  FROM tC
""").show()

+--------------------+---------+
|             celsius|threshold|
+--------------------+---------+
|[35, 36, 32, 30, ...|     true|
|[31, 32, 34, 55, 56]|    false|
+--------------------+---------+
```

- `reduce()`
	- Reduces the elements of an array to a single value by merging the elements into a buffer `B` using `function<B, T, B>`, and applying a finishing `function<B, R>` on the final buffer

```python
// Calculate average temperature and convert to F
spark.sql("""
SELECT celsius, 
       reduce(
          celsius, 
          0, 
          (t, acc) -> t + acc, 
          acc -> (acc div size(celsius) * 9 div 5) + 32
        ) as avgFahrenheit 
  FROM tC
""").show()

+--------------------+-------------+
|             celsius|avgFahrenheit|
+--------------------+-------------+
|[35, 36, 32, 30, ...|           96|
|[31, 32, 34, 55, 56]|          105|
+--------------------+-------------+
```

# Common DataFrames and Spark SQL Operations

- DataFrame operations
	- Aggregate functions
	- Collection functions
	- Dataime functions
	- Math functions
	- Miscellaneous functions
	- Non-aggregate functions
	- Sotring functions
	- String functions
	- UDF functions
	- Window functions

- Common relational operations
	- Unions and joins
	- Windowing
	- Modifications

- Prepare data
	- Import two files and create two DataFrames
	- Use `expr()`, convert the `delay` and `distance` columns from `STRING` to `INT`
	- Create a smaller table

```python
from pyspark.sql.functions import expr
tripdelaysFilePath = 
  "/databricks-datasets/learning-spark-v2/flights/departuredelays.csv"
airportsFilePath = 
  "/databricks-datasets/learning-spark-v2/flights/airport-codes-na.txt"
  
# Obtain airports data set
airports = (spark.read
  .format("csv")
  .options(header="true", inferSchema="true", sep="\t")
  .load(airportsFilePath))

airports.createOrReplaceTempView("airports")

# Obtain departure delays data set
departureDelays = (spark.read
  .format("csv")
  .options(header="true")
  .load(tripdelaysFilePath))

departureDelays = (departureDelays
  .withColumn("delay", expr("CAST(delay as INT) as delay"))
  .withColumn("distance", expr("CAST(distance as INT) as distance")))

departureDelays.createOrReplaceTempView("departureDelays")

# Create temporary small table
foo = (departureDelays
  .filter(expr("""origin == 'SEA' and destination == 'SFO' and 
    date like '01010%' and delay > 0""")))
foo.createOrReplaceTempView("foo")
```

## Unions

- Union two different DataFrames with the same schema together
- `union()`

```python
# In Python
# Union two tables
bar = departureDelays.union(foo)
bar.createOrReplaceTempView("bar")

# Show the union (filtering for SEA and SFO in a specific time range)
bar.filter(expr("""origin == 'SEA' AND destination == 'SFO'
AND date LIKE '01010%' AND delay > 0""")).show()
```


```SQL
-- In SQL
spark.sql("""
SELECT * 
  FROM bar 
 WHERE origin = 'SEA' 
   AND destination = 'SFO' 
   AND date LIKE '01010%' 
   AND delay > 0
""").show()

+--------+-----+--------+------+-----------+
|    date|delay|distance|origin|destination|
+--------+-----+--------+------+-----------+
|01010710|   31|     590|   SEA|        SFO|
|01010955|  104|     590|   SEA|        SFO|
|01010730|    5|     590|   SEA|        SFO|
|01010710|   31|     590|   SEA|        SFO|
|01010955|  104|     590|   SEA|        SFO|
|01010730|    5|     590|   SEA|        SFO|
+--------+-----+--------+------+-----------+
```

## Joins

- Join two DataFrame together
- Default is `inner join`
	- Other options
		- `inner`
		- `cross`
		- `outer`
		- `full`
		- `full_outer`
		- `left`
		- `left_outer`
		- `right`
		- `right_outer`
		- `left_semi`
		- `left_anti`

```python
# In Python
# Join departure delays data (foo) with airport info
foo.join(
  airports, 
  airports.IATA == foo.origin
).select("City", "State", "date", "delay", "distance", "destination").show()
```

```SQL
-- In SQL
spark.sql("""
SELECT a.City, a.State, f.date, f.delay, f.distance, f.destination 
  FROM foo f
  JOIN airports a
    ON a.IATA = f.origin
""").show()
```

## Windowing

- A windowing function uses values from the rows in a window to return a set of values, typically in the form of another row
- Operate on a group of rows while still returning a single value for every input row
- `dense_rank()`
	- Quickly ascertain that the destinations with the worst delays for the three origin cities
	- Each windowing grouping needs to fit in a single executor and will get composed into a single partition during execution

- Ranking functions
	- `rank()`
	- `dense_rank()`
	- `percent_ranl()`
	- `ntile()`
	- `row_number()`
- Analytic functions
	- `cume_dist()`
	- `first_value()`
	- `last_value()`
	- `lag()`
	- `lead()`

## Modifications

- Modify DataFrames through operations that create new, different DataFrames, with different columns

### Adding new columns

```python
// In Scala/Python
foo.show()

--------+-----+--------+------+-----------+
|    date|delay|distance|origin|destination|
+--------+-----+--------+------+-----------+
|01010710|   31|     590|   SEA|        SFO|
|01010955|  104|     590|   SEA|        SFO|
|01010730|    5|     590|   SEA|        SFO|
+--------+-----+--------+------+-----------+

# In Python
from pyspark.sql.functions import expr
foo2 = (foo.withColumn(
          "status", 
          expr("CASE WHEN delay <= 10 THEN 'On-time' ELSE 'Delayed' END")
        ))
```

### Dropping columns

```python
# In Python
foo3 = foo2.drop("delay")
foo3.show()

+--------+--------+------+-----------+-------+
|    date|distance|origin|destination| status|
+--------+--------+------+-----------+-------+
|01010710|     590|   SEA|        SFO|Delayed|
|01010955|     590|   SEA|        SFO|Delayed|
|01010730|     590|   SEA|        SFO|On-time|
+--------+--------+------+-----------+-------+
```
### Renaming columns

```python
foo4 = foo3.withColumnRenamed("status", "flight_status")
foo4.show()

+--------+--------+------+-----------+-------------+
|    date|distance|origin|destination|flight_status|
+--------+--------+------+-----------+-------------+
|01010710|     590|   SEA|        SFO|      Delayed|
|01010955|     590|   SEA|        SFO|      Delayed|
|01010730|     590|   SEA|        SFO|      On-time|
+--------+--------+------+-----------+-------------+
```

### Pivoting

- Swap the columns for the rows

```SQL
-- In SQL
SELECT destination, CAST(SUBSTRING(date, 0, 2) AS int) AS month, delay 
  FROM departureDelays 
 WHERE origin = 'SEA'

+-----------+-----+-----+
|destination|month|delay|
+-----------+-----+-----+
|        ORD|    1|   92|
|        JFK|    1|   -7|
|        DFW|    1|   -5|
|        MIA|    1|   -3|
|        DFW|    1|   -3|
|        DFW|    1|    1|
|        ORD|    1|  -10|
|        DFW|    1|   -6|
|        DFW|    1|   -2|
|        ORD|    1|   -3|
+-----------+-----+-----+
only showing top 10 rows

SELECT * FROM (
SELECT destination, CAST(SUBSTRING(date, 0, 2) AS int) AS month, delay 
  FROM departureDelays WHERE origin = 'SEA' 
) 
PIVOT (
  CAST(AVG(delay) AS DECIMAL(4, 2)) AS AvgDelay, MAX(delay) AS MaxDelay
  FOR month IN (1 JAN, 2 FEB)
)
ORDER BY destination

+-----------+------------+------------+------------+------------+
|destination|JAN_AvgDelay|JAN_MaxDelay|FEB_AvgDelay|FEB_MaxDelay|
+-----------+------------+------------+------------+------------+
|        ABQ|       19.86|         316|       11.42|          69|
|        ANC|        4.44|         149|        7.90|         141|
|        ATL|       11.98|         397|        7.73|         145|
|        AUS|        3.48|          50|       -0.21|          18|
```