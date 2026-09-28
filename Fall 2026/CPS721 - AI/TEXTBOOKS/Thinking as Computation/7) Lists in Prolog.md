- Symbolic structures
	- Lists
# Lists

- A predicate with an undefined about of items should work on any collection $L$
- A Prolog list is a sequence of objects that are called its elements

```prolog
[]
[anna,fred]
[[1,hello],[2,bye]]
```

- Empty list
- Contain other lists as elements
- 3D list
- One-element list is different from the element itself

- First element of a nonempty list is the head of the list
- The list that is formed by removing the first element is called the tail
- The head of a nonempty list can be anything
- Tail is always a list

## Lists as Prolog terms

- Term
	- A constant, variable, number, of list
- Square parentheses that includes a sequence of terms separated by commas
- Square parentheses, followed by a nonempty sequence of terms, and a vertical bar denoting a list
## Unification with lists

- Variables can appear within a list item
- Unify
	- Two lists without variables are considered to unify when they are identical, element for element
	- Two lists with distinct variables are considered to unify when the variables can be given values that make the two lists identical, element for element
	- Lists will not unify if they have different numbers of elements or if at least one corresponding element does not unify

- $X$ matches anything, including any list
- $[X]$ matches any list with exactly one element
- $[X|Y]$ matches any list with at least one element
- $[X,Y]$ matches any list with exactly two elements
# Writing programs that use lists

- Programs that go through lists end up being recursive
- Not known in advance how many elements are involved
- Each list will have some number n of elements
	- Write clauses to handle the n = 0 case
		- Empty set
	- Write clause to handle (n+1) case
		- Assumption that the n case is already complete
## Some example lists predicates

_Example 1: List of People_

- There is a predicate `person(x)` that holds when x is a person
- `person_list(z)` holds when z is a list whose elements are all people


```prolog
person_list([john, sue, george, harry]).
Yes
person_list([john, 5, harray])
No
```

- Predicate will go through and check each element of the list
- Clause to handle the empty list
- Write clause to handle the list `[H|T]`

```prolog
% If H is a person and T is a list of people,
% then [H|T] is also a list of people

person_list([H|T]) :- person(H), person_list(T).
```

- `[john, sue]` does not unify with `[]` in the first clause, but does unify with `[H|T]`
- `[]` unifies with `[]`, and the predicate succeeds immeditaly

_Example 2: Membership in a list_

- Define a predicate `elem` that will determine whether something is an element of a list

```prolog
elem(b, [a, b, c, d]).
Yes
elem(f, [a, b, c, d]).
No
```

- Prolog provides a predefined predicate, `member`
- Write clauses for the empty list
- Query `elem(X, [H|T])`

```prolog
% X is an element of any list whose head is X
elem(X, [H|T]).

% If X is an element of a list L,
% then it is an element of any list whose tail is L
elem(X, [_|L]) : elem(X, L).
```

_Example 3: List of unique people_

- `member` can be used to write teh clauses for a predicate `uniq_people(z)`, holds when `z` is a list of people that are all distinct
- The empty list of unique people
- For the list `[P|L]`, if P is a person, L is a list of unique people, and in addition, P is not an lement of L, then `[P|L]` is also a list of unique people

```prolog
unique_people([]).
uniq_people([P|L]) :- uniq_people(L), person(P), \+ member(P, L)
```

_Example 4: Joining two lists_

- Define a predicate `john` that concatenates two lists

```prolog
join([a, b, c, d], [e, f, g], L).
L=[a, b, c, d, e, f, g]
Yes
```

- Predefined predicate, `append`
- Recursive predicate needs to determine what the third argument should be for any two lists
- Clauses to handle the case where the first argument is `[]` and the second argument is any list
- Clauses to handle the case where the first argument is `[H|T]` and the second argument i s any list `[L]`

```prolog
% Joining [] and any list L produces L
join([], L, L)

% If joining T and L, produces the list Z,
% then joining [H|T] produces the list [H|Z]
join([H,T], L, [H|T]) :- join(T, L, Z).
```

- Most of the work is done by `join`
- The query succeeds at each level, new elements re added to the third argument, building the final concatenated list

- The top level query is `join([a, b, c, d], [e, f], R)`

<img src="/images/Pasted image 20260928120044.png" alt="image" width="500">

# Using the `member` and `append` predicates

- `member` can also be used to generate the elements of a list

```prolog
member(X, [a, b, c]).
X = a ;
X = b ;
X = c;
No
```

- Queries can be written that go through the elements of a list looking for one that satisfies some condition
- `member(X, L), p(X), ...`
- If `L` is a nonempty list, and the variable x is not instantiated, the member of `member(X, L)` query will succeed, with `X` getting the head of the list as its value
- If `p(x)` fails, the program will backtrack, and x will be assigned to the next element of the list, until an element of `L` is found for which `p(X)` succeeds
- Do not generate an infinite set of candidates

```prolog
member(N, [1, 2, 3, -4, 5, 7]), N < 0.
N = -3 ;
N = 5 ;
No

member(3, L).
L = [3|_G214]
L = [_G213, 3|_G217]
L = [_G213, _G216, 3|_G220]
Yes

member(3, L), 1 = 2
Yes
```


## The blocks world revisited
