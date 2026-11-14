
- Retrieval and ranking architecture
- Agentic search for videos using natural language

# Intro. to Recommenders

- Recommender systems
	- Help users discover relevant content in user-facing systems
- Content based recommendation systems
- Interaction datasets
	- Containing user action events for content
		- Views, likes, and shares
- Item-to-item (i2i) recommendations
	- Focuses on the relationship between items themselves
- User-to-item (u2i) recommendations
	- Centering recommendations on the individual user
	- Historical preferences and behaviours
- Collaborative filtering
	- Difficult handling large data volumes and sparse data
- Factorization machines
	- Better handling data sparsity, but also had scalability issues and real time updates

<img src="/images/Pasted image 20261113223521.png" alt="image" width="500">

- Features useful for building recommendation models are centred around users, items, and interactions between users and items
	- Slowly-changing data
	- Real-time content information
		- Click through rate (CTR)
- In-session browsing features contain valuable real-time signals or recent user activity

# A TikTok Recommender with the Retrieval and Ranking Architecture

- Decompose the problem of recommending videos
	- A retrieval phase that uses a scalable vector index to return a few hundred candidate videos
	- A ranking phase to order the hundreds of candidates based on a metric we want to optimize, like increased user engagement

<img src="/images/Pasted image 20261113224004.png" alt="image" width="500">

- Non-stationarity challenges
	- Dynamic environment
	- Retraining models to prevent concept drfit
	- Link
		- Sub-second streaming feature computation from user actions
		- Cassandra (key-value store)
		- Redis (cache)
		- Continual retraining of the models (once per minute)
- Sparse-feature challenges
	- High-cardinality categorical variables
	- Collaborative filtering and factorization machines
	- Sparse feature can lead to overfitting because models might memorize rare user-item interactions instead of generalizing
	- Embeddings
		- Convert high dimensional sparse feature into low-dimensional dense vectors
- Retrieval challenges
	- Build a vector index that indexes all the videos, and trained in a two-tower architecture
	- Create user action, history data, and create a vector embedding with the user embedding model
	- Nearest
		- Based on the interaction data
- Personalized ranking challenges
	- High recall
	- Improve the precision and utility of the recommendation by rank-ordering so that the engaging/relevant videos appear at the top
	- Ranking function based on a desired metric
- Scalability Challenges
	- Millions of concurrent requests and store PBs of data
	- Highly available architecture to prevent downtime
- Data source challenges
	- Create synthetic data simulating user interactions with video

- Positive interactions and negative interaction
- Train embedding models for the retrieval phase that help predict what video a user is likely to watch, given long- and short- term viewing behaviour, as well as current viewing behaviour of other users

<img src="/images/Pasted image 20261113224850.png" alt="image" width="500">


- 0
	- User did **not watch** the recommended video
- 1
	- User **watched** the recommended video
- 2
	- User **liked** the recommended video
- 3
	- User **shared** the recommended video

- Also measure watch time of video
- Google
	- Deep neural networks for YouTube recommendations
- Netflix
	- Foundation transformer model

# Real-Time Personalized Recommender

- Build an MVPs

<img src="/images/Pasted image 20261113225051.png" alt="image" width="500">

- Feldera and Polars
	- Data transformation frameworks
- PySpark
	- Vector embeddings
- Two-tower model
	- TensorFlow recommenders library
- XGBoost
	- Raning model
- FastAPI in KServe
	- Online inference pipeline


<img src="/images/Pasted image 20261113225248.png" alt="image" width="500">

- Streaming feature pipeline to compute aggregated viewing statistics
	- Kafka
- Batch pipelines to compute user profile, video attributes, and ranking feature data
	- Vector embeddings

- 2 embedding models
	- User data
	- Video data

## Feature Pipelines

- An external event-sourcing pipeline stores historical interaction events in a lakehouse table
- Create synthetic interaction data and write it to a Kafka topic
- User profile data is updated by users in the video player application
- Video attributes are updated by batch pipelines
- Streaming feature pipeline to compute windowed aggregations for videos

	- Number of video for a vide
	- Click through ratee
	- Recently viewed
	- Last login
	- Mean session duration
	- Standard deviation session duration

- Feldera
	- Compute the streaming-feature pipeline
	- Backfill mode to process historical interaction data

- Video data
	- Video name
	- Description
	- Genre
	- Rating
	- Vector index used for similarity search
- Periodically update video attributes with a batch vector embedding pipeline

<img src="/images/Pasted image 20261113225800.png" alt="image" width="500">

- Retrieval stage selects video based on static and dynamic properties
- Dynamic properties also increase both the write load on the vector index and the compute requirements for the pipeline
- User profile feature pipeline
	- Scheduled daily for incremental updates
	- Validation rules
- Create feature views containing the features used by the 3 models
	- User/query embedding model
	- Video-embedding model
	- Ranking model

## Training Pipelines

- Train user-embedding and video-embedding models using a single training dataset from 4 different feature group
	- User profile
	- Video attributes
	- Video stats
	- Use activity
- Create a ranking view starting from interaction
- Ranking model can react faster to changes in trending videos and user behaviour

<img src="/images/Pasted image 20261113230209.png" alt="image" width="500">


### Two-tower embedding model

- Train a custom embedding model with the two-tower model architecture
	- Interaction, user, and video data
- Takes in t video interaction dataset and score of each interaction as the label

- User features
- Video features

- Features and layers
	- User embedding layer
	- Video embedding layer
	- Feedforward layers
	- Transformer block
	- CNN

- User tower takes the user feature, a user entry, and processes them through any initial layers to the embedding layer and then feedforward layers to output a single vector
- The video tower, does the same thing with the video entry

<img src="/images/Pasted image 20261113230543.png" alt="image" width="500">

- User and video embeddings are compared using a similarity function
	- Dot product
	- Cosine similarity

- Collapse the output into one of two classes
	- Positive = strong or weak engagement (1, 2, 3)
	- Negative = no engagement (0)
- Positive or negative outcome is compared with the binary label suing a contrastive loss function
	- Information noise-contrastive estimation (InfoNCE)
	- Sampled softmax
- Larger losses will result in larger weight updates to optimize similarity scores

### Building the vector index of videos

- Write a vector-embedding pipeline that can backfill vector index from the interaction dataset and also incrementally process new entries in the interaction dataset
- Computes the user vector embeddings, and retrieves the top N candidate videos most similar
- ANN search on the vector index, returns videos that are then ranked

### Ranking model

- 


## Online Inference Pipelines



# Agent Search for Videos
# The Dirty Dozen of Fallacies of MLOps
# The Ethical Responsibilities of AI Builders