- Constraint satisfaction problems
	- Trial and error

# Constraint satisfaction problems

## Generate-and-test

- Generate and test
	- A value is generated fro a variable and then tested to see if the value is the desired one
	- If correct, then success
	- If not, backtracks and generated another value

_Map Colouring_

<img src="/images/Pasted image 20260925113242.png" alt="image" width="500">

```prolog
solution(A,B,C,D,E)
A = red, B = white, C = blue, D = white, E = blue
```
## Variables, domains, constraints

- Constraint satisfaction problem
	- Variables for which values are to be found
	- Each variable gets a value from some finite domain of value
	- Constraints to be satisfied among subset of the variables
	- Solution
		- An assignment of value to each variable such that all the constraints are satisfied
## Output in Prolog

- Prolog displays values for all the variables
- `write(term)`
	- Always succeed
	- Printing the value of the term
- `n1`
	- No argument is considered to always succeed
	- Going to a new line
# A first example: Sudoku

<img src="/images/Pasted image 20260925113659.png" alt="image" width="500">

## The anonymous variable in Prolog

- Anonymous variable
	- Underscore characters are used as a variable in those cases where the goal i not finding the value of the variables but ensuring that there is one
	- Each occurrence of the anonymous variable can be for a different value
- User provides a partial solution to find a complete solution

## Sudoku as constraint satisfaction

<img src="/images/Pasted image 20260925120204.png" alt="image" width="500">

- Negation needs its arguments to be instantiated

## Search spaces

- Search space is the collection of all the different ways the variables of a problem can be assigned values from the domain before taking the constraints into account

## Guessed values and forced values

<img src="/images/Pasted image 20260925120523.png" alt="image" width="500">

# A second example: Crypt-arithmetic
## Arithmetic in Prolog

- Prolog term is either a constant, variable or number
	- Number is a sequence of one or more digits optionally preceded by a minus sign and containing a decimal point
- Arithmetic relations
	- Less than, <
	- Greater than, >
	- Less than or equal, =<
	- Greater than or equal, >=
	- Equal, =:=, is
- Arithmetic expressions
	- Addition, +
	- Subtraction, -
	- Multiplication, *
	- Division, /
	- Exponentiation, **

- Requires variables to be instantiated before
- Using the `is` relation
	- Getting the value of an arithmetic expression to use with another predicate

_Arithm_

## Crypt-arithmetic as constraint satisfaction

## Minimizing the guesswork: Two rules

# A third example: The eight queens

# A fourth example: Logic problem

## Hidden variables
## A more complex logic problem
# A fifth example: Scheduling
