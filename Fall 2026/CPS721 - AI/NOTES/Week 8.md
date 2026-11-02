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
- Need to parse elgal noun phrases according to a given grammar
- Determine the referent to a legal noun phrases
	- Find the names of an individual being referred to from 




# AI and NLU

- A computer language has a very clear form
	- Code needs to be exactly converted into machine language
	- No ambiguity so there are not unintended consequences
- Natural language is not so rigid
	- Interpret what others say based on common sense and our own knowledge

- 