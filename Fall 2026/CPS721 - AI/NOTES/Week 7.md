
```prolog

1 4 X X
1 4 X X
1 4 X X
1 4 X X

solve(R11, R12, ..., R44) :-
	digits(11), digit(R12), digit(R13), digit(R14),
	digits(11), digit(R12), digit(R13), digit(R14),
	digits(11), digit(R12), digit(R13), digit(R14),
	digits(11), digit(R12), digit(R13), digit(R14),
	
	all_diff([R11, R12, R13, R14]),
	all_diff([R21, R22, R23, R24]), % rows 1, 2
```


```prolog

% domain
child(bob). child(kristie). child(sam). child(jenny)

all_diff([]).

all_diff([H|T]) :- not member(H,T), all_diff(T).

solve([Dibbs, Gibb, Mibb, Ribb, Lion, Bear, Monkey, Snake]) :-
	child(Mibb), child(Bear), child(Snake), not Bear = kristie not Bear = Jenny,
	not Snake = bob, not Snake = sam, all_diff([bob, Mibb, Bear, Snake]), % 1
	child(Dibb), not Bear = kristie, not Bear = Jenny, not Snake = bob,
	not snake = sam, all_diff([Dibb, Beark, Snake, Jenny]), %2
	child(Gibb), Snake = Gibb, child(Snake), %3
	child(Monkey)
```