# Defining heuristics: Designing educated guesses

- Informed search
	- The algorithm has some context of specific problem being solved
- Heuristic
	- A rule or set of rules used to evaluate a state
	- Define criteria that a state must satisfy or measure the performance of a specific state
	- Context specific

# Informed search: Looking for solutions with guidance

- Informed search is an algorithm that uses both breadth-first search and depth-first search
- Combined with some intelligence and predefined knowledge

## A* Search

- A* search
	- Improves performance by estimating heuristics to minimize the cost of the next node visited
- Total cost
	- Total distance from the start node to the current node
	- Estimated cost of moving to a specific node by using a heuristic
- Saves computation time
- Internally targets odes that are cheaper to visit
- Stack is ordered by cost ascending every time a new calculation happens
- Ignores nodes that cost more than nodes already visited

## Use cases for informed search algorithms

- Path finding for autonomous game characters in video games
- Parsing paragraphs in NLP
- Telecommunications network routing
- Single player games

# Adversarial search: Looking for solutions in a changing environment

- Adversarial search
	- Require problems to anticipate, understand, and counteract the actions of the opponent in pursuit of a goal

## Min-max search: Simulate actions and choose the best future

- Min-max search
	- Aims to build a tree of possible outcomes based on moves that each player could make and favour paths that are advantageous, and avoid paths that are favourable to the opponent
- Score is defined by heuristics and is not learned by the algorithm
- Recursive function
## Alpha-beta pruning: Optimize by exploring the sensible path only

- Alpha-beta pruning
	- Technique used with the min-max search algorithm to short-circuit exploring areas of the game tree
	- Optimizes the min-max search algorithms to save computations
	- Insignificant paths are ignored
	- Sorts the best score for maximizing player, and best score for minimizing player as alpha and beta, respectively

## use cases for adversarial search algorithms

- Creating game-playing agents for turn-based games
- Adversarial search and ant colony optimization (ACO) for route optimization

# Summary of Intelligent search
