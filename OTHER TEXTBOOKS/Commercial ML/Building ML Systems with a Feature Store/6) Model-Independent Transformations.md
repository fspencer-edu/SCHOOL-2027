
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



# DAG of Feature Functions
# Credit Card Fraud Features
# Composition of Transformations

