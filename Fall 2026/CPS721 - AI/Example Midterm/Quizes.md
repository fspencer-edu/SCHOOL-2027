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

## Generate and Test

```prolog
person(ben).
person(fred).
person(jim).
person(tim).

% member
member(X, [X|T]).

member(X, [X|T]) :-
	member(X, T)

% check that all people are different
all_diff([]).

all_diff([H|T]) :-
	not(member(H, T)),
	all_diff(T).
	
solve([Alt, Ind, Pac, Nor], [Dinghy, Yawl, Ketch, Schooner], [Esc, Que, Gup, Mai]) :-
	% === Generate all possibilities ===
	
	% Ocean assignments
	person(Alt),
	person(Ind),
	person(Pac),
	person(Nor),
	
	% Boat assignments
	person(Dinghy),
    person(Yawl),
    person(Ketch),
    person(Schooner),
    
    % ship name assignments
    person(Esc),
    person(Que),
    person(Gup),
    person(Mai),
    
    % === Test all constraints ===
    
    all_diff([Alt, Ind, Pac, Nor])
    
    all_diff([Dinghy, Yawl, Ketch, Schooner]),
    
    all_diff([Escape, Quest, Guppy, Maine]),
    
    % Indian Ocean restrictions
    not(Ind = ben),
    not(Ind = fred),

    % Maine and Schooner are in Indian Ocean
    Maine = Ind,
    Schooner = Maine,

    % Jim does not sail the Schooner
    not(Schooner = jim),

    % Yawl restrictions
    not(Yawl = ben),
    not(Yawl = fred),

    % Dinghy restrictions
    not(Dinghy = ben),

    % Escape is the Dinghy
    Escape = Dinghy,

    % Atlantic restrictions
    not(Atl = ben),
    not(Atl = fred),

    % Guppy sails in the Pacific
    Guppy = Pac,

    % Pacific restrictions
    not(Pac = fred).
```

## Interleaving

```
solve_boats_interleaving(
    [Atl, Ind, Pac, Nor],
    [Dinghy, Yawl, Ketch, Schooner],
    [Escape, Quest, Guppy, Maine]
) :-

    % STEP 1: Indian Ocean
    person(Ind),
    not(Ind = ben),
    not(Ind = fred),

    Maine = Ind,
    Schooner = Maine,
    not(Schooner = jim),

    % STEP 2: Yawl
    person(Yawl),
    not(Yawl = ben),
    not(Yawl = fred),
    not(Yawl = Schooner),

    % STEP 3: Dinghy
    person(Dinghy),
    not(Dinghy = ben),
    not(Dinghy = Yawl),
    not(Dinghy = Schooner),

    Escape = Dinghy,

    % STEP 4: Ketch
    person(Ketch),
    all_diff([Dinghy, Yawl, Ketch, Schooner]),

    % STEP 5: Atlantic Ocean
    person(Atl),
    not(Atl = ben),
    not(Atl = fred),
    not(Atl = Ind),

    % STEP 6: Pacific Ocean
    person(Pac),
    not(Pac = fred),
    not(Pac = Atl),
    not(Pac = Ind),

    Guppy = Pac,

    % STEP 7: North Ocean
    person(Nor),
    all_diff([Atl, Ind, Pac, Nor]),

    % STEP 8: Remaining ship name
    person(Quest),
    all_diff([Escape, Quest, Guppy, Maine]).
```
# Zoo Puzzle

## Generate and Test

```prolog
solve_zoo_generate(
    [Dibb,Gibb,Mibb,Ribb],
    [Lions,Bears,Monkeys,Snakes]
) :-

    % STEP 1: GENERATE ALL POSSIBILITIES

    % Generate surnames
    child(Dibb),
    child(Gibb),
    child(Mibb),
    child(Ribb),

    % Generate animal preferences
    child(Lions),
    child(Bears),
    child(Monkeys),
    child(Snakes),


    % STEP 2: TEST CONSTRAINTS

    % Every surname belongs to a different child
    all_diff([Dibb,Gibb,Mibb,Ribb]),

    % Every animal belongs to a different child
    all_diff([Lions,Bears,Monkeys,Snakes]),

    % Bear-lover is a boy, but not Bob
    boy(Bears),
    not(Bears = bob),

    % Snake-lover is a girl, but not Jenny
    girl(Snakes),
    not(Snakes = jenny),

    % Gibb likes snakes
    Gibb = Snakes,

    % Bob, Mibb, Bears, Snakes are different
    all_diff([bob,Mibb,Bears,Snakes]),

    % Dibb, Snakes, Bears, Jenny are different
    all_diff([Dibb,Snakes,Bears,jenny]),

    % Bob does not like monkeys
    not(Monkeys = bob).
```

## Interleaving

```prolog
solve_zoo_interleaving(
    [Dibb,Gibb,Mibb,Ribb],
    [Lions,Bears,Monkeys,Snakes]
) :-

    % STEP 1: Determine bear-lover
    boy(Bears),
    not(Bears = bob),

    % STEP 2: Determine snake-lover
    girl(Snakes),
    not(Snakes = jenny),

    % STEP 3: Gibb likes snakes
    Gibb = Snakes,

    % STEP 4: Determine Mibb
    child(Mibb),
    all_diff([bob,Mibb,Bears,Snakes]),

    % STEP 5: Determine Dibb
    child(Dibb),
    all_diff([Dibb,Snakes,Bears,jenny]),

    % STEP 6: Determine Ribb
    child(Ribb),
    all_diff([Dibb,Gibb,Mibb,Ribb]),

    % STEP 7: Determine monkey-lover
    child(Monkeys),
    not(Monkeys = bob),

    % STEP 8: Determine lion-lover
    child(Lions),
    all_diff([Lions,Bears,Monkeys,Snakes]).
```

# Map Colouring

## Generate and Test

```prolog
% Domains
colour(red).
colour(blue).
colour(white).

solve_map([A, B, C, D, E]) :-

    % Generate all possible colours
    colour(A),
    colour(B),
    colour(C),
    colour(D),
    colour(E),

    % Test adjacent regions
    not(A = B),
    not(A = C),
    not(A = D),
    not(A = E),

    not(B = C),
    not(C = D),
    not(D = E).
```

## Interleaving

```prolog
colour(red).
colour(blue).
colour(white).

solve_map_interleaving([A, B, C, D, E]) :-

    % Generate A
    colour(A),

    % Generate B and test
    colour(B),
    not(A = B),

    % Generate C and test
    colour(C),
    not(A = C),
    not(B = C),

    % Generate D and test
    colour(D),
    not(A = D),
    not(C = D),

    % Generate E and test
    colour(E),
    not(A = E),
    not(D = E).
```