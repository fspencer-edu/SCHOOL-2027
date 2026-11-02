# Linguistics

- Classical approach to AI for NLU
- 


## Syntax and Semantics

- Syntax refers to how words are grouped together
- Defines what does a well-formed string of words look like

- Semantics refers to what the words mean

## Lexicon

- Lexicon specifies the word categories

- Article
	- a, the
- Adjective
	- happy, sad
- Proper nouns
	- Toronto
- Common nouns
	- sweater, park
- Transitive verbs
	- kick, eat
- Intransitive verbs
	- walk, 
- Copula (linking)
- Prepositions
- Pronouns
- Adverb
- Interjections

# Grammar Rules

- A grammar specifies the types of well-formed word groups
- Defined by a collection of rules describing how each group is formed
- Need to distinguish between
	- Lexical or terminal categories
		- Terminal in that they cannot be broken down further
	- Group or non-terminal categories like phrases or sentences
		- Non-terminal in that they consist of words

- Will use short abbreviations (NP instead of Noun-Phrase)

## Sampe Grammar

```prolog
S = sentence
NP = noun phrase
VP = verb phrase
PP = preposition phrase
Mods = modifier

S -> NP VP
VP -> copula_verb Mods
VP -> transititve_verb NP Mods
VP -> intransititve_verb Mods
Mods -> 
Mods -> PP Mods
NP -> proper_noun
NP -> article_NP2
NP2 -> adjective NP2
NP2 -> common_noun Mods
```

## Parse Tree

- Parsing involves taking a sequence of words and fitting them into a given grammar
- Words are at the leaves and categories are parent nodes

## Ambiguity

- A grammar is ambiguous if there are sequences that could have two distinct phrase trees

`the boy in the park with the hat`

<img src="/images/Pasted image 20261102123243.png" alt="image" width="500">


# Objective

- Write a program that does syntactic and semantic parsing
	- Prolog
	- Focus on noun phrases only
- Need to parse legal noun phrases according to a given grammar
- Determine the referent to a legal noun phrases
	- Find the names of an individual being referred to from KB

```prolo
who([a, person], X)
X = tom;
x = mary;
no

who([a, person, with, a, red, hat], X).
X = mary;
no

who([a, red, with, a person, hat], X).
no
```




# Three Main Parts

- Part 1 - Database
	- Represent facts in worlds we want to reason about

```prolog
% === DATABASE ===
person(john).
person(grace).
person(mark).
person(linda).

job(john, doctor).
job(grace, doctor).
job(mark, programmer).
job(linda, programmer).

size(john, small).
size(grace, big).
size(mark, small).
size(linda, small).

park(qbeach).
park(queens_park).

tree(tree01).
tree(tree02).
tree(tree03).

size(tree01, small).
size(tree02, small).
size(tree03, small).
```

- Part 2 - A Lexicon
	- Specifies vocabulary
	- What are words we want to use to interact with the system
	- What type are each of the words
	- How do they relate to the facts in the database?

- Part 3 - Parser/Interpreter
	- Set of grammatical rules defining well formed statements
	- Use back-chaining to decompose sentences into tree, connect to lexicon and database

## 3 Part Program

- A database
	- Represent facts in the worlds we want to reason about
- A lexicon
	- Specifies vocabulary
	- Types of each words and how they relate to the facts in the db
- Parser/Interpreter
	- Set of grammatical rules defining well formed statements
	- Use back-chaining to decompose sentence into tree, connect to lexicon and db


### Database

- Define a model of the world
	- What are the objects, properties, relationships between objects
- Not intended to be language specific
	- Connect to language to it with lexicon and the grammar

### Building the Lexicon

- Articles
	- an, an, the
- Common nouns
	- person, tree, hat
- Proper nouns
	- John, Queen's Park
- Prepositions
	- On, beside, with
- Adjectives
	- big, small, large, red, blue

- The database stores facts
	- Does not car about language
- Must identify the English words used in noun phrases
- Impose semantic constraint each word imposes on referents
- Prepositions involve two referents
	- "X on Y" = `on(X, Y)`
- Proper nouns are explicitly defined
	- Lexicon describes works we are interested in using
	- Database describes facts about the word using the concept

```prolog
% === LEXICON ===
article(a).
article(the).

common_noun(park, X) :- park(X).
common_noun(tree, X) :- tree(X).
common_noun(hat, X) :- hat(X).
common_noun(programmer, X) :- job(X, programmer).
common_noun(doctor, X) :- job(X, doctor).
common_noun(doc, X) :- job(X, doctor).
common_noun(doctor, X) :- hasPhD(X).
common_noun(medical_doctor, X) :- job(X, doctor), hasPhD(X).

% Adjectives
adjective(big, X) :- size(X, big).
adjective(snall, X) :- size(X, small).
adjective(red, X) :- colour(X, red).
adjective(blue, X) :- colour(X, blue).

% Prepositions
preposition(on, X, Y) :- on(X, Y).
preposition(in, X, Y) :- in(X, Y).
preposition(beside, X, Y) :- beside(X, Y).
preposition(beside, X, Y) :- beside(Y, X).

% Preposition "with"
preposition(with, X, Y) :- on(Y, X).
preposition(with, X, Y) :- in(Y, X).
preposition(with, X, Y) :- beside(X, Y).
preposition(with, X, Y) :- beside(Y, X).
```

# Grammar Rules

- A grammar specifies the types of well-formed word groups
- Defined by a collection of rules describing how each group is formed
- Need to distinguish between
	- Lexical or terminal categories (lower case)
		- `article` or `transitive_verb`
	- Group or non-terminal categories like phrases or sentences (upper case)

- Will use short abbreviations
- Rules have the following form

```
category -> cateogry1 category 2 ... categoryn
```

- Left category is non-terminal
- An the right may be terminal or non-terminal

## Parsing Noun Phrases

- Will pass noun phrases to parser/interpreter as a list

```prolog
Words = [a, small, programmer, beside, a, programmer]

np([Name], Name) :- proper_noun(Name)
np([Art|Rest], Who) :- article(Art), np2(Rest, Who)
```

<img src="/images/Pasted image 20261102133542.png" alt="image" width="500">

**Q** - `[a, small, programmer, beside, a, programmer]`
- Noun phrase

```prolog
NP (6)
	article -> a
	NP2 (7)
		adjective -> small
		NP2 (8)
			common_noun -> programmer
			Mods (10)
				PP (11)
					preposition -> beside
					NP (6)
						article -> a
						NP2 (8)
							common_noun -> programmer
							Mods (9) -> []
				
				Mods (9) -> []
```

**Q** - `[a, doctor, with, a, blue, hat, in, a, park]`

- Blue hat is in a park
- Hat is modified by in a park

```prolog
NP (6)
	article -> a
	NP2 (8)
		common_noun -> doctor
		Mods (10)
			PP (11)
				preposition -> with
				NP (6)
					article -> a
					NP2 (7)
						adjective -> blue
						NP2 (8)
							common_noun -> hat
							Mods (10)
								PP (11)
									preposition -> in
									NP (6)
										article -> a
										NP2 (8)
											common_noun -> park
								Mods (9) -> []
			Mods (9) -> []
```

- Alternative method
	- Preposition
	- Doctor in a park
	- Doctor is modified by in a park

```prolog
NP (6)
	article -> a
	NP2 (8)
		common_noun -> doctor
		Mods (10)
			PP (11)
				preposition -> with
				NP (6)
					article ->a
					NP2 (7)
						adjective -> blue
						NP2 (8)
							common_noun -> hat
							Mods (9) -> []
			Mods (10)
				PP (11)
					preposition -> in
					NP (6)
						article -> a
						NP2 (8)
							common_noun -> park
							Mods (9) -> []
```

**Q** - `[a, doctor, with, a, blue, hat, in, a, park, with, a, big, tree]`

```prolog
doctor <- blue hat <- park <- tree (3 modifiers)
blue hat <- park <- tree (2 modifiers)

```


**Q** - `[mary, saw, the, docter, with, the, telescope]`


## Sample Grammar for Noun Phrases

## Parses for Noun Phrases

- For each non-terminal category, will have a predicate in the parser
- Each parser predicate takes two arguments
	- First argument is list of words (input)
	- Second arguments is the referent (output)


```prolog
who(Words, Ref) -: np(Words, Ref).

np([Name], Name) :- proper_noun(Name).
np([Art|Rest], Who) :- article(Art), np2(Rest, Who).

np2([Adj|Rest], Who) :- adjective(Adj, Who), np2(Rest, Who).
np2([Noun|Rest], Who) :- common_noun(Adj, Who), modes(Rest, Who).

mods([], Who).
mods(Words, Who) :-
	append(Start, End, Words),
	pp(Start, Who), mods(End, Who).
	
pp([Prep|Rest], Who) :-
	preposition(Prep, Who, Who2), np(Rest, Who2)

```

## Tracing

**Q** - `who([a, small, programmer], X).`


**Q** - `who([a, programmer, beside, a, programmer], X).`


## Dealing with Ambiguity

**Q** - `np2([a, doctor, in, a, park, with, a, tree], D).`


### More Query Examples

```prolog
?- who([a, doctor, with, a, big, hat], X).
X = grace ; no

?- who([the, hat, on, grace], X).
X = hat04 ; no

?- who([a, doctor, in, a, park, with, a, big tree], X).
no

?- who([a, programmer, in, a, park, with, a, big, tree], X).
X = mark ; X = linda ; no

?- who([a, programmer, in, a, park, with, a, big, red, hat], X).
X = linda ; no

?- who([a, programmer, beside, a, programmer, with, a, blue, hat], X).
X = mark ; X = linda ; no

?- who([a, programmer, with, a, blue, hat, beside, a, woman], X).
X = mark ; no
```

## Completion and Generation

```prolog
?- who([the, W, on, john], hat01).
W = hat ; no

?- who([a, doctor, with, H], P), who([the, hat, on, P], H).
H = hat01, P = john ;
H = hat04, P = grace ;
No

?- who([a, X, Y], linda).
X = small, Y = programmer ; no

?- who(L, linda).
L = linda ;
Execution gets stuck in recursion constructing “a small small small ...”

?- L = [a, W, X, Y, Z], who(L, linda).
L = [a, small, small, small, programmer] ;
L = [a, small, programmer, in, queens_park] ;
L = [a, small, programmer, with, mark] ; 
```

## Interrogative Sentences

- Can add grammatical rules to handle interrogative sentences

```prolog
WH -> wh_word copula_verb NP    % what is X?
WH -> wh_word copula_verb PP    % who is in X
```

## Yes/No

```prolog
YN -> copula_verb NP NP    % Is X a Y?
YN -> copula_verb NP PP    % Is X with Y?
```

## Prolog for Yes/No Questions

```prolog
ynq([Verb|Rest], Answer) :- copula_verb(verb),
	append(W1, W2, Rest), np(W1, Ref), same_ref(W2, Ref, Answer)
	
same_ref(X, Ref, yes) :- np(X, Ref).
same_ref(X, Ref, yes) :- pp(X, Ref).
same_ref(X, Ref, no) :- np(X, Ref), not Ref = Ref2.
same_ref(X, Ref, no) :- pp(X, Ref), not Ref = Ref2
```