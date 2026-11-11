
- Model training is the broadest and deepest area of data science
- Model centric AI
	- Iterative process of improving model performance by experimenting with model architecture and tuning hyperparameters
- Data-centric AI
	- Iterative process of selecting features and data to improve model performance

- Training pipeline
	- Learning algorithm
	- Connecting labels to features in a feature store
	- Feature selection
	- Training dataset creation
	- Model architecture
	- Distributed training
	- Model evaluation

# Unstructured Data and Labels in Feature Groups

- Identify the prediction problem and data sources available to solve that problem
	- Supervised learning
	- Unsupervised learning
	- Self-supervised learning

## Self-Supervised and Unsupervised Learning

- Do not require separate labels/targets
- An LLM predicts the next token in a sequence of text
- Self-supervised learning
	- Algorithm generates the labels automatically from the input data
	- LLM uses the predicted next token to predict the following token, and continues
- Autoregressive models
	- Unstable

- Masked language modeling
	- BERT transformer model
	- Randomly masks out target works

<img src="/images/Pasted image 20261110225800.png" alt="image" width="500">


- kNN
	- Unsuperivsed learning algorithm for
		- ANN search
		- Segmenting or clustering a set of unlabeled data point

- Generative adversarial network (GAN)
- Consist of 2 neural network
	- Generator
		- Creates new input data samples
	- Discriminator
		- Tries to distinguish real samples from generated ones
- Stable diffusion network
	- Generate images from text

## Supervised Learning Requires a Label

```python
fraud_df = fs.get_feature_group("cc_fraud").read()
transactions_df = fs.get_feature_group("credit_card_transactions").read()
transactions_df = transactions_df.merge(fraud_df, on="t_id", how="left")
transactions_df["fraud"] = transactions_df["fraud"].fillna(0)
```

- Most the labels for image classification datasets were created by humans manually drawing bounding boxes
- Weak supervision
	- Generates a large amount of weakly trusted labels
- Start by implementing the labels as a feature group
- Import a static dataset of labels directly into a feature group

<img src="/images/Pasted image 20261110230213.png" alt="image" width="500">

- Data for both decision trees and time-series models are naturally stored in feature groups
- CNNs and transformers are trained using unstructured data from files
- Pretrained LLMs use text data for supervised fine-tuning (SFT) and preference tuning, commonly stored in JSON Lines (JSONL) files
	- Appended without rewriting the entire file
	- Read and written in a streaming manner
- Instruction datasets
	- Instruction
	- Input
	- Output
- Preference datasets
	- Additional fields to represent multiple possible responses and either the preferred response or scores for each response
	- Used to train reward models for reinforcement learning with human feedback (RLHF)

# Root and Label Feature Groups

- Each feature group column is either an index column or a feature
- Feature views can define one or more columns in feature groups as labels
- Feature group that provides the labels for the feature view is called the label feature group
- Labels can also be stored in a child feature group

<img src="/images/Pasted image 20261110230556.png" alt="image" width="500">

- Root feature group is the starting feature group for the feature view
- Include any features or labels that can be reached by graph traversal
	- Feature groups are nodes and edges are foriegn keys
	- Path from the root feature group to the feature group containing the features or labels

<img src="/images/Pasted image 20261110230713.png" alt="image" width="500">


- Bronse layer
	- Stores a copy of the raw data from operational databases and event streaming platforms
- Silver layer
	- Stores cleaned and deduplicated data in tables in third normal form (3NF)
- Gold layer
	- Using either snowflake schema or star schema data mode

# Feature Selection

- A useful feature has predictive power for the label/target that you can check by visualizing the feature with respect to the target and computing quick signal checks

<img src="/images/Pasted image 20261110230909.png" alt="image" width="500">

- Avoid
	- Redundant features
	- Irrelevant features
	- Prohibited features
	- Infeasible features

- Create a feature view that contains the features that will be used for both training and inference

<img src="/images/Pasted image 20261110231000.png" alt="image" width="500">

```python
card_subtree = card_details.select_features()
.join(account.select_features())
.join(bank.select_features()
)
selection = transactions.select_features()
.join(fraud_labels.select_features())
.join(card_subtree)
.join(merchant.select_features()
)
fv = fs.create_feature_view(name="trans_fv", version=1,
         query=selection,
         labels=['fraud']
)
```


- Join the selected features from a feature group together without explicitly specifying the join columns

- Categories of feature selection methods for refining the set of selected features
	- Recursive feature addition/elimination methods
	- Filter methods
	- Wrapper methods
	- Embedded methods


- Novel method of feature selection is to use LLMs and natural language to select features
- LLMs may exhibit biases inherited from their pretraining data, leading to poor feature selection

# Training Data

- Pandas create intermediate copies during operations
- Creating training data from feature groups
	- In memory DF, read as Arrow data
	- On disk files materialized from feature groups
	- Unstructured data as files from an object store, with DF providing file paths and metadata

<img src="/images/Pasted image 20261110231403.png" alt="image" width="500">

- When training data is materialized to files from feature groups with a feature view, there are many different file formats that can be used as training data in different ML frameworks

<img src="/images/Pasted image 20261110231453.png" alt="image" width="500">

- CSV and Parquet are popular formats for tabular training data
- CSV is a row-oriented file format supported by nearly all ML frameworks
	- CSV files are poorly splittable
	- Parquet is a columnar file format better for compression
	- Split into many files and directories
- JSONL
	- Fine-tune pretrained LLMs
- TFRecords
	- Row-oriented
	- Binary
	- Splittable file format
- Tensors
	- Used by PyTorch and TensorFlow
- Hierarchical Data format 5 (HDF5)
	- Non-splittable file format for storing large numerical data arrays and metadata
	- Complex hierarchical data and supports efficient I/O and random access
	- Not suitable for large volumes of data for multi host training
- NPY
	- Non-splittable
	- NumPy arrays
		- Store numerical data
	- Compressed as NPZ file

- Reasons to separate training dataset pipelines
	- Training is CPU bound, leaving GPU's underutilized
		- MDTs performed on CPUs
	- Training data is larger than available memory in the container(s) training the model, causing an OM error

## Splitting Training Data

- A time-series split is preferable

```python
feature_view.create_train_test_split(
            train_start="2021-01-01", train_end="2024-06-15", 
            test_start="2024-07-01", test_end="2024-12-31", 
            storage_connector=s3_bucket, 
            …
)
```

- Gap between the end train end and test start to avoid overlap on rolling aggregation
- Create 3 splits
	- Train
		- Train the model
	- Validation
		- Tune hyperparameters and select best model
	- Test
		- Evaluate the final model's performance on unseen data

```python
X_train, X_val, X_test, y_train, y_val, y_test =
  feature_view.train_validation_test_split(validation_size=0.1, test_size=0.15)
```

- Data is rarely independent and identically distributed (i.i.d.)
- Stratified sampling ensure that splits preserve the portion of positive fraud row
- Maintain class balance across splits
- k-fold cross validation
	- Improves robustness

```python
from sklearn.model_selection import StratifiedKFold

X, y = feature_view.training_data()
skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
train_idx, val_idx = next(skf.split(X, y.squeeze()))
X_train, X_val = X.iloc[train_idx], X.iloc[val_idx]
y_train, y_val = y.iloc[train_idx], y.iloc[val_idx]
```

## Reproducible Training Data

- Reproducible training data is important for compliance
- 


# Model Training

## Model Architecture
## Checkpoints to Recover from Failures
## 
## 
# Model Evaluation and Model Validation