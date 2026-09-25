1) parent(fred, peter).
2) parent(fred, susan).
3) parent(ann, susan).
4) parent(ann, peter).
5) parent(john, ann).
6) parent(sandy, ann).
7) parent(michael, john).
8) ancestor(X, Y):= parent(X, Y).
9) ancestor(X, Y):= parent(X, Z), ancestor(Z, Y).


**Q - ancestor(sandy, michael)**

a) Fail, not found in KB
b) match on (8) with ancestor(X, Y) := parent(X, Y). with X = sandy, Y = michael
c) Establish parent(sandy, michael)
	"parent(sandy, michael)"
	a) Fail, not found in KB
	b) Fail, not found in conditional
b) match on (9) with ancestor(X, Y):= parent(X, Z), ancestor(Z, Y). with X = sandy, Y = michael
	"parent()"
	





---


male(X). female(Y). parent(X, Y)
father(X, Y) :- male(X), parent(X, Y)
mother(X, Y) :- female(X), parent(X, Y)
sister(X, Y) :- female(X), parent(Z, X), parent(Z, Y)
brother(X, Y) :- male(X), parent(Z, X), parent(Z, Y)
ancestor(X, Y) :- 