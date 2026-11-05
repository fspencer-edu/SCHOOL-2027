<img src="/images/Screenshot 2026-11-01 at 12.15.19 PM.png" alt="image" width="500">

- Prolog queries
	- Formulate queries using facts, comparisons, and negation
- Backward chaining
	- Trace Prolog's execution and draw evaluation trees
- List unification
	- Simplify lists, identify variables, and prove whether lists match
- Recursive list
	- `member`
	- `append`
	- `length`
	- `sum`
	- `filtering`
	- `merge`
- Structures and terms
	- Hierarchical structures and binary trees
- Constraint satisfaction
	- Solve puzzles using generate and tests and smart interleaving
- Dependency graphs
	- Identify which variables can be calculated from others

# Prolog Fundamentals

```prolog
parent(john, mary)
parent(mary, alice)
parent(john, bob)

grandparent(X, Z) :-
	parent(X, Y),
	parent(Y, Z)
	
% X is a grandparent of Z, if X is the parent of Y, and Y is the parent of Z
```

```prolog
student(alice, computer_science).
student(bob, mathematics).
student(charlie, computer_science).

grade(alice, 90).
grade(bob, 76).
grade(charlie, 85).

% Find all cs students
student(Name, computer_science).

% Find a cs student with grades above 80
student(Name, computer_science),
grades(Name, Grade),
Grade > 80.

% Find a student who is not studying math
student(Name, X), not(X = mathemetics).
```

# Recursive Programs

```prolog
predicate([], BaseResult).

predicate([Head|Tail], Result) :-
    predicate(Tail, SmallerResult),
    % Calculate Result.
```

**Q** - Calculate the length of a list

```prolog
length([a,b,c,d], N).

length([], 0).

length([Head|Tail], N) :-
	length(Tail, N1),
	N is N + N1.
```

**Q** - Sum a list

```prolog
sum([1,10,100], S).

sum([], 0).

sum([Head|Tail], S) :-
	sum(Tail, S1),
	S is Head + S1.
```

**Q** - Implement member/2

```prolog
% X is the first element
member(X, [X|Tail]).

% Recursivey search the tail
member(X, [Head|Tail]) :-
	member(X, Tail).
```

**Q** - Implement append/2

```prolog
% append an empty list
append([], List, List)

% copy the head and append the remaining elements
append([Head|Tail], List2, [Head|Result]) :-
	append(Tail, List2, Result)
```

**Q** - Write a predicate that returns only positive numbers

```prolog
positives([-3,5,0,8,-1], X).

% Base case
positives([], []).

% Keep positive elements
postitives([Head|Tail], [Head|Result]) :-
	Head > 0,
	postitives(Tail, Result),.
	
% Skip zero and negative elements
positives([Head|Tail], Results) :-
	Head =< 0,
	positives(Tail, Result).
```

**Q** - Merge two sorted lists

```prolog
merge([2,6], [3,8], Result).

% Empty first list
merge([], List, List).

% Empty second list
merge(List, [], List).

% First head is small or equal
merge([X|xs], [Y|Ys], [X|Result]) :-
	X =< Y,
	merge(Xs, [Y|Ys], Result).
	
% second head is smaller
merge([X|Xs], [Y|Ys], [Y|Result]) :-
	X > Y,
	merge([X|Xs], Ys, Result).
```

# Structures and Terms

```prolog
parent(john, mary).
parent(mary, alice).
parent(alice, bob).

% Base case
ancestor(X, Y) :-
	parent(X, Y).
	
% Recusive case
ancestor(X, Y) :-
	parent(X, Z),
	ancestor(Z, Y).
```

```prolog
member(X, [X|Rest]).

member(X, [Head|Rest]) :-
	member(X, Rest).
```

# Binary Tree Recursion

```prolog
tree(value, LeftT, RightT)

tree(5,
	tree(2, void, void),
	tree(2, void, void),
)
```

**Q** - Sum values in a binary tree

```prolog
% Base case
tree_sum(void, 0).

% Recusively sum both subtrees
tree_sum(tree(Value, Left, Right), S) :-
	tree_sum(Left, LeftSum),
	tree_sum(Right, RightSum),
	S is Value + LeftSum + RightSum.
```

**Q** - Count leaves

```prolog
% Base case
leaves(void, 0).

% Base case: A leaf node
leaves(tree(_, void, void), 1)

% Recursive case: count all leaves
leaves(tree(_, Left, Right), N) :-
	not((Left = void, Right = void)),
	leaves(Left, NLeft),
	leaves(Right, NRight),
	N is NLeft + NRight.
```

**Q** - Count nodes

```prolog
% Base case: empty tree has 0 nodes
nodes(void, 0).

% Recursive case: count all nodes
nodes(tree(_, Left, Right), N) :-
	nodes(Left, NLeft),
	nodes(Right, NRight),
	N is NLeft + NRight + 1.
```

# Constraint Satisfaction Problems

- Variables whose value are unknown
- Domains containing possible values
- Constraints restricting valid combinations

```prolog
A = Rehersal
B = Wedding
C = Part

- occurs on different days
- A before B
- B before C
  
% Generate and test
solve_pure([A,B,C]) :-
	% Generate all possible arguments
	day(A),
	day(B),
	day(C),
	
	% Test constraints
	not(A = B),
	not(A = C),
	not(B = C),
	
	A < B,
	B > C.
	
There are 3^3 = 27 possible assignments
```

```prolog
solve_smart([A,B,C]) :-
	% Generate A
	day(A),
	
	% Generate B and test
	day(B),
	A < B,
	
	% Generate C and test
	day(C),
	B < C,
	
	% Verify all values are different
	not(A = C).
```

**Q** - Implement all_diff/1

```prolog
% X differs from every element in the list
different_from(X, []).

different_from(X, [Y|Rest]) :-
	not(X = Y),
	different_from(Rest).
	
% all elements are pairwise different
all_diff([]).

all_diff([X|Rest]) :-
	different_from(X, Rest),
	all_diff(Rest).
```

**Q** - count all occurrences

```prolog
% Base case
count(_, [], 0).

% Matching
count(X, [X|T], N) :-
	count(X, T, N1),
	N is N + N1.
	
% Nonmatching
count(X, [H|T], N) :-
	not(X = H),
	count(X, T, N).
```


**Q** - Remove occurrences

```prolog
% Base case
remove(_, [], []).

% Matching element: skip head
remove(X, [X|T], R) :-
	remove(X, T, R).
	
% Nonmatching element: keep head
remove(X, [H|T], [H|R]) :-
	not(X = H),
	remove(X, T, R).
```

**Q** - Keep matching elements

```prolog
% Base case
keep(_, [], []).

% Matching element: keep head
keep(X, [H|T], [H|R]) :-
	keep(X, T, R).
	
% Nonmatching: remove
keep(X, [H|T], R) :-
	not(X = H),
	keep(X, T, R).
```

**Q** - Filter all numbers greater than a value

```prolog
% Base case
greater_than(_, [], []).

% Keep the head if H > X
greater_than(X, [H|T], [H|R]) :-
	H > X,
	greater_than(X, T, R).
	
% skip the head if H <= X
greater_than(X, [H|T], R) :-
	H <= X,
	greater_than(X, T, R).
```

**Q** - Remove duplicates from a list

```prolog
% Base case
remove_duplicates([], []).

% Skip if it already appears in the result
remove_duplicates([H|T], R) :-
	member(H, T),
	remove_duplicates(T, R).
	
% Keep if unique
remove_duplicates([H|T], [H|R]) :-
	not(member(H, T)),
	remove_duplicates(T, R).

```

**Q** - Merge two ascending lists

```prolog
% Base case
merge([], L, L).
merge(L, [], L).

% Take first element from left list
merge([X|Xs], [Y|Ys], [H|R]) :-
	X =< Y,
	merge(Xs, [Y|Ys], R).
	
% Take first element from right list
merge([X|Xs], [Y|Ys], [H|R]) :-
	X > Y,
	merge([X|Xs], Ys, R).
```

**Q** - Append 3 lists

```prolog
% base case
append([], L, L).

append([H|T], L, [H|R]) :-
	append(T, L, R)
```

**Q** - Interleave two lists

```prolog
% Base cases
interleave([], L, L).
interleave(L, [], L).

% Take one from A, then swap the lists
interleave([H|T], L, [H|R]) :-
	L = [_,_],
	interleave(L, T, R)
```

**Q** - Filter and merge student grades
- Combine and return student with grades at least 60

```prolog
% keep passing students
passing([], []).

passing([student(Name, Grade)|T],
	    [student(Name, Grade)| R]
) :-
	Grade >= 60,
	passing(T, R).
	
% skip failing students
passing([student(_, Grade)|T], R) :-
	Grade < 60,
	passing(T, R).
	
% combine both classes and filter
merge)passing(Class1, Class2, Result) :-
	append(Class1, Class2, Combined),
	passing(Combined, Result)
```


**Q** - Count and sum numbers between 0 and 9

```prolog
% Base case
count_sum([], 0, 0)

% Case 1: Number between 0 and 9
count_sum([X|Xs], Count, Sum) :-
	X >= 0,
	X =< 9,
	count_sum(Xs, C1, S1),
	Count is C1 + 1,
	Sum is S1 + X,

% Case 2: Number is outside 0 and 9
count_sum([X|Xs], Count, Sum) :-
	not((X >= 0, H =< 9)),
	count_sum(Xs, Count, Sum).
```


**Q** - member, all_diff, and append

```prolog
% MEMBER
member(X, [X|_]).

member(X, [_|T]) -:
	member(X, T).
	
% ALL DIFF
all_diff([]).

all_diff([X|T]) :-
	not(member(H, T)),
	all_diff(T).
	
% APPEND
append([], L, L).

append([H|T], L, [H|R]) :-
	append(T, L, R).
```