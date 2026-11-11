- Batch feature pipelines
	- Program that reads data from data sources
	- Applies MITs to the extracted data
	- Stores the computed feature data in the feature store
- Run on a schedule, or incrementally
- Backfilling
	- Run on demand
	- Transform a large volume of historical data into features
- Automate feature creation in what is known as batch processing
	- Errors only need to be fixed before the next scheduled run
	- Feature data is only guaranteed to be as fresh as the time interval between batch processing runs
- Synthetic data
- Data contract
	- Providing data quality guarantees
	- Validating feature data before it is stored

# Batch Feature Pipelines

 - Feature pipelines are a type of data pipeline
	 - A program that automates the transfer and transformation of data from one or more data sources to a destination data store, known as the data sink
- ETL and ELT pipeline
	- ETL
		- Transform the data before it is written to the destination
	- ELT
		- Write the data to the destination and then transform the data in place
- Data pipeline are operational services that need to either run on a schedule or 24/7
- Batch feature pipelines are most commonly ETL pipelines
	- Python programs
		- An execution run of the program is scheduled or triggered by an orchestrator
		- Input data is read from one or more data sources with start/end timestamps
		- A directed acyclic graph (DAG) of MITs create feature data for feature groups
		- A set of data and schema validation checks are applied to the feature data
		- Feature data is saved to one or more feature groups
- ELT
	- Create popular features
		- Aggregations
		- Statistical features
		- Lagged features
		- SQL programs
	

# Feature Pipeline Data Sources

- AI systems
	- Applications
	- Services
	- Devices connected to users, machines
- Data is stored in operational databases, lakehouses, or data warehouses

- 3 types of data stores
	- Batch sources
	- Stream sources
	- API sources

<img src="/images/Pasted image 20261110184638.png" alt="image" width="500">

- Backfilling typically uses batch data to read historical data
- Scheduled batch or streaming feature pipeline read new incremental data

## Batch Data Sources

- Batch data is read as structured data

- Relational databases
- Object store and filesystems
- NoSQL data stores
	- Key-value stores
	- Document-oriented stores
	- JSON-like document stores
	- Graph databases
	- Vector databases

<img src="/images/Pasted image 20261110184916.png" alt="image" width="500">


## Streaming Data Sources

- Event streams are continuous data sources and building blocks for real-time ML systems
- Event streaming platforms are stores for event data, transporting events beteen a producer and a consumer

<img src="/images/Pasted image 20261110185308.png" alt="image" width="500">

- Event streaming platforms
	- Apache Kafka
	- RabbitMQ
	- Amazon Kinesis
	- Google Cloud Pub/Sub
	- Azure Event Hubs

- Apache Kafka
	- Events created by producers in a queue called a topic
	- Consumers can listen to a topic for new events and process them as they become available

## Unstructured Data in Object Stores and Filesystems

<img src="/images/Pasted image 20261110185540.png" alt="image" width="500">

- Text data is widely used in AI systems for natural language processing (NLP) and LLMs

## API and SaaS Sources

- Amount of enterprise data is only accessible via APIs
	- HTTP/REST APIs
- Salesforce
- HubSpot
- API stores are not a great fit for feature pipeline
- Data integration platforms
	- ETL or ELT tools that can backfill and incrementally copy data from hundreds of data sources to centralized data platform
- dtlHub
- Airbyte

# Synthetic Credit Card Data with LLMs

## A Logical Model for the Data Mart and the LLM

- Define a logical model for the credit card data mart and ask the LLM to create the synthetic data for that logical model
- The logical model is an extension of the entity-relationship (ER) diagram
- Logical model add details on columns
	- Data type
	- Cardinality
	- Distribution

- Logical model
	- Name and description of tables
		- Number of rows
	- Name, data type, and description of each column in the table
	- If a column is an index column
		- Primary key, foreign key, partition key, or event time
	- Column is a categorical value
	- Cardinality of a categorical variable
	- Shape of the distribution of values
	- Format of dates and timestamps
	- Any missing values

## LLM Prompt to Generate the Synthetic Data

```text
Below these instructions, you will find 6 different logical models for database tables. Write a Polars program to generate the data for these tables as DataFrames. Try to use Polars expressions for efficiency. If you can’t, it’s ok to use the Faker library. Write the DataFrames you created to new feature groups that you create in Hopsworks.

Write a loop that repeats 1,000 times. Select a random credit card number from the card_details, and create a fraudulent transaction for that card that represents a geographic attack—where the location of the IP addresses is so far apart and the time between the transactions is so low that the card holder could not realistically travel between the two locations within the time between the transactions. The card_present field should be true for the transaction and cc_fraud should add it as a row.

Select another random credit card number from the card_details, and create a fraudulent transaction for that card where the card is used to make many small payments (between 5 and 50) within a short period of time (between 15 minutes and 1 hour). Add the transaction as a fraudulent transaction in cc_fraud.

Write a Polars program to read the contents of the credit_card_transactions feature group for the previous day as a Polars DataFrame. Then read all of the contents of the bank_details, card_details, account_details, and merchant_details feature groups.

Then modify the DataFrames as follows and save them back as updates to feature groups in Hopsworks:
```

# Backfilling and Incremental Updates

- Synthetic data generation programs
	- Creates historical data
	- Update the slowly changing tables daily
	- Continuously add new credit card transactions to Apache Kafka

- Full load is often used instead of backfilling
- Incremental load is used as incremental processing
- Process at a frequency that
	- Ensures that feature freshness requirements are met for downstream training and inference pipelines
	- Ensure that batch pipeline processing capacity matches the rate of arrival of new data

## Polling and CDC for Incremental Data

- Polling
	- A user-defined column in each table containing the last modified time-stamp for the row
- Change data capture (CDC)
	- A system-managed timestamp storing the ingestion time for each row

### Polling

- Polling is only used for batch data sources
- Partition pruning is needed for large tables
- Default row fetch size to prevent out-of-memory errors
- Polling can miss updates to tables
- Polling can also miss late-arriving data in columnar tables
### Change Data Capture

- CDC resolves the problems of missing rows within a polling interval and late-arriving data
- Most lakehouse tables, cloud data warehouses, and row-oriented databases provide CDC APIs
- Read the changes in a feature group between the start and end timestamp

```python
df = fg.asof(end_timestamp, exclude_until=start_timestamp).read()
```
## Backfill and Incremental Processing in One Program

```python
start_time = os.environ.get('START_TIME')
end_time = os.environ.get('END_TIME')
df = credit_card_transactions_fg.read(start_time=start_time, end_time=end_time)
```

- There is one type of data transformation to account for when writing a batch feature pipeline 
	- Time window aggregations
- Jon schedulers support cron based scheduling of batch programs

# JobOrchestrators

- Orchestrator
	- Service that schedulers and coordinate the execution of programs with logging and fault tolerance
	- Streamline and optimize the execution of frequent, repeatable processes
- Job orchestrator
	- Schedules the execution of Pandas/Polars/PySpark programs

- Job schedules
	- Package program with all its dependencies
		- Containers
	- Support for one or more execution runtimes
		- Kubernetes of AWS Fargate
	- Support for executing and monitoring programs from different languages and frameworks
	- Logs for execution runs
- Dependencies
 - Arguments and environment variables for incremental processing
 - Resources requested

- Python
	- Requirements file
- PySpark
	- JAR files
	- Python modules
	- Drivers

## Modal

- Modal is a developer friendly serverless platform to deploy, schedule, and manage Python jobs
- Modal supports automatic containerization
	- No need to write and compile container images
	- Add decorators to Python functions
		- Linux OS type
		- Resources the image uses
		- Python libraries
		- Instances of functions
		- Read shared secrets
		- Cron schedule for running the Python program

- Model will compile containers for it and cache them

```python
import modal

image = modal.Image.debian_slim(python_version="3.12").pip_install("hopsworks")

secret = modal.Secret.from_name(
    "hopsworks-secret",
    required_keys=["HOPSWORKS_API_KEY"],
)
app = modal.App("hopsworks-feature-group")

@app.function(
    schedule=modal.Period(days=1), 
    image=image, 
    cpu=4.0, 
    memory=8192, 
    secrets=[secret]
)
def daily_hopsworks_job():
    import hopsworks
    import pandas as pd
    fs = hopsworks.login().get_feature_store()
    weather_forecast_df = # call remote API
    fg = fs.get_feature_group(name="weather", version=1)
    fg.insert(weather_forecast_df)

if __name__ == "__main__":
    app.deploy()
```

## Hopsworks Jobs

- Hopsworks jobs run on the same Kubernetes cluster Hopsworks
- Jobs are executed as containers in the same Kubernetes namespace
- Specify
	- Program, its arguments, and the container image it will use
	- PySpark jobs
		- Any additional file dependencies or configuration parameters
	- Resources for the program
	- Optional cron schedule for running the program

```python
job_api = hopsworks.login().get_job_api()

spark_config = job_api.get_configuration('PYSPARK')
spark_config['appPath'] = '/projects/ccfraud/Resources/f_pipeline.py'
spark_config['spark.driver.memory'] = 2048
spark_config['spark.driver.cores'] = 1
spark_config['spark.executor.memory'] = 8192
spark_config['spark.executor.cores'] = 1
spark_config['spark.dynamicAllocation.maxExecutors']= 2
spark_config['spark.dynamicAllocation.enabled'] = True

job = job_api.create_job('my_spark_job', spark_config)

job.schedule(
    cron_expression="0 */5 * ? * * *",
    start_time=datetime.datetime.now(tz=timezone.utc)
)
job.save()

execution = job.run()
print(execution.success)
out_log_path, err_log_path = execution.download_logs()
```

- Workflow orchestrators capture visualize lineage information for the DAGs they compute
- Job orchestrators often delegate DAG visualization to the data processing framework

# Workflow Orchestrators

- Workflow orchestartors
	- Orchestrate the execution of many programs, organized in a DAG
- Multistep workflows decompose batch feature pipeline into tasks with dependencies between the tasks
- Break down larger programs into small tasks

- ML pipeline orchestartor
	- Kubeflow
		- Kubernetes native orchestrator for ML piplines
		- Training pipelines
		- Does not scale for feature pipelines of batch inference pipelines
	- Metaflow
		- Originally developed by Netflix
		- Automatic containerization similar to Model
	- Flyte
		- Originally developed at Lyft
		- Supports running containers in Kubernetes as training and batch inference pipelines
	- ZenML
		- Open source ML pipeline orchestrator similar to Metaflow
	- Vertex AI Pipeline, Azure ML, and SageMaker Pipelines
		- Specialized for training pipelines
		- Containers with prebuilt binaries for popular ML frameworks

- Workflow orchestrator within data engineering
	- Cloud native Python-based workflow orchestrators
		- Dagster
		- Prefect
	- Databricks Workflows, Snowflake tasks, Google Dataform

## Airflow

- Apache Airflow is a popular open source orchestrator
	- Define, schedule, and monitor workflows

## Cloud Provider Workflow Orchestrators

- Azure Data Factory (ADF)
	- Generic workflow orchestrator that you can use to run Spark, Pandas, and Polar programs on Azure
	- Organizes workflows into pipelines, which define a series of steps or activities needed for data integration or transformation
	- Each pipeline can contain a sequence of activities
		- Data movement
		- Data transformation
		- Triggering external systems
- AWS Step Function
	- General purpose serverless workflow orchestrator for AWS
	- Coordinate multiple AWS services and build workflows with frameworks like PySpark, Polars, Pandas, and DuckDB
- Google Cloud Composer
	- Fully managed orchestration service on GCP that is build on Airflow
	- Users to connect and orchestrator various Goggle Cloud Services and APIs

# Data Contracts

- Hopsworks performs schema validation on writing data to feature group
- Data contracts should provide guarantees on the quality of data and its timely delivery to data consumers
	- Service level objectives (SLOs) for a feature group
	- Domain (valid range) of values for a given feature
	- Expected and worst-case freshness for feature data
	- How late can data arrive before it should be discarded
	- What percentage of missing values can be tolerated for a given feature

- Design governance policies with tags
	- Personally identifiable information (PII)

```python
fg = fs.get_feature_group("cc_trans_fg", version=1)
fg.add_tag(name="PII", value="false")
```

- Enforce a governance policy in code by checking whether the correct tags values are set for an asset, feature group, feature view, model, or deployment

```python
search_api = project.get_search_api()
tag_search_result = search_api.featurestore_search("PII")
tag_search_result.to_dict()
```

# Data Validation with Great Expectations in Hopsworks

- Data is validated before it is written to feature group

<img src="/images/Pasted image 20261110200602.png" alt="image" width="500">

- Write-audit-publish (WAP) patterns
	- Ingesting all source data
	- One or mode data pipelines apply data validation rules, detect anomalies, and identify duplicates
	- Pipeline transform the validated data to a consumable layer for downstream applications

- Implement the data validation rules as an expectation suite in Great Expectations
- Governance requires both a way to define a policy and a mechanism to enforce it
	- Provides tags and schematized tags to define policies and attach them to feature gorup

<img src="/images/Pasted image 20261110200817.png" alt="image" width="500">

```python
expectation_suite = ge.core.ExpectationSuite( .. )
fg.save_expectation_suite(
    expectation_suite, run_validation=True, validation_ingestion_policy="ALWAYS"
)

# remove the expectation suite from the feature group
fg.delete_expectation_suite()

if fg.contains_tag("NO_PII"):
    if check_for_pii_data(df):
        fg.create_alert(receiver="email", severity="warning",\
            status=f"PII data")
```

- In feature pipelines
	- Define governance policies as tags and implement enforcement check

