
# Part 1 - Prolog Basics

-  PROLOG (PROgramming in LOGic)
	- Declarative, non-imperative programming language
	- Context means logical deduction
	- Constraint based reasoning
	- Alain Colmerauer and Philippe Roussel
		- Based on NLP
- ECLiPSe PROLOG
	- Owned by Cisco

- Knowledge based
- Atomic statements
	- Constant
	- Predicate
		- Relationships between entities
		- $predName(arg_1, arg_2, ..., arg_n$)
- Predicates and constants = lowercase
- Atoms end with a period

```prolog
hasAccount (jennifer).
student (jennifer).
connected (tony, jennifer).
worksAt (jennifer, google, 2020).
```

Knowledge Base

```prolog
1) hasAccount(tony)
2) hasAccount(sam)
3) hasAccount(jennifer)
4) hasAccount(leon)
   
5) connected(tony, sam)
6) connected(tony, jennifer)
7) connected(tony, leon)
8) connected(tony, henry)
   
9) student(jennifer)
10) student(henry)
```

Find - connected(tony, X), student(X)

- Match on (5), $x =$ sam
	- student(sam) is false
- Match on (6), with $X =$ jennifer
	- student(jennifer) is true
	- match on (9), with $X =$ jennifer
- Match on (7), $x =$ leon
	- student(leon) is false
- Match on (8), $x =$ henry
	- student(henry) is true
	- match on (10), with $X =$ henry

- Stores a list of statements in a ".pl" file
	- Use % for comments
	- Symmetry is not assumed
	- Check atomic statements from left to right
		- Only succeeds if all succeed
		- Uses lazy evaluation
- Negation in prolog

`not (student(jennifer, student(tony))`

- Queries with variables perform retrieval
	- Uppercase or underscore for variables

- Example queries

**Is there a student who is connected to Tony?**

?-connected(tony, X), student(X)

**Is Tony connected to someone who is connected to a student?**

?-connected(tony, X), connected (X, Y), student(Y)


- Equality predicate

```prolog
Q - Is Tony connected to two people?

connected(tony, X), connected(tony, Y), not X = Y
```

- Prolog does not check for equivalent answers
- Equality in Prolog means unification
	- Tries to make both sides the same as generally as possible
	- Inefficient when unnecessary
	- String matching
- Negation over multiple statements

`hasAccount(X), not (connected(tony, X), student(X))`

- X = jennifer

not (connected(tony, jennifer), student(jennifer))
connected(tony, jennifer)
not (A and B) $\equiv$ not A or not B

- Jennifer is not connected to tony, and is not a student
not (connected(tony, X), student(X))
not (connected(tony, jennifer), student(jennifer))
- not(success) = fail
(connected(tony, jennifer), student(jennifer))
- success, success
- 
# Part 2 - Rules and Deductive Databases

- Conditional sentences

`If (X is a car) and (X is electric) then (X is an ev)`

- Use general rules or clauses

`ev(x) := car(X), electric (X)`

- Clauses
	- `a := b1, ..., bn`
	- Head must be an atom (cannot use not)
	- Each $b_i$ in the body is an atom or negation of an atom
	- Read as
		- $a$ if $b_1$ and ... and $b_n$

`:-` means if
`,` means if and

- Unit clases
	- Also call atoms like `car(tesla123` as a unit clauses
		- A unit clauses has its head and an empty body
		- `a.`
	- Prolog programs are just sequences of clauses

```prolog
hasAccount(jennifer).
hasAccount(tony).
hasAccount(tim).
hasAccount(michelle).
hasAccount(sam).

connected(jennifer, tony).
connected(tony, jennifer).
connected(tony, tim).
connected(tim, tony).

student(jennifer).
student(sam).
student(michelle).

worksAt(jennifer, google, 2020).
worksAt(tony, bell, 2015).
worksAt(tim, apple, 2022).

degree2Connection(X, Y) :- connected(X, Z), connected(Z, Y), not X = Y.
connectionAtCompany(P1, P2, C) :- connected(P1, P2), worksAt(P2, C, Y).
connectionAtCompany(P1, P2, C) :- degree2Connection(P1, P2), worksAt(P2, C, Y).
```

- Two statements is an OR

 - Querying a general program
	 - Full back chaining

Q1 - **connectionAtCompany(jennifer, P2, bell)**

- Match on (17) with connectionAtCompany(P1, P2, C) :- connected(P1, P2), worksAt(P2, C, Y) with P1 = jennifer, P2 = P2, C = bell
	 "connected(jennifer, P2)" and  "worksAt(P2, bell, Y)"
	 "connected(jennifer, P2)"
	- Match on (6) with P2 = tony
	- "worksAt(P2, bell, Y)"
	- Match on (14) with Y = 2014
	- Success with P2 = tony

Q2 - **connectionAtCompany(jennifer, P2, apple)**

- Match on (17) with P1 = jennifer, P2 = P2, C = apple
	"connected(jennifer, P2)" and  "worksAt(P2, apple, Y)"
	"connected(jennifer, P2)"
	- Match on (6) with P2 = tony
	"worksAt(P2, apple, Y)"
	- Match on (14) with Y = 2014
	- Failed with C = bell
	"connected(jennifer, P2)"
	- Failed
- Match on (18) with P1 = jennifer, P2 = P2, C = apple
	"degree2Connection(jennifer, P2)" and  "worksAt(P2, apple, Y)"
	"degree2Connection(jennifer, P2)"
	- Match on (16) with X = Jennifer, Y = P2
		"connected(jennifer, Z)" and "connected(Z, Y)" and "not jennifer = P2"
		"connected(jennifer, Z)"
		- Match on (6) with Z = tony
		"connected(Z, Y)"
		- Match on (8) with Z = tony, Y = tim
		"not jennifer = P2"
		- Match on (7) with P2 = Jennifer
			- Fail on not jennfier = jennifer
		- Match on (8) with P2 = tim
			- Success on not jennfier = tim
	"worksAt(tim, apple, Y)"
	- Match on (15) with Y = 2022
- Success with P2 = tim

```prolog
hasAccount(jennifer).
hasAccount(tony).
hasAccount(tim).
hasAccount(michelle).
hasAccount(sam).

student(jennfier).
student(sam).
student(michelle).

worksAt(jennifer, google, 2020).
worksAt(tony, bell, 2015).
worksAt(tim, apple, 2022).

unemployed(X) :- hasAccount(X), not student(X), not worksAt(X, Y, D)
```


- Blocks world
	- Deductions
		- Block 3 is above block 6
		- Block 1 is left of block 7
		- Block 4 is right of block 2

```prolog
on(b1, b2).
on(b3, b4).
on(b4, b5).
on(b5, b6).

onTable(b2)
onTable(b6)
onTable(b7)
```

- Recursion to implement above
- Show b3 is above b6, and b4
- b4 is above b6

```prolog
above(X, Y) :- on(X, Y). % base case
above(X, Y) :- on(X, Y), above(Z, Y). 
```

- Evaluate **above(b3, b6)**

- Match on (4) with X = b3, Y = b6
	"on(b3, b6)"
	- Fail
- Match on (5)


- Left in the blocks world
	- `onTable(X)` is not enough to know relative position of towers
	- `justLeft(X, Y`
		- X and Y are on the table and X is immediately left of Y

```prolog
justLeft(b2, b6).
justLeft(b6, b7).
```


- Full blocks world

```prolog
on(b1, b2).
on(b3, b4).
on(b4, b5).
on(b5, b6).

justLeft(b2, b6).
justLeft(b6, b7).

above(X, Y) :- on(X, Y).
above(X, Y) :- on(X, Y), above(Z, Y). 

left(X, Y) :- justLeft(X, Y).
left(X, Y) :- justLeft(X, Y), left(Z, Y).
left(X, Y) :- above(X, Y), left(Z, Y).
left(X, Y) :- above(X, Y), left(Y, Z).
```

- Evaluate **left(b1, b5)**


- Renaming variables
	- Rename variables to avoid collisions
	- Prolog does not automatically by storing clauses with internal variables that are different than any other program clause or query

- Evaluate **right(b7, b2)**





# Part 3 - Recursion in Prolog



---

- Creating queries

```prolog
hasAccount(Name)
connected(Name1, Name2)
student(Name)
worksAt(Person, Company, Year)
```

Q1 - **Find someone who works at the same company as tom**

worksAt(tom, C, Y), worksAt(P, C, Z), not P = tom


Q2 - **Find a student who works at the same company as tome, but started after tom**

worksAt(tom, C, Y), worksAt(P, C, Y1), student(P), Y > Y1, not P = tom



