### 0:00–0:20 — Introduction and Variables

**[Show the top of your Python program.]**

For Question 3, I implemented a simplified MapReduce program in Python.

My student number gives me A equals zero and B equals five. The HOODS list contains five Toronto neighbourhoods, which are used to group the trips.

The goal is to identify trips lasting at least 30 minutes, count them by neighbourhood, and calculate their total fares.

### 0:20–0:55 — Generating the Trips

**[Highlight** `**make_trips()**`**.]**

The `make_trips()` function generates one million simulated trips using a loop from zero to 999,999.

For each trip, the neighbourhood is selected using the trip ID modulo five, which cycles through the five neighbourhoods.

The fare is calculated using the trip ID, a formula involving A, and modulo 7,400. The duration uses a similar formula involving B and modulo 3,480.

Modulo gives the remainder after division, which keeps these values within their specified ranges.

Each trip is stored as a tuple containing the trip ID, neighbourhood, fare in cents, and duration in seconds.

### 0:55–1:25 — Map Step

**[Highlight** `**map_step()**`**.]**

The map function receives one trip and unpacks its four values.

It checks whether the duration is at least 1,800 seconds, which is 30 minutes.

If the trip qualifies, it returns a list containing a neighbourhood and fare pair. Otherwise, it returns an empty list.

This filters out shorter trips and creates the key-value pairs needed for aggregation.

### 1:25–1:55 — Shuffle Step

**[Highlight** `**shuffle_step()**`**.]**

The shuffle function creates three empty reducer lists.

For each pair, it finds the neighbourhood's index in HOODS and calculates that index modulo three to select the reducer.

Downtown and North York go to reducer zero, Scarborough and East York go to reducer one, and Etobicoke goes to reducer two.

In a real distributed cluster, the shuffle step transfers intermediate data between machines so that records with the same neighbourhood reach the same reducer.

### 1:55–2:25 — Reduce Step

**[Highlight** `**reduce_step()**`**.]**

The reduce function receives the pairs assigned to one reducer.

It creates a dictionary called `totals`. If a neighbourhood has not been encountered, it initializes its count and fare total to zero.

For each pair, the function increases the trip count by one and adds the fare to the running total.

It returns a dictionary containing the number of long trips and total fare in cents for each neighbourhood.

### 2:25–2:50 — Main Program

**[Highlight the final section of the code.]**

The main program creates an empty list called `pairs`.

It loops through the million generated trips and extends the list with the output of the map function.

Next, it passes those pairs to the shuffle function, which divides them among the three reducers.

Finally, it loops through each reducer, calls the reduce function, and prints the results.

The fare totals are divided by 100 to convert cents into dollars.

### 2:50–3:20 — Run and Explain the Output

**[Run your program and show the terminal.]**

Running the program with my values gives 206,895 pairs for reducer zero, 206,895 for reducer one, and 103,446 for reducer two.

For example, Downtown has 103,449 long trips and approximately 4.35 million dollars in total fares.

Reducer two receives fewer pairs because it handles only Etobicoke, while the other two reducers each handle two neighbourhoods.

This creates a workload imbalance. Reducer two may finish earlier, but the job must wait for the slowest reducer before completing.

### 3:20–3:30 — Conclusion

**[Keep the output visible.]**

Overall, mapping filters the trips, shuffling distributes them by neighbourhood, and reducing calculates the totals.

This demonstrates the main stages of MapReduce and how data can be processed across multiple machines.