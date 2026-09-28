
**Euclid's Method in Prolog**

- Define `myGCD(X, Y, G)` to handle the if, and use helper for rest

```prolog
myGCD(X, Y, G) :- X > Y, gcdHelp(X, Y, G).
myGCD(X, Y', G) :- X >= Y', gcdHelp(Y', X, G).
gcdHelp(G, O, G).
gcdHelp(G, O, G) :- Y > O, N is X mod Y, gdcHelp(Y, N, G).
```


---
# Part 1 - Intro. to Lists


- Often working on a collection of objects
	- A list is an ordered collection
- Heads and Tails

```prolog
[a, b, c, d]
head => a
tail => [b, c, d]

[a]
head => a
tail => []

[]
No head or tail
```

- Matching
	- To use this notation, must match different terms
- Matching lists
	- Lists match as follows
		- When identical, element by element
		- If one or more lists have variables, when the variables can be given values that make the lists identical, element for element

```prolog
% Matching pairs
[] = []
[a, b, c] = [a, b, c]
[X] and [a] with X = a
[X] and [Y] with X = _978 and Y = _978

% Non matching pairs
[a] and []
[a, b, c] = [a, a, c]
[X, Y] and [U, V, W]
[] and [[]]

```

- List representations

```prolog
[a, b, c, d]
[a, | [b, c, d]]
[a, b | [c, d]]
```

- Head and tail
	- For list iteration
- Matching lists with head tail notation

- Computing with lists
	- Predicate `head(X, Y)`
	- Hold if Y is non-empty list and X is its first element
	- Y must have at least one element, and first element must be X

```prolog
head(X, [X|Z])
head(X, Y) :- Y = [X|Z].
```

- `tail(X, Y)` so that X is the tail of Y

```prolog
tail(X, [Z|X])
tail(X, Y) :- Y = [Z|X].
```

- Another predicate
	- `atLeast3Elements(X)` should hold if X is a list with at least 3 elements
	- Yes for `X = [a, b, c] or X = [[], [b, c], Z, Q]`
	- No for `X = [a, b]`

```prolog
atLeast3Elements([X, Y, Z|T]).
```

# Part 2 - Recursion on Lists

- Recursion on Lists
	- List operations are often naturally done recursively
	- Every sub list is an ordered collection
- List membership
	- `member(E, L)` holds if E is an element of the list

```prolog
Q1 - member(a, [b, c, a, d])

Match on 2 with, E = a, H = b, T = [c, a, d]
member(a, [(c, a, d)])

Mtch on 2 with E = C, H = c, T = [a, d]
member(a, [(a, d)])

Sucess, with E = a, H = a 
```

```
Q2 - member(q, [b, c, a, d])

Match on 2 with, E = q, H = b, T = [c, a, d]
member(q, [c, a, d])

Match on 2 with, E = q, H = c, T = [a, d]
member(q, [a, b])

Match on 2 with, E = q, H = a, T = [d]
member(q, [d])

match on 2 with, E = q, H = d, T = []
member(q, [])
Fail

```


```
Q3 - member(X, [a, b, c])

Match on 2 with X = a, T = [b, c]
Sucess with X = a

member(X, [b, c])
Match on 2 with X = b, T = [c]
Sucess with X = b

member(X, [c])
Match on 2 with X = c, T = []
Sucess with X = c
```

- Appending two lists
	- `append(L1, L2, L)` holds when L is the result of joining L1 and L2

```prolog
append([a, b], [c, d, e], [a, b, c, d, e])
append([], [a, b], [a, b])
append([a, b], [], [a, b])
append([], [], [])
```

- Implementing Append


Base case

append([], L, L).

Recursive Call

append(L1, L2, L) : - append


```prolog
append([a, b], [c, d, e], L)

Match on 2, with H = a, L1 = [b], L2 = [c, d, e], L = [a|L3]
append([b], [c, d, e], L3)

Match on 2, with H = b, L1 = [], L2 = [c, d, e], L = [b|L4]
append([], [c, d, e], L4)

Success on 1, with L4 = [c, d, e]

L3 = [b|L4] = [b, c, d, e]
L = [a|L3] = [a, b, c, d, e]
```

- Queries with Append
- Defining last using append
- Defining prefix using append
- Defining member using append

Example `replaceFirst`
Example `replaceAll`
Example `Length`

