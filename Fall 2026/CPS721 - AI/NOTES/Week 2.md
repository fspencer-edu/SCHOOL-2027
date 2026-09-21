
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
	"connected(jennifer, P2)"

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



