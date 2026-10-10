## Finding Minimum Number

```prolog
minim(NumbList, Min).

minim([X], X).

minim([H|T], Min) :-
	minim(T, Min), H => Min.
	
minim([H, T], ) :-
	mimim(T, Min), Min > H
	
-- Recusive
minim([X1, X2 | T], Min), X1 =< X2, minim([X1|T], Min).
minim([X1, X2 | T], Min), X2 < X1, minim([X2|T], Min).

minim(4, 2, 1, Min).
Min = 1

minim(4, 2, 1, 2).
No
```

## next()

```prolog
next(Ele, nil)

[1, 2, 3]
next(1, next(2, next(3, nil)))

base
minim(next(X, nil), X)

minim(next(X1, next(X2, T)), Min) :-
	X1 =< X2, minim(next(X1, T), Min).
	
minim(next(X1, next(X2, T)), Min) :-
	X2 =< X1, minim(next(X2, T), Min).
```

## Binary Trees 

```prolog
tree(Ele, LeftNode, RightNode).

tree(Ele, void, void).

tree(2, tree(1, void, void), tree(3, void, void).
```

## Leaves

```prolog
leaves(Tree, N).

leaves(void, 0)
leaves(tree(_, void, void), 1).

leaves(tree(_, LeftTree, RightTree), N) :-
	leaves(leftTree, LN), leaves(RightTree, RN), N is LN + RN.
```