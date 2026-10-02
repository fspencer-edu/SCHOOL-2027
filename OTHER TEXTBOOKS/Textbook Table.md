# Phase overview

| Phase  | Focus                                 | Core progression                                                                                                                      |
| ------ | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **1**  | Strong ML base                        | Hands-On ML → Probabilistic ML                                                                                                        |
| **2**  | Data & analytics engineering          | SQL/Data Modeling → Database Internals → dbt → Airflow → Kafka → Spark → Databricks → Iceberg/Delta                                   |
| **3**  | Systems, cloud & infrastructure       | Linux → Networking → AWS → Docker → Terraform → Kubernetes → Helm → Argo CD                                                           |
| **4**  | Observability & reliability           | OpenTelemetry → Prometheus/Grafana → Sentry → SLOs/SLIs → SRE → Incident Response                                                     |
| **5**  | Production ML                         | ML Production Systems → MLflow → Feature Stores → ML Platform Engineering → Serving → Monitoring                                      |
| **6**  | Mathematical depth                    | Numerical Linear Algebra → Convex Optimization → Information Theory → Gaussian Processes                                              |
| **7**  | Modern AI / RAG                       | Transformers/Hugging Face → Embeddings → Vector Databases → Hybrid Search/Reranking → RAG → Agents → FastAPI → LLMOps → Evals         |
| **8**  | Research & decision intelligence      | Bayesian Methods → Experimental Design → Causal Inference → Optimization → Evolutionary Computing → Bandits → RL → Optimal Control    |
| **9**  | Cognitive / brain-inspired AI         | Cognitive Neuroscience → Natural General Intelligence → Computational Cognitive Science → Neural Computation → Neuro-Symbolic AI      |
| **10** | Advanced systems integration          | Distributed Systems → APIs → Data Platforms → Cloud Platforms → ML Platforms → Reliability                                            |
| **11** | GPU & accelerated computing           | GPU Architecture → CUDA → PyTorch GPU → Profiling → Triton → Mixed Precision → Quantization → vLLM → TensorRT-LLM                     |
| **12** | Security & software supply-chain engineering | Web/Application Security → IAM/OAuth/OIDC → Secrets Management → Container/Kubernetes Security → SAST/DAST → SBOM → SLSA → Sigstore/Cosign → Runtime Security |
| **13** | Computer vision / vision ML           | Image Processing → CNNs → Transfer Learning → Detection → Segmentation → Vision Transformers → Multimodal/VLMs → Deployment           |
| **14** | Robotics / embodied ML                | ROS 2 → Simulation → Perception → SLAM → Navigation → Manipulation → Reinforcement Learning → Vision-Language-Action / Embodied AI    |
| **15** | Software engineering & delivery       | Git → Testing → GitHub Actions → CI/CD → OpenAPI → Release Engineering                                                                |
| **16** | Backend & distributed applications    | REST → FastAPI/Express → gRPC → Redis → Queues → Temporal                                                                              |
| **17** | ML lifecycle & serving                | Experiment Tracking → MLflow → Registry → Serving → KServe/Ray → Monitoring                                                           |
| **18** | Data quality & lineage                | Great Expectations → Data Contracts → OpenLineage → Data Observability                                                                |
| **19** | Developer/platform productivity       | Backstage → Feature Flags → Dev Environments → Policy → FinOps                                                                        |

---

# 1. ML research foundation

|   # | Textbook                                                              | Level                   | Context                                          | Link                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --: | --------------------------------------------------------------------- | ----------------------- | ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1 | [[0) Hands-On Machine Learning with Scikit-Learn and PyTorch]]        | Intermediate            | Classification, ensembles, PyTorch, practical ML | [O’Reilly](https://www.oreilly.com/library/view/hands-on-machine-learning/9798341607972/)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|   2 | [[0) Probabilistic Machine Learning: An Introduction — Kevin Murphy]] | Intermediate → Advanced | Probability, Bayesian ML, probabilistic models   | [MIT Press](https://mitpress.ublish.com/book/probabilistic-machine-learning-an-introduction)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|   3 | [[0) Numerical Linear Algebra — Trefethen & Bau]]                     | Advanced                | SVD, QR, eigenvalues, numerical stability        | [Official page](https://people.maths.ox.ac.uk/trefethen/text.html)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|   4 | [[0) Convex Optimization — Boyd & Vandenberghe]]                      | Advanced                | Constraints, duality, convex optimization        | [Free official book](https://web.stanford.edu/~boyd/cvxbook/)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|   5 | [[0) Elements of Information Theory — Cover & Thomas]]                | Advanced                | Entropy, KL divergence, mutual information       | [Wiley](https://onlinelibrary.wiley.com/doi/book/10.1002/047174882X)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|   6 | [[0) Gaussian Processes for Machine Learning]]                        | Advanced                | Bayesian prediction, kernels, uncertainty        | [Free MIT Press edition]([https://direct.mit.edu/books/oa-monograph/2320/Gaussian-Processes-for-Machine-Learning](https://watermark02.silverchair.com/book_9780262256834.pdf?token=AQECAHi208BE49Ooan9kkhW_Ercy7Dm3ZL_9Cf3qfKAc485ysgAAAkEwggI9BgkqhkiG9w0BBwagggIuMIICKgIBADCCAiMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMR12QTokLxv5g5GzeAgEQgIIB9OJlCTndNcetqJ8tGByRzU7RVMwnOZFQ5TMwKw1q73ZEZOmsl5BcV9NJ1Wc9iqrlykJgfgmy4fvD_rIYeDEdCgFRkmRo28z3kXt1zn0g3g3Y0kLZF1YKr_OBWsrMAK6_odB2W7YYqsnttqYFrGMhJhPf9p70-QAI92rnEDX8H18V2Wvvdv7oLF402ANDlG-XL2W9iZwNZDx67QZqP0GYbomSyuTxM1oIhVevEyhPfvs4l--bBQewWdiMG0q1asMfVn5gE75Z4AH672PS-nTCNUcRAaRNAFJmxsFgMkkKF8kMimCiaD9ebCPQI6A0TXIQ5AYJqSLy17j3aYwmktpIfFxI3FiMtbCgA92kJpnIJW-XJmVj9yvJzj4m-Qygi4c1FA5tnwZepiSjnGswM5Wrui6iiobMpCdpn27aQbYNPLFTxmf_UuAJgv-m7d0WEIm03NcKFm0ymCPpvKF-Uli2hcUSGXTV-Fjcg9OMDe8Rj7LnFZUcEeq3wTT3oam6v1UJMv0JxeE6MbA5IcmgohHHlujvueGCVUtI7LgqeFS4LNXdNZed_NVEAuXozmuIdyO3hthBnqNlnfm4c6NdD9sSA-3hkMOolZKUEU2GDtIdAN1afXXxGgY18o-_f2m_hzC9nxr-jVUZywI6GyQFweI2rM7yeBOh)) |

---

# 2. Data modeling & analytics engineering

|   # | Textbook                                      | Level                   | Context                                            | Link                                                                                       |
| --: | --------------------------------------------- | ----------------------- | -------------------------------------------------- | ------------------------------------------------------------------------------------------ |
|   1 | [[0) Analytics Engineering with SQL and dbt]] | Intermediate            | dbt, SQL models, testing, analytics engineering    | [O’Reilly](https://www.oreilly.com/library/view/analytics-engineering-with/9781098142377/) |
|   2 | [[0) Data Modeling with Microsoft Power BI]]  | Intermediate            | Star schemas, dimensions, relationships            | [O’Reilly](https://www.oreilly.com/library/view/data-modeling-with/9781098148546/)         |
|   3 | [[0) Universal Data Modeling]]                | Intermediate → Advanced | Relational, NoSQL, dimensional, Data Vault         | [O’Reilly](https://www.oreilly.com/library/view/universal-data-modeling/0642572229368/)    |
|   4 | [[0) Data Management at Scale, 2nd Ed.]]      | Intermediate            | Data products, governance, enterprise architecture | [O’Reilly](https://www.oreilly.com/library/view/data-management-at/9781098138851/)         |
|   5 | [[0) Fundamentals of Data Engineering]]       | Intermediate            | End-to-end data engineering architecture           | [O’Reilly](https://www.oreilly.com/library/view/fundamentals-of-data/9781098108298/)       |

### Tool stack

|Area|Tools|
|---|---|
|SQL|PostgreSQL, advanced SQL|
|Transformation|**dbt Core / dbt Cloud**|
|Warehouse|Snowflake, Redshift, Databricks SQL|
|Local analytics|DuckDB, Polars|
|Columnar data|Parquet, PyArrow|
|BI|Power BI / Tableau|
|Data quality|Great Expectations / Soda|
|Lineage|OpenLineage|
|Lakehouse|Iceberg / Delta Lake|

**Flow:**  
**Advanced SQL → Data Modeling → dbt → Analytics Engineering → Airflow → Spark → Databricks**

---

# 3. Data engineering & distributed systems

| #   | Textbook                                              | Level                   | Context                                                                                    | Link                                                                                                      |
| --- | ----------------------------------------------------- | ----------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| 1   | [[0) Data Pipelines with Apache Airflow, 2nd Ed.]]    | Intermediate → Advanced | DAGs, orchestration, scheduling                                                            | [O’Reilly](https://www.oreilly.com/library/view/data-pipelines-with/9781633436374/)                       |
| 2   | [[0) Databricks Data Intelligence Platform]]          | Intermediate            | Spark, Delta, Unity Catalog, ML                                                            | [O’Reilly](https://www.oreilly.com/library/view/databricks-data-intelligence/9798868804441/)              |
| 3   | [[0) Apache Iceberg - The Definitive Guide]]          | Advanced                | Lakehouse tables, metadata, transactions                                                   | [O’Reilly](https://www.oreilly.com/library/view/apache-iceberg-the/9781098148614/)                        |
| 4   | [[0) Kafka: The Definitive Guide, 2nd Ed.]]           | Beginner → Intermediate | Event streaming, producers, consumers, partitions, clusters                                | [O’Reilly](https://www.oreilly.com/library/view/kafka-the-definitive/9781492043072/)                      |
| 5   | [[0) Learning Spark, 2nd Ed.]]                        | Intermediate → Advanced | Spark SQL, DataFrames, Structured Streaming, ML pipelines                                  | [O’Reilly](https://www.oreilly.com/library/view/learning-spark-2nd/9781492050032/)                        |
| 6   | [[0) Hadoop: The Definitive Guide, 4th Ed.]]          | Beginner → Intermediate | HDFS, MapReduce, YARN, distributed storage                                                 | [O’Reilly](https://www.oreilly.com/library/view/hadoop-the-definitive/9781491901687/)                     |
| 7   | [[0) Delta Lake - The Definitive Guide]]              | Intermediate → Advanced | ACID lakehouses, transaction logs, Delta tables, Spark integration                         | [O’Reilly](https://www.oreilly.com/library/view/delta-lake-the/9781098151935/)                            |
| 8   | [[0) Streaming Systems]]                              | Intermediate → Advanced | Event time, windows, watermarks, state, exactly-once processing                            | [O’Reilly](https://www.oreilly.com/library/view/streaming-systems/9781491983867/)                         |
| 9   | [[0) Designing Data-Intensive Applications, 2nd Ed.]] | Intermediate → Advanced | Distributed systems, replication, partitioning, transactions, streaming                    | [O’Reilly](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781098119058/)     |
| 10  | [[0) Fundamentals of Analytics Engineering]]             | Beginner → Intermediate | dbt, ELT, data modeling, quality, CI/CD                                                    | [O’Reilly](https://www.oreilly.com/library/view/fundamentals-of-analytics/9781837636457/)                 |
| 11  | [[0) Database Internals — Alex Petrov]]               | Intermediate → Advanced | B-trees, LSM trees, WAL, storage engines, replication, distributed transactions, consensus | [O’Reilly](https://www.oreilly.com/library/view/database-internals/9781492040330/?utm_source=chatgpt.com) |
| 12  |                                                       |                         |                                                                                            |                                                                                                           |



Also learn:

**Kafka → Spark Structured Streaming → S3 → Parquet → Iceberg/Delta → Databricks**
    
---

# 4. AWS / cloud engineering

## AWS services roadmap

|#|Area|Services|
|--:|---|---|
|1|Identity|IAM, IAM Identity Center|
|2|Security|KMS, Secrets Manager, ACM|
|3|Networking|VPC, Subnets, Route Tables, NAT, Security Groups, Route 53|
|4|Compute|EC2, Auto Scaling, ELB|
|5|Containers|ECR, ECS, Fargate, EKS|
|6|Storage|S3, EBS, EFS, Glacier|
|7|Relational DB|RDS, Aurora|
|8|NoSQL|DynamoDB|
|9|Cache|ElastiCache / Redis|
|10|Serverless|Lambda|
|11|API|API Gateway|
|12|Messaging|SQS, SNS, EventBridge|
|13|Streaming|Kinesis, MSK|
|14|ETL|Glue|
|15|Query|Athena|
|16|Big data|EMR|
|17|Data lake|Lake Formation|
|18|Warehouse|Redshift|
|19|ML|SageMaker|
|20|GenAI|Bedrock|
|21|Monitoring|CloudWatch, X-Ray|
|22|Auditing|CloudTrail, Config|
|23|DevOps|CodeBuild / CodePipeline / GitHub Actions|
|24|IaC|CloudFormation, CDK, Terraform|
|25|Governance|Organizations, Control Tower, SCPs|
|26|Cost|Budgets, Cost Explorer, Compute Optimizer|

### AWS priority for ML/data work

**IAM → VPC → S3 → EC2 → Lambda → SQS/EventBridge → Glue → Athena → EMR → Redshift → Kinesis/MSK → SageMaker → Bedrock → EKS → CloudWatch → Terraform**

---

# 5. AWS certification textbooks

| #   | Certification / Book                                             | Level                   | Context                                                                     | Link                                                                                    |
| --- | ---------------------------------------------------------------- | ----------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| 1   | [[0) AWS Certified Solutions Architect – Associate Study Guide]] | Intermediate            | Broad AWS architecture                                                      | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-solutions/9781119982623/) |
| 2   | [[0) AWS Certified Data Engineer Associate Study Guide]]         | Intermediate → Advanced | Pipelines, storage, quality, governance                                     | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-data/9781098170066/)      |
| 3   | [[0) AWS Certified Machine Learning Engineer Study Guide]]       | Intermediate → Advanced | SageMaker, training, deployment, MLOps                                      | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-machine/9781394319954/)   |
| 4   | [[0) AWS Certified Data Engineer Study Guide — Sybex]]           | Intermediate → Advanced | Deeper DEA-C01 reference                                                    | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-data/9781394286584/)      |
| 5   | [[0) AWS Certified Security Study Guide, 2nd Ed.]]               | Advanced                | IAM, KMS, encryption, GuardDuty, Security Hub, incident response, DevSecOps | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-security/9781394253463/)  |
| 6   | [[0) AWS Certified SysOps Administrator Study Guide, 3rd Ed.]]   | Intermediate → Advanced | Cloud operations, monitoring, automation, reliability, troubleshooting      | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-sysops/9781119813101/)    |
| 7   | [[0) AWS Certified DevOps Engineer – Professional]]              | Advanced                | CI/CD, IaC, deployment automation, observability, resilient operations      | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-devops/9781836207634/)    |
| 8   | [[0) AWS Certified Advanced Networking Study Guide, 2nd Ed.]]    | Advanced                | VPC, Transit Gateway, Direct Connect, VPNs, DNS, hybrid networking          | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-advanced/9781394171859/)  |
| 9   | [[AWS Certified Generative AI Developer – Professional]]         | Advanced                | Bedrock, foundation models, RAG, agents, GenAI application development      | [AWS Certification](https://aws.amazon.com/certification/)                              |

Recommended certification order:

**Solutions Architect Associate → Data Engineer Associate → Machine Learning Engineer Associate**

---

# 6. Infrastructure & platform engineering
| #   | Resource                                                      | Level                   | Focus                                                                         | Link                                                                                                            |
| --- | ------------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| 1   | [[0) Terraform in Depth]]                                     | Advanced                | Infrastructure as code                                                        | [O’Reilly](https://www.oreilly.com/library/view/terraform-in-depth/9781633438002/)                              |
| 2   | [[0) Argo CD - Up and Running]]                               | Intermediate → Advanced | Kubernetes GitOps deployments                                                 | [O’Reilly](https://www.oreilly.com/library/view/argo-cd-up/9781098141998/)                                      |
| 3   | [[0) Observability Engineering, 2nd Ed.]]                     | Advanced                | Telemetry, SLOs, distributed debugging                                        | [O’Reilly](https://www.oreilly.com/library/view/observability-engineering-2nd/9781098179915/)                   |
| 4   | [[0) Mastering API Architecture]]                             | Intermediate → Advanced | Gateways, REST, microservices, service mesh                                   | [O’Reilly](https://www.oreilly.com/library/view/mastering-api-architecture/9781492090625/)                      |
| 5   | [[0) Effective Platform Engineering]]                         | Advanced                | Internal platforms, self-service infrastructure                               | [O’Reilly](https://www.oreilly.com/library/view/effective-platform-engineering/9781633436497/)                  |
| 6   | [[0) Docker Docs]]                                            | Beginner → Advanced     | Containers, images, networking, storage, Compose                              | [Docker Docs](https://docs.docker.com/)                                                                         |
| 7   | [[0) Docker Deep Dive, 5th Ed.]]                              | Beginner → Intermediate | Docker internals, images, containers, networking, security                    | [O’Reilly](https://www.oreilly.com/library/view/docker-deep-dive/9781806024032/)                                |
| 8   | [[0) Kubernetes Docs]]                                        | Beginner → Advanced     | Pods, deployments, services, networking, cluster concepts                     | [Kubernetes Docs](https://kubernetes.io/docs/)                                                                  |
| 9   | [[0) The Kubernetes Book, 3rd Ed.]]                           | Beginner → Intermediate | Kubernetes fundamentals, workloads, services, RBAC, StatefulSets              | [O’Reilly](https://www.oreilly.com/library/view/the-kubernetes-book/9781805806639/)                             |
| 10  | [[0) Cloud Native DevOps with Kubernetes, 2nd Ed.]]           | Intermediate → Advanced | Production Kubernetes, deployment, reliability, security, scaling             | [O’Reilly](https://www.oreilly.com/library/view/cloud-native-devops/9781098116811/)                             |
| 11  | [[0) Prometheus: Up & Running, 2nd Ed.]]                      | Intermediate            | Metrics, PromQL, exporters, alerting, Alertmanager                            | [O’Reilly](https://www.oreilly.com/library/view/prometheus-up/9781098131135/)                                   |
| 12  | [[0) Mastering Prometheus]]                                   | Intermediate → Advanced | Prometheus at scale, Kubernetes monitoring, Loki, Tempo                       | [O’Reilly](https://www.oreilly.com/library/view/mastering-prometheus/9781805125662/)                            |
| 13  | [[0) Observability with Grafana]]                             | Intermediate → Advanced | Grafana dashboards, Prometheus, Loki, Tempo, logs and traces                  | [O’Reilly](https://www.oreilly.com/library/view/observability-with-grafana/9781803248004/)                      |
| 14  | [[0) Linux — Michael Kofler]]                                 | Beginner → Intermediate | Linux administration, filesystems, processes, networking, shell, security     | [O’Reilly](https://www.oreilly.com/library/view/linux/9781806108176/?utm_source=chatgpt.com)                    |
| 15  | [[0) UNIX and Linux System Administration Handbook, 5th Ed.]] | Intermediate → Advanced | Production Linux, storage, networking, DNS, security, performance, automation | [O’Reilly](https://www.oreilly.com/library/view/unix-and-linux/9780134278308/?utm_source=chatgpt.com)           |
| 16  | [[0) Network Programming with Go]]                            | Intermediate → Advanced | TCP/IP, sockets, DNS, routing, HTTP, TLS, network services                    | [O’Reilly](https://www.oreilly.com/library/view/network-programming-with/9781098128890/?utm_source=chatgpt.com) |
### Core tool flow

**Docker → Kubernetes → Helm → Terraform → Argo CD → OpenTelemetry → Prometheus/Grafana**

---

# 7. Commercial ML engineering

| #   | Textbook                                                      | Level                   | Context                                                                       | Link                                                                                        |
| --- | ------------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 1   | [[0) Hands-On Machine Learning]]                              | Intermediate            | Train and evaluate models                                                     | [O’Reilly](https://www.oreilly.com/library/view/hands-on-machine-learning/9798341607972/)   |
| 2   | [[0) Machine Learning Production Systems]]                    | Intermediate → Advanced | Production pipelines and serving                                              | [O’Reilly](https://www.oreilly.com/library/view/machine-learning-production/9781098156008/) |
| 3   | [[0) Machine Learning Platform Engineering]]                  | Advanced                | MLflow, Kubeflow, Feast, Kubernetes                                           | [O’Reilly](https://www.oreilly.com/library/view/machine-learning-platform/9781633437333/)   |
| 4   | [[0) Building Machine Learning Systems with a Feature Store]] | Advanced                | Features, training, online inference                                          | [O’Reilly](https://www.oreilly.com/library/view/building-machine-learning/9781098165222/)   |
| 5   | [[0) Designing Machine Learning Systems]]                     | Intermediate → Advanced | End-to-end ML system design, data distribution shifts, retraining, monitoring | [O’Reilly](https://www.oreilly.com/library/view/designing-machine-learning/9781098107956/)  |
| 6   | [[0) Reliable Machine Learning]]                              | Intermediate → Advanced | ML reliability, SLOs, monitoring, testing, incident response                  | [O’Reilly](https://www.oreilly.com/library/view/reliable-machine-learning/9781098106218/)   |
| 7   | [[0) Practical MLOps]]                                        | Beginner → Intermediate | CI/CD, deployment, cloud MLOps, monitoring, automation                        | [O’Reilly](https://www.oreilly.com/library/view/practical-mlops/9781098103002/)             |

Core technologies:

**Scikit-Learn → LightGBM/XGBoost → PyTorch → MLflow → Feast → Docker → Kubernetes → monitoring**

---

# 8. Modern AI / RAG
| #   | Textbook                                                          | Level                   | Context                                                                           | Link                                                                                        |
| --- | ----------------------------------------------------------------- | ----------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 1   | [[0) Designing Large Language Model Applications]]                | Intermediate → Advanced | LLM architecture, embeddings                                                      | [O’Reilly](https://www.oreilly.com/library/view/designing-large-language/9781098150495/)    |
| 2   | [[0) RAG from First Principles]]                                  | Advanced                | Retrieval, chunking, reranking                                                    | [O’Reilly](https://www.oreilly.com/library/view/rag-from-first/9781835888667/)              |
| 3   | [[0) Hands-On RAG for Production]]                                | Advanced                | Production RAG, GraphRAG, agents                                                  | [O’Reilly](https://www.oreilly.com/library/view/hands-on-rag-for/9798341621701/)            |
| 4   | [[0) RAG with Python Cookbook]]                                   | Intermediate → Advanced | Practical RAG recipes                                                             | [O’Reilly](https://www.oreilly.com/library/view/rag-with-python/9798341600553/)             |
| 5   | [[0) Building Generative AI Services with FastAPI]]               | Intermediate → Advanced | AI APIs, vector DBs, caching                                                      | [O’Reilly](https://www.oreilly.com/library/view/building-generative-ai/9781098160296/)      |
| 6   | [[0) LLMs in Production]]                                         | Advanced                | LoRA, fine-tuning, serving, LLMOps                                                | [O’Reilly](https://www.oreilly.com/library/view/llms-in-production/9781633437203/)          |
| 7   | [[0) AI Engineering]]                                             | Intermediate → Advanced | Foundation models, RAG, agents, evals, inference, architecture                    | [O’Reilly](https://www.oreilly.com/library/view/ai-engineering/9781098166298/)              |
| 8   | [[0) LLM Engineer’s Handbook]]                                    | Intermediate → Advanced | Training, fine-tuning, RAG, inference, monitoring, MLOps                          | [O’Reilly](https://www.oreilly.com/library/view/llm-engineers-handbook/9781836200079/)      |
| 9   | [[0) Evals for AI Engineers]]                                     | Intermediate → Advanced | LLM evaluation, agent evaluation, testing, improvement loops                      | [O’Reilly](https://www.oreilly.com/library/view/evals-for-ai/9798341660717/)                |
| 10  | [[0) Building LLM Powered Applications]]                          | Intermediate → Advanced | LangChain, orchestration, fine-tuning, application architecture                   | [O’Reilly](https://www.oreilly.com/library/view/building-llm-powered/9781835462317/)        |
| 11  | [[0) Natural Language Processing with Transformers, Revised Ed.]] | Intermediate → Advanced | Hugging Face Transformers, Datasets, Tokenizers, Accelerate, training, deployment | [O’Reilly](https://www.oreilly.com/library/view/natural-language-processing/9781098136789/) |
| 12  | [[0) Transformers - The Definitive Guide]]                        | Intermediate → Advanced | Transformer architecture, fine-tuning, modern foundation models, deployment       | [O’Reilly](https://www.oreilly.com/library/view/transformers-the-definitive/9781098167004/) |
| 13  | [[0) Hands-On Large Language Models]]                             | Intermediate → Advanced | Embeddings, sentence transformers, semantic search, rerankers, fine-tuning        | [O’Reilly](https://www.oreilly.com/library/view/hands-on-large-language/9781098150952/)     |
| 14  | [[0) Large Language Models - The Hard Parts]]                     | Advanced                | Evaluation, open-source LLMs, local inference, llama.cpp, quantization            | [O’Reilly](https://www.oreilly.com/library/view/large-language-models/9798341622517/)       |

Also learn:

- Hugging Face
- Transformers
- PEFT / LoRA
- sentence-transformers
- vector databases
- hybrid search
- rerankers
- vLLM
- llama.cpp
- model evaluation
- agents/tool calling
    
---

# 9. Research & decision intelligence

| #   | Textbook                                             | Level                   | Context                                                           | Link                                                                                                            |
| --- | ---------------------------------------------------- | ----------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| 1   | [[0) Bayesian Analysis with Python, 3rd Ed.]]        | Intermediate            | Practical Bayesian modeling                                       | [O’Reilly](https://www.oreilly.com/library/view/bayesian-analysis-with/9781805127161/)                          |
| 2   | [[0) Design and Analysis of Experiments]]            | Intermediate → Advanced | A/B testing, factorial designs, ANOVA                             | [O’Reilly](https://www.oreilly.com/library/view/design-and-analysis/9781119320937/)                             |
| 3   | [[0) Causal Inference - The Mixtape]]                | Intermediate → Advanced | Causal effects and quasi-experiments                              | [Yale](https://yalebooks.yale.edu/book/9780300251685/causal-inference/)                                         |
| 4   | [[0) Causal AI]]                                     | Advanced                | Causal ML/AI                                                      | [Official resources](https://www.robertosazuwaness.com/causal-ai-book/)                                         |
| 5   | [[0) Optimization Algorithms]]                       | Intermediate → Advanced | Search, metaheuristics, optimization                              | [O’Reilly](https://www.oreilly.com/library/view/optimization-algorithms/9781633438835/)                         |
| 6   | [[0) Introduction to Evolutionary Computing]]        | Advanced                | Genetic and evolutionary algorithms                               | [Springer](https://link.springer.com/book/10.1007/978-3-662-44874-8)                                            |
| 7   | [[0) Reinforcement Learning - An Introduction]]      | Advanced                | MDPs, Q-learning, policy learning                                 | [Free official book](http://incompleteideas.net/book/the-book-2nd.html)                                         |
| 8   | [[0) Dynamic Programming and Optimal Control]]       | Advanced                | Sequential decisions and optimal control                          | [Official resources](https://www.mit.edu/~dimitrib/dpbook.html)                                                 |
| 9   | 0) Probabilistic Machine Learning: An Introduction   | Intermediate → Advanced | Probability, Bayesian ML, decision theory, graphical models       | [Free official version](https://probml.github.io/book1/)                                                        |
| 10  | 0) Probabilistic Machine Learning: Advanced Topics   | Advanced                | Bayesian inference, generative models, causality, uncertainty     | [MIT Press](https://mitpress.mit.edu/9780262376006/probabilistic-machine-learning/)                             |
| 11  | 0) Gaussian Processes for Machine Learning           | Advanced                | Gaussian processes, kernels, uncertainty, Bayesian regression     | [MIT Press Open Access](https://direct.mit.edu/books/oa-monograph/2320/Gaussian-Processes-for-Machine-Learning) |
| 12  | 0) Convex Optimization                               | Advanced                | Convex sets, duality, constrained optimization, numerical methods | [Free official book](https://web.stanford.edu/~boyd/cvxbook/)                                                   |
| 13  | 0) Elements of Information Theory, 2nd Ed.           | Advanced                | Entropy, KL divergence, mutual information, compression           | [Wiley](https://doi.org/10.1002/047174882X)                                                                     |
| 14  | 0) Bandit Algorithms                                 | Advanced                | Exploration vs exploitation, UCB, Thompson sampling, regret       | [Free official PDF](https://tor-lattimore.com/downloads/book/book.pdf)                                          |
| 15  | 0) Practical Statistics for Data Scientists, 2nd Ed. | Beginner → Intermediate | Statistical testing, regression, sampling, experimentation        | [O’Reilly](https://www.oreilly.com/library/view/practical-statistics-for/9781492072935/)                        |

**Flow:**  
**Bayesian Statistics → Experimental Design → Causality → Optimization → Evolutionary Computing → RL → Optimal Control**

---

# 10. Cognitive / AI research


| #   | Textbook / Resource                                           | Level                   | Context                                                                                  | Link                                                                                                                                      |
| --- | ------------------------------------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | [[0) Natural General Intelligence — Christopher Summerfield]] | Intermediate            | Brain-inspired AI concepts                                                               | [Oxford](https://academic.oup.com/book/45403)                                                                                             |
| 2   | [[0) Probabilistic Machine Learning]]                         | Intermediate → Advanced | Learning under uncertainty                                                               | [MIT Press](https://mitpress.ublish.com/book/probabilistic-machine-learning-an-introduction)                                              |
| 3   | [[0) Elements of Information Theory]]                         | Advanced                | Representation and information                                                           | [Wiley](https://onlinelibrary.wiley.com/doi/book/10.1002/047174882X)                                                                      |
| 4   | [[0) Reinforcement Learning: An Introduction]]                | Advanced                | Reward-based cognition/decision making                                                   | [Free](http://incompleteideas.net/book/the-book-2nd.html)                                                                                 |
| 5   | [[0) MIT Computational Cognitive Science]]                    | Advanced                | Bayesian cognition, concepts, reasoning                                                  | [MIT OCW](https://ocw.mit.edu/courses/9-66j-computational-cognitive-science-fall-2004/)                                                   |
| 6   | 0) The Cambridge Handbook of Computational Cognitive Sciences | Intermediate → Advanced | Cognitive architectures, Bayesian models, neural networks, memory, perception, reasoning | [Cambridge](https://www.cambridge.org/core/books/cambridge-handbook-of-computational-cognitive-sciences/2713AC0C8AC0B0F2B9E97DB010813883) |
| 7   | 0) Computational Explorations in Cognitive Neuroscience       | Advanced                | Biologically grounded neural networks and computational brain models                     | [MIT Press](https://mitpress.mit.edu/9780262650540/computational-explorations-in-cognitive-neuroscience/)                                 |
| 8   | 0) Cognitive Neuroscience, 5th Ed.                            | Intermediate            | Neural basis of attention, memory, language, perception and executive control            | [Cambridge](https://www.cambridge.org/highereducation/books/cognitive-neuroscience/E7140D8507A519822B1D2B6C07025679)                      |
| 9   | 0) Intelligence Science                                       | Intermediate → Advanced | Neuroscience, cognition, neural computation, learning, memory and AI                     | [O’Reilly](https://www.oreilly.com/library/view/intelligence-science/9780323884983/)                                                      |
| 10  | 0) Neuro-Symbolic Artificial Intelligence                     | Intermediate → Advanced | Combining neural learning with symbolic reasoning                                        | [O’Reilly](https://www.oreilly.com/library/view/neuro-symbolic-artificial-intelligence/9781394355570/)                                    |

---

# 11. GPU & accelerated computing

| #   | Textbook / Resource                                       | Level                   | Context                                                                          | Link                                                                                           |
| --- | --------------------------------------------------------- | ----------------------- | -------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| 1   | [[0) Programming Massively Parallel Processors, 4th Ed.]] | Intermediate → Advanced | GPU architecture, CUDA, kernels, warps, memory, parallel algorithms              | [O’Reilly](https://www.oreilly.com/library/view/programming-massively-parallel/9780323984638/) |
| 2   | [[0) GPU Programming with C++ and CUDA]]                  | Intermediate → Advanced | CUDA C++, kernels, streams, memory, multi-GPU programming                        | [O’Reilly](https://www.oreilly.com/library/view/gpu-programming-with/9781805124542/)           |
| 3   | NVIDIA CUDA Programming Guide                             | Intermediate → Advanced | CUDA programming model, APIs, kernels, memory, asynchronous execution, multi-GPU | [NVIDIA](https://docs.nvidia.com/cuda/cuda-programming-guide/index.html)                       |
| 4   | NVIDIA Nsight Systems                                     | Advanced                | System-wide CPU/GPU profiling, tracing, bottleneck analysis                      | [NVIDIA](https://docs.nvidia.com/nsight-systems/index.html)                                    |
| 5   | NVIDIA Nsight Compute                                     | Advanced                | CUDA kernel profiling, occupancy, memory throughput, kernel optimization         | [NVIDIA](https://docs.nvidia.com/nsight-compute/)                                              |
| 6   | Triton                                                    | Advanced                | Python-based custom GPU kernels and ML kernel optimization                       | [Official docs](https://triton-lang.org/)                                                      |
| 7   | vLLM                                                      | Advanced                | High-throughput LLM inference, batching, KV-cache management, serving            | [Official docs](https://docs.vllm.ai/en/stable/)                                               |
| 8   | TensorRT-LLM                                              | Advanced                | NVIDIA-optimized LLM inference, quantization, parallelism, KV cache, deployment  | [NVIDIA](https://nvidia.github.io/TensorRT-LLM/latest/index.html)                              |

---

# 12. Security & software supply-chain engineering

| #   | Textbook / Resource                                     | Level                   | Context                                                               | Link                                                                                       |
| --- | ------------------------------------------------------- | ----------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| 1   | [[0) Software Supply Chain Security — Cassie Crossley]] | Intermediate → Advanced | SBOMs, secure SDLC, DevSecOps, software provenance, supplier risk     | [O’Reilly](https://www.oreilly.com/library/view/software-supply-chain/9781098133696/)      |
| 2   | [[0) Building Secure and Reliable Systems]]             | Intermediate → Advanced | Secure systems design, reliability, incident response, recovery       | [O’Reilly](https://www.oreilly.com/library/view/building-secure-and/9781492083115/)        |
| 3   | [[0) Web Application Security, 2nd Ed.]]                | Intermediate → Advanced | Web/API vulnerabilities, threat modeling, authentication, secure SDLC | [O’Reilly](https://www.oreilly.com/library/view/web-application-security/9781098143923/)   |
| 4   | [[0) Learning Kubernetes Security, 2nd Ed.]]            | Intermediate → Advanced | RBAC, containers, network security, runtime security                  | [Packt](https://www.packtpub.com/en-us/product/learning-kubernetes-security-9781835886380) |
| 5   | OWASP Top 10 / ASVS                                     | Intermediate            | Application security requirements and common vulnerabilities          | [OWASP ASVS](https://owasp.org/projects/asvs)                                              |
| 6   | SLSA                                                    | Advanced                | Build integrity, provenance, attestations, supply-chain security      | [Official SLSA v1.2](https://slsa.dev/spec/v1.2/)                                          |
| 7   | Sigstore / Cosign                                       | Intermediate → Advanced | Artifact signing, container signing, verification, attestations       | [Sigstore Cosign](https://docs.sigstore.dev/cosign/)                                       |

---

# 13. Computer vision / vision ML

| #   | Textbook / Resource                                 | Level                   | Context                                                                                      | Link                                                                                     |
| --- | --------------------------------------------------- | ----------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| 1   | [[0) Modern Computer Vision with PyTorch, 2nd Ed.]] | Intermediate → Advanced | CNNs, transfer learning, object detection, segmentation, vision transformers, deployment     | [O’Reilly](https://www.oreilly.com/library/view/modern-computer-vision/9781803231334/)   |
| 2   | [[0) AI and ML for Coders in PyTorch]]              | Beginner → Intermediate | PyTorch foundations, CNNs, image classification, transfer learning                           | [O’Reilly](https://www.oreilly.com/library/view/ai-and-ml/9781098199166/)                |
| 3   | [[0) Computer Vision Projects with PyTorch]]        | Intermediate → Advanced | Classification, detection, segmentation, pose estimation, anomaly detection, video analytics | [O’Reilly](https://www.oreilly.com/library/view/computer-vision-projects/9781484282731/) |
| 4   | [[0) Vision Language Models]]                       | Intermediate → Advanced | Vision transformers, multimodal models, CLIP-style systems, Hugging Face, VLMs               | [O’Reilly](https://www.oreilly.com/library/view/vision-language-models/9798341624030/)   |
| 5   | [[0) Learn Computer Vision Using OpenCV]]           | Intermediate            | OpenCV, image processing, object detection, tracking, classical computer vision              | [O’Reilly](https://www.oreilly.com/library/view/learn-computer-vision/9781484242612/)    |
| 6   | [[0) Deep Learning for Computer Vision]]            | Intermediate → Advanced | Deep learning for image recognition and practical vision systems                             | [O’Reilly](https://www.oreilly.com/library/view/deep-learning-for/9781788295628/)        |
| 7   | OpenCV Documentation                                | Beginner → Advanced     | Image processing, feature extraction, geometry, video, camera calibration                    | [OpenCV](https://docs.opencv.org/)                                                       |
| 8   | torchvision Documentation                           | Intermediate            | PyTorch vision datasets, transforms, models, detection and segmentation                      | [PyTorch](https://pytorch.org/vision/stable/index.html)                                  |


### Core vision flow

**OpenCV / image fundamentals**  
→ **PyTorch + CNNs**  
→ **Transfer Learning**  
→ **Object Detection**  
→ **Image Segmentation**  
→ **Pose Estimation**  
→ **Vision Transformers**  
→ **Self-Supervised Vision**  
→ **Multimodal / Vision-Language Models**  
→ **Production Deployment**

---

# 14. Robotics / embodied ML

|#|Textbook / Resource|Level|Context|Link|
|---|---|---|---|---|
|1|[[0) Mastering ROS 2 for Robotics Programming, 4th Ed.]]|Intermediate → Advanced|ROS 2, Gazebo, Nav2, MoveIt 2, autonomous robotics, RL and AI integration|[O’Reilly](https://www.oreilly.com/library/view/mastering-ros-2/9781836209010/)|
|2|[[0) Hands-On ROS for Robotics Programming]]|Intermediate|ROS, simulation, SLAM, navigation, computer vision, ML and reinforcement learning|[O’Reilly](https://www.oreilly.com/library/view/hands-on-ros-for/9781838551308/)|
|3|[[0) ROS Robotics Projects, 2nd Ed.]]|Intermediate → Advanced|Autonomous robots, perception, navigation, reinforcement learning, robotics projects|[O’Reilly](https://www.oreilly.com/library/view/ros-robotics-projects/9781838649326/)|
|4|[[0) ROS Programming: Building Powerful Robots]]|Intermediate → Advanced|ROS architecture, sensors, actuators, SLAM, MoveIt, navigation, computer vision|[O’Reilly](https://www.oreilly.com/library/view/ros-programming-building/9781788627436/)|
|5|[[0) Deep Reinforcement Learning and Its Industrial Use Cases]]|Advanced|Deep RL for robot control, navigation, autonomous systems and manipulation|[O’Reilly](https://www.oreilly.com/library/view/deep-reinforcement-learning/9781394272556/)|
|6|[[0) Reinforcement Learning: An Introduction]]|Advanced|MDPs, Q-learning, policy optimization, sequential robot decision-making|[Free official book](http://incompleteideas.net/book/the-book-2nd.html)|
|7|[[0) Modern Computer Vision with PyTorch, 2nd Ed.]]|Intermediate → Advanced|Robot perception, detection, segmentation, visual recognition|[O’Reilly](https://www.oreilly.com/library/view/modern-computer-vision/9781803231334/)|
|8|ROS 2 Documentation|Beginner → Advanced|Nodes, topics, services, actions, TF2, middleware, robotics integration|[ROS](https://docs.ros.org/)|
|9|Gazebo Documentation|Intermediate|Robotics simulation, sensors, physics and environments|[Gazebo](https://gazebosim.org/docs/)|
|10|MoveIt 2 Documentation|Intermediate → Advanced|Motion planning, manipulation, robot arms, collision checking|[MoveIt](https://moveit.picknik.ai/main/index.html)|
|11|Nav2 Documentation|Intermediate → Advanced|Mapping, localization, path planning and autonomous navigation|[Nav2](https://docs.nav2.org/)|


---

# 15. Software engineering & delivery

| # | Textbook / Resource | Level | Context | Link |
|---|---|---|---|---|
| 1 | [[0) Version Control with Git, 3rd Ed.]] | Intermediate → Advanced | Git internals, branching, merges, rebasing, hooks, GitHub workflows | [O’Reilly](https://www.oreilly.com/library/view/version-control-with/9781492091189/) |
| 2 | [[0) Learning GitHub Actions]] | Intermediate | GitHub Actions, workflow automation, CI/CD, custom actions, security | [O’Reilly](https://www.oreilly.com/library/view/learning-github-actions/9781098131067/) |
| 3 | [[0) Software Engineering at Google]] | Intermediate → Advanced | Code reviews, testing, engineering practices, large-scale software development | [O’Reilly](https://www.oreilly.com/library/view/software-engineering-at/9781492082781/) |
| 4 | [[0) Fundamentals of Software Architecture, 2nd Ed.]] | Intermediate → Advanced | Architecture styles, modularity, trade-offs, governance, system design | [O’Reilly](https://www.oreilly.com/library/view/fundamentals-of-software/9781098175504/) |
| 5 | [[0) Release It!, 2nd Ed.]] | Intermediate → Advanced | Production stability, resilience patterns, failure handling, release engineering | [O’Reilly](https://www.oreilly.com/library/view/release-it-2nd/9781680504552/) |

### Core flow

**Git → Pull Requests / Code Review → Testing → GitHub Actions → CI/CD → OpenAPI → Release Engineering**

---

# 16. Backend & distributed applications

| #   | Textbook / Resource                           | Level                   | Context                                                                      | Link                                                                                          |
| --- | --------------------------------------------- | ----------------------- | ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| 1   | [[0) FastAPI — Bill Lubanovic]]               | Intermediate → Advanced | Python APIs, async services, validation, testing, deployment                 | [O’Reilly](https://www.oreilly.com/library/view/fastapi/9781098135492/)                       |
| 2   | [[0) gRPC - Up and Running]]                  | Intermediate → Advanced | RPC, Protocol Buffers, streaming, microservices, production gRPC             | [O’Reilly](https://www.oreilly.com/library/view/grpc-up-and/9781492058328/)                   |
| 3   | [[0) Redis in Action]]                        | Intermediate → Advanced | Caching, queues, pub/sub, in-memory data structures, real-time systems       | [O’Reilly](https://www.oreilly.com/library/view/redis-in-action/9781617290855/)               |
| 4   | [[0) Building Microservices, 2nd Ed.]]        | Intermediate → Advanced | Microservices, integration, deployment, testing, observability, security     | [O’Reilly](https://www.oreilly.com/library/view/building-microservices-2nd/9781492034018/)    |
| 5   | [[0) Designing Distributed Systems, 2nd Ed.]] | Intermediate → Advanced | Distributed patterns, sidecars, sharding, coordination, cloud-native systems | [O’Reilly](https://www.oreilly.com/library/view/designing-distributed-systems/9781098156343/) |
| 6   | Temporal Documentation                        | Intermediate → Advanced | Durable workflows, retries, stateful orchestration, long-running processes   | [Official docs](https://docs.temporal.io/)                                                    |

### Core flow

**REST → OpenAPI → FastAPI / Express → gRPC → Redis → Queues / Events → Temporal → Distributed Services**


---

# 17. ML lifecycle & serving

| # | Textbook / Resource | Level | Context | Link |
|---|---|---|---|---|
| 1 | [[0) Machine Learning Engineering with MLflow]] | Intermediate → Advanced | Experiment tracking, reproducibility, MLflow projects, registry, deployment | [O’Reilly](https://www.oreilly.com/library/view/machine-learning-engineering/9781800560796/) |
| 2 | [[0) Learning Ray]] | Beginner → Intermediate | Distributed ML, Ray Train, Tune, Serve, clusters, scaling Python ML | [O’Reilly](https://www.oreilly.com/library/view/learning-ray/9781098117214/) |
| 3 | [[0) Practical MLOps]] | Beginner → Intermediate | CI/CD for ML, model deployment, cloud MLOps, monitoring | [O’Reilly](https://www.oreilly.com/library/view/practical-mlops/9781098103002/) |
| 4 | [[0) Designing Machine Learning Systems]] | Intermediate → Advanced | End-to-end ML systems, deployment, drift, monitoring, feedback loops | [O’Reilly](https://www.oreilly.com/library/view/designing-machine-learning/9781098107956/) |
| 5 | [[0) Practical MLflow for Generative AI on Databricks]] | Intermediate → Advanced | MLflow 3.x, GenAI evaluation, registry, observability, production workflows | [O’Reilly](https://www.oreilly.com/library/view/practical-mlflow-for/9798341652743/) |
| 6 | KServe Documentation | Advanced | Kubernetes-native model serving, inference services, autoscaling | [Official docs](https://kserve.github.io/website/) |

### Core flow

**Experiment Tracking → MLflow → Artifacts → Registry → Model Promotion → Batch/Online Serving → Ray Serve / KServe → Monitoring**


---

# 18. Data quality & lineage

| #   | Textbook / Resource                            | Level                   | Context                                                                   | Link                                                                                   |
| --- | ---------------------------------------------- | ----------------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| 1   | [[0) Fundamentals of Data Observability]]      | Beginner → Intermediate | Data incidents, quality, lineage, monitoring, observability architecture  | [O’Reilly](https://www.oreilly.com/library/view/fundamentals-of-data/9781098133283/)   |
| 2   | [[0) Data Observability for Data Engineering]] | Intermediate → Advanced | Data quality monitoring, SLAs/SLOs, lineage, observability implementation | [O’Reilly](https://www.oreilly.com/library/view/data-observability-for/9781804616024/) |
| 3   | [[0) Data Contracts]]                          | Intermediate → Advanced | Schema contracts, producer/consumer guarantees, evolution, governance     | [O’Reilly](https://www.oreilly.com/library/view/data-contracts/9781098157623/)         |
| 4   | Great Expectations Documentation               | Intermediate            | Data validation, expectations, checkpoints, data quality automation       | [Official docs](https://docs.greatexpectations.io/)                                    |
| 5   | OpenLineage Documentation                      | Intermediate → Advanced | Open lineage standard for datasets, jobs, and pipeline metadata           | [Official docs](https://openlineage.io/docs/)                                          |
### Core flow

**Schema Validation → Great Expectations / Soda → Data Contracts → OpenLineage → Data Observability → Alerts / SLAs**

---

# 19. Developer/platform productivity

| #   | Textbook / Resource                     | Level                   | Context                                                                   | Link                                                                                           |
| --- | --------------------------------------- | ----------------------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| 1   | [[0) The Platform Engineer's Handbook]] | Intermediate → Advanced | Internal platforms, Backstage, self-service, golden paths, policy, FinOps | [O’Reilly](https://www.oreilly.com/library/view/the-platform-engineers/9781806380138/)         |
| 2   | [[0) Effective Platform Engineering]]   | Advanced                | Platform teams, internal developer platforms, self-service infrastructure | [O’Reilly](https://www.oreilly.com/library/view/effective-platform-engineering/9781633436497/) |
| 3   | [[0) Managing Feature Flags]]           | Intermediate → Advanced | Feature flags, progressive delivery, canaries, experimentation            | [O’Reilly](https://www.oreilly.com/library/view/managing-feature-flags/9781492028598/)         |
| 4   | [[0) Cloud FinOps]]                     | Intermediate → Advanced | Cloud cost allocation, optimization, unit economics, FinOps practices     | [O’Reilly](https://www.oreilly.com/library/view/cloud-finops/9781492054610/)                   |
| 5   | Backstage Documentation                 | Intermediate → Advanced | Developer portals, service catalogs, templates, plugins                   | [Official docs](https://backstage.io/docs/)                                                    |
| 6   | OpenFeature Documentation               | Intermediate            | Vendor-neutral feature flags and progressive delivery                     | [Official docs](https://openfeature.dev/docs/)                                                 |

### Core flow

**Backstage → Service Catalog → Templates / Golden Paths → Feature Flags → Policy as Code → Developer Environments → FinOps**

---
# Complete recommended order

### Stage 1 — Core foundations

**Hands-On ML**  
→ Advanced SQL  
→ Data Modeling  
→ Probabilistic ML
### Stage 2 — Data systems

**dbt**  
→ Airflow  
→ Spark/Hadoop  
→ Kafka  
→ Databricks  
→ Parquet / Iceberg / Delta
### Stage 3 — Cloud

**AWS Solutions Architecture**  
→ IAM/VPC/S3/EC2  
→ Lambda/SQS  
→ Glue/Athena/EMR  
→ Redshift  
→ Data Engineer certification
### Stage 4 — Infrastructure

**Docker**  
→ Terraform  
→ Kubernetes  
→ Helm  
→ Argo CD  
→ OpenTelemetry / Prometheus / Grafana
### Stage 5 — Production ML

**ML Production Systems**  
→ MLflow  
→ Feature Stores  
→ SageMaker  
→ model serving/monitoring
### Stage 6 — Mathematical depth

**Numerical Linear Algebra**  
→ Convex Optimization  
→ Information Theory  
→ Gaussian Processes
### Stage 7 — Modern AI

**LLM Applications**  
→ Embeddings  
→ RAG From First Principles  
→ Production RAG  
→ FastAPI AI Services  
→ LLMOps
### Stage 8 — Research intelligence

**Bayesian Analysis**  
→ Experimental Design  
→ Causal Inference  
→ Optimization  
→ Evolutionary Computing  
→ Reinforcement Learning  
→ Optimal Control
### Stage 9 — Cognitive AI

**Natural General Intelligence**  
→ Computational Cognitive Science
