
```prolog
long(my, example(X, of(a, term, Y))) = long(Y, example(q, Z)).

X = q
Y = my
Z = of(a, term, my)

long(my, example(X, of(a, term, Y))) = long(Y, example(q, Z)).
```

```prolog
Given a list od date(D, M, Y), count the number of people bron between 1990 and 1999

count90(ListOfDates). % N is the number of cases in ListOfDates where Y is between 1990 and 1999

count90([date(1,1,1989), date(22,3,1990), date(27,8,1999), date(18,11,2000)], X)?
X = 2

% Base case
count90([], 0)

% Recursive case
count90([date(D, M, Y) | ListOfDates], N) :- Y < 1990, count90(ListOfDates, N).

% second case
count90([date(D, M, Y) | ListOfDates], N) :- Y > 1999, count90(ListOfDates, N).

% third case
count90([date(D, M, Y) | ListOfDates], N) :- Y >= 1990, Y =< 1999, count90(ListOfDates, Interim), N is Interim + 1.

Find the oldeset person, or youngest person
```


```prolog
next(H1, next(H2, next(H3, nil))).

[H1, H2, H3] = [H1 | [H2 | [H3 | []]]]

append(L1, L2, L3)

% base case
append([], L2, L2)

% recursive case
append(next(H, T), L2, next(H, L3)) :- append(L1, L2, L3)

append([H|L1], L2, [H|L3]) :- append(L1, L2, L3)
```

# Binary trees

```prolog
write(X)
nl

inOrder(tree(10, tree(8, Tree(6, void, void), void), tree(20, tree(12, void, void), void)))

Returns answer yes and prints 6, 8, 10, 12, 20
one number be line

inOrder(tree, 9, void, tree(11, void, void)).

```