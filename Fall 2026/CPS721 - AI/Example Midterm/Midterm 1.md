<img src="/images/Pasted image 20261101122433.png" alt="image" width="500">

```prolog
hasBook(Bookstore, Author, Title, Listprice)
lives(Person, City)
shipping(Bookstore, City, Cost)
```

What bookstore sells Harry Potter for the total price less than 20 to customers from more than one city?

```prolog
hasBook(Store, Author, 'Harry Potter', Price),
	lives(Person1, City1),
	lives(Person2, City2),
	not(City = City2),
	shipping(Store, City1, Cost1),
	shipping(Store, City2, Cost2),
	Total1 is Price + Cost1,
	Total2 is Price + Cost2,
	Total1 < 20,
	Total2 <20.
```

Find books by Robertson Davies available from exactly one bookstore?

```prolog
hasBook(Store, 'Robertson Davies', Title, Price),
	not((
		hasBook(OtherStore, 'Robertson Davies', Title, OtherPrice),
		not(OtherStore = Store)	
	)).
```

<img src="/images/Pasted image 20261101122505.png" alt="image" width="500">

(a) `[X | [Y | Z]] and [[a,b,c], k, l, m, n].`

```prolog
[X|[Y|Z]]
[X, Y | Z]

[X, Y | Z] = [[a,b,c], k | [l, m, n]]

X = [a,b,c]
Y = k
Z = [l,m,n]
```

(b) `[cps109,mth110 | [X | []]] and [P | [Q,[pcs110] | S]].`

```prolog
[cps109,mth110 | [X | []]]
[cps109,mth110,X]

[P | [Q,[pcs110] | S]]
[P, Q [pcs110] | S]

P = cps109
Q = mth110
X = [pcs110]
S = []
```

<img src="/images/Screenshot 2026-11-01 at 12.25.26 PM.png" alt="image" width="500">

```prolog
% Base case: an empty list
rangeTenForty([], []).

% Recursive: Element between 10 and 40
rangeTenForty([X|Rest], [X|Result]) :-
	X >= 10,
	X =< 40,
	rangeTenForty(Rest, Result)
	
% Recursive: Skip an element if it is outside the range
rangeTenForty([X|Rest], Result) :-
	(X < 10 ; X > 40),
	rangeTenForty(Rest, Result).
```


<img src="/images/Screenshot 2026-11-01 at 12.25.30 PM 1.png" alt="image" width="500">


```prolog
merge(L1, L2, Result, N)

% Base case: both lists are empty
merge([], [], [], 0).

% Recursive 1: first list is empty
merge([], [Y|Ys], [Y|Result], N) :-
	merge([], Ys, Result, N1),
	N is N1 + 1.
	
% Recursive 2: second list is empty
merge([X|Xs], [], [X|Result], N) :-
	merge(Xs, [], Result, N1),
	N is N1 + 1.
	
% Recursive 3: X is smaller than or equal to Y
merge([X|Xs], [Y|Ys], [X|Result], N) :-
	X =< Y,
	merge(Xs, [Y|Ys], Result, N1)
	N is N1 + 1.

% Recursive 4: Y is smaller than X
merge([X|Xs], [Y|Ys], [X|Result], N) :-
	X > Y,
	merge(Xs, [Y|Ys], Result, N1)
	N is N1 + 1.
```


<img src="/images/Screenshot 2026-11-01 at 12.25.35 PM.png" alt="image" width="500">

```prolog
family(Husband, Wife, ListOfChildren)
```

a) Find families with no children, where both parents have the same employer and birthday but different ages.

```prolog
family(
	person(FirstName1, Lastname, data(Day, Month, Year1), Employer),
	person(FirstName2, Lastname, data(Day, Month, Year1), Employer),
),
not(Employer = unemployed),
not(Year1 = Year2))
```

(b) Define `relatives(X,Y)` to determine whether two people have a common ancestor.

```prolog
% check whether an element belongs to a list
member(X, [X|Rest]).

member(X, [H|Rest]) :-
	member(X, Rest),
	
% Parent is the husband
parent(Parent, Child) :-
	family(Parent, Wife, Chidren),
	member(Child, Children).

% Parent is the wife
parent(Parent, Child) :-
	family(Husbdan, Parent, Chidren),
	member(Child, Children).

% Base case: parent is an ancestor
ancestor(Ancestor, Person) :-
	parent(Ancestor, Person).

% Recursive: an ancestor of a parent
ancestor(Ancestor, Person) :-
	parent(Parent, Person),
	ancestor(Ancestor, Parent)

% Define relatives
relatives(X, Y) :-
	ancestor(Ancestor1, X),
	ancestor(Ancestor2, X),
```

<img src="/images/Screenshot 2026-11-01 at 12.25.40 PM.png" alt="image" width="500">

(a) Define the possible ages

```prolog
age(1).
age(2).
age(3).
age(4).
```

(b) Complete smart-interleaving solution

```prolog
% possible ages
age(1).
age(2).
age(3).
age(4).

% all for values must be different
all_diff(A, B, C, D) :-
	not(A = B),
	not(A = B),
	not(A = D),
	not(B = C),
	not(B = D),
	not(C = D).
	
% solve birthday
solve([teresa, sarah, laura, jane],
	  [anne, brian, charlie, daniel]
) :-
	% sarah had ann just over a year ago
	sarah = 1,
	anne = sarah,
	
	% laura's child will turn 3 next birthday
	laura = 2,
	
	% teresa's child is the oldest
	teresa = 4,
	
	% generate charlie's age and test constraints
	age(charlie),
	charlie > laura,
	charlie < teresa,
	
	% Deniel is older than charlie
	age(daniel),
	daniel > charlie,
	
	% brian is not the oldest
	age(jrian),
	brian < teresa,
	not(brian = anne),
	not(brian = charlie),
	not(brian = daniel),
	
	% generate jane's child's age
	age(jane),
	not(jane = teresa),
	not(jane = sarah),
	not(jane = laura),
	
	% verify distinct ages
	all_diff(teresa, sarah, laura, jane),
	all_diff(anne, brian, charlie, daniel),
```

- Generate a value and immediately teat the constraints relevant to that value

(c) Final solution

```prolog
solve(Mothers, Children).

Sarah -> Anne (1 years)
Laura -> Brian (2 years)
Jane -> Charlie (3 years)
Teresa -> Daniel (4 years)
```


<img src="/images/Screenshot 2026-11-01 at 12.25.57 PM.png" alt="image" width="500">

```prolog
before(m2,m3).
before(m3,m4).
starts(m1,m2).
during(m5,m3).

% Rule 1
before(A,C) :-
    during(A,B),
    before(B,C).

% Rule 2: Missing (add in part b)

% Rule 3
before(A,C) :-
    before(A,B),
    before(B,C).

% Rule 4
during(A,B) :-
    starts(A,B).

% Rule 5
during(A,C) :-
    starts(A,B),
    during(B,C).
```

(a) Show the evaluation tree for `before(m1,m4)`

```prolog
% STEP 1
before(m2,m3) % fails
before(m3,m4) % fails

% STEP 2
before(A,C) :-
	during(A,B),
	before(B,C).

% STEP 3
A = m1
C = m4
before(m1,m4) :-
during(m1,B),
before(B,m4).

% STEP 4
during(m1,B)

during(A,B) :-
	starts(A,B).
	
start(m1,B) % success on 3 with B = m2

% STEP 5
before(m2,m4) % fails, backtrack

before(A,C) :-
    before(A,B),
    before(B,C).
    
before(m2,B), % success on 1 with B = m3
before(B,m4). % success on 3 with B = m3
```

(b) Add one rule to prove `before(m1,m5)`

```prolog

```