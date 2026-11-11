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
### Change Data Capture

## Backfill and Incremental Processing in One Program




# JobOrchestrators

## Modal
## Hopsworks Jobs


# Workflow Orchestrators

## Airflow
## Cloud Provider Workflow Orchestrators




# Data Contracts




# Data Validation with Great Expectations in Hopsworks




