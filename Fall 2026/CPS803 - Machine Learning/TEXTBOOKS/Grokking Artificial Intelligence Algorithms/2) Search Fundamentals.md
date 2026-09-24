# What are planning and searching?

- Planning happens at different levels of detail in different contexts to strive for the best possible outcome when carrying out the tasks involved in accomplishing goals
- Searching is a way to guide planning by creating steps in a plan
- Searching involves evaluating future states toward a goal with the aim of dining an optimal path of states until the goal is reached
# Cost of computation: The reason for smart algorithms

- Big O notation
	- Describes the complexity of a function
- $O(1)$
	- Single operation
- $O(n)$
	- Function that iterates over a list
- $O(n^2)$
	- Function that compares every item in a list with every item in another list

# Problem applicable to searching algorithms

# Representing state: Creating a framework to represent problem spaces and solution

- Data is raw facts about something
- Information is an interpretation of those facts that provides insights about the data in the specific domain
- Information requires context and processing data to provide meaning
- Data structures are concepts in CS used to represent data in a way that is suitable for efficient processing by algorithms
	- Array
		- Collection of data
- Other data structures are useful in planning and searching

### Graphs: Representing search problems and solutions

- A graph is a data structure containing several states with connections among them
- Each state is a node, and a connection between two states is an edge

### Representing a graph as a concrete data structure

- Other representations of graphs include an incidence matrix, an adjacency matrix, and an adjacency list

### Trees: The concrete structures used to represent search solutions

- A tree is a popular data structure that simulates a hierarchy of values or objects
- A hierarchy is an arrangement of things in which a single object is related to several other objects below it
- A tree is connected acyclic graph
- The value or object represented at a specific point is called a node
- A path is a sequence of nodes and edges connecting nodes that are not directly connected
- Degree
	- Number of children a node has

# Uniformed search: Looking blindly for solutions

- Uniformed search also known as unguided search, blind search, or brute force search
- Have no additional information about the domain of the problem apart from the representation of the problem
- Breadth-first search (BFS)
	- Explores all options at a specific depth before moving to options deeper in the tree
- Depth-first search
	- Explores a specific path from the start until if finds a goal at the utmost depth

# Breadth-first search: Looking wide before looking deep

- Traverse or generate a tree
- Starts at the root, and explores every node at that depth before the next depth of nodes
- First-in, first-out queue
# Depth-first search: Looking deep before looking wide

- Depth first search used to traverse a tree or generate nodes and paths in a tree
# Use cases for uniformed search algorithms

- Finding paths between nodes in a network
- Crawling web pages
- Finding social network connection

## Graph Categories

- Undirected graph
- Directed graph
- Disconnected graph
- Acyclic graph
- Complete graph
- Complete bipartite graph
- Weighted graph