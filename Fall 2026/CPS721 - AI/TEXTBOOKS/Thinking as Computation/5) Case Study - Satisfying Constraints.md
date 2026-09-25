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

_Arithmetic programs_

```prolog
birth_year(donna, 1986).
birth_year(andy, 1987).
current_year(2012).

% Age of a perion P is the current year minus the birth year
age(P,X) :- birth_year(P,Y1), current_year(Y2), X is Y2-Y1.

age(andy,N).
N = 25
Yes
```

<img src="/images/Pasted image 20260925131759.png" alt="image" width="500">

## Crypt-arithmetic as constraint satisfaction

- Integer quotient, //
- Integer remainder, mod

## Minimizing the guesswork: Two rules

- If a value is fully determined by other values, then avoid guessing the value and later testing if it is correct

```prolog
uniq3(A,B,C) % guess at A,B,C
B is (A+C) mod 10 % then test if B is ok

instead

uniq2(A,C), % guess at A and C
B is (A+C) mod 10,
uniq(A,B,C)
```

- First version search space or 1000, second has a search space of 100

- Avoid placing independent guesses between the generation and the testing of other values

```prolog
dig(A), dig(B),
dig(C), dig(D),
A > B

instead

dig(A), dig(B),
A > B,
dig(C), dig(D),

```

- First case
	- Program guesses at values for C and D between the generating and the testing for A and B
- Better solution
	- Finishes the generate-and test for A and B before going on to C and D
- The end result of shuffling constraints is that the program will now run in under one-tenth of a second
# A third example: The eight queens

<img src="/images/Pasted image 20260925132436.png" alt="image" width="500">

- Constraint satisfaction
	- 8 variables
		- $C_i$ is the column for the queen that is placed in row i
		- Domain is 1 to 8 representing the columns
	- Different columns

<img src="/images/Pasted image 20260925132646.png" alt="image" width="500">

- Make sure that each queen has its own left and right diagonal
- A queen that is located on (row1, col1) can capture a queen that is located on (row2, col2) if and only if one of the following conditions hold
	- They are in the same row
		- $row_1 = row_2$
	- They are in the same column
		- $col_1 = col_2$
	- They are in the same left diagonal
		- $(row_1-col_1)=(row_2-col_2)$
	- They are in the same right diagonal
		- $(row_1+col_1)=(row_2+col_2)$

<img src="/images/Pasted image 20260925132911.png" alt="image" width="500">

- The negation of the cap predicate is used at each stage
- Find column in numeric order

# A fourth example: Logic problem

- Logic problem
	- A word problem involving several clues about the identities of individuals playing certain roles
- Determine variables, domain, and information that leads to constraints

- Variables
	- Doctor, Lawyer, Engineer, Piano, Violin, Flute
- Domain
	- {sandy, chris, pat}
- Constraints
	- If x is married to y, then x = y
	- If x is a patient of y, then x = y, and y is the doctor

<img src="/images/Pasted image 20260925133250.png" alt="image" width="500">

## Hidden variables

- Determine how to express the constraints
- Hidden variables

<img src="/images/Pasted image 20260925133359.png" alt="image" width="500">

## A more complex logic problem

- Zebra problem
- Determine what domain to use for the variables
- Positional ordering
# A fifth example: Scheduling

- Scheduling
	- Assigning people to jobs
- The task is to find periods for the classes

<img src="/images/Pasted image 20260925133540.png" alt="image" width="500">

- Variables
	- $P_i$ for the period
- Domains
	- Each period is a certain time on a certain day
	- A period can be encoded as a number (100 x day) + 24 hour
- Constraints
	- 5 periods must be available, non consecutive, with no more than two per day
	- 5 periods must all be distinct

<img src="/images/Pasted image 20260925133728.png" alt="image" width="500">