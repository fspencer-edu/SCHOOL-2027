
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
- When the body is empty, the :- should be ommited
- Program
	- A sequence of clauses
- Clause
	- An atomic or condition


# Prolog queries

## Queries and their outcomes
## Conjunctive queries
## Negation in queries
## Tracing the back chaining
## Instantiated and uninstantiated variables
## Equality in queries
# Prolog back-chaining

## Unification
## Renaming variables
## Back chaining revisitied
