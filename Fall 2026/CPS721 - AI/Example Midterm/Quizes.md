# Binary Trees

- Inorder traversal

```prolog
% Base case: empty tree
inOrder(void).

% Recursive
in_order(tree(N, Left, Right)) :-
	in_order(Left),
	write(Node),
	nl,
	in_order(Right).
```

# Print a List Forward and Backward

```prolog
write_list([a,b,c]).

% Base case
write_list([]).

% Recusive
write_list([H|T]) :-
	write(H),
	nl,
	write_list(T).
```

```prolog
% Base cae
write_rev([]).

write_rev([H|T]) :-
	write_rev(T),
	write(H),
	nl.
```

# List Unification

```prolog
[b,u,r | [g,e,v,s]] ? [A,B,X,Y | [Z,Q]]
[b,u,r,g,e,v,s]       [A,B,X,Y,Z,Q]

A = b
B = u
X = r
Y = g
Z = e
Q =\ [v, s]

- First has 7 elements, second has 6
  
[b,u | [r,g,e,v,s]] ? [B,U,R,G | [X|Y]]
[b,u,r,g,e,v,s] ?     [B,U,R,G,X|Y]

B = b
U = u
R = r
G = g
X = e
Y = [v, s]

- Unfiy
  
[B,u,X,g,e | [v,s]] ? [b,U,v | [G,E,X,S]]
[B,u,X,g,e,v,s]       [b,U,v,G,E,X,S]

B = b
Y = u
X = v
G = g
E = e
S = s

- Unify

[l,e,t,t,u,c,e] ? [X,Y,Z,Z,u | [C,e]]
				  [X,Y,Z,Z,u,C,e]
				  
X = l
Y = e
Z = t
C = c

- unify
  
[l,e,t | [t,u,c,e]] ? [A,B,C,C,s | [D]]
[l,e,t,t,u,c,e]       [A,B,C,C,s,D]

A = l
B = e
C = t

- First list contains 7 elem, second 6
  5th element, u =\ s
  
[[o,n,i], [o,n]] ? [X,Y,Z|Q]
		           [X,Y,Z,Q]

- First has 2 elem, second 3
```

# Ship Captains

- 4 captains, oceans, boards, and ship names

```prolog
person(ben).
person(fred).
person(jim).
person(tim).
```


# Zoo Puzzle