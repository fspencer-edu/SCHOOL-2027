# What are artificial neural networks?

- Artificial neural networks (ANNs)
	- Unstructured data
- Deep learning
	- Algorithms that use ANNs in varying architectures to accomplish an objective
		- Supervised learning
		- Unsupervised learning
		- Reinforcement learning
- Nervous sysetm
	- Biological structure that allows us to feel sensations
	- Basis of how brain operates
- Interconnected neurons that pass information by using electrical and chemical signals
- Neuron
	- Dendrites that receive signals from other neurons
- Cell body and nucleus
	- Activates and adjust the signal
- Axon
	- Passes the signal to other neurons
- Synapses
	- Carry and adjust the signal
# The Perceptron: A representation of a neuron

- Perceptron
	- A logical representation of a single biological neuron
	- Alters inputs by using weights
- Inputs
- Weights
- Hidden nodes (sum and activation)
- Output

- Activation functions
	- Help solve a linear problem

# Defining artificial neural networks

- Min max scaling
	- Common way to scale data
	- Scales to values between 0 and 1
	- Scales all data to be a consistent format
	- Remove bias with large input values
	- Uses the min and max values for a feature and finds the percentage of the actual value for the feature
- Hidden layers
	- Not directly observed from the outside

- Data structures required for the algorithm
	- Input nodes
	- Weights
	- Hidden nodes
	- Output nodes

# Forward propagation: Using a trained ANN

- A train ANN is a network that has learned from examples and adjusted its weights to best predict the class of new examples

- Forward propagation
	- Input an example
	- Multiple inputs and weights
	- Sum results of weighted inputs for each hidden node
	- Activation function for each hidden node
	- Sum results of weighted outputs of hidden nodes to the output node
	- Activation function for output node

<img src="/images/Pasted image 20260924174848.png" alt="image" width="500">


# Backpropagation: Training an ANN


- Training an ANN
	- Setting up the ANN architecture
		- Inputs, outputs, hidden layers
	- Forward propagation
		- Predicted output will be compared with the actual class for each example in the training set to train the network
	- Backpropagation
		- Calculate cost
		- Update weights in the ANN
		- Define a stopping condition
- Cost function
	- Subtract predicted output from actual output
	- Result indicates how incorrect the prediction was
	- Used to adjust the weights


- Gradient descent
	- Move the weight closer to the min value by finding the derivative
- Derivative
	- Measure the sensitivity to change for that function
- The Chain Rule
	- A theorem from calculus that calculates the derivative of a composite function
- Calculate the weight update by plugging the respective values into the formula
- Apply the results to the weights in the ANN by adding the update value to the respective weight
- 

# Options for activation functions
# Designing artificial neural networks
# Artificial neural network types and use cases
