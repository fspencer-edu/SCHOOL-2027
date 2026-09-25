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

![[Pasted image 20260925092751.png]]

# Recursion in Prolog

- A predicate is considered recursive when the predicate appears in both the head and the body of a clause
- The predicate is used in both the if and the then parts
- Mathematical induction
# Mathematical induction

- A technique for providing that something is true for all natural numbers
- Prove that for ann n, $S(n)$ is true
	- Prove that S(0) is true
	- Prove that for any natural number n, if S(n) is true, than S(n+1) is also strue
# Nonterminating programs

- Third programming requirement
	- A program must be in a form suitable for back chaining
- When the body of a clause contains a recursive predicate, make sure that its new variables are instantiate by early atoms in the body
# A more complex predicate

- 

## Recursion and termination, reconsidered

# Efficiency in Prolog
