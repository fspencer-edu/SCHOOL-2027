
- Data arrives continuously and needs to be processed in a real-time manner
# Evolution of the Apache Spark Stream Processing Engine

- Stream processing systems transitioned from single-node processing engines to multiple-node, distributed processing engines
- Record-at-a-time processing model

<img src="/images/Pasted image 20261015201610.png" alt="image" width="500">

- Not efficient at recovering from node failures and straggler nodes
- Either recover from a failure very fast with a lost of extra failover resources, or use minimal extra resources but recover slowly
- 


# The Programming Model of Structured Streaming
# The Fundamentals of a Structured Streaming Query
# Streaming Data Sources and Sings
# Data Transformations
# Stateful Streaming Aggregations
# Streaming Joins
# Arbitrary Stateful Computations

# Performance Tuning