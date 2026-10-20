- Meeting schedule
	- 5 hours for meetings for the coming week
	- Only one conference room is available, but already partially booked
	- Conference room is booked in one hour from 9-5

- Variables and domains

M1, M2, M3, M4, M5
- Meeting data and time

meet(D, H)
- Day and hour

- Room Booked Constraint

```prolog
taken([X, 12])
taken([wed, X])
taken([fri, X])

taken([mon, 9])
taken([mon, 10])
taken([mon, 2])
taken([mon, 3])
taken([mon, 4])

taken([tues, 9])
taken([tues, 10])
taken([tues, 11])
taken([tues, 3])
taken([tues, 4])

taken([thurs, 8])
taken([thurs, 10])
```

- Constraints
	- Cannot select already booed times

_No more than 2 hours a day_

```prolog
not threeOnOneDay([M1, M2, M3, M4, M5])


threeOnOneDay(L) :- member([D, H], L), member([D, H2], L), member([D, H3], L), not H1 = H2, not H1 = H3, not H2 = H3
```

_Non consecutive hours only_

```prolog
twoConsHours(L) :- member([D, H1], L), member([D, H2], L), H2 is H1 + 1
```

- Scheduling in Prolog

```prolog
roomTime([D, H]) :- member(D, [mon, tues, wed, thurs, fri]), member(H, [9, 10, 11, 12, 13, 14])

solve([T1, T2, T3, T4, T5]) :-
	roomTime(T1), roomTime(T1), roomTime(T2), roomTime(T3), roomTime(T4), not taken(T5),
	not taken(T1), not taken(T2), not taken(T3), not taken(T4), not taken(T5),
	not twoConsHours([T1, T2, T3, T4, T5]),
	not threeOnOneDay([T1, T2, T3, T4, T5]),
	allDiff([T1, T2, T3, T4, T5])
```

- Improve
	- Move `allDiff` before `not twoConsHours()`

# The Wedding Puzzle

- Two groups of spouses
	- Group 1
		- Adam, Cathy, Eve, Fran, Ida
	- Group 2
		- Patricia, Rob, Sally, Verm, Wally

- Each couple was married on a different weekday
- Adam was married on Monday, but not will Wally
- Sally's weddings was on Wednesday
- Rob was marred on Friday, but not with Ida
- Verm (married Fram), was married the day after Eve

- Everyone is married to a unique person

- Variables and domains

```prolog
W = [P1, P2]

marriage(P1, P2, D)

A C E F I ->  <- P R S V W
		    \/
mon tues wed thurs fri

day(1), day(2), day(3), day(4), day(5)

A = 1
S = 3
R = 5
```

```prolog
solve([A, C, e, F, I, P, R, S, V, W]) :-
	A = 1, S = 3, R = 5,
	day(W), not W = A,
	day(I), not R = I,
	day(V), day(E), V is E + 1, day(F), V = F,
	day(c), day(P),
	allDiff([A, C, E, F, I]), allDiff([P, R, S, V, W])
```

- A, S, R, W, I, V, E, F are set
- C and P are not set

```prolog
allDiff([A, C, E, F, I]), allDiff([P, R, S, V, W])
```

- `day(E), V is E + 1, day(V)`

# Wages Puzzle

- Ann, Bob, Cindy, Daniel, Eve
	- Weekly salary is either 100, 200, 300, 400, 500
- Bob's wage s different than both Cindy and Eve
- Cindy earns less than Daniel and Eve
- Ann earns less than Eve and Bob
- Ann's wage is different than both Daniel and Cindy
- Daniel earns more than Eve and Bob

Variables and domains

```prolog
A, B, C, D, E for each person
wage(100) wage(200) wage(300) wage(400) wage(500)

solve([A, B, C, D, E]) :-
	wage(B), wage(C), not B = C, wage(E), not E = B,
	wage(D), C < E, C < D,
	wage(A), A < E, A < B,
	not A = D, not A = C,
	D > E, D > B.
```

# Quiz Puzzle

- True/False quiz
- Cindy got more marks than Ann
- David got more marks than Bob
- Edward did not get a perfect score or 0

```prolog
A1, A2, A3, A4, A5
t or f
ans(t) ans(f)

score(SA, CA, M)
[t, t, f, t, f]
[A1, A2, A3, A4, A5]
```

- Compute grades

```prolog
score([], [], 0).
score([H|T2], [H|T1], S) :- score(T1, T2, score2), S is score2 + 1.
score([H1|T1], [H2|T2], S) :- not H1 = H2, score(T1, T2, S).

solve([A1, A2, A3, A4, A5]) :-
	ans(A1), ans(A2), ans(A3), ans(A4), ans(A5),
	score([t,t,f,t,f], [A1, A2, A3, A4, A5], SA),
	score([f,t,t,t,f], [A1, A2, A3, A4, A5], SB),
	score([t,f,t,t,f], [A1, A2, A3, A4, A5], SC),
	score([f,t,t,f,t], [A1, A2, A3, A4, A5], SD),
	score([t,f,t,f,t], [A1, A2, A3, A4, A5], SE),
	SC > SA, SD > SB, not SE = 0, not SE = 5.
```

# The Restaurant

- John ate at the same restaurant for 5 days straight
- First and second course

1. Drank coffee after mil, and tea the day after he drank coffee
2. Duck for the second course on both Tues and Wed
3. John's first course on Tues was chow mein
4. John drake water the day after he drank tea, and juice on friday
5. No egg rolls on monday or thursday, and had egg rolls at least twice
6. Sour soup ordered as the first course, never the second

```prolog
M T W R F
1 2 3 4 5

M1 T1 W1 R1 F1
M2 T2 W2 R2 F2

tea, coffee, milk, juice, water
day(1), day(2), day(3), day(4), day(5)

food(duck), food(cm), food(egg), food(soup), food(rice)


solve([T, C, M, J, W, M1, M2, T1, T2, W1, W2, R1, R2, F1, F2]) :-
	day(C), day(M), C > M, T is C + 1, day(T), %1
	T2 = Duck, W2 = duck, %2
	T1 = cm, %3
	J = 5, W is T + 1, day(W) %4
	food(M1), not M1 = er, food(M2), not M2 = er, food(R1), not R1 = er, food(R2), not R2 = er, food(W1), food(W2), food(F1), food(F2),
	count([T1, T2, W1, W2, F1, F1], er, Z), Z > = 2, %5
	count([M1, T1, W1, R1, F1], soup, Z1), Z1 >= 1, count([M2, T2, W2, T2, F2], soup, Z2), Z2 = 0, %6
	allDiff([T, C, M, J, W]).
```

- Move setting values to the top
- All food, then all drink
	- Do not backtrack over food and drink since separate
- Move all diff before food, to check drinks