- PROLOG (PROgramming in LOGic)
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


```prolog

```


# Back chaining

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

