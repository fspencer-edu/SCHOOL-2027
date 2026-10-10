### 0:00–0:15 — Introduction

**[Show the top of your Python program.]**

For Question 3, I completed a Python program demonstrating MapReduce.

I used A equals zero and B equals five, based on my student number.

The goal was to process one million trips, find those lasting at least 30 minutes, and calculate the trip counts and total fares by neighbourhood.

### 0:15–0:35 — Generating the Trips

**[Highlight** `**make_trips()**`**.]**

The `make_trips()` function generated one million trips, using modulo five to cycle through the five neighbourhoods.

It calculated the fares and durations using formulas containing A and B, then stored each trip as a tuple with its ID, neighbourhood, fare in cents, and duration in seconds.

### 0:35–0:55 — Map Step

**[Highlight** `**map_step()**`**.]**

The map function separated each trip into four values: ID, neighbourhood, fare, and duration.

If the duration was at least 1,800 seconds, or 30 minutes, it returned the neighbourhood and fare as a pair. Otherwise, it returned an empty list.

This filtered out shorter trips.

### 0:55–1:15 — Shuffle Step

**[Highlight** `**shuffle_step()**`**.]**

The shuffle function created three reducer lists and assigned each pair using the neighbourhood's index modulo three.

Downtown and North York went to reducer zero, Scarborough and East York to reducer one, and Etobicoke to reducer two.

This kept trips from the same neighbourhood together.

### 1:15–1:35 — Reduce Step

**[Highlight** `**reduce_step()**`**.]**

The reduce function used a dictionary called `totals` to track each neighbourhood's long-trip count and total fare in cents.

It initialized the values to zero when needed, then added one to the count and added each fare to the total.

Finally, it returned the totals for each neighbourhood.

### 1:35–2:00 — Main Program and Results

**[Highlight the main program, then run it.]**

The main program passed the generated trips through map, distributed the pairs using shuffle, and reduced and printed the results.

It divided the total fares by 100 to convert cents into dollars.

When I ran the program, reducers zero and one each received 206,895 pairs, while reducer two received 103,446.

For example, Downtown had 103,449 trips lasting at least 30 minutes, with a combined fare of about 4.35 million dollars.

### 2:00–2:20 — Q3(a): Network Communication

**[Show** `**shuffle_step()**`**.]**

For part A, the shuffle step would transfer data between machines in a real cluster so that trips from the same neighbourhood reached the same reducer.

The map step could process trips locally, while the reduce step could process the pairs it had already received, without additional network transfers.

### 2:20–2:40 — Q3(b): Reducer Imbalance

**[Show the terminal output.]**

For part B, reducer two received fewer pairs because it only handled Etobicoke, while the other reducers each handled two neighbourhoods.

This meant reducer two could finish earlier, but the whole job would still have to wait for the slower reducers, increasing the overall processing time compared with an evenly distributed workload.