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

# Options for activation functions

- Activation functions introduce non-linear properties to the ANN

![[Pasted image 20260924224704.png]]

- Step unit
	- Binary classifier
- Sigmoid
	- Learning and solving non-linear problems
	- Pool learning
	- Vanishing gradient problem
- Hyperbolic tangent
	- Steep derivatives, for faster learning
- Rectified linear unit (ReLU)
	- Allows some neurons to not activate, which reduces computation

# Designing artificial neural networks

- Inputs and outputs
	- Define the interface of the network
- Hidden layers and nodes
	- More hidden layers allow to solve problem with higher dimensions and more complexity
- Weights
	- Starting point from which the weight will be adjusted over many iteration
	- Exploding gradient problem
		- Weights move around the desired result
- Bias
	- Adding a value to the weighed sum of the input nodes or other layers in the network
	- Shifts activation function
- Activation function
	- Ensure that all nodes on the same layer use the activation function
- Cost function and learning rate
	- Mean squared error
# Artificial neural network types and use cases

## Convolutional neural network

- CNN are designed for image recognition
- Find the relationship among different objects and unique areas within images
- Image recognition
	- Convolution operates on a single pixel and its neighbours in a certain radius
	- Edge detection
	- Image sharpening
	- Image blurring
- Convolution
	- Finds features in image
- Pooling
	- Downsamples the patterns by summarizing features
	- Allowing unique signatures in image to be encoded

## Recurrent neural network

- RNNs accept a sequence of inputs with no pre-determined length
- Memory consisting of hidden layers that represent time
- Allows the network to retain information about the relationship among the sequences of inputs
- Pretraining to speech and text recognition and prediction
## Generative adversarial network

- GAN consists of a generator network and a discriminator network
- Two components compete to incrementally generate the best solution
