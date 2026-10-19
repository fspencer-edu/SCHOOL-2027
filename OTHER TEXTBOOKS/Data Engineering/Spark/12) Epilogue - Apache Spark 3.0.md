
# Spark Core and Spark SQL

- Expedite queries by reading less data using dynamic partition pruning
- Adapt and optimize query plans during execution

## Dynamic Partition Pruning (DPP)

- Skip over data that is not used for query results
- Joining two tables
	- A fact table and a dimension table
- Filter is on the non-partitioned side of the table

```SQL
SELECT * FROM Sales JOIN ON Sales.date = Date.date
```

<img src="/images/Pasted image 20261019000211.png" alt="image" width="500">

- take the result of the filter from the dimension table and inject it into the fact table as part of the scan operation to limit the data read
- On the dimension side, Spark builds a hash table from the dimension table, also called the build relation
- Spark will plug the result of this query into the hash table and assign it to a broadcast variable
	- Distributed to all executors
- On each executor, Spark will probe the broadcasted hash table to determine what corresponding rows to read from the fact table
- Spark will inject this filter dynamically into the file scan operation of the fact table and reuse the results from the broadcast variable

<img src="/images/Pasted image 20261019000433.png" alt="image" width="500">

## Adaptive Query Execution (AQE)

- Reoptimizes and adjusts query plans based on runtime statistics collected in the process of query execution
- Reduce the number of reducers in the shuffle stage by decreasing the number of shuffle partitions
- Optimize the physical execution plan of the query
- Handle data skew during join

<img src="/images/Pasted image 20261019000551.png" alt="image" width="500">

### The AQE Framework

- Spark operations in a query are pipelined and executed in parallel processes
- Shuffle or broadcast exchange is needed as input to the next stage
- Materialization points
	- Reoptimize and re-examine the query


<img src="/images/Screenshot 2026-10-19 at 12.07.11 AM.png" alt="image" width="500">
<img src="/images/Screenshot 2026-10-19 at 12.07.17 AM.png" alt="image" width="500">
<img src="/images/Screenshot 2026-10-19 at 12.07.22 AM.png" alt="image" width="500">

- All the leaf nodes of each stage are executed
- Once the materialization point finished, its marked as complete
- Based on statistics (partitions read, bytes of data read), the framework runs the Catalyst optimizer again to understand whether
	- Coalesce the number of partitions to reduce the number or reducers to read shuffle data
	- Replace a sort merge join, based on the size of tables read, with a broadcast join
	- Try to remedy a skew join
	- Create a new optimized logical plan, and physical plan

- Re-optimization is done dynamically
	- Dynamically coalesce the shuffle partitions
	- Decrease reducers
	- Switch join strategies
	- Remedy any skew joins

## SQL Join Hints

- Adds join hints for all Spark join strategies

### Shuffle sort merge join (SMJ)

- Suggest to Spark that it perform a `SortMergeJoin` when joining tables

### Broadcast Hash Join (BHJ)

- Provide a hint to Spark for a broadcast join
### Shuffle hash join (SHJ)

### Shuffle and replicate nested loop join (SNLJ)

## Catalog Plugin API and DataSourceV2

- Enables plugging in an external data source for catalog and table management
- Supports predicate pushdown to additional data sources with supported file formats like ORC, Parquet, Kafka, Cassandra, Delta Lake, and Apache Iceberg
- Provides unified APIs for streaming and batch processing of data sources for sinks and sources

<img src="/images/Pasted image 20261019001411.png" alt="image" width="500">

- In SQL issue commands to create namespaces for catalog

## Accelerator Aware Scheduler

- Project Hydrogen
	- A community initiative to bring AI and big data together
		- Implementing barrier execution mode
		- Accelerator aware scheduling
		- Optimized data exchange
- Specify hardware resources available
# Structured Streaming

- Two more statistics tabs
	- Aggregate information about completed streaming query jobs
	- Detailed statistics about the streaming queries
		- Input rate, process rate, number of input rows, batch duration, and operation duration
# PySpark, Pandas UDFs, and Pandas Function APIs

- Spark 3.0 requires
	- Pandas version 0.23.2 or higher
	- PyArrow version 0.12.1 or later

## Redesigned Pandas UDFs with Python Type Hints

- Naturally express UDFs without requiring the evaluation type

```python
# Pandas UDFs in Spark 3.0
import pandas as pd
from pyspark.sql.functions import pandas_udf

@pandas_udf("long")
def pandas_plus_one(v: pd.Series) -> pd.Series:
  return v + 1
  
df = spark.range(3)
df.withColumn("plus_one", pandas_plus_one("id")).show()

+---+--------+
| id|plus_one|
+---+--------+
|  0|       1|
|  1|       2|
|  2|       3|
+---+--------+
```

## Iterator Support in Pandas

- If a model is very large, then there is high overhead for the Pandas UDF to repeatedly load the same model
- Load the model once instead of for every series in the iterator

```python
from typing import Iterator      

@pandas_udf('long')
def pandas_plus_one(iterator: Iterator[pd.Series]) -> Iterator[pd.Series]:
    return map(lambda s: s + 1, iterator)

df.withColumn("plus_one", pandas_plus_one("id")).show()

+---+--------+
| id|plus_one|
+---+--------+
|  0|       1|
|  1|       2|
|  2|       3|
+---+--------+
```

## New Pandas Function APIs

- take an iterator as input and output another iterator

```python
def pandas_filter(
    iterator: Iterator[pd.DataFrame]) -> Iterator[pd.DataFrame]:
  for pdf in iterator:
    yield pdf[pdf.id == 1]

df.mapInPandas(pandas_filter, schema=df.schema).show()

+---+
| id|
+---+
|  1|
+---+
```

# Changed Functionality

- Languages supported and deprecated
- Changes to the DataFrame and Dataset API
- DataFrame and SQL explain commands
- 