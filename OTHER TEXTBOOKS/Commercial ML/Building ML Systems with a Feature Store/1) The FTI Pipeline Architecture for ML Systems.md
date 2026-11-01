- Feature pipelines
	- Compute both the historical features used to train your model
	- Used as inputs into train model, which will output the predications
- Batch ML system
	- A system that automates reading from data sources, transforming data into features, training models, performing inference on new data with the model, and updating a dashboard with the model's prediction
- ML pipelines
	- Programs that transform raw data into features
	- Feed feature to the model for easy retraining
	- Feed new feature to model to make predications
- ML system
	- Decision trees
	- Deep learning
	- LLM-powered agents
- Moving from static data to batch data that is updated at some interval, to real time data
# The Anatomy of ML System

- Batch ML system
	- Spotify's Discovery Weekly
	- Recommendation engine that, once per week, predicts songs that a user might like
- ML system reads a batch of data and makes predications using the trained recommender ML model for all rows in the batch of data
- Predications are stored in a database (Cassandra), and is used in the interface

- TikTok's recommendation engine
	- Real time ML system

- Agentic systems are more often interactive systems than batch systems

- ML systems
	- Batch
	- Real-time
	- LLM applications

## Types of ML

- Supervised learning
	- Train a model with data containing features and labels
	- Learn relationships between the labels and the input feature values
	- Classification problems
	- Regression problems
- Unsupervised learning
	- Learn form input feature without any labels
- Self-supervised learning
	- Generating a labeled dataset from a fully unlabeled one
	- Masking
		- Provide a piece of text and mask out individual works, and predict he word in NLP
	- BERT
		- Masked language modeling
		- Next-sentence prediction
	- Image classification
- Reinforcement learning
	- Learning how to make optimal decisions
- In-context learning
	- Ability to learn to solve new tasks by providing context in the prompt to the LLM
	- Require content engineering to get relevant data into the LLM's promt
	- Newly learned skill is forgotten after the context window is emptied

## Data Sources

### Tabular Data

- Tabular data is stored as tables containing columns adn rows
	- Row-oriented stores
		- Relational and NoSQL databases
	- Column-oriented stores
		- Data warehouses and data lakehouses
		- Optimized for reading and processing columns of data
- SQL and object-relational mappers (ORM) are used by relational databases
	- MySQL
	- Postgres
- Key value APIs
	- Cassandra
	- RocksDB
- JSON store API
	- MongoDB
- Columnar stores support reading and writing data with SQL and DataFrame APIs
	- Spark
	- Pandas
	- Polars

### Event Data

- Event data contains a record of discrete occurrences or actions that happen at specific points in time
- Event streaming platform (Apache Kafka) is a data platform for collecting and temporarily storing event data for downstream consumers
	- Columnar data store that store raw data for analysis
### Graph Data

- Graph data is represented as nodes (entities) and edges (relationships)
- Efficient storage and retrieval of complex, interconnected graph data
- Structured knowledge sources for improved reasoning and question answering
### Unstructured Data

- Data that has a schema is called structured data
- Unstructured data
	- PDFs
	- Docs
	- HTML
	- Markdown
	- Image
	- Video
	- Audio
### API Scraped Data

- Data stored and processed in software as a service (SaaS) systems

## Mutable Data

- Production ML systems typically work with mutable data
	- Stored in row- or column-oriented stored
	- Efficient inserts, appends, updates, and deletions
- Data transformations
	- Aggregations
	- Binning
	- Dimensionality reduction
	- Encoding
	- Normalizing

# A Brief History of ML Systems

- Image tagging in Facebook and Google translate
- Batch ML systems that made prediction on a schedule
- Interactive online ML systems that made predictions in response to users actions

<img src="/images/Pasted image 20261031203633.png" alt="image" width="500">

- Batch program/pipeline
	- Ensure that features created for training and batch inference are consistent
	- Run in either training or inference mode

- Offline training pipeline and an online model-serving service
- Cannot ensure consistent features between training and inference
	- Versioning

<img src="/images/Pasted image 20261031203938.png" alt="image" width="500">

- Stateless online ML systems
	- Image tagging program
	- First chatbots
	- Limited by their training data
- Provide historical and context information as input into a model

- Stateful online ML system
	- Feature store enables personalized history and context to be retrieved

<img src="/images/Pasted image 20261031204304.png" alt="image" width="500">

- Write a feature pipeline as a stream processing program
- ML pipeline
	- Any feature pipelines, training pipelines, and inference pipelines

- Stateless LLM application
	- Incorporate relevant and timely context as input
	- RAG using a vector database
	- Turned user input as a string and queries a vector database
		- Approximate nearest neighbour (ANN) search
	- Vector embedding pipeline
	- Prompt was defined by the LLM's context window
		- Stored input and output of the LLM
	- Context engineering
		- Construct a prompt from user input and context data that maximizes the performance of the LLM's output for a given input

<img src="/images/Pasted image 20261031204523.png" alt="image" width="500">

- Agents
	- A class of LLM application that have a level of autonomy in jow to query diverse data sources
		- Vector indexes
		- Search engines
		- Feature stores
	- Systems where LLM's dynamically direct their own processes and tool usage, maintaining control over how they accomplish tasks
- Model Context Protocol (MCP)
	- Unified standard for retrieving RAG data from a variety of data sources an using internal and external APIs as tools

<img src="/images/Pasted image 20261031205017.png" alt="image" width="500">

- ML system
	- Type of AI system that learns from data through ML algorithms and statistical models
- AI
	- Broader term that covers search, memory, and many other techniques

# MLOps and LLMOps

- Machine learning operations (MLOps)
	- Hidden Technical Debt in Machine Learning Systems
	- Data management and building and operating the ML system infrastructure
	- Processes for building reliable and scalable ML systems
	- Automation, testing, and operations

- Tests
	- Unit tests
		- Validate feature logic
	- Integration test
		- Validate MP pipelines
	- Model validation tests
		- Performance and bias
	- Evals
		- Safety, reliability, and performance of LLM application and agents
	- Data validation tests
		- Prevent bad data from entering your system
	- Model performance monitoring
		- Models degrade in performance over time
	- Feature drift detection
		- Check whether the input data at inference time is statistically significantly different from the model's training data
	- A/B tests
		- Run for new version of models
	- Guadrails
		- Run for LLM inputs and outputs to prevent harmful responses

- CI platforms
	- GitHub Actions
	- Jenkins
	- Azure DevOps

- Deployments
	- Development
	- Preproduction
	- Production

- Versioning of both features and models
	- Upgrading and downgrading an ML system without downtime

- Monitoring
	- Quality of models' prediction with some business key perforance indicator (KPI)
	- Monitoring newly arriving data for drift
	- Measuring the performance (throughput and latency)

# A Unified Architecture for AI Systems - Feature, Training, and Inference Pipelines

- Modularity
	- Capacity to decompose a system into smaller, more manageable modules that can be independently developed and composed into a complete software system
	- Modules can be independently tests
- 5 AI system architectures
	- Batch
	- Stateless real time
	- Stateful real time
	- RAG LLM
	- Agentic AI

- Decomposition of AI systems (FTI)
	- Feature creation
		- Take data as input and produce reusable feature data as output
	- Model training
		- Take feature data as input, train a model, and output the trained model
	- Inference pipelines
		- Take feature data and a model as inputs, and output predications and prediction logs

- Define a AI system as a set of independent feature pipelines, training pipelines, and inference pipelines that are connected via a feature store and model registry

<img src="/images/Pasted image 20261031211715.png" alt="image" width="500">

- Feature pipelines ingest both backfill and production data and compute feature data that is stored as tabular data in the feature store
- Training pipelines read training data from the feature store and store any trained models they produce in the model registry

- Batch compute engines
	- SQL in data warehouses
	- Spark
	- Pandas
	- Polars
- Stream compute engines
	- Flink
	- SPark Structured Streaming
	- Feldera

## Classes of AI Systems with a Feature Store

- AI systems with a feature store
	- Real-time (interactive) ML systems
	- Agentic workflows
	- Batch ML systems
	- Stream processing ML systems

- Embedded or edge ML sysetms
	- Used an embedded model and compute features from their input data, without precomputed features from a feature store
	- Run on resource constrained network detached devices

## ML Frameworks and ML Infrastructure Used in This Book

-  Python
	- Data engineering
		- Pandas
		- Polars
	- Model serving
		- Scikit-Learn
		- PyTorch
		- KServe
- Other programming frameworks or languages
	- Spark
	- dbt/SQL
- Data analysis, model training, and other non-operational services
	- Jupyter notebooks
- Libraries
	- Streamlit
	- Hugging Face Spaces
	- Gradio
- Serverless ML infrastructure
	- Hopsworks
- Model serving platform
	- MLflow
	- Databricks, GCP Vertex
	- AWS Sagemaker