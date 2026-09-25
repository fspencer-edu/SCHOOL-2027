# What is reinforcement learning?

- RL is an area of machine learning inspired by behavioural psychology
- Cumulative rewards or penalties for the actions that are taken by an agent in a dynamic environment
- Positive reinforcement
- Negative reinforcement
- Instant gratification
- Long term consequences
# Problems applicable to reinforcement learning

- Individual actions build up toward a greater goal
	- Strategic planning
	- Industrial process automation
	- Robotics

# The life cycle of reinforcement learning

- Markov Decision Process
	- Provides mathematical framework for modeling
	- Quantifies decisions made and their outcomes

- Agent
	- A entity that can take actions in the environment
- Simulating the environment
	- Initialize
	- Current state
	- Apply an action
	- Calculate the reward of the action
	- Determine if goal is achieved

## Training with the simulation using Q-learning

- Q-learning
	- An approach in reinforcement learning that uses the states and actions in an environment to model a table that contains information describing favourable actions based on specific states
	- Dictionary in which the key is the state, and the value is the best action
- Q-table
	- Columns that represent the possible actions and rows that represent the possible states in the environment
- Initialize
	- Initialize Q-table
	- Set parameters
		- Chance of choosing a random action
		- Learning rate
		- Discount factor
	- Repeat for n interactions
		- Initialize simulator
		- Get environment state
		- Goal achieved?
		- Pick a random action
		- Reference action in Q-table
		- Apply action to environment
		- Update Q-table

- Bellman equations
	- Used to update the values of the Q-table
	- Determines the value of a decision made at a certain point in time
- Learn rate($\alpha$)
- Discout ($\gamma$)

## Testing with the simulation and Q-table

- Q-table is the model that encompasses the learnings
- Agent favours short term reward over long term rewards
- Episodes
	- Includes all the states between the initial state and the state when the goal is achieved
- Infinite
	- If goal is never achieved

## Measuring the performance of training

- Count the number of penalties in a given number of attempts
- Average reward per action
	- Avoid poor actions
	- Divide cumulative reward by total number of actions

## Model free and model based learning

- Model based
	- Simulate scenarios with predefined landmarks, layout, and environment
- Model free
	- Trial and error is used to explore interactions with the environment

# Deep learning approaches to reinforcement learning

- Deep reinforcement learning
	- Use ANNs to process the states of an environment and produce an action
	- Actions are learned by adjusting weights in the AN
	- Using reward feedback and change sin the environment

# Use cases for reinforcement learning

- Robotics
- Recommendation engines
- Financial trading
- Game playing