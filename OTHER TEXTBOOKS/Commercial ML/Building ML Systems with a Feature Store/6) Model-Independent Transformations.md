
- Feature pipelines are the programs that execute model independent data transformations to produce reusable features that are stored in the feature store
- Feature data created could be used by potentially many different models

- EVAC transformations
	- Feature extraction
		- Lagged features
		- Binning
		- Chunking for LLMs
	- Data validation and cleaning
	- Aggregation
	- Compression

# Source Code Organization

<img src="/images/Pasted image 20261109215138.png" alt="image" width="500">

- Source for the different FTI pipelines is stored in a pipelines directory
- Store tests in separate files in a dedicated directory outside the pipeline
- 2 types of testes
	- Features tests
		- Unit tests for computing features
	- Pipeline tests
		- End to end tests for pipeline
- Separate the functions used to compute features from the program that implement the FTI pipelines
- Place feature functions in the features directory
- Monorepo
	- Source code for entire system in in a single source code repo
- Python library dependencies are needed to containerize ML pipeline programs

# Feature Pipelines

- Feature pipelines read data from some data source
- Transform that data to create features
- Write their output feature data to the feature store

- Engines
	- Stream processing for streaming feature pipelines
		- Python
		- Java
		- SQL
	- DataFrame for batch feature pipelines
		- Python
	- Data warehouses for batch feature pipelines
		- SQL

- Open source engines
	- Pandas
	- Polars
	- Apache Spark
	- Apache Flink
	- Feldera

- Data processing frameworks
	- Scale to process data that is too big to be processed by a single server
		- Apache Spark
		- Apache Flink
	- Stream processing frameworks
		- Feldera
		- Apache Flink
		- Spark Structured Streaming
	- SUpport real-time computation of feature data in prediction requests
		- Python UDFs
	- Batch data transformations
		- Pandas
		- Polars
		- DuckDB
		- PySpark

<img src="/images/Pasted image 20261109215727.png" alt="image" width="500">

- Data warehouses
	- Snowflake
	- BigQuery
	- Databricks
	- Photon
	- Redshift
	- DuckDB
	- dbt

<img src="/images/Pasted image 20261109215836.png" alt="image" width="500">

- Prefer DF compute engines over SQL
	- Fetch data from APIs
	- Extensive data cleaning
	- Transform unstructured data
	- Use feature engineering libraries that are only available in Python
	- Write transformations with custom logic

- Scale up feature engineering with DF on a single machine by using Polar
	- Better use of available memory and CPUs
- When too large for a single machine, use PySpark
	- Scaled out over many workers

- Use SQL over DataFrame
	- Batch feature pipeline
	- All of the source data is in the data warehouse or lakehouse
	- Feature engineering can be implemented in SQL

# Data Transformations for DataFrames

- Feature engineering with both DataFrames and SQL tables involves performing row-wise and column-wise transformations on the data

- Class of transformations
	- Expressions
	- User-defined functions (UDFs)
	- Filter and join transformations
	- Group by and aggregation

<img src="/images/Pasted image 20261110075309.png" alt="image" width="500">


- Transformation cardinalities
	- Row size preserving transformation
	- Row/column size-reducing transformation
	- Row/column size-increasing transformation
	- Join transformation

## Row Size Preserving Transformation

```python
def detect_outliers(value_series: pd.Series) -> pd.Series:
    """Add a column that indicates whether the row is an outlier"""
    mean = value_series.mean()
    std_dev = value_series.std()
    z_scores = (value_series - mean) / std_dev
    return np.abs(z_scores) > 3

df["is_outlier"] = detect_outliers(df["value"])

def remove_outliers(df: pd.DataFrame) -> pd.DataFrame:
    """Remove the rows in the DataFrame where is_outlier is True"""
    return df[df["is_outlier"] == False]

df_filtered = remove_outliers(df)

# Polars

df = df.with_columns(
    pl.col("col1").map_elements(lambda x: x * 2).alias("new_col")
)

# Rolling window expression

df.with_columns(
    (col("amount").rolling_mean(3).over("cc_num")).alias("rolling_avg")
)

# Conditional transformations

df.with_columns(
    (pl.when(df["col"]==0)
    .then("positive").otherwise("non_positive"))
    .alias("new_col")
)

# Temporal transformations

df.with_columns(
    (pl.lit(datetime.now()) - pl.col("last_modified"))
    .dt.total_days()
    .alias("days_since_bank_cr_changed")
)

# Sorting and ranking

df.with_columns(pl.col("col").rank().alias("rank_col"))

# Mathematical transformations

df.with_columns((pl.col("col1") + pl.col("col2")).alias("sum_col"))

# String transformations

df.with_columns(uppercase_name = pl.col("name").str.to_uppercase())

# Lag and lead

df.with_columns(lagged_pm25 = pl.col("pm25").shift(1))
```

## Row and Column Size-Reducing Transformations

- Aggregations
	- Reduce the number of rows from the input DF
- Common aggregation functions
	- count
	- Sum
	- Mean/median
	- Max/min
	- Standard deviation/variance
	- Percentiles
	
- Use `group_by` and a window
- Forward fill strategy
	- Replacing null values with the last valid non-null value that appeared earlier in the data

```python
filled_df = (df.with_columns(pl.col("amount").fill_null(strategy="forward"))
              .group_by("cc_num", maintain_order=True)
              .agg([
                  pl.col("event_time"),
                  pl.col("amount").sum().alias("total_amount")
              ])
              .explode(["event_time"]))
```

- Aggregations support different types of time windows
- Rolling window aggregations
	- Compute an output for every row in the source DF
	- Not size reducing
- Tumbling windows
	- Compute an output for all events in a window length
	- Reduce the number of rows
- Composing aggregation transformations

```python
df3 = df.group_by("cc_num").agg(
    pl.col("amount").filter(pl.col("category").count() > 1).max()
)
```

- Vector embeddings
	- Another data transformation type that compresses input data
	- Embedding model
	- Vector is a fixed-sized array (dimension)
	- Search similar strings with kNN
		- Probabilistic algorithm that returns k records containing vector embeddings that are semantically close to the provided vector embeddings

```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')
embeddings = model.encode(df["explanation"].to_list())
df = df.with_columns(embedding_explanation=pl.lit(embeddings))
```

## Row/Column Size-Increasing Transformations

- Extract values in the JSON object as new columns
- Exploring the column containing the JSON object

```python
df = pl.DataFrame({
    "json_col": [
        {"name": "Alice", "age": 25, "city": "Palo Alto"}, 
        {"name": "Bob", "age": 30, "city": "Dublin"},
    ]})

df_exploded = df.unnest("json_col")
```

- PySpark
	- User-defined table functions (UDTFs)
		- Functions that transform a single input row into multiple output rows
		- Explode a JSON structure in a column to multiple rows based on deeply nested fields
		- Parallel across Spark tasks
	- UDF
		- Row-to-row basis

```python
pivot = (
    df.group_by(["cc_num", "category"])
    .agg(pl.col("amount").sum())
    .pivot(on="category", values="amount", index="cc_num")
    .fill_null(0)
)
pivot = pivot.rename(
    {col: f"spend_{col}" for col in pivot.columns if col != "cc_num"}
)

dv_unpivot = df.unpivot(index=["cc_num"], on=["category"])

```


## Join Transformations

- Include features that belong to different entities
- Join two or more DF using a common join key

```python
merged_df = transaction_df.join(account_df, on="cc_num", how="inner")

```

# DAG of Feature Functions

- Feature logic (transformations) should be factored into feature functions to improve code modularity and make transformations unit-testable

1) Read data from one or mode data sources into DFs
2) Apply feature functions to transform data into features and to join feature together
3) Write a DataFrame containing featurized data to the corresponding feature group

- Parametrize the feature pipeline by its data input so that you can run the feature pipeline either with historical data or with new incremental data
- Feature pipeline organizes the feature function in a dataflow graph
	- Directed acyclic graph (DAG)
		- Inputs (data sources)
		- Nodes (DataFrames)
		- Edges (feature functions)
		- Outputs (feature groups)

<img src="/images/Pasted image 20261110113802.png" alt="image" width="500">

- The graph structure inherently represent dependencies among the transformations

## Lazy DataFrames

- Pandas supports eager evaluation of operations on DF
- Each command is processed right away
- In constrast, DF frameworks that support lazy evaluation wait across multiple steps before the commands are executed
	- Optimize the execution of steps
	- An action triggers the execution of the transformation on it

```python
# Lazy loading with pl.scan_csv
lazy_df = pl.scan_csv("transactions.csv")

# Compute the mean, then create a new column for deviation from mean
lazy_df = lazy_df.with_columns([
    (pl.col("amount") - pl.col("amount").mean()).alias("deviation_from_mean")
])

# Trigger execution and collect the result
result = lazy_df.collect()
```

## Vectorized Compute, Multicore, and Arrow

- DataFrame transformations that follow these idioms are executed by a vectorized compute engine and not executed in native Python code
- Python's standard execution model is interpreted bytecode that lacks native vectorization
- Python programs are constrained by the Global Interpreter Lock
	- Prevents efficient scalability on multiple CPU cores
- A vectorized compute engine performs operations on large arrays or data structures by applying single instructions to multiple data point simultaneously
	- Single instruction, multiple data (SIMD)
- Write data transformations so that they are executed in the vectorized compute engine rather than run in Python as interpreted bytecode

<img src="/images/Pasted image 20261110133145.png" alt="image" width="500">

```python
import numpy as np
def numpy_udf(series: pd.Series) -> pd.Series:
    return series * 1.1 + np.sin(series)

df['pandas_udf_result'] = numpy_udf(df['value'])

import polars as pl
df_polars = pl.DataFrame({'value': np.random.rand(num_rows) * 100})

df_polars_expr = df.with_columns(
    (pl.col("value") * 1.1 + pl.col("value").sin()).alias("result")
)
```

- Polar has good multicore support
	- Better memory management for larger data volumes

```python
import duckdb
con = duckdb.connect()
con.register("input_df", df)

result_df = con.execute("""
    SELECT 
        value, 
        value * 1.1 + SIN(value) AS result 
    FROM input_df
""").fetchdf()
```


- Pandas, Polars, PySpark, and DuckDB all can natively exchange their data as Arrow tables
	- Zero (memory) copy
	- Move DF without overhead
- Arrow
	- Language dependent in-memory columnar format that is an efficient format for data interchange among different programming languages and frameworks
	- Supports dictionary compression
	- Serialized format
	- Send over the network
	- Arrow Flight is a network protocol for transferring Arrow data from Hopsworks to Python clients

```python
import pyarrow as pa

pdf = pd.DataFrame({
    'name': ['Alice', 'Bob', 'Charlie', 'David'],
    'age': [25, 30, 35, 40],
    'salary': [50000, 60000, 75000, 90000]
})

# Convert Pandas DataFrame to PyArrow Table (zero-copy if possible)
# Zero-copy if all columns are already Arrow-compatible types


arrow_table = pa.Table.from_pandas(pdf)

# Convert to Polars DataFrame (zero-copy)
pldf = pl.from_arrow(arrow_table)

pldf_transformed = pldf.with_columns([
    pl.when(pl.col('age') < 35)
    .then(pl.lit('Young'))
    .otherwise(pl.lit('GettingOn'))
    .alias('age_category')
])

arrow_table_transformed = pldf_transformed.to_arrow()

con = duckdb.connect()
con.register('employee_table', arrow_table_transformed)

# Transform salary to categorical in DuckDB SQL
result_df = con.execute("""
    SELECT name, age_category, 
        CASE 
            WHEN salary < 60000 THEN 'Junior'
            WHEN salary BETWEEN 60000 AND 80000 THEN 'Senior'
            ELSE 'Staff'
        END as salary_band
    FROM employee_table
""").df()
con.close()

fg.insert(result_df)
```

- Create a Pandas DB
- Convert to PyArrow Table with zero copy
- Load into Polars and transform into a new categorical column
- Convert the Polars DF back to array and register it as a table in DuckDB

## Data Types

- ML pipeline interoperate via a shared data layer, the feature store, and every feature store has its own set of supported data types
- Loss of precision for some data type if the feature pipeline compute engine supports higher-precision data types than the feature store or if the training/inference pipeline supports lower-precision data types

### Arrays, structs, maps, and tensors

- Hopsworks stores the expected primitive data types
	- int, string, boolean, float, double, long, decimal, timestamp, data
	- Arrays, structs, maps
- Vector embeddings are stored as an array of floats
- Tensor
	- Multidimensional numerical data structure that can represent data in more than one dimensions
	- Constructed from unstructured data, such as images, videos, and audio signals, enabling the representation and processing of complex data formats

<img src="/images/Pasted image 20261110134034.png" alt="image" width="500">

- PyTorch reprsents tensors as instances of the `torch.Tensor` class
	- Default type being `torch.float32`
- Training/inference pipeline transform unstructured data into tensors after it has been read from files

```python
import torch
from torchvision import transforms
from PIL import Image
image = Image.open("path/to/your/image.png")

# Define a transformation pipeline to convert the image into a tensor
transform = transforms.Compose([ transforms.ToTensor() ])
image_tensor = transform(image)
```

- Preprocess the files in a training dataset pipeline that outputs tensors as files, such as TFRecord File
	- File format that natively stores serialized tensors
	- Improve CPU and GPU utilization

### Implicit or explicit schemas for feature groups

- Schema of a feature group can be inferred from the first DF inserted into it
- Pandas can infer the schema of columns when reading CSV
- Best practice to explicitly specify the schema for a feature group, which helps to prevent any type inference errors or precision errors

```python
from hsfs.feature import Feature
features = [
    Feature(name="id",type="int", online_type="int"),
    Feature(name="name",type="string",online_type="varchar(2000)")
]

fg = fs.create_feature_group(name="fg_with_explicit_schema",
                             features=features,
                             …)
fg.save(features)
```

# Credit Card Fraud Features

- Data-related challenges
	- Class imbalance
	- Non-stationary prediction problems
	- Data drift
	- ML fraud models

<img src="/images/Pasted image 20261110134459.png" alt="image" width="500">

<img src="/images/Pasted image 20261110134549.png" alt="image" width="500">

- All the features computed for the `cc_trains_aggs_fg` feature group require stateful data transformations

# Composition of Transformations

- In batch pipelines, compute aggregations over a window of time

<img src="/images/Pasted image 20261110134701.png" alt="image" width="500">

- Compute larger windows from the smallest window to reduce amount of work

<img src="/images/Pasted image 20261110134729.png" alt="image" width="500">

```python
def compute_mean(days):
    window_spec = \
        Window.partitionBy("user_id").orderBy("date").rowsBetween(-days, 0)
        df = df.withColumn(f"{days}d_avg",
        F.sum(F.col("daily_mean") * F.col("daily_count")).over(window_spec) /
        F.sum("daily_count").over(window_spec))
```


- Sum of squares is an alternative approach, requires an additional column storing the sum of squares

