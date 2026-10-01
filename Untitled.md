
# Phase overview

| Phase  | Focus                                 | Core progression                                                                                                                      |
| ------ | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **1**  | Strong ML base                        | Hands-On ML → Probabilistic ML                                                                                                        |
| **2**  | Data & analytics engineering          | SQL/Data Modeling → Database Internals → dbt → Airflow → Kafka → Spark → Databricks → Iceberg/Delta                                   |
| **3**  | Systems, cloud & infrastructure       | Linux → Networking → AWS → Docker → Terraform → Kubernetes → Helm → Argo CD                                                           |
| **4**  | Observability, reliability & security | OpenTelemetry → Prometheus/Grafana → Sentry → SRE → Application/Cloud Security → Kubernetes Security → Software Supply-Chain Security |
| **5**  | Production ML                         | ML Production Systems → MLflow → Feature Stores → ML Platform Engineering → Serving → Monitoring                                      |
| **6**  | GPU & accelerated computing           | GPU Architecture → CUDA → PyTorch GPU → Profiling → Triton → Quantization → vLLM → TensorRT-LLM                                       |
| **7**  | Mathematical depth                    | Numerical Linear Algebra → Convex Optimization → Information Theory → Gaussian Processes                                              |
| **8**  | Modern AI / RAG                       | Transformers/Hugging Face → Embeddings → Vector Databases → Hybrid Search/Reranking → RAG → Agents → FastAPI → LLMOps → Evals         |
| **9**  | Research & decision intelligence      | Bayesian Methods → Experimental Design → Causal Inference → Optimization → Evolutionary Computing → Bandits → RL → Optimal Control    |
| **10** | Cognitive / brain-inspired AI         | Cognitive Neuroscience → Natural General Intelligence → Computational Cognitive Science → Neural Computation → Neuro-Symbolic AI      |

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

| #   | Textbook                                           | Level                   | Context                                                                                    | Link                                                                                                      |
| --- | -------------------------------------------------- | ----------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| 1   | [[0) Data Pipelines with Apache Airflow, 2nd Ed.]] | Intermediate → Advanced | DAGs, orchestration, scheduling                                                            | [O’Reilly](https://www.oreilly.com/library/view/data-pipelines-with/9781633436374/)                       |
| 2   | [[0) Databricks Data Intelligence Platform]]       | Intermediate            | Spark, Delta, Unity Catalog, ML                                                            | [O’Reilly](https://www.oreilly.com/library/view/databricks-data-intelligence/9798868804441/)              |
| 3   | [[0) Apache Iceberg - The Definitive Guide]]       | Advanced                | Lakehouse tables, metadata, transactions                                                   | [O’Reilly](https://www.oreilly.com/library/view/apache-iceberg-the/9781098148614/)                        |
| 4   | [[0) Kafka: The Definitive Guide, 2nd Ed.]]            | Beginner → Intermediate | Event streaming, producers, consumers, partitions, clusters                                | [O’Reilly](https://www.oreilly.com/library/view/kafka-the-definitive/9781492043072/)                      |
| 5   | [[0) Learning Spark, 2nd Ed.]]                         | Intermediate → Advanced | Spark SQL, DataFrames, Structured Streaming, ML pipelines                                  | [O’Reilly](https://www.oreilly.com/library/view/learning-spark-2nd/9781492050032/)                        |
| 6   | [[0) Hadoop: The Definitive Guide, 4th Ed.]]           | Beginner → Intermediate | HDFS, MapReduce, YARN, distributed storage                                                 | [O’Reilly](https://www.oreilly.com/library/view/hadoop-the-definitive/9781491901687/)                     |
| 7   | [[0) Delta Lake: The Definitive Guide]]                | Intermediate → Advanced | ACID lakehouses, transaction logs, Delta tables, Spark integration                         | [O’Reilly](https://www.oreilly.com/library/view/delta-lake-the/9781098151935/)                            |
| 8   | [[0) Fundamentals of Data Engineering]]                | Beginner → Intermediate | Data lifecycle, architecture, ingestion, storage, transformation                           | [O’Reilly](https://www.oreilly.com/library/view/fundamentals-of-data/9781098108298/)                      |
| 9   | [[0) Streaming Systems]]                               | Intermediate → Advanced | Event time, windows, watermarks, state, exactly-once processing                            | [O’Reilly](https://www.oreilly.com/library/view/streaming-systems/9781491983867/)                         |
| 10  | [[0) Designing Data-Intensive Applications, 2nd Ed.]]  | Intermediate → Advanced | Distributed systems, replication, partitioning, transactions, streaming                    | [O’Reilly](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781098119058/)     |
| 11  | [[0) Fundamentals of Analytics Engineering]]              | Beginner → Intermediate | dbt, ELT, data modeling, quality, CI/CD                                                    | [O’Reilly](https://www.oreilly.com/library/view/fundamentals-of-analytics/9781837636457/)                 |
| 12  | [[0) Database Internals — Alex Petrov]]                | Intermediate → Advanced | B-trees, LSM trees, WAL, storage engines, replication, distributed transactions, consensus | [O’Reilly](https://www.oreilly.com/library/view/database-internals/9781492040330/) |
| 13  | [[0) Data Contracts]]                                   | Intermediate → Advanced | Producer/consumer contracts, schema evolution, data quality, shift-left governance          | [O’Reilly](https://www.oreilly.com/library/view/data-contracts/9781098157623/) |



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
| 5   | [[0) AWS Certified Security Study Guide, 2nd Ed.]]                   | Advanced                | IAM, KMS, encryption, GuardDuty, Security Hub, incident response, DevSecOps | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-security/9781394253463/)  |
| 6   | [[0) AWS Certified SysOps Administrator Study Guide, 3rd Ed.]]       | Intermediate → Advanced | Cloud operations, monitoring, automation, reliability, troubleshooting      | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-sysops/9781119813101/)    |
| 7   | [[0) AWS Certified DevOps Engineer – Professional]]                  | Advanced                | CI/CD, IaC, deployment automation, observability, resilient operations      | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-devops/9781836207634/)    |
| 8   | [[0) AWS Certified Advanced Networking Study Guide, 2nd Ed.]]        | Advanced                | VPC, Transit Gateway, Direct Connect, VPNs, DNS, hybrid networking          | [O’Reilly](https://www.oreilly.com/library/view/aws-certified-advanced/9781394171859/)  |
| 9   | [[AWS Certified Generative AI Developer – Professional]]             | Advanced                | Bedrock, foundation models, RAG, agents, GenAI application development      | [AWS Certification](https://aws.amazon.com/certification/)                              |

Recommended certification order:

**Solutions Architect Associate → Data Engineer Associate → Machine Learning Engineer Associate**

---

# 6. Infrastructure & platform engineering
| #   | Resource                                                  | Level                   | Focus                                                                         | Link                                                                                                            |
| --- | --------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| 1   | [[0) Terraform in Depth]]                                 | Advanced                | Infrastructure as code                                                        | [O’Reilly](https://www.oreilly.com/library/view/terraform-in-depth/9781633438002/)                              |
| 2   | [[0) Argo CD - Up and Running]]                           | Intermediate → Advanced | Kubernetes GitOps deployments                                                 | [O’Reilly](https://www.oreilly.com/library/view/argo-cd-up/9781098141998/)                                      |
| 3   | [[0) Observability Engineering, 2nd Ed.]]                 | Advanced                | Telemetry, SLOs, distributed debugging                                        | [O’Reilly](https://www.oreilly.com/library/view/observability-engineering-2nd/9781098179915/)                   |
| 4   | [[0) Mastering API Architecture]]                         | Intermediate → Advanced | Gateways, REST, microservices, service mesh                                   | [O’Reilly](https://www.oreilly.com/library/view/mastering-api-architecture/9781492090625/)                      |
| 5   | [[0) Effective Platform Engineering]]                     | Advanced                | Internal platforms, self-service infrastructure                               | [O’Reilly](https://www.oreilly.com/library/view/effective-platform-engineering/9781633436497/)                  |
| 6   | [[0) Docker Docs]]                                            | Beginner → Advanced     | Containers, images, networking, storage, Compose                              | [Docker Docs](https://docs.docker.com/)                                                                         |
| 7   | [[0) Docker Deep Dive, 5th Ed.]]                              | Beginner → Intermediate | Docker internals, images, containers, networking, security                    | [O’Reilly](https://www.oreilly.com/library/view/docker-deep-dive/9781806024032/)                                |
| 8   | [[0) Kubernetes Docs]]                                        | Beginner → Advanced     | Pods, deployments, services, networking, cluster concepts                     | [Kubernetes Docs](https://kubernetes.io/docs/)                                                                  |
| 9   | [[0) The Kubernetes Book, 3rd Ed.]]                           | Beginner → Intermediate | Kubernetes fundamentals, workloads, services, RBAC, StatefulSets              | [O’Reilly](https://www.oreilly.com/library/view/the-kubernetes-book/9781805806639/)                             |
| 10  | [[0) Cloud Native DevOps with Kubernetes, 2nd Ed.]]           | Intermediate → Advanced | Production Kubernetes, deployment, reliability, security, scaling             | [O’Reilly](https://www.oreilly.com/library/view/cloud-native-devops/9781098116811/)                             |
| 11  | [[0) Prometheus: Up & Running, 2nd Ed.]]                      | Intermediate            | Metrics, PromQL, exporters, alerting, Alertmanager                            | [O’Reilly](https://www.oreilly.com/library/view/prometheus-up/9781098131135/)                                   |
| 12  | [[0) Mastering Prometheus]]                                   | Intermediate → Advanced | Prometheus at scale, Kubernetes monitoring, Loki, Tempo                       | [O’Reilly](https://www.oreilly.com/library/view/mastering-prometheus/9781805125662/)                            |
| 13  | [[0) Observability with Grafana]]                             | Intermediate → Advanced | Grafana dashboards, Prometheus, Loki, Tempo, logs and traces                  | [O’Reilly](https://www.oreilly.com/library/view/observability-with-grafana/9781803248004/)                      |
| 14  | [[0) Linux — Michael Kofler]]                                 | Beginner → Intermediate | Linux administration, filesystems, processes, networking, shell, security     | [O’Reilly](https://www.oreilly.com/library/view/linux/9781806108176/)                    |
| 15  | [[0) UNIX and Linux System Administration Handbook, 5th Ed.]] | Intermediate → Advanced | Production Linux, storage, networking, DNS, security, performance, automation | [O’Reilly](https://www.oreilly.com/library/view/unix-and-linux/9780134278308/)           |
| 16  | [[0) Network Programming with Go]]                            | Intermediate → Advanced | TCP/IP, sockets, DNS, routing, HTTP, TLS, network services                    | [O’Reilly](https://www.oreilly.com/library/view/network-programming-with/9781098128890/) |
| 17  | [[0) Learning OpenTelemetry]]                              | Intermediate → Advanced | Instrumentation, traces, metrics, logs, collectors, semantic conventions     | [O’Reilly](https://www.oreilly.com/library/view/learning-opentelemetry/9781098147174/) |
| 18  | [[0) Site Reliability Engineering, 2nd Ed.]]              | Intermediate → Advanced | SRE, SLIs/SLOs, error budgets, incident response, scalable operations         | [O’Reilly](https://www.oreilly.com/library/view/site-reliability-engineering/9798341607675/) |
| 19  | [[0) Software Architecture: The Hard Parts]]              | Intermediate → Advanced | Distributed architecture, decomposition, coupling, data ownership, trade-offs | [O’Reilly](https://www.oreilly.com/library/view/software-architecture-the/9781492086888/) |
### Core tool flow

**Linux → Networking → Docker → Kubernetes → Helm → Terraform → Argo CD → OpenTelemetry → Prometheus/Grafana → SRE**

Also learn:

- Redis
- API gateways
- gRPC
- OAuth/OIDC
- service meshes
- GitHub Actions
- Backstage
- secrets management
- Sentry
- systemd / SSH / Bash
- strace / lsof / ss / tcpdump
- DNS / TCP / UDP / HTTP/2 / HTTP/3 / TLS

---

# 7. Commercial ML engineering

| #   | Textbook                                                      | Level                   | Context                                                                       | Link                                                                                        |
| --- | ------------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 1   | [[0) Hands-On Machine Learning]]                              | Intermediate            | Train and evaluate models                                                     | [O’Reilly](https://www.oreilly.com/library/view/hands-on-machine-learning/9798341607972/)   |
| 2   | [[0) Machine Learning Production Systems]]                    | Intermediate → Advanced | Production pipelines and serving                                              | [O’Reilly](https://www.oreilly.com/library/view/machine-learning-production/9781098156008/) |
| 3   | [[0) Machine Learning Platform Engineering]]                  | Advanced                | MLflow, Kubeflow, Feast, Kubernetes                                           | [O’Reilly](https://www.oreilly.com/library/view/machine-learning-platform/9781633437333/)   |
| 4   | [[0) Building Machine Learning Systems with a Feature Store]] | Advanced                | Features, training, online inference                                          | [O’Reilly](https://www.oreilly.com/library/view/building-machine-learning/9781098165222/)   |
| 5   | [[0) Designing Machine Learning Systems]]                         | Intermediate → Advanced | End-to-end ML system design, data distribution shifts, retraining, monitoring | [O’Reilly](https://www.oreilly.com/library/view/designing-machine-learning/9781098107956/)  |
| 6   | [[0) Reliable Machine Learning]]                                  | Intermediate → Advanced | ML reliability, SLOs, monitoring, testing, incident response                  | [O’Reilly](https://www.oreilly.com/library/view/reliable-machine-learning/9781098106218/)   |
| 7   | [[0) Practical MLOps]]                                            | Beginner → Intermediate | CI/CD, deployment, cloud MLOps, monitoring, automation                        | [O’Reilly](https://www.oreilly.com/library/view/practical-mlops/9781098103002/)             |

Core technologies:

**Scikit-Learn → LightGBM/XGBoost → PyTorch → MLflow → Feast → Docker → Kubernetes → monitoring**

---

# 8. Modern AI / RAG
| #   | Textbook                                                      | Level                   | Context                                                                           | Link                                                                                        |
| --- | ------------------------------------------------------------- | ----------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 1   | [[0) Designing Large Language Model Applications]]            | Intermediate → Advanced | LLM architecture, embeddings                                                      | [O’Reilly](https://www.oreilly.com/library/view/designing-large-language/9781098150495/)    |
| 2   | [[0) RAG from First Principles]]                              | Advanced                | Retrieval, chunking, reranking                                                    | [O’Reilly](https://www.oreilly.com/library/view/rag-from-first/9781835888667/)              |
| 3   | [[0) Hands-On RAG for Production]]                            | Advanced                | Production RAG, GraphRAG, agents                                                  | [O’Reilly](https://www.oreilly.com/library/view/hands-on-rag-for/9798341621701/)            |
| 4   | [[0) RAG with Python Cookbook]]                               | Intermediate → Advanced | Practical RAG recipes                                                             | [O’Reilly](https://www.oreilly.com/library/view/rag-with-python/9798341600553/)             |
| 5   | [[0) Building Generative AI Services with FastAPI]]           | Intermediate → Advanced | AI APIs, vector DBs, caching                                                      | [O’Reilly](https://www.oreilly.com/library/view/building-generative-ai/9781098160296/)      |
| 6   | [[0) LLMs in Production]]                                     | Advanced                | LoRA, fine-tuning, serving, LLMOps                                                | [O’Reilly](https://www.oreilly.com/library/view/llms-in-production/9781633437203/)          |
| 7   | [[0) AI Engineering]]                                             | Intermediate → Advanced | Foundation models, RAG, agents, evals, inference, architecture                    | [O’Reilly](https://www.oreilly.com/library/view/ai-engineering/9781098166298/)              |
| 8   | [[0) LLM Engineer’s Handbook]]                                    | Intermediate → Advanced | Training, fine-tuning, RAG, inference, monitoring, MLOps                          | [O’Reilly](https://www.oreilly.com/library/view/llm-engineers-handbook/9781836200079/)      |
| 9   | [[0) Evals for AI Engineers]]                                     | Intermediate → Advanced | LLM evaluation, agent evaluation, testing, improvement loops                      | [O’Reilly](https://www.oreilly.com/library/view/evals-for-ai/9798341660717/)                |
| 10  | [[0) Building LLM Powered Applications]]                          | Intermediate → Advanced | LangChain, orchestration, fine-tuning, application architecture                   | [O’Reilly](https://www.oreilly.com/library/view/building-llm-powered/9781835462317/)        |
| 11  | [[0) Natural Language Processing with Transformers, Revised Ed.]] | Intermediate → Advanced | Hugging Face Transformers, Datasets, Tokenizers, Accelerate, training, deployment | [O’Reilly](https://www.oreilly.com/library/view/natural-language-processing/9781098136789/) |
| 12  | [[0) Transformers: The Definitive Guide]]                         | Intermediate → Advanced | Transformer architecture, fine-tuning, modern foundation models, deployment       | [O’Reilly](https://www.oreilly.com/library/view/transformers-the-definitive/9781098167004/) |
| 13  | [[0) Hands-On Large Language Models]]                             | Intermediate → Advanced | Embeddings, sentence transformers, semantic search, rerankers, fine-tuning        | [O’Reilly](https://www.oreilly.com/library/view/hands-on-large-language/9781098150952/)     |
| 14  | [[0) Large Language Models: The Hard Parts]]                      | Advanced                | Evaluation, open-source LLMs, local inference, llama.cpp, quantization            | [O’Reilly](https://www.oreilly.com/library/view/large-language-models/9798341622517/)       |
| 15  | [[0) Vector Databases — Nitin Borwankar]]                         | Intermediate → Advanced | Vector search, ANN, structured + vector hybrid architecture, metadata filtering    | [O’Reilly](https://www.oreilly.com/library/view/vector-databases/9781098177584/)             |

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
| 7   | [[0) Reinforcement Learning: An Introduction]]       | Advanced                | MDPs, Q-learning, policy learning                                 | [Free official book](http://incompleteideas.net/book/the-book-2nd.html)                                         |
| 8   | [[0) Dynamic Programming and Optimal Control]]       | Advanced                | Sequential decisions and optimal control                          | [Official resources](https://www.mit.edu/~dimitrib/dpbook.html)                                                 |
| 9   | [[0) Probabilistic Machine Learning: An Introduction]]   | Intermediate → Advanced | Probability, Bayesian ML, decision theory, graphical models       | [Free official version](https://probml.github.io/book1/)                                                        |
| 10  | [[0) Probabilistic Machine Learning: Advanced Topics]]   | Advanced                | Bayesian inference, generative models, causality, uncertainty     | [MIT Press](https://mitpress.mit.edu/9780262376006/probabilistic-machine-learning/)                             |
| 11  | [[0) Gaussian Processes for Machine Learning]]           | Advanced                | Gaussian processes, kernels, uncertainty, Bayesian regression     | [MIT Press Open Access](https://direct.mit.edu/books/oa-monograph/2320/Gaussian-Processes-for-Machine-Learning) |
| 12  | [[0) Convex Optimization]]                               | Advanced                | Convex sets, duality, constrained optimization, numerical methods | [Free official book](https://web.stanford.edu/~boyd/cvxbook/)                                                   |
| 13  | [[0) Elements of Information Theory, 2nd Ed.]]           | Advanced                | Entropy, KL divergence, mutual information, compression           | [Wiley](https://doi.org/10.1002/047174882X)                                                                     |
| 14  | [[0) Bandit Algorithms]]                                 | Advanced                | Exploration vs exploitation, UCB, Thompson sampling, regret       | [Free official PDF](https://tor-lattimore.com/downloads/book/book.pdf)                                          |
| 15  | [[0) Practical Statistics for Data Scientists, 2nd Ed.]] | Beginner → Intermediate | Statistical testing, regression, sampling, experimentation        | [O’Reilly](https://www.oreilly.com/library/view/practical-statistics-for/9781492072935/)                        |

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
| 6   | [[0) The Cambridge Handbook of Computational Cognitive Sciences]] | Intermediate → Advanced | Cognitive architectures, Bayesian models, neural networks, memory, perception, reasoning | [Cambridge](https://www.cambridge.org/core/books/cambridge-handbook-of-computational-cognitive-sciences/2713AC0C8AC0B0F2B9E97DB010813883) |
| 7   | [[0) Computational Explorations in Cognitive Neuroscience]]       | Advanced                | Biologically grounded neural networks and computational brain models                     | [MIT Press](https://mitpress.mit.edu/9780262650540/computational-explorations-in-cognitive-neuroscience/)                                 |
| 8   | [[0) Cognitive Neuroscience, 5th Ed.]]                            | Intermediate            | Neural basis of attention, memory, language, perception and executive control            | [Cambridge](https://www.cambridge.org/highereducation/books/cognitive-neuroscience/E7140D8507A519822B1D2B6C07025679)                      |
| 9   | [[0) Intelligence Science]]                                       | Intermediate → Advanced | Neuroscience, cognition, neural computation, learning, memory and AI                     | [O’Reilly](https://www.oreilly.com/library/view/intelligence-science/9780323884983/)                                                      |
| 10  | [[0) Neuro-Symbolic Artificial Intelligence]]                     | Intermediate → Advanced | Combining neural learning with symbolic reasoning                                        | [O’Reilly](https://www.oreilly.com/library/view/neuro-symbolic-artificial-intelligence/9781394355570/)                                    |

---

# 11. GPU & accelerated computing

| #   | Textbook / Resource                                   | Level                   | Context                                                             | Link                                                                                                                  |
| --- | ----------------------------------------------------- | ----------------------- | ------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| 1   | [[0) Programming Massively Parallel Processors, 4th Ed.]] | Intermediate → Advanced | GPU architecture, CUDA, kernels, warps, memory, parallel algorithms | [O’Reilly](https://www.oreilly.com/library/view/programming-massively-parallel/9780323984638/) |
| 2   | [[0) GPU Programming with C++ and CUDA]]                  | Intermediate → Advanced | CUDA C++, kernels, streams, memory, multi-GPU programming           | [O’Reilly](https://www.oreilly.com/library/view/gpu-programming-with/9781805124542/)           |
| 3   | NVIDIA CUDA Programming Guide                          | Intermediate → Advanced | CUDA programming model, APIs, memory, optimization, multi-GPU          | [NVIDIA](https://docs.nvidia.com/cuda/cuda-programming-guide/index.html)                                                                                         |
| 4   | NVIDIA Nsight Systems / Compute                       | Advanced                | GPU profiling, kernel analysis, bottleneck detection                    | [NVIDIA Nsight](https://developer.nvidia.com/tools-overview)                                                                                                  |
| 5   | Triton                                                | Advanced                | Python-based custom GPU kernels for ML                                  | [Official docs](https://triton-lang.org/)                                                                                         |
| 6   | vLLM                                                  | Advanced                | High-throughput LLM inference, batching, KV-cache management            | [Official docs](https://docs.vllm.ai/)                                                                                           |
| 7   | TensorRT-LLM                                          | Advanced                | NVIDIA-optimized LLM inference and deployment                           | [NVIDIA](https://docs.nvidia.com/tensorrt-llm/index.html)                                                                                                  |

---

# 12. Security & software supply-chain engineering

| #   | Textbook / Resource                                 | Level                   | Context                                                           | Link                                                                                                         |
| --- | --------------------------------------------------- | ----------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| 1   | [[0) Software Supply Chain Security — Cassie Crossley]] | Intermediate → Advanced | SBOMs, secure SDLC, DevSecOps, software provenance, supplier risk | [O’Reilly](https://www.oreilly.com/library/view/software-supply-chain/9781098133696/) |
| 2   | [[0) Building Secure and Reliable Systems]]             | Intermediate → Advanced | Secure systems design, reliability, incident response, recovery   | [O’Reilly](https://www.oreilly.com/library/view/building-secure-and/9781492083115/)                                                                                                     |
| 3   | [[0) Web Application Security, 2nd Ed.]]                | Intermediate → Advanced | Web/API vulnerabilities, authentication, secure architecture      | [O’Reilly](https://www.oreilly.com/library/view/web-application-security/9781098143923/)                                                                                                     |
| 4   | [[0) Learning Kubernetes Security, 2nd Ed.]]            | Intermediate → Advanced | RBAC, containers, network security, runtime security              | [O’Reilly](https://www.oreilly.com/library/view/learning-kubernetes-security/9781835886380/)                                                                                                     |
| 5   | OWASP Top 10 / ASVS                                 | Intermediate            | Application security requirements and common vulnerabilities      | [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)                                                                                                        |
| 6   | SLSA                                                | Advanced                | Build integrity and software provenance                           | [Official specification](https://slsa.dev/spec/)                                                                                  |
| 7   | Sigstore / Cosign                                   | Intermediate → Advanced | Artifact signing and verification                                 | [Official docs](https://docs.sigstore.dev/cosign/)                                                                              |

---

# Complete recommended order

### Stage 1 — Strong ML base

**Hands-On ML**  
→ Probabilistic ML

### Stage 2 — Data & analytics engineering

**Advanced SQL / Data Modeling**  
→ Database Internals  
→ dbt  
→ Airflow  
→ Kafka  
→ Spark / Hadoop  
→ Databricks  
→ Parquet / Iceberg / Delta  
→ Data Contracts

### Stage 3 — Systems, cloud & infrastructure

**Linux**  
→ Networking  
→ AWS Solutions Architecture  
→ IAM / VPC / S3 / EC2  
→ Docker  
→ Terraform  
→ Kubernetes  
→ Helm  
→ Argo CD

### Stage 4 — Observability, reliability & security

**OpenTelemetry**  
→ Prometheus / Grafana  
→ Sentry  
→ Site Reliability Engineering  
→ Web / API Security  
→ AWS Security  
→ Kubernetes Security  
→ Software Supply-Chain Security  
→ SLSA / Sigstore / Cosign

### Stage 5 — Production ML

**ML Production Systems**  
→ MLflow  
→ Feature Stores  
→ ML Platform Engineering  
→ SageMaker  
→ Model Serving  
→ Monitoring / Reliability

### Stage 6 — GPU & accelerated computing

**GPU Architecture**  
→ CUDA  
→ PyTorch GPU Execution  
→ Nsight Profiling  
→ Triton  
→ Mixed Precision / Quantization  
→ vLLM  
→ TensorRT-LLM

### Stage 7 — Mathematical depth

**Numerical Linear Algebra**  
→ Convex Optimization  
→ Information Theory  
→ Gaussian Processes

### Stage 8 — Modern AI / RAG

**Transformers / Hugging Face**  
→ Embeddings / Sentence Transformers  
→ Vector Databases  
→ Hybrid Search / Reranking  
→ RAG From First Principles  
→ Production RAG / GraphRAG  
→ Agents / Tool Calling  
→ FastAPI AI Services  
→ LLMOps  
→ Evals

### Stage 9 — Research & decision intelligence

**Bayesian Analysis**  
→ Experimental Design  
→ Causal Inference  
→ Optimization  
→ Evolutionary Computing  
→ Bandits  
→ Reinforcement Learning  
→ Optimal Control

### Stage 10 — Cognitive / brain-inspired AI

**Cognitive Neuroscience**  
→ Natural General Intelligence  
→ Computational Cognitive Science  
→ Neural Computation  
→ Neuro-Symbolic AI
