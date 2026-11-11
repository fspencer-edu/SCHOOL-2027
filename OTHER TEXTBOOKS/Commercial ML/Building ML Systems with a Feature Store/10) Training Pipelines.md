
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
- Create the training data once and have all models reread the same training data using the same version
- Other sources of randomness when training
	- Weight initialization
	- Data augmentation
	- Compute Unified Device Architecture (CUDA) kernels
	- Dropout

```python
SEED = 42
os.environ["PYTHONHASHSEED"] = str(SEED)
# For full CUDA matmul determinism (set before CUDA ops):
os.environ.setdefault("CUBLAS_WORKSPACE_CONFIG", ":4096:2")

random.seed(SEED)
np.random.seed(SEED)
torch.manual_seed(SEED)
torch.cuda.manual_seed_all(SEED)

torch.backends.cudnn.benchmark = False
torch.use_deterministic_algorithms(True)  # error if nondeterministic op 

X_df, y_df = feature_view.get_training_data(training_dataset_version=1)

X = torch.tensor(X_df.values, dtype=torch.float32)
y = torch.tensor(np.ravel(y_df.values), dtype=torch.long)

g = torch.Generator()
g.manual_seed(SEED)

def seed_worker(worker_id):
    # Ensures each worker has a deterministic RNG state derived from SEED
    worker_seed = SEED + worker_id
    np.random.seed(worker_seed)
    random.seed(worker_seed)
    torch.manual_seed(worker_seed)

dataset = TensorDataset(X, y)
dataloader = DataLoader(
    dataset, batch_size=10,
    shuffle=True,           # uses the generator below
    generator=g,            # deterministic shuffles across epochs
    num_workers=0,          # safest for determinism; or >0 with seed_worker
    worker_init_fn=seed_worker if 0 else None,
)
```

# Model Training

1) Select features and creating training data
2) Create a model architecture
3) Performance hyperparameter tuning trials
4) Use the best hyperparameters to fit the model
5) Evaluate the trained model on the test set and evaluation sets

<img src="/images/Pasted image 20261111075641.png" alt="image" width="500">


- Ray
	- Open source distributed framework for managing compute and data for ML

## Model Architecture

- A model's architecture is its layout
	- Decision trees
		- Splitting criterion and maximum depth
	- Feed-forward neural newtorks
		- Layer depth/width, activation functions, normalization/dropout, and output head
	- CNNs
		- Convolution and pooling blocks with stride/padding
	- Transformers
		- Stacks of self-attention and feed-forward blocks with residuals and layer norm

- Supervised learning with structured data
	- < 10 M rows
		- Decision tree-based models
		- XGBoost
	- Between 10 and 100 M rows
		- XGBoost and NN
	- > 100 M rows
		- NN

- Supervised learning on unstructured data
	- CNNs
		- 2D and 3D spatial data
	- Transformers
		- Sequential and contextual data
	- Feed-forward NNs
		- Tabular input
		- No spatial or sequential relationships
	- Long short-term memory (LSTM) networks
		- Sequential data with temporal dependencies

```python
class CustomMnist(nn.Module):
    def __init__(self, layer_sz=128, dropout=0.3):
        super(CustomMnist, self).__init__()
        self.fc1 = nn.Linear(28*28, layer_sz)
        self.dropout = nn.Dropout(dropout)
        self.fc2 = nn.Linear(layer_sz, 10)
    
    def forward(self, x):
        x = torch.flatten(x, 1)  # Flatten (batch_sz, 28, 28) -> (batch_sz, 784)
        x = torch.relu(self.fc1(x))  # Apply ReLU activation
        x = self.dropout(x)  # Apply dropout after activation
        return self.fc2(x)  # Output logits
```

- The forward pass is the process in which an input is passed through the NN from the input layer to the output layer
	- Produces logits for training and prediction for inference
- Cross entropy loss
	- Los function for classification that measures the difference between the true labels and predicted probabilities
- Adaptive Moment Estimation (Adam) optimizer
- Stochastic gradient descent
	- Updates weights for a mini-batch of parameters by changing the values of the parameters in the opposite direction of the gradient using a fixed learning rate

```python
from torch.utils.data import Dataset, DataLoader
from PIL import Image
import torchvision.transforms as T

class ImageDataset(Dataset):
    def __init__(self, transform, features, labels=None):
        self.transform = transform
        self.features = features
        self.labels = labels

    def __len__(self):
        return len(self.features)

    def __getitem__(self, idx):
        img_path = pathlib.Path(self.features.iloc[idx]["image_path"])
        image = Image.open(img_path).convert("L")
        image = self.transform(image)
        if self.labels is not None:
            label = int(self.labels.iloc[idx]["label"])
            return image, torch.tensor(label, dtype=torch.long)
        return image

proj = hopsworks.login()
fv = proj.get_feature_store().get_feature_view(name="mnist", version=1)
transform = T.Compose([T.Resize((28, 28)), T.ToTensor()])
features, labels = fv.training_data()
dataset = ImageDataset(transform, features, labels)
train_loader = DataLoader(dataset, batch_size=32, shuffle=True)
```

```python
def train_model(config, train_loader):
    model = CustomMnist(layer_sz=config["layer_sz"], dropout=config["dropout"])
    optimizer = optim.Adam(model.parameters(), lr=config["lr"])    
    loss_fn = nn.CrossEntropyLoss()
    
    state = None
    model.train() # sets the model to training mode (enables dropout)
    for epoch in range(config["num_epochs"]):
        correct, total=0
        for inputs, labels in train_loader:
            optimizer.zero_grad()
            logits = model(inputs)
            loss = loss_fn(logits, labels)
            loss.backward()
            optimizer.step()
            preds = logits.argmax(1)
            total += labels.size(0)
            correct += (preds == labels).sum().item()
        # Uncomment next line to add Ray support
        # ray_train.report({"train_accuracy": correct / max(total, 1)})

    return model

config = {"layer_sz": 128, "dropout": 0.3, "lr": 1e-3, "num_epochs": 10}
model = train_model(config, train_loader)

state = {k: v.detach().cpu() for k, v in model.state_dict().items()}

model_registry = proj.get_model_registry()
mr_model = model_registry.python.create_model(
               name="mnist",
               metrics=config, # save hparams for inference
               feature_view=fv
           )
with tempfile.TemporaryDirectory() as tmpdir:
    joblib.dump(state, os.path.join(tmpdir, "model.pkl"))
    joblib.dump(transform, os.path.join(tmpdir, "transform.pkl"))
    mr_model.save(tmpdir)
```

## Checkpoints to Recover from Failures

- To handle failures, periodically create training checkpoint to recover from
- Stores and loaded from distributed storage
	- S3 bucket or local directory via HopsFS Filesystem Usersapce (FUSE)

```python
def train_model(config, train_loader, model, optimizer, checkpoint_path):

    if os.path.exists(checkpoint_path):

        checkpoint = torch.load(checkpoint_path)
        model.load_state_dict(checkpoint['model_state_dict'])
        optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
        start_epoch = checkpoint['epoch'] + 1

    for epoch in range(start_epoch, config["num_epochs"]):
  …
               
        torch.save({  # Save checkpoint after every epoch
            'epoch': epoch,
            'model_state_dict': model.state_dict(),
            'optimizer_state_dict': optimizer.state_dict()
        }, checkpoint_path)
```

## Hyperparameter Tuning with Ray Tune

- Hyperparameter tuning can be easily integrated into a training pipeline by using an AutoML library
- Auto-sklearn
	- Tabular data
- Ray Tune
	- Cluster
- Define
	- A hyperparameter search space
	- A search algorithm over that search space
	- A schedular to allocate resources to all the trials that will be performed in parallel


- Ray Tune is an orchestrator for hyperparameter turning
- Asynchronous Successive Halving Algorithm (ASHA)
	- Periodically pruning underperformed and promoting the best to larger budgets
	- Freed resources are given to new or promoted trials

```python
from ray.tune.schedulers import ASHAScheduler
from ray.tune.search.optuna import OptunaSearch

scheduler = ASHAScheduler(metric="train_accuracy", mode="max", grace_period=3)
searcher = OptunaSearch()

param_space = {
    "lr": tune.loguniform(1e-4, 1e-2),
    "dropout": tune.choice([0.1, 0.3, 0.5]),
    "layer_sz": tune.choice([64, 128, 256]),
    "num_epochs": 10,  # max epochs per trial; ASHA may stop early
}

resources_per_trial = {"cpu": 2, "gpu": 0}

tuner = tune.Tuner(
    tune.with_resources(
        tune.with_parameters(
            train_model,
            train_loader=train_loader,
            proj=proj,
            fv=fv,
            transform=transform,
        ),
        resources=resources_per_trial,
    ),
    param_space=param_space,
    tune_config=tune.TuneConfig(
        metric="train_accuracy",
        mode="max",
        scheduler=scheduler,
        search_alg=searcher,
        num_samples=15,
    ),
    run_config=air.RunConfig(name="mnist_asha_optuna_acc"),
)

results = tuner.fit()
best = results.get_best_result(metric="train_accuracy", mode="max")
print("Best config:", best.config)
print("Best train_accuracy:", best.metrics["train_accuracy"])

```

- Experiment tracking services
	- Store hyperparameters tuning experiment results and training loss curve
	- MLflow

## Distributed Training with Ray

- Data parallel training
	- Reduce the training time by replicating the model on many different GPUs
- Ray Train
	- Data parallel training that can be scaled out cross many hosts using a gradient synchronization algorithm
	- Ring all-reduce

- Tensor parallelism
	- Large tensors are partitioned across multiple GPU, improving performance
- Model parallel training
	- Model does not fit in memory of a single GPU
	- High performance network (InfiniBand)

- Ray Data
	- Data processing library that supports the parallel reading of training data during training

<img src="/images/Pasted image 20261111081212.png" alt="image" width="500">


```python
pipe = ray.data.read_parquet(path)
pipe = pipe.map_batches(preprocess)
dataset_pipeline = pipe.random_shuffle()

def train_model():
    model = NeuralNetworkModel(...)
    model = train.torch.prepare_model(model)
    optimizer = torch.optim.Adam(model.parameters())
    
    for batch in train.get_dataset_shard().iter_batches():
        # Proper training loop here

trainer = Trainer(num_workers=3, backend="torch", use_gpu=True)
result = trainer.run(train_model, dataset=dataset_pipeline)
```

## Parameter-Efficient Fine-Tuning of LLMs

- Pretraining
	- Perplexity
		- A measure of the expectation for the next token
	- Catastrophic forgetting
		- Pretrained model loses its previously learned knowledge when trained on new tasks or data
- Supervised fine-tuning (SFT)
	- Takes the pretrained LLM and fine-tunes it with labeled training data specific to a target task
- Preference alignment
	- Further fine-tunes the instruction model to align its outputs with human preferences
		- RLHF (reinforcement learning from human feedback)

<img src="/images/Pasted image 20261111084851.png" alt="image" width="500">

- Reward models
	- Proximal Policy Optimization (PPO)

- Parameter-efficient fine-tuning (PEFT)
	- LoRA
		- Freezes the original weights of the LLM and adds small, trainable low-rank matrices to selected weight matrices
	- Quantized LoRA (QLoRA)
		- Optimized version
		- requires less GPU memory

<img src="/images/Pasted image 20261111085139.png" alt="image" width="500">


- LoRA
	- Models often have low intrinsic dimensions
	- Describe with fewer dimensions that what is represented in the original weights

## Credit Card Fraud Model with XGBoost

- XGBoost
	- Ensemble of gradient boosted decision trees
- Increase max depth and adjust n estimators with early stopping to control overfitting
- Decrease learning rate and use GPU acceleration
- Increase lambda, alpha, and min child weight to control overfitting and generalization

```python
def train_xgboost(config): 
    model = xgb.XGBClassifier(
        objective='binary:logistic',
        max_depth=config['max_depth'],
        n_estimators=config['n_estimators'],
        learning_rate=config['learning_rate'],
        reg_lambda=config['reg_lambda'],
        reg_alpha=config['reg_alpha'],
        min_child_weight=config['min_child_weight'],
        eval_metric='logloss'
    )
    model.fit(X_train, y_train, \
        eval_set=[(X_val, y_val)], early_stopping_rounds=20)
    preds = model.predict(X_val)
    f1 = f1_score(y_val, preds)
    tune.report({"f1_score": f1})

search_space = {  # Define the hyperparameter search space
    'max_depth': tune.choice([3, 5, 7, 9, 11]),
    'n_estimators': tune.choice([50, 100, 200, 300]),
    'learning_rate': tune.loguniform(0.01, 0.3),
    'reg_lambda': tune.loguniform(1e-3, 10),
    'reg_alpha': tune.loguniform(1e-3, 10),
    'min_child_weight': tune.choice([1, 3, 5, 7])
}

analysis = tune.run( # Run hyperparameter tuning
    train_xgboost,
    config=search_space,
    num_samples=50,
    resources_per_trial={"cpu": 2, "gpu": 0},
    metric="f1_score",
    mode="max"
)
best_config = analysis.get_best_result("f1_score")
print(f"Best hyperparameters: {best_config}")
```


## Identifying Bottlenecks in Distributed Training

- GPUs can either be colocated on the same host or distributed across many hosts
- Distributed training involves workers collaborating to train a model

- Ring all-reduce
	- Architecture in which workers ware connected logically in a ring
	- Share gradients with their neighbouring workers

<img src="/images/Pasted image 20261111085639.png" alt="image" width="500">

- Each GPU server has one or more local NVMe to cache partition of training samples

<img src="/images/Pasted image 20261111085726.png" alt="image" width="500">


```bash
nvidia-smi -l

nvidia-smi nvlink --status

iostat -x 1 <device-name>
```


# Model Evaluation and Model Validation

- Evaluate using test data to determine performance for the intended task
- Model validation pipeline
- Allocates GPUs and CPUs
- Model validation is managed by a separate team that owns the compliance tests
- Model training produces a huge number of candidate models

## Model Performance for Classification and Regression

- Model performance evaluation is tightly coupled with the type of ML model
	- Classification
	- Regression

- Evaluate using mean absolute error (MAE), mean squared error (MSE), and R-squared
- R-squared
	- Measures the proportion of variance in the target explain by the model
	- Dimensionless and remains the same across different scales of target values
- Evaluate classification
	- Accuracy
	- Precision
	- Recall
	- F1 score
- ROC AUC (receiver operating characteristic - area under the curve)
	- Measure the ability of a classification model to distinguish between classes by evaluating the trade-off between the true positive rate and false positive rate
- Confusion matrix
	- Counts for predicting correctly and incorrectly

```python
from sklearn.metrics import accuracy_score, f1_score, confusion_matrix
y_pred = model.predict(X_test)
y_prob = model.predict_proba(X_test)[:, 1]  

accuracy = accuracy_score(y_test, y_pred)
f1 = f1_score(y_test, y_pred)
cm = confusion_matrix(y_test, y_pred)
roc_auc = roc_auc_score(y_test, y_prob)
```

## Model Interpretability

- Model interpretability
	- SHAP (Shapely Additive exPlanation)
	- Provides a unified measure of feature importance based on game theory

```python
import shap
explainer = shap.Explainer(model, X_test)
shap_values = explainer(X_test)
# Summary plot to visualize feature importance
shap.summary_plot(shap_values, X_test)
```

- SHAP values
	- Effective when used in decision trees and ensemble models
- Ablation studies
	- Evaluate the contribution of different components or feature of an NN by systematically "ablating" (removing or altering) parts of its architecture

## Model Bias Tests

- Model bias tests should assess and measure potential bias in a model
- Marked as free from known bias and continues to production
- Extract different slicer of evaluation data from the test dataset
- Training helper columns
	- Create evaluation data
	- Dropped before training and not returned when reading inference data

```python
fv = fs.create_feature_view(name="trans_fv", version=1,
    training_helper_columns=["gender"],
    ...
)

X_train, X_test, y_train, y_test = fv.train_test_split(
    test_size=0.2,
    training_helper_columns=True
)

X_train = X_train.drop("gender", axis=1) # Drop helper column before training
model = xgboost.XGBClassifier().fit(X_train, y_train)

# Evaluate on female subset
female_mask = X_test["gender"] == "female"
X_female_test = X_test[female_mask].drop("gender", axis=1)
y_female_test = y_test[female_mask]
y_female_pred = model.predict(X_female_test)
female_accuracy = accuracy_score(y_female_test, y_female_pred)
```

## Model File Formats and the Model Registry

- Training a model is similar to compiling a program into binary
- Build once and deploy anywhere

- .safetensors
	- Interoperable, efficient model formats used by model LLMs and transformers models
	- Sharded files to enable parallel loading
- .pkl
	- Scikit-Learn models
	- Create picked Python object using the joblib library
	- Execute arbitrary code when loading data
- .json
	- XGBoost/LightGBM model
- .onnx
	- Interoperable model format requires either Open Neural Network Exchange (ONNX)
- .pt and .pth
	- Generic PyTorch checkpoint file formats that can be used to resume training
- .engine
	- TensorRT file format that is optimized for NVIDIA GPUs and requires TensorRT server
- .pb and .h5
	- TensorFlow model file formats
- .bin and .ckpt with optimizer states (Lightning Checkpoints)
	- Optimizer states and full checkpoint information for continued training or fine-tuning

## Model Cards

- Model cards
	- One-page overviews of models in the model registry that are increasingly required for governance and compliance
	- Information about the model, performance, and passed validation tests
	- Usage introductions or guidance so that the model can be deployed to production
	- PNG files (plots or graphs)
	- Model card should strive to cover 100% of the categories

#### MODEL CARD

**Model Name/Version:** [Model Name, Version Number]

**Date:** [MM/DD/YYYY]

**Intended Use:**

- [Describe the primary purpose of the model and intended applications and stakeholders]
    
- [Describe not intended uses, where the model should not be used]
    

**Model Details:**

- _Model Architecture_: [e.g., Random Forest, CNN, Transformer, etc.]
    
- _Feature View_: Input features required by model
    
    - _Training Data_: Size and feature groups used
        
- _Model Signature_: [Input features and output labels for model]
    

**Performance Evaluation:**

- _Evaluation Metrics_: [RMSE, F1 score, ROC AUC, etc.]
    
- _Test Dataset_: [Describe the test dataset—size, split policy]
    
- _Performance Results_: [Provide key performance numbers on test data]
    
- _Comparison with Baselines_: [How does it compare with existing methods?]
    

**Ethical Considerations and Limitations:**

- _Bias_: [Evaluation datasets and bias tests performed]
    
- _Potential Risks and Limitations_: [Describe potential harms and limitations of the model]
    

**Deployment and Maintenance:**

- _Intended Deployment Environment_: [Batch, API/Online, Streaming, Edge]
    
- _Model Dependencies_: [List libraries or frameworks required]
    
- _Monitoring Strategy_: [Describe plans for post-deployment monitoring]
    
- _Retraining Schedule_: [Planned model updates and frequency]
    

**Explainability and Interpretability:**

- _Feature Importance_: [Key features influencing the model’s decisions]
    
- _Interpretability Techniques Used_: [SHAP, LIME, etc.]
    

**Responsible AI Considerations:**

- _Compliance_: [Regulatory frameworks followed, such as GDPR, EU AI Act]
    
- _Feedback Mechanism_: [How users can report issues or provide feedback]
    
- _Cost of Model Training and Deployment_: [Electricity consumption]
    

**References:**

- _Code/Papers/Documentation_: [Source code, referenced publications, doc links]
    
- _Contact Information_: [Who to contact for questions]