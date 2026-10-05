# Part 1 - Terms I

```prolog
student(jennifer)


```

 - A term is a function that maps individuals into a unique individual
	 - Data structure
- `dob(4, 1, 1643)`

- Formal definition of terms
	- Terms
		- A constant
		- A variable
		- A list
		- A predicate symbol pred, and input arguments that are terms


- Predicates vs terms
	- Syntactically, they are almost the same
	- A predicate states a relationship between its arguments
		- It is either true of false
	- A term specifics an individual
		- It is a function that returns that individual

- Queries with terms

```prolog
family(ListofParents, ListofChildren)

person(FirstName, LastName, DOB)

member(E, [E|T]).
member(E, [E|T]) :- member(E|T).

dob(Day, Month, Year)
```

**Q1** - Is there a family with a parent with the last name chang born after 1992?

```prolog
family(PList, CList), member(P, PList), P = person(F, chang, dob(Day, M, Y)), Y > 1992

family(PList, CList), member(Person(F, change, dob(D, M, Y)), PList), Y > 1992
```

**Q2** - Is there a family with at least two children, one born before 1957?

```prolog
family(PList, [X, Z|T])
family(PList, CList), member(X, CList), member(Z, CList), not X = Z, X = person(F, L, dob(D, M Y)), Y > 1957
```

 - Database about families

```prolog
family(ListOfParents, ListOfChildren)
```


- Defining new predicates using family

```prolog
parent(X) :- family(PList, CList), member(X, PList)
child(X) :- family(PList, CList), member(X, CList)

human(X) :- parent(X)
human(X) :- child(X)
```

- List of terms

```prolog
item(Name, Colour, Weight, Price).

[
	item(sofa, blue, 25, 500),
	item(table, brown, 20, 200),
	item(loveseat, blue, 18, 150),
]
```

- What is the total weight of the items

```prolog
totalWeight([], 0).
totalWeight([item(N, C, W, P)|T], S) :-
	totalWeight(T, S2), S is S2 + W
```

- Binary trees as terms
	- Represent a binary tree as a term with 3 arguments
	- Use `void` to mean an empty binary tree


```prolog
tree(Element, LeftBranch, RightBranch)
tree(a, tree(b, void, void)), tree(c, void, void)
```

- Recursion Over Terms
	- A binary tree is a recursive data structure
		- Each subtree is also a binary tree
	- A term is represented using a string
		- Create a term `binaryTree(T)` to check that T is a binary tree

```prolog
binaryTree(void)
binaryTree(Tree(E, L, R)) :-
	binaryTree(L), binaryTree(R).
```


- Recursion over terms
	- Holds if `E` is an element in the binary tree

```prolog
1) memberOfTree(E, tree(E, L, R)).
2) memberOfTree(E, tree(H, L, R)) :-
	memberofTree(E, L).
3) memberOfTree(E, tree(H, L, R)) :-
	memberOfTree(E, R).

	 a
	/ \
    b  c
    
member(C, memberOfTree)
```


- List as Terms
	- Can represent list `[H|T]` using the term `next(H, T)`
		- An empty list represented using `nil`
		- Looks even closer to the linked in representation
- What would the list `[a, b, c]` look like?

```prolog
next(a, next(b, next,(c, nil)))
[a, b, c] = (a | [b| [c | nil]])
```

- List as terms
	- Reimplement member(X, List) using terms

```prolog
memberList(X, List)

member(X, [X|T]).
member(X, [H|T]) := member(X, T).

memberList(X, next(X, T)).
memberList(X, next(Y, T)) :-
	memberList(X, Y).
```

# Constraint Satisfaction Problems

- Prolog output
	- Write the string or term to output
	- `nl` - newline

```prolog
write("Some string) or write(Term)

sum(List, S)
sum([1, 2, 3], S), write("The sum is ), write S, nl.
```

### Hospital Rostering

- Have a set of employees, with different skills
- Have staffing requirements for different times of days
- Have a list of constraints that myst be handled
	- No one can work more than 16 hours in a row
	- James wants Friday off for vacation
- Find a schedule for he next two weeks that satisfies these

### Baseball Scheduling

- 30 MLB teams, each plays 162 games
- Need a schedule such that satifies certain constraints
	- Cannot use the Rogers Centre on contains dates
	- Teams can only be away from home x days in a row

## Constraint Satification Problems

- Many problems can be represented as followed
	- A set of choices to be made
	- Choice must satisfy some set of constraint
- Hand reasoning tasks
- Quality metric

### Map Colouring

- Assign colours so that adjacent countries are not the same colour
	- 3 colours
- How many possible assignments
- 2 countries beside do not have the same colour

```prolog
colour(red).
colour(blue).
colour(white).

solve([A, B, C, D, E]) :-
	colour(A), colour(B), colour(C), colour(D), colour(E), not A = B, not A = E, not A = C, not A = D, not B = C, not C = D, not D = E
	
	
```

- Scaling up map colour

colour^num_items


### Interleaving Generated Tests

- Partially generate, then test, the generate some more

```prolog
solve([A, B, C, D, E]) :-
	colour(A), colour(B), not A = B,
	colour(C), not C = B, not C = A,
	colour(D), not C = D, not C = A,
	colour(E), not E = D, not C = A.
	
find_and_print :-
	solve([A, B, C, D, E]),
	write("The Colour of A is ), write(A, nil)
```


# General CSP Approach (Generate and test)

```prolog
solve(ListOfVars) :-
	domain1(Var1), domain2(var2),
	constaint1(Vart, ..., Varn)
```

### Cryptarithmetic Puzzels

- What are the variables?
	- S, E, N, D, M, O, R, Y
- What are the domains
	- 0 to 9
- dig[]

# Part 2 - Terms II