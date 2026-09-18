1) Peter is a child of fred
2) Peter is a child of ann
3) Susan is a child of ann
4) Susan is a child of fred
5) ann is a child of sandy
6) Ann is a child of john
7) Peter is male
8) Susan is female
9) Fred is male
10) Ann is female
11) john is male

12) If X is a child of Y, then Y is a parent of X
13) If X is a child of Y and Y is female then Y is a mother of X
14) If X is a mother of Y and Y is a parent of Z then X is a grandmother of Z
15) If X is a child of Y and Y is male then Y is a father of X
16) If X is a father of Y and Y is a parent of Z then X is a grandfather of Z


Establish
a) Try and locate it in the KB
b) Otherwise, locate a condition sequence
c) Backchaining to establish conditional sequence
d) Otherwise, back track to step 2 and look for another conditional

**Q1 - "ann is a mother of susan"**
a) fail
b) match on 13 with Y = ann and X = susan
c) establish "susan is a child of ann" and "ann is female"
	"susan is a child of ann"
	a) success on 3
		"ann is female"
	a) success on 10
success

**Q2 - "john is a mother of ann"**
a) fail
b) match on 13 with Y = john and X = ann
c) establish "ann is a child of john" and "john is female"
	"ann is a child of john"
	a) success on 6
	"john is female"
	a) fail
	b) fail
	"ann is a child of john"
	a) fail
	b) fail
b) fail


**Q3 - "fred is a relative of peter"**
a) fail
b) fail
fail





```prolog
child(peter, fred).
child(peter, ann).
child(susan, ann).
child(susan, fred).
child(ann, sandy).
child(ann, john).

male(peter).
female(susan).
male(fred).
female(ann).
male(john).

% 1. If X is a child of Y, then Y is a parent of X
parent(Y, X) :-
    child(X, Y).

% 2. If X is a child of Y and Y is female, then Y is a mother of X
mother(Y, X) :-
    child(X, Y),
    female(Y).

% 3. If X is a mother of Y and Y is a parent of Z, then X is a grandmother of Z
grandmother(X, Z) :-
    mother(X, Y),
    parent(Y, Z).

% 4. If X is a child of Y and Y is male, then Y is a father of X
father(Y, X) :-
    child(X, Y),
    male(Y).

% 5. If X is a father of Y and Y is a parent of Z, then X is a grandfather of Z
grandfather(X, Z) :-
    father(X, Y),
    parent(Y, Z).
```

