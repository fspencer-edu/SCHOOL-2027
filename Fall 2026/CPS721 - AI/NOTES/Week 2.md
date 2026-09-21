
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
not (A and B) $\equiv$ not A or not B
# Part 2 - Rules and Deductive Databases
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



