```prolog
[h, o, r, s, e]

[X, Y] = [C, D].

X = D
Y = D

[c, a, t, e, r, p, i, l, l, a, r]

[c, a, t | [X]] = [c, a, t | X]

[c, a, t | X] = [c, a, t, s]

---

[X, Y] = [X, | [Y]]
[c, a, t | [X | [Y]]]
[c, a, t, X | [Y]]
[c, a, t, X, Y]

---

[c, a, t | [X, Y | Z]]
[c, a, X, Y| Z]]
[c, a, e, r| [p, i, l, l, a, r]]]
X = e, Y = r, Z = [p, i, l, l, a, r]

---

[X | [Y | [p, i, l, l | Z]]]
[X, Y | [p, i, l, l | Z]]
[X, Y, p, i, l, l | Z]

X = c
Y = a
thrid elements are different, and does not match

---

[X | [a, t | [M, N | [p, i | Q]]]]
[X, a, t | [M, N | [p, i | Q]]]
[X, a, t, M, N | [p, i | Q]]
[X, a, t, M, N, p, i | Q]

[c, a, t, e, r, p, i | [l, l, a, r]]

X = c
M = e
N = r
Q = [l, l, a, r]

---

[a, b | [c, d]] = [a, b, c | [d]] = [a, b, c, d | []]

---

[b, [W | [a, Z]]] and [b, c | [d, a, f]]

LS = [b, [W | [a, Z]]]
[b, W | [a, Z]]
[b, W a, Z]

RS = [b, c | [d, a, f]]
[b, c, d, a, f]

Does not match 4, element list vs 5

---

[a, b | [[q], [r]| S]] and [X | [Y, Z | [W]]]

LS = [a, b | [[q], [r]| S]]
[a, b, [q], [r]| S]

RS = [X | [Y, Z | [W]]]
[X, Y, Z | [W]]
[X, Y, Z, W]

X = a
Y = b
Z = [q]
W = [r]
S = []

---

[con | [A | B]] and [D, A | [t, e, s, t]]

LS = [con | [A | B]]
[con, A | B]

RS = [D, A | [t, e, s, t]]
[D, A, t, e, s, t]


[X|Y] /= [X, Y]

[X] =
```

- `X` will match any list
- `[X]` matches a list with one element
- `[X | Y]` matches a list with one or more elements since Y and can be a list of arbitrary size

```prolog
X = [a, b, c]
```


```prolog
% Find even numbers
even_number([H|_], H) :-
	0 is H mod 2.
	
even_number([_|T], X) :-
	even_number(T, X).
```