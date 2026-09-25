
- Queries will direct a computer to perform back-chaining
- Prolog
	- Programming in Logic
	- Language for writing programs developed by Alain Commerauer
	- Extremely strict

# Prolog programs

- Knowledge bases of atomic and conditional sentences

_Constants_

- Start with a lowercase letter
- Can be followed by any number of letters, underscores, or digit
- A constant may be a quoted string

_Variables_

- A variable must start with an uppercase letter
- Can be followed by any number of letters, underscores, or digits

_Atomic sentences_

- predicate(arg1, ... argk)
- The predicate is a Prolog constant and the subsequent arguments are either constants or variables
- When a predicate has no arguments, the parentheses can be left out

_Conditional sentences_

- head :- body1, ..., bodyn
- Head of each element of the body is a atom
- When the body is empty, the :- should be omitted
- Program
	- A sequence of clauses
- Clause
	- An atomic or conditional sentence terminated by a period
- Comment
	- Start with % and continues to the end of line

# Prolog queries

- Runing a Prolog program
	- Prepare a file containing the Prolog program
	- Start the Prolog system, and load the file
	- Repeadedly
		- Post a query to the system
		- Wait for answer
	- Exit the system
## Queries and their outcomes

- Query
	- An atom with or without variables
	- Terminated with a period
- Query with no variables
	- Yes
	- No
	- Does not answer
- Query with variables
	- No
	- Does not answer
	- Prolog displays values for the variables for which it can establish the query
	- Using a semicolon, Prolog tries to find new values from the variables

## Conjunctive queries

- Conjunctive queries
	- Sequences of atoms separated by commas and terminated by a period
	- Asked to establish all the atoms in a single query
	- The user seeks the same person for btoh atoms

## Negation in queries

- Negated queries
	- `\+`
- Used in front of an atom in a query to flip a yes to a no
## Tracing the back chaining

Trace
- Call
	- Prolog starts to work on an atomic query
- Fail
	- Atomic query has failed and looks for alternatives
- Exit
	- Atomic query has tentatively succeeded, pending the renaming conjunctive query
- Redo
	- Prolog has gone back to a choice point to reconsider an atomic query

## Instantiated and uninstantiated variables

```prolog
\+ female(X), parent(X,john).
```

- If fails on the first atom, it does not go on to the second atom
- Variables X is instantiated when the negated portion of the query is handled
- Variable X is instantiated before the negation step
- When variables appear in a negated query, make sure that they are already instantiated at an early stage of the back-chaining
- Use another atom in a query before the negated part

## Equality in queries

- Equality queries
	- Two terms are either constants or variables
	- Succeed when the two terms can be made equal by instantiating any variables
- Term
	- Constant, variable, or number
- Literal
	- Possibly negated atom or equality
- Query
	- A sequence of one or more literals separated by commas and terminated with a period
- Clause
	- An atom followed by a period or by the :- symbol then a query
- Program
	- A sequence of one or more clauses
# Prolog back-chaining

## Unification

- Unification
	- Clauses in a program that are selected during back chaining through a matching process
	- Two atoms whose variables are distinct are said to unify if there is a substation of values for the variables that makes the atoms identical

## Renaming variables

- Prolog renames the variables in a query before attempting unification to ensure that there are not clashes

## Back chaining revisited

