
- Back-chaining
	- Treated as uninterpreted symbolic structures
	- Operate on them without having to know in advance what they mean
# Atomic and conditional sentences

- Atomic sentences
	- Simple basic sentences whose exact form is left unspecified for for now
	- Conditional sentences
		- P and then Q, where P and Q are atomic sentences

# Logical entailment

- Procedure will receive an atomic sentence $Q$ (query) as input, and have to determine if the query is logically entailed by the KB
- Logically entailed
	- If it cannot help but be true if all sentences in the KB are true

_Back-chaining procedure_

- Establish a sentence Q

1) Locate Q in the KB
2) Otherwise, locate in conditional sentences in the KB
3) Otherwise, use back-chaining to try to establish a conditional statement
4) Otherwise go back to step 2 and look for another conditional

# Back-chaining

- Back chaining
	- Asked to establish the query
	- Output is success of failure
	- Leaves the KB unchanged
	- Chains backward from a query to the atomic sentences in the KB
	- Recursive procedure

## Using variables

## Tracing the back chaining

```prolog
Q - george is a father of sue

a) Fail in KB
b) Match on condition with If X is a child of Y and Y is male then Y is a father of X with Y = george and X = sue
	"X is a child of Y"
	Establish sue is a child of george
	a) Success in KB
	"Y is male"
	Establish george is mail
	a) Success in KB
Success that george isa father of sue
```

# Variables in queries

- Sue is a child of gina
	- Asks if the sentence is logically entailed by the KB
	- Yes or no answer
- X is a child of gina
	- Asks what value of X is the sentence logically entailed by the KB
	- Variable declaration answer

## One complication: Renaming variables

- The variables in the sentences of the KB will be renamed to ensure that they differ from the ones in the query
## Another complication: Back tracing

- It is possible that one answer is found, but that later in the back-chaining procedure, the answer leads to failure
- Back tracking
	- Go back to where the answer was found, and find another answer
- Procedure search the KB for the matching atomic or condition sentences, from top to bottom and left to right
## A more complex query

- Variables are introduced for subqueries along the way

# Why is back-chaining good?

- Back chaining
	- Defined for KB consisting of atomic and conditional sentences
- Forward chaining
- Other sentence types
	- Negation
	- Disjunction
- Positives of back chaining
	- Goal directed
	- Logically sound
	- Logically complete, unless stuck in a look
		- Sufficient

## Getting stuck in a loop?

- Logical interpretation
- Proof theory
- Model theory
- 