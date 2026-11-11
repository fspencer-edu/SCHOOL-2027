- Streaming feature pipeline
	- Stream processing program that runs 24/7 consuming events from a streaming data source
	- More in common with microservices, than batch pipeline
- Window
	- A time-bound set of events

# Interactive AI Enabled Systems Need Real Time Features

- An interactive AI-enabled system adapts it behaviour in real time based on context, user actions, and environmental changes
- ByteDance (TikTok)
	- Real time data processing infrastructure to ensure that AI is responsive
	- Use online feature store as the retrieval engine for RAG with agents and LLMs

<img src="/images/Pasted image 20261110201234.png" alt="image" width="500">

- In a production system
	- Application would publish events to an event-streaming platform
	- Stream-processing application would consume, transform, and publish them to the online feature store

# Event Streaming Platforms

- Streaming data sources provide data as a sequence of events, message, or records
- Real-time data as an event stream
- Event streams are ingested and processed incrementally
	- CDC or polling from an operational database
	- Activity logs in applications
	- Sensors used by applications
		- Location
		- Cameras
		- Edge/IoT devices
		- Supervisory Control and Data Acquisition (SCADA)
		- Application context ifnormation
		- Third party data

- Event streams from these data sources are centralized in an event-streaming platofrm that acts as a hub
	- Scalable

- Apache Kafka
	- Open source scalable distributed event-streaming platform
- Amazon Kinesis
	- Cloud-native managed event-streaming service
- Google Cloud Pub/Sub
	- Cloud native event-streaming service

- Event streaming platforms are a primary data source for streaming feature pipelines
- Stream processing programs include a sink
	- Place where the results of data processing are stored
		- DAG
		- Lakehouse
		- Feature store

# Shift Left or Shift Right?

- Streaming feature pipelines precompute feature to provide history and context for online models
- Compute real-time feature on demand in response to prediction requests from AI-enabled applications or services
- Shifting left
	- Moving a phase of the software development process to the left
	- Precomputing features
	- Reduce latency of prediction requests
- Shifting right
	- Move phase closer to operations
	- Compute features in ODTs or MDTs
	- Removes the need for feature pipeline

<img src="/images/Pasted image 20261110201939.png" alt="image" width="500">


- Application requirements help decide whether to precompute or create features on demand

- Reasons to shift left
	- Application requires very low latency prediction
	- Overall computational burden is reduce by precomputing features
- Reasons to shift right
	- Latency-insensitive prediction requests
	- Avoiding the infrastructural burden of running a streaming feature pipeline

<img src="/images/Pasted image 20261110202139.png" alt="image" width="500">

- Choice imply trade-offs
	- Shift left may incuretoo much operational overheal
	- Shift right could add too much latency and cost to predictions

## Shift-Right Architectures

<img src="/images/Pasted image 20261110202252.png" alt="image" width="500">


- Events get stored a rows in online feature groups and asynchronously materialized to the offline feature store
- Data transformation on ODT function
	- Stateless transformations
		- Computed using only request parameters
	- Stateful transformations
		- Computed using a combination of request parameters and precomputed features read from the feature store
	- Stateful transformations with raw events
		- Read records from the online feature store as a DF and perform transformations
	- Stateful transformations with SQL
		- Transformations are executed in online feature store directly as SQL expressions

- Stateful transformations with raw events are more compute intensive and place high load on the online inference pipeline, network, and feature store

<img src="/images/Pasted image 20261110202633.png" alt="image" width="500">

- TTL can be specified as either the table level or row level
- Per-table TLL
	- All rows in the table are given the same TTL
- Write and deletions can get out of sync due to delays or failures in feature pipeline
- Purge window
	- Expired rows are only deleted after the purge window has passed

## Shift Left Architectures

- Precomputing features data in streaming feature pipelines
	- Online feature engineering in a stream processing layer
	- Offline feature creation in a batch pipeline
### Hybrid Streaming-batch Architecture

- A hybrid streaming batch architecture is designed in which you have two separate processing layers
	- Streaming processing pipeline for real-time feature engineering
	- Batch processing pipeline for historical feature data creation

<img src="/images/Pasted image 20261110203112.png" alt="image" width="500">

- Avoid this architecture
	- Requires custom infrastructure and complex logic
- Streaming native architecture
	- Single stream-processing pipeline can process both real-time data and backfill feature data for training
- Hybrid streaming-batch architecture is called a Lambda architecture
- Streaming-native is called a Kappa architecture

### Streaming-native Architecture

- Uses streaming pipeline to process both real-time event streams and historical data

<img src="/images/Pasted image 20261110203313.png" alt="image" width="500">

- Streaming feature pipeline need to run against both streaming and batch data sources and in different modes of operation
- Real time mode
	- Processes live event stream continuously
	- highly available
- Stream replay
	- Replays historical event through the streaming pipeline
	- Simulating real-time processing
- Backfilling
	- Addresses gaps in data or processes historical data from a batch data source
- Stream reprocessing
	- Updated logic is applied to already processed data by re-executing the stream

- Store a full copy of the event stream in a process called event sourcing
	- Used as a data source for streaming feature pipeline to replay, backfill, or reprocess a historical event stream
- Streaming programs can perform both stateless and stateful data transformations

- Data processing guarantees by event sources and streaming engines
	- Exactly-once
		- Each event is processed once and only once, ensuring no duplicates or msises
	- At-least once
		- Events are processed one or more times
		- Ensuring no data loss
		- Allowing duplicate events
	- At-most once
		- Events are processed once or not at all, prioritizing low latency, but risking data loss

- By default provide at-least once semantic
	- Turning duplicates events into idempotent updates for the online store
	- Removing duplicate events for the offline store

- Provision your stream-processing system so that it can handle the expected write load
- Backpressure
	- A flow control mechanism in stream processing that matches the rate of data production at the source with the rate of data consumption at the sink
# Writing Streaming Feature Pipelines

- Dataflow graphs
- Dataflow program
	- Models computation as a directed graph
	- Streaming feature pipeline is a dataflow program that starts with one or more event streams as input
	- Nodes are operators, edges are data dependencies, feature groups are the sinks

- Stream-processing programs work with datastream
	- Continuous, unbounded sequence of data records that are generated over time

<img src="/images/Pasted image 20261110204155.png" alt="image" width="500">

- Operations on datastreams are stateful and time-sentitive
- Windows convert the infinite stream into a bounded set of events that are processed together
- Datastream also enable easy incremental computation
- DataFrames represent a static, bounded collection of data and ar eprocessed in branches

## Dataflow Programming

- Operators consume data from their inputs, perform computations on the data, and produce data to their output
- Operators without input edges are called data sources
- Operators with output edges are called data sinks
- Operators can accept multiple input streams and produce multiple output streams
- Split a single input into multiple output streams for parallel processing
- Merge multiple input streams into a single output stream with a join transformation
- Different operators can run in parallel (task parallelism)

- Data exchange
	- Forward data exchange
		- Data is passed directly to the next downstream operator without altering distribution or routing
	- Broadcast data exchange
		- A copy of the same data is sent to all downstream operators, which is useful for distributing shared data like configuration or lookup tables
	- Key-based data exchange
		- Data is routed by key
		- Ensures records with the same key are processed by the same operator, enabling parallel stateful operators
	- Random data exchange
		- Data is randomly distributed across operators, balancing load for stateless operations, but without preserving data locality

## Stateless and Stateful Data Transformations

- Stateless data processing
	- Does not maintain any internal state
	- Stateless data transformation do not depend on any event in the past
	- Easily parallelized
	- Safely rerun
- Out-of-order data is when events arrive for processing in an order that is different from event time order

- Stream processing for stateful data tansformations
	- Rolling aggregations
		- Over a period of time to capture trends in time-series data
	- Session-based features
		- Number of clicks or duration for a user session
	- Lag features
		- Capture the value of a variable at a previous time step
	- Cumulative sums and counts
		- Include capturing customer lifetime value through the amount spent by a customer
	- Time since last event
		- When and where credit card was most recently used, and it helps identify geographic fraud attacks
	- Windowed aggregations
		- Provide insights into recent spikes or drops in activity
	- Stateful joins
		- Join incoming credit card transactions with a stream of metadata about credit cards that's read from a lakehouse table

- Stateful data processing
	- Maintains state about previously processed events
	- State can be updated when processing new events, and used to parameterized data transformation

- Stream-processing frameworks
	- Apace Flink
		- Support built-in stateful and stateless data tarsnformation operations
		- Java
	- Quix and Pathway
		- Single-host stream-processing engines with Python APIs
		- Stateful and stateless data transformations
	- RisingWave
		- Distributed stream-processing engine build in Rust
		- Row-oriented store
	- Apache Spark Structured Streaming
		- Built-in stateful and stateless data transformation operators
		- Java/Scala engine
	- Feldera
		- Open source stream-processing engine built in Rust that supports built-in stateful and stateless data transformation operators in SQL


## Apache Flink

- Flink's DataStream API supports data transformation operators on an event stream
	- map
	- filter
	- keyBy
	- reduce
	- window

```python
stream.map(evt -> evt.value * 2)

stream.filter(evt -> evt.value > 10)

stream.keyBy(evt -> evt.pk)

stream.keyBy(evt -> evt.pk)
      .reduce((a, b) -> a + b);
      
stream.keyBy(evt ->evt.pk)
      .window(TumblingEventTimeWindows.of(Time.seconds(10)))
```

- Apache Flink also provides a Complex Event Processing (CEP) library that can be used to specify patterns as finite state machines that match specific event sequences

```python
Pattern<Transaction, ?> fraudPattern =
  Pattern.<Transaction>begin("chainAttack")
    .where(evt -> evt.amount > 50) // Only transactions > 50 dollars
    .timesOrMore(10)  // 10 or more times
    .within(Time.minutes(5));  // Within 5 minutes
PatternStream<Transaction> patternStream = 
  CEP.pattern(transactions, fraudPattern);
DataStream<String> alerts = patternStream
    .select((PatternSelectFunction<Transaction, String>) pattern -> {
        Transaction first = pattern.get("largeTx").get(0);
        return "Fraud detected on card: " + first.cardId;
    });
```

## Feldera

- Provides a SQL API that supports a variety of data transformation operations on an event stream
	- Map
	- Filter
	- Reduce
	- Partition
	- Windowing

```python
SELECT value * 2 AS transformed_value FROM stream

SELECT * FROM stream WHERE value > 10

SELECT key, value FROM stream PARTITION BY key

SELECT key, COUNT(*) AS count 
    FROM stream WINDOW TUMBLING (10 SECONDS) GROUP BY key
```

- Prevent unbounded stat growth, define state expiration policies using `RETAIN`

```python
SELECT key, COUNT(*) AS count FROM stream WINDOW TUMBLING (10 SECONDS)
    RETAIN 1 HOUR GROUP BY key;
```

- Process event with low latency and at high throughput
- Most streaming feature pipelines should push an SLO for the 95th or 99th percentile latency
# Windowed Aggregations

- Windows define start and end boundaries over an event stream
- Windowed aggregations help capture temporal patterns or trends
	- Predictive power to real-time ML systems

<img src="/images/Pasted image 20261110222056.png" alt="image" width="500">

- Unbounded event stream
	- Incoming events from one or more streaming data sources
- Window assigner
	- Window assigner extracts timestamps from events and then maps events to one or more window
- Window type, state retention policy, and watermakr
	- Define when a window is created and/or destroyed
- Trigger condition
	- Specifies when to evaluate the window
	- Trigger condition depends on the window type
	- Some window emits results only at the end of the window
- Evaluation function
	- Aggregation function that are computer over the window's events
- Sink
	- Destination feature group in the feature store

- Apache Flink supports session windows and global windows

<img src="/images/Pasted image 20261110222319.png" alt="image" width="500">

- Session window starts when a session begins and closes after a period of inactivity
- Global window is useful for computing global features
	- Trending products
	- Assigner places all relevant events into a single global window spanning the entire streaming job runtime
	- Window is created when the streaming job starts and closes when it end

## Rolling Aggregations

- Rolling aggregations create the freshest aggregated features in streaming feature pipelines
- Form of windowed aggregation, but without distinct, fixed dinwos
- Compute over a continuously moving time interval
- Window assigner
	- Extracts each event's `event_time` and maps it to one or more rolling windows
- Rolling aggregations are evaluated immediately
- Each arrival triggers a new aggregated value, making rolling aggregations row size preserving transformation
- Memory intensive
- Most streaming engines provide built-in aggregation functions to compute rolling aggregation

<img src="/images/Pasted image 20261110222722.png" alt="image" width="500">

- Incremental views reduce rolling aggregation complexity from linear time to constant time


## Time Window Aggregations

- A time window is a set of temporarily related, often contiguous, events
	- Window length
		- The time between a window's start and end
	- Window size
		- The numebr of events in the window's bucket
	- Window assigner
		- Maps events to windows based on whether the event's `event_time` falls between the window's start and end times

- Many windows can be open simultaneously for different interval
- Windows are continually created and closed

- Tumbling windows
	- A window that advances by a fixed size and does not overlap
- Hopping (or sliding) windows
	- A window that advances by a fixed interval called the hop size and can overlap with previous windows

<img src="/images/Pasted image 20261110223026.png" alt="image" width="500">


- Window's state retention policy defines how long the bucket containing the vents will be kept until it is closed
- Keep time window open for longer by defining a watermark on the window
	- Upper bound on how late an event's timestamp can be for it to be assigned to the time window
	- Window is triggered and closed when watermark has passed

- Watermark duration
	- Confident that no delayed events will arrive after the upper bound
	- Accept that late events arriving after the bound will be ignored

<img src="/images/Pasted image 20261110223223.png" alt="image" width="500">

- Do not drop late events if you need them to later create training data or for RAG
- Store all the raw events with event sourcing
- Create feature data from historical data
- Streaming feature pipeline compute the features on the late data, but only rite it to the offline store

## Choosing the Best Window Type for Aggregations

<img src="/images/Pasted image 20261110223411.png" alt="image" width="500">

- Tumbling windows
	- Slowly changing time windows with large data volumns
	- Can include late data
- Hopping windows

## Rolling Aggregations with Incremental Views

- Rolling aggregations can be implemented in Apache Flink with `OVER` aggregates
	- Partitioned over many workers
	- Do not scale well with increasing window size and increasing event throughput

<img src="/images/Pasted image 20261110223536.png" alt="image" width="500">

- Incremental view reuse the previously computer value and apply only the changes introduced by new or removed events
- Work performed is proportional to the input.output changes, not the window size
- Feldera support incremental view maintenance through it streaming engine DBSP
	- Z-sets
	- GEneralization of relational sets
	- Positive counts = insertions
	- Negative counts = deletion

- Z-sets to represent deltas, without storing the full state

- Rolling aggregation in Feldera
	- Choose the aggregation
		- Highest predictive power
		- Choose the key to group by
	- Select the window size and window type
	- Handle missing data

# Credit Card Fraud Streaming

- Insert in aggregations over credit card transaction

```python
CREATE TABLE credit_card_transactions ( 
    t_id BIGINT,
    ts TIMESTAMP,
    cc_num VARCHAR,
    merchant_id VARCHAR,
    amount DOUBLE,
    ip_addr VARCHAR,
    card_present BOOLEAN
) WITH (
    'connectors' = '[{transaction_source_config}]'
);

CREATE MATERIALIZED VIEW rolling_aggregates AS 
SELECT 
    t.cc_num, 
    t.ts AS event_time, 
    t.ip_addr,
    t.card_present,
    SUM(COALESCE(amount, 0)) OVER window_10_minute AS sum_10min,
    COUNT(amount) OVER window_10_minute AS count_10min,
    SUM(COALESCE(amount, 0)) OVER window_1_hour AS sum_1hour,
    COUNT(amount) OVER window_1_hour AS count_1hour,
    SUM(COALESCE(amount, 0)) OVER window_1_day AS sum_1day,
    COUNT(amount) OVER window_1_day AS count_1day,
    SUM(COALESCE(amount, 0)) OVER window_7_day AS sum_7day,
    COUNT(amount) OVER window_7_day AS count_7day
FROM
    credit_card_transactions AS t

WINDOW 
    window_10_minute AS (
        PARTITION BY cc_num
        ORDER BY ts
        RANGE BETWEEN INTERVAL '10' MINUTE PRECEDING AND CURRENT ROW
    ),
    window_1_hour AS (
        PARTITION BY cc_num
        ORDER BY ts
        RANGE BETWEEN INTERVAL '1' HOUR PRECEDING AND CURRENT ROW
    ),
    window_1_day AS (
        PARTITION BY cc_num
        ORDER BY ts
        RANGE BETWEEN INTERVAL '1' DAY PRECEDING AND CURRENT ROW
    ),
    window_7_day AS (
        PARTITION BY cc_num
        ORDER BY ts
        RANGE BETWEEN INTERVAL '7' DAY PRECEDING AND CURRENT ROW
    );
```

1) Create a transaction table that represents the event stream
2) Create a materialized view with original transaction events enriched with rolling aggregations
3) Define window lengths

- Chronon framework
	- Provides an alternative solution to reduce the computational overhead of computing rolling aggregations called tiled time window aggregation
	- Tiles partition a window of length N into M tiles, where M<<N, and compose aggregations using both the tiles with unaligned events at the start and end of the interval

## ASOF joins and Composition of Transformations

- Enrich event streams by joining event data with historical data from other data sources
- Add to transaction events the `status` of the credit card that performed the transaction
- Compose data transformation
	- Aggregation or filter using derived data
- Define a new `invalid_card` transformation as a materialized view that filters for transaction from cards marked as `active`

```python
CREATE TABLE card_details (
    cc_num VARCHAR NOT NULL,
    cc_expiry_date TIMESTAMP,
    account_id VARCHAR NOT NULL,
    bank_id VARCHAR NOT NULL,
    issue_date TIMESTAMP,
    card_type VARCHAR,
    status VARCHAR,
    last_modified TIMESTAMP
) WITH (
    'connectors' = '[{card_details_source_config}]'
);

CREATE MATERIALIZED VIEW invalid_card_transaction AS
SELECT
    t.cc_num,
    t.ts AS event_time,
    (cd.status != 'active') AS invalid_card
FROM credit_card_transactions AS t
LEFT ASOF JOIN card_details AS cd
    MATCH_CONDITION (t.ts >= cd.last_modified)
    ON t.cc_num = cd.cc_num
;
```

- Compose data transformations using nested view

```SQL
CREATE MATERIALIZED VIEW invalid_card_transaction_count AS
SELECT
    cc_num,
    SUM(CASE WHEN invalid_card THEN 1 ELSE 0 END)
        OVER window_1_day AS invalid_1day
FROM
    invalid_card_transaction
WINDOW
    window_1_day AS (
PARTITION BY cc_num 
ORDER BY event_time RANGE BETWEEN
      INTERVAL '1' DAY PRECEDING AND CURRENT ROW
    );
```

## Lagged Features and Feature Pipelines in Feldera

- `LAG` operator
	- Use to efficiently compute lagged features as a stateful data transformation
	- Create two intermediate materialized view, and then join to produce the final features for our feature group

```SQL
def build_last_tr_sql(transaction_src_config: str, fs_sink_config: str) -> str:
    return f"""

--Point-in-time correct join of rolling_aggregates view with card_details table
CREATE MATERIALIZED VIEW cc_trans_card AS
SELECT
    ra.*,
    cd.account_id,
    cd.bank_id
FROM rolling_aggregates AS ra
LEFT ASOF JOIN card_details AS cd
    MATCH_CONDITION (ra.event_time >= cd.last_modified)
    ON ra.cc_num = cd.cc_num
;

-- Compute lagged features for transactions
CREATE LOCAL VIEW lagged_trans AS
SELECT
    ctc.*,
    LAG(event_time) OVER 
      (PARTITION BY cc_num ORDER BY event_time ASC) AS prev_ts_transaction,
    LAG(ip_addr) OVER 
      (PARTITION BY cc_num ORDER BY event_time ASC) AS prev_ip_transaction,
    LAG(card_present) OVER 
      (PARTITION BY cc_num ORDER BY event_time ASC) AS prev_card_present
FROM cc_trans_card AS ctc;
    
-- Write the final features to the feature group sink
CREATE VIEW cc_trans_aggs_fg
WITH (
    'connectors' = '[{fs_sink_config}]'
) 
AS 
    SELECT 
        cc_num,
        event_time,
        account_id,
        bank_id,
        sum_10min,
        count_10min,
        sum_1hour,
        count_1hour,
        sum_1day,
        count_1day,
        sum_7day,
        count_7day,
        prev_ts_transaction, 
        prev_ip_transaction,
        prev_card_present
    FROM lagged_trans;
"""
```

- Define the input data sources and plug them together to run a Feldera pipeline

```python
transaction_src_config = # Apache Kafka Topic
card_details_src_config = # card_details table in data mart
fs_sink_config = # Hopsworks Feature Group output
last_tr_sql = build_last_tr_sql(transaction_src_config, fs_sink_config)
last_tr_pipeline = PipelineBuilder(client, name = \
    "hopsworks_delta_kafka_last_tr", sql = last_tr_sql).create_or_replace()
last_tr_pipeline.start()
```

