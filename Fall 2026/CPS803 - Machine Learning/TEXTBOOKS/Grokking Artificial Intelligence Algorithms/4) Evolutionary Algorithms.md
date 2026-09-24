
# What is evolution?

- The theory of evolution
	- Living organisms that we see today did not exist, nut have evolved through millions of years and subtle changes
	- Each generation adapting to its environment
	- Physical and cognitive characteristics of each living organism are a result of best fitting to its environment for survival

- Population attributes
	- Variety
	- Hereditary
	- Selection
- Process of evolution
	- Reproduction
	- Crossover and mutation

# Problems applicable to evolutionary algorithms

- Knapsack Problem
	- A knapsack has a specific max weight that it can hold
	- Each item has a weight and value
	- Maximize the total value and weight threshold
- Performance
	- How well a specific configuration does in finding a solution
- Stochastic
	- The output of the algorithms is likely to be different each time it is run

# Genetic algorithms: Life cycle

- The genetic algorithm is a specific algorithm in the family of evolutionary algorithms
- Genetic algorithms are used to evaluate large search spaces for a good solution
- Finds global best while avoiding local best
- Global best

- Life cycle of a genetic algorithm
	- Creating a population
	- Measuring the fitness of individuals in the population
	- Selecting parents based on their fitness
	- Reproducing individuals from parents
	- Populating the next generation

# Encoding the solution spaces

- State
	- A data structure with specific rules that represent possible solutions to a problem
- Binary encoding
	- Represents items with 0s and 1

## Binary encoding: Representing possible solutions with zeros and ones

- Express the presence of a specific element or even encoding numeric values as binary numbers
- More performant due to the use of primitive types
- Less demand on working memory

# Creating a population of solutions

- Only solutions that satisfy the weight-limit constraint should be considered
# Measuring fitness of individuals in a population

- Fitness defines how well a solution performs
# Selecting parents based on their fitness

- Select parents that will produce new individuals
- Roulette-wheel selection
	- Gives different individuals portions of a wheel based on their fitness
	- Higher fitness gives an individual a higher chance
- Population models are ways to control the diversity of a population
	- Steady state
	- Generational

## Steady state: Replacing a portion of the population each generation

- Majority of the population is retained
- Small group of weaker individuals are removed and replaced with new offspring

## Generational: Replacing the entire population each generation

- Creates a number of offspring individuals equal to the population size and replaces entire population

## Roulette wheel: Selecting parents and surviving individuals

- Probabilistic selection

# Reproducing individuals from parents

- Crossover
	- Mixing part of the chromosome of the first parent with part of the chromosome of the second
- Mutation
	- Randomly changing the offspring slightly to create variation in the population
- Single crossover
- Two-point crossover
- Uniform crossover
- Bit string mutation for binary encoding
	- A gene in a binary encoded chromosome is selected randomly and changed to another valid value
- Flit bit mutation for binary encoding
	- All genes in a binary encoded are inverted

# Populating the next generation

## Exploration vs. Exploitation

- Diversity in the individuals and the population have different potential solutions in the search space
- Stronger local solution spaces are exploited to find the most desirable solution
## Stopping conditions

- When conditions are met so the algorithm can end
- Strongest individuals of the population at that generation is selected as the best solution
- Constant
	- Number of generations of runs
- Stop at a defined fitness
- Stagnation
	- Population yields solution of similar strength for several generations
# Configuring the parameters of a generic algorithm

- Encoding
- Population size
- Population initialization
- Number of offspring
- Parent selection method
- Crossover method
- Mutation rate
- Mutation method
- Generation selection methods
- Stopping conditions
# Use cases for evolutionary algorithms

- Predicting investor behaviour
- Feature selection in machine learning
- Code breaking and ciphers
# Summary of evolutionary algorithms

