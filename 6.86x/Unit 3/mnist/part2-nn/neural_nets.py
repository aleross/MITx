import numpy as np
import math

"""
 ==================================
 Problem 3: Neural Network Basics
 ==================================
    Generates a neural network with the following architecture:
        Fully connected neural network.
        Input vector takes in two features.
        One hidden layer with three neurons whose activation function is ReLU.
        One output neuron whose activation function is the identity function.
"""


#pragma: coderesponse template
def rectified_linear_unit(x):
    """ Returns the ReLU of x, or the maximum between 0 and x."""
    return np.maximum(0, x)
#pragma: coderesponse end

#pragma: coderesponse template
def rectified_linear_unit_derivative(x):
    """ Returns the derivative of ReLU."""
    return 0 if x <= 0 else 1
#pragma: coderesponse end

def output_layer_activation(x):
    """ Linear function, returns input as is. """
    return x

def output_layer_activation_derivative(x):
    """ Returns the derivative of a linear function: 1. """
    return 1

class NeuralNetwork():
    """
        Contains the following functions:
            -train: tunes parameters of the neural network based on error obtained from forward propagation.
            -predict: predicts the label of a feature vector based on the class's parameters.
            -train_neural_network: trains a neural network over all the data points for the specified number of epochs during initialization of the class.
            -test_neural_network: uses the parameters specified at the time in order to test that the neural network classifies the points given in testing_points within a margin of error.
    """

    def __init__(self):

        # DO NOT CHANGE PARAMETERS
        self.input_to_hidden_weights = np.matrix('1 1; 1 1; 1 1')
        self.hidden_to_output_weights = np.matrix('1 1 1')
        self.biases = np.matrix('0; 0; 0')
        self.learning_rate = .001
        self.epochs_to_train = 10
        self.training_points = [((2,1), 10), ((3,3), 21), ((4,5), 32), ((6, 6), 42)]
        self.testing_points = [(1,1), (2,2), (3,3), (5,5), (10,10)]

#pragma: coderesponse template prefix="class NeuralNetwork(NeuralNetworkBase):\n\n"
    def train(self, x1, x2, y):

        #print('\n')
        #print('Training on: ({},{}) with label: {}'.format(x1, x2, y))
        
        ### Forward propagation ###
        X = np.matrix([[x1],[x2]])
        W1 = self.input_to_hidden_weights
        B1 = self.biases
        W2 = self.hidden_to_output_weights

        # Calculate the input and activation of the hidden layer
        Z1 = W1 @ X + B1
        A1 = np.vectorize(rectified_linear_unit)(Z1)

        Z2 = W2 @ A1
        A2 = np.vectorize(output_layer_activation)(Z2)
        Yh = A2

        print('Prediction: {}, Actual: {}, Loss: {}'.format(Yh, y, np.sum(1/2 * (y - Yh)**2)))
        
        ### Backpropagation ###

        # Compute gradients

        # Output layer
        dL_A2 = -(y - A2)
        dA2_Z2 = np.vectorize(output_layer_activation_derivative)(Z2)
        dL_Z2 = dL_A2 * dA2_Z2 # Loss wrt output layer/neuron
        
        # Hidden layer
        dL_W2 = 1./A1.shape[1] * dL_Z2 @ A1.T # (1,3)
        dL_A1 = W2.T @ dL_Z2 # (1,3)
        dA1_Z1 = np.vectorize(rectified_linear_unit_derivative)(Z1)
        dL_Z1 = np.multiply(dL_A1, dA1_Z1)

        # Input layer
        dL_W1 = 1./X.shape[1] * dL_Z1 @ X.T
        dL_B1 = dL_Z1
        
        #print('W2 grad: {}, W1 grad: {}, B1 grad: {}'.format(dL_W2, dL_W1, dL_B1))
        
        # Use gradients to adjust weights and biases using gradient descent
        self.biases = self.biases - self.learning_rate * dL_B1
        self.input_to_hidden_weights = self.input_to_hidden_weights - self.learning_rate * dL_W1
        self.hidden_to_output_weights = self.hidden_to_output_weights - self.learning_rate * dL_W2
#pragma: coderesponse end

#pragma: coderesponse template prefix="class NeuralNetwork(NeuralNetworkBase):\n\n"
    def predict(self, x1, x2):

        input_values = np.matrix([[x1],[x2]])

        # Compute output for a single input(should be same as the forward propagation in training)
        
        # Hidden layer
        hidden_layer_weighted_input = self.input_to_hidden_weights @ input_values + self.biases # (3 by 1 matrix)
        hidden_layer_activation = np.vectorize(rectified_linear_unit)(hidden_layer_weighted_input) # (3 by 1 matrix)
        
        # Output layer
        output = self.hidden_to_output_weights @ hidden_layer_activation
        activated_output = np.vectorize(output_layer_activation)(output)

        return activated_output.item()
#pragma: coderesponse end

    # Run this to train your neural network once you complete the train method
    def train_neural_network(self):

        for epoch in range(self.epochs_to_train):
            print('Epoch #', epoch)
            for x,y in self.training_points:
                self.train(x[0], x[1], y)
            print('\n')

    # Run this to test your neural network implementation for correctness after it is trained
    def test_neural_network(self):

        for point in self.testing_points:
            print("Point,", point, "Prediction,", self.predict(point[0], point[1]))
            if abs(self.predict(point[0], point[1]) - 7*point[0]) < 0.1:
                print("Test Passed")
            else:
                print("Point ", point[0], point[1], " failed to be predicted correctly.")
                return

x = NeuralNetwork()

x.train_neural_network()

# UNCOMMENT THE LINE BELOW TO TEST YOUR NEURAL NETWORK
# x.test_neural_network()
