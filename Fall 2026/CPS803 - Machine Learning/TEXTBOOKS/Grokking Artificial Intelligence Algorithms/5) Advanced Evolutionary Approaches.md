# Evolutionary algorithm life cycle 

# Alternative selection strategies

## Rank selection: Even the playing field

- More diversity means more exploration of the search space
- Ranks individuals based on their fitness and then using each individual's rank as the value for calculating the size of its slice on the wheel
- Better-performing solutions have a better chance of selection
## Tournament selection

- Randomly chooses a set of number of individuals from the population and places then in a group
- Individuals with the highest fitness score in each respective group is selected
- Larger the group the less diverse

## Elitism

- Selects the best individuals in the population
- Retaining strong-performing individuals and eliminating the risk that they will be lost through other selection methods
- Population can fall into a local best solution space

# Real-value encoding: Working with real numbers

- Real value encoding
	- Represents the item in terms of a numeric value, strings, or symbols
	- Expresses potential solutions in the natural state

## Arithmetic crossover

- Arithmetic operations to be computed by using each parent as variables in the expression
## Boundary mutation

- A item is randomly set to a lower bound or upper bound value
- Evaluate the impact of individual genes on the chromosome
## Arithmetic mutation

- A randomly selected item in a real-value-encoded set is changed by adding or subtracting a small number

# Order encoding: Working with sequences

- Order encoding, also called permutation encoding
	- Represents items as a sequence of elements
	- Requires all elements to be present
- Two randomly selected items swap positions

# Tree encoding: Working with hierarchies

- Represented as a tree of elements
- Potential solutions in hierarchy spaces

## Tree crossover: Inheriting portions of a tree

- A single point in the tree structure is selected and parts are exchanged with another parents
## Change node mutation

- A randomly selected node in a tree is changed to a randomly selected value object

# Common types of evolutionary algorithms

- Genetic programming
- Evolutionary programming

# Glossary of evolutionary algorithms terms
# More use cases for evolutionary algorithms

- Adjusting weights in artificial neural networks
- Electronic circuit design
- Molecular structure simulation and design
# Summary of advanced evolutionary approaches