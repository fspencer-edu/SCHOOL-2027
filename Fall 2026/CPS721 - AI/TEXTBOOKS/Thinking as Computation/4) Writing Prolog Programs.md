# The truth in Prolog

## The truth, and nothing but

## The whole truth

- A program might not contain all possible truths
- A program must include all relevant truths, explicitly or implicitly
- Logically correct
	- Correct with respect to grammar and to truth
- Correct
	- Grammatically correct, logically correct, and in a form suitable for back chaining
# A blocks world

<img src="/images/Pasted image 20260925092751.png" alt="image" width="500">

# Recursion in Prolog

- A predicate is considered recursive when the predicate appears in both the head and the body of a clause
- The predicate is used in both the if and the then parts
- Mathematical induction
# Mathematical induction

- A technique for providing that something is true for all natural numbers
- Prove that for ann n, $S(n)$ is true
	- Prove that S(0) is true
	- Prove that for any natural number n, if S(n) is true, than S(n+1) is also true
# Nonterminating programs

- Third programming requirement
	- A program must be in a form suitable for back chaining
- When the body of a clause contains a recursive predicate, make sure that its new variables are instantiate by early atoms in the body
- - When a clause is recursive, the recursive predicate should appear toward the end of the clause
	- New variables can be instantiated
# A more complex predicate

- Different recursive predicates require different measures of size
## Recursion and termination, reconsidered

- Termination
	- A recursive program will terminate if the query that matches the head of a clause is always bigger than the queries from the body of the clause

# Efficiency in Prolog

- Forces the program to reconsider the same queries over and over
- If the stack had k blocks in it, the program would try to establish the same bottom queries over and over $2^k$ times

<img src="/images/Pasted image 20260925112835.png" alt="image" width="500">

- 