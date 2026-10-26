- Saturday October 31
- DCC
- 100 minutes
- Multiple and short answer questions

- Main topics
	- Querying in KB
	- Back chaining
	- List matching and list recursion
	- CSPs

# Knowledge Bases and Queries

- A knowledge base is a list of atomic statements defining what is true
- Queries allow use to use those statements to make interesting inferences about the world specified by the knowledge base

```prolog
inStore(ItemID, ProductType, Quantity)

manufacturer(ItemID, Company, Year)
```

**Q** - What product does the store have the most of?

```prolog
inStore(I1, P1, Q1), not (inStore(I2, P2, Q2), Q2 > Q1).
```

**Q** - What apple product does the store have the most of?

```
```prolog
inStore(I1, P1, Q1), manufactuer(I1, apple, Y),
not(inStore(I2, P2, Q2), Q2 > Q1), manufacturer(I2, apple, Y2)
```

# Rules and Back Chaining

- Rules specify additional relationships, useful for deducing more information

```prolog
head :- body1, body2, ..., bodyN
```

- Query
	- Given a KB, establish establish sentence Q is true
		- If Q is in KB, done
		- Find a sentence that matches with "Q :-"

**Q** - `ancestor(bob, mary)`

```prolog
1) parent(bob, steve).
2) parent(ann, bob).
3) parent(steve, peter).
4) parent(steve, sue).
5) parent(peter, mary).
6) parent(mary, john).
7) ancestor(X, Y) :- parent(X, Y).
8) ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

X = bob
Y = mary
Match on 7, fails on parent(bob, mary)
Match on 8, parent(bob, Z), ancestor(Z, mary)
Z = steve
ancestor(steve, mary)
X = steve
Y = mary
Match on 7, fail on parent(steve, mary)
Match on 8, (steve, Z), ancestor(Z, mary)
Z = peter
ancestor(peter, mary)
match on 7, parent(peter, mary)
X = peter
Y = mary
Match on 5, success of parent(peter, mary)

7, 8, 1, 7, 8, 3, 7, 5
```