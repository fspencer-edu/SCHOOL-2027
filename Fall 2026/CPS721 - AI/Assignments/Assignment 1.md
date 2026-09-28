# Part 1 -  Knowledge Base

## a) KB

- q1a_trip_kb.pl
- Add knowledge base in the q1_kb section
- Include at least 10 statements for each of `flight, hasRomm, and ticket`

```prolog
flight(City1, city2, Date, Price)

hasRoom(Name, City, Data, Price)

ticket(Name, City, Data, Price)
```

- No flights from a city to itself
- Hotels with the same names in different cities
- Only one `hasRomm` statement for any combinations
- There is only one type of room for each hotel
	- Price of a room may different data to data
- On ticket price for any attraction on any one day
	- Price can differ data to day
- All dates for are in October
	- 1-31
	- All prices as positive integers


## b) Queries

- Create queries for each of the 12 statements and add then to the file q1b_queries.pl

1. What is the price of the flight from Toronto to quebec city on oct 9
2. Does the sheraton in halifax have availability on October 4
3. Find an attraction in calgary that has tickets available for it on October 18
4. On what date can you get opera tickets in vancouver for less than 75


# Part 2 - Arithmetic
## a) KB

- Calculate the bill at an e-store on three products
	- `laptop, monitor, keyboard`

```prolog
cost(Product, Count)
numPurchased(Product, Count)
shippingCost(Product, Cost)
expressSheippingRate(Rate)
taxRate(Rate)
freeRegularShippingMin(Amount)
freeExpressShippingMin(Amount)
```

## b) CALC

```prolog
subtotal(Sub)

costWithShipping(ShippingType, Cost)

totalCost(ShippingType, Cost)
```


## c) LOG


# Part 3 - Recursive

## a) KB

- recursive program to calculate the cost of staying at a hotel for a given amount of time
- All trip planning os in october, 1-31
- Hotel will have rooms on all days
- Assume that in any query, checn in and check out will be given as non negative integers
- Variable queries for `Hotel, City, Cost = H, L, C`

```prolog
stayCost(Hotel, City, CheckinDate, CheckoutDate, Cost)
```
## b) CALC

- Recursive program to find possible round trips and the cost of those round trips
- Write a program to find possible multi-city round trips and their costs

```prolog
roundTrip(City, Start, End, NumFlights, Cost)
```
## c) QUERIES and LOG
