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
_Example 2: Membership in a list_
_Example 3: List of unique people_
_Example 4: Joining two lists_

# Using the `member` and `append` predicates

## The blocks world revisited
