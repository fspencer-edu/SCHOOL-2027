# Introduction to Problem Solving and Planning

- What is a planning problem?
	- A planning problem is a situation where an AI agent must decide which actions to perform, and in what order, to accomplish a goal
- Sequential decision making

# 4 Components of a planning problem

- Initial state
- Goal state
- Available actions
- Plan

- Operator properties
	- Preconditions
		- Conditions that must be true before performing the action
	- Effects
		- Changes the occur after performing the action

- Representing states as vectors
	- Instead of storing the entire environment, AI planning systems usually represent only the information needed to solve the problem

- 3 coins, each with two possibilities
	- Left, middle, right
	- State contains $2^3 = 8$ possible state

```prolog
[h, h, t]

[h, h, h]
[t, h, t]
[t, t, t]
[h, t, h]

% goal state
[h, h, h]
[t, t, t]
```

- State space graph