
# Part 1 - Intro

- Goal of AI
	- Develop artifacts that can show behaviour, that is considered to humans as intelligence
	- Software based artifacts are called agents
	- Systems that think rationally
- "Thinking as Computation" textbook
	- Reasoning approaches based on viewing thinking as computation
	- Manipulate ideas procedurally
	- Logical inference
	- PROLOG
- Learning objectives
	- Formulate and trace queries in PROLOG
	- Compare PROLOG lists and write recursive programs
	- Solve constraint satisfaction problems
	- Analyze a given context-free grammar
	- Parse natural language phrases and identify sources of ambiguity
	- Solve planing problems using an iterative depth-first planner
	- Bayesian network for diagnosis and prediction
- Course material
	- Machine learning
	- Computer vision
	- Generative AI

# Part 2 - Thinking as Computation

- Thinking
	- Process that occurs in the brain
- Computational process
	- Procedure for manipulating symbols or characters to produce output
- Symbols and symbolic structures
	- Characters
		- Digits
		- Letters
		- Operators
	- String together characters into numerals or words
	- Complex groupings
	- Truth values
- Symbol manipulation procedures
- Complex behaviour from primitive operations

- Propositions vs sentences
	- Proposition
		- Idea expressed by a declarative sentence
		- Abstract entities
	- Sentences
		- Abstract entities

- Mechanizing reasoning
- Logical entailment
	- A collection of sentences logically entail a sentence $S$ if the truth of $S$ is implicit in the truth of all of the $S_i$
- Sentences are linked by terms that appear in them
- Logic can crawl over webs to make connections between terms
- Representing information used symbolic sentences
- Using logic of reason over these sentences
- Act according to the conclusions it derives
- Knowledge based systems
	- A collection of sentences is the knowledge base (KB)

# Part 3 - Back Chaining

- If-Then Reasoning
	- Atomic sentences
		- Simple primitives
	- Conditional sentences
		- If $P_1$ and $P_2$ and ... $P_n$, then $Q$
- Notation
	- Variables = capital letters
	- Constants = lowercase letters

- Back chaining
	- Computational procedure for deriving new conclusions
- Query (goal)
	- Given a KB, establish atomic sentence $Q$ is true
		- If $Q$ is in KB, done
		- Find a sentence of the form "If $P_1$ and $P_2$ and ... $P_n$, then $Q$"
		- Establish each of $P_i$ (call back chaining with $P_i$ as query)
	- If sentence has variables, replace with atoms

<img src="/images/Pasted image 20260914123002.png" alt="image" width="500">

<img src="/images/Pasted image 20260914132054.png" alt="image" width="500">
### Trace Examples

$Q =$ ioniq123 is a sedan
- Match (1) on $Q$

$Q =$   rav456 is a car
- $Q$ is not in KB
- Match on (4) with $X =$ rav456
- if rav456 is a suv, then rav456 is a car
- Match on (2)

$Q =$ ioniq123 is ev
- $Q$ is not in KB
- Match on (6) with $X =$ ioniq123
- Establish "ioniq123 is a car" and "ioniq123 is a electric"
	- "ioniq123 is a car" is not in KB
	- Match on (4) with $X =$ ioniq123
		- X $\neq$ suv
		- X $\neq$ car
	- Match on (5) with $X =$ ioniq123
		- X $=$ suv, then X $=$ car
- Match on (6) with X $=$ car amd X $=$ electric, therefore $X = ev$

- Retrieval
	- Use back-chaining to find individuals for a given property
	- Establish "ioniq123 is a car" $\rightarrow$  confirm that ioniq123 is a car
	- Establish "$Z$ is a car" $\rightarrow$  locate an individual $Z$ is a car

### Retrieval Examples

$Q =$ "$z$ is a car"
- Fail on (1-3)
- Match on (4) with $X=Z$
	- Establish "$Z$ is an suv"
	- Match on (2) with $Z =$ rav456
	- Fail on more suv
- Match on (5) with $X=Z$
	- Establish "$Z$ is an sedan"
	- Match on (1) with $Z =$ sedan

$Q =$ "$z$ is an ev"
- a) fail
- b) Match on (6) with $X=z$
	- Establish $Z$ is an car" and "$Z$ is an electric"
		- a) fail
		- b) match on (4) with $X=Z$
		- Establish "$Z$ is an suv"
			- c) match on (2) with "$Z =$ rav456", "rav456 is electric"
				- a) fail
				- b) fail
			- a) fail
			- b) fail, cannot find suv that is electric
		- b) match on (5) with $X=Z$
		- Establish "$Z$ is an sedam"
			- c) match on (1) with "$Z =$ ioniq123", "ioniq123 is electric"
				- a) Match on (3), success with "$Z =$ ioniq123


- Variables collision
	- Variables add an additional complication

- Properties of back chaining
	- Back chaining is sound
		- Anything it establishes is actually entailed by the KB
	- Back chaining is complete
		- Eventually entail establish any possible atomic entailments
		- Avoid cyclic rules
			- "If X is a car, then X is a car"
	- Back chaining is goal directed
		- Start with what you want, not just what you known (forward chaining)

- Back chaining as a computation process
	- PROLOG (Programming in Logic)
		- Declarative language
		- Define a knowlege base (program)
		- Make queries
		- Program execution is back-chaining with back tracking
