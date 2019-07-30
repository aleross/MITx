#! /usr/bin/env python

import _pickle as cPickle, gzip
import numpy as np
from tqdm import tqdm
import torch
import torch.autograd as autograd
import torch.nn.functional as F
import torch.nn as nn
import sys
sys.path.append("..")
import utils
from utils import *
from train_utils import batchify_data, run_epoch, train_model

import copy

def main():
    # Load the dataset
    num_classes = 10
    X_train, y_train, X_test, y_test = get_MNIST_data()

    # Split into train and dev
    dev_split_index = int(9 * len(X_train) / 10)
    X_dev = X_train[dev_split_index:]
    y_dev = y_train[dev_split_index:]
    X_train = X_train[:dev_split_index]
    y_train = y_train[:dev_split_index]

    permutation = np.array([i for i in range(len(X_train))])
    np.random.shuffle(permutation)
    X_train = [X_train[i] for i in permutation]
    y_train = [y_train[i] for i in permutation]

    #validation_scores = [0.932487, 0.944388, 0.937834, 0.907587, 0.936497]
    #validation_scores2 = [0.977440, 0.977487, 0.978610, 0.968416, 0.978443]
    validation_scores = []
    best_validation = {'score': 0, 'param': None}
    test_scores = []
    
    baseline = {
        'batch_size': 32,
        'activation': nn.ReLU(),
        'lr': 0.1,
        'momentum': 0
    }
    
    grid = [(), ('batch_size', 64), ('lr', 0.1), ('momentum', 0.9), ('activation', nn.LeakyReLU())]
    
    for p in grid:
        np.random.seed(12321)  # for reproducibility
        torch.manual_seed(12321)  # for reproducibility
        print('Testing param:', p)
        params = copy.deepcopy(baseline)
        
        if len(p):
            params[p[0]] = p[1]
        
        # Split dataset into batches
        batch_size = params['batch_size']
        train_batches = batchify_data(X_train, y_train, batch_size)
        dev_batches = batchify_data(X_dev, y_dev, batch_size)
        test_batches = batchify_data(X_test, y_test, batch_size)

        #################################
        ## Model specification
        model = nn.Sequential(
                  nn.Linear(784, 128),
                  params['activation'],
                  nn.Linear(128, 10),
                )
        lr = params['lr']
        momentum = params['momentum']
        ##################################
    
        train_model(train_batches, dev_batches, model, lr=lr, momentum=momentum)
        
        ## Evaluate on validation data
        loss, accuracy = run_epoch(dev_batches, model.eval(), None)
        validation_scores += [accuracy]
        if accuracy > best_validation['score'] and len(p):
            best_validation['score'] = accuracy
            best_validation['param'] = p[0]
        
        ## Evaluate the model on test data
        loss, accuracy = run_epoch(test_batches, model.eval(), None)
        test_scores += [accuracy]

        print ("Loss on test set:"  + str(loss) + " Accuracy on test set: " + str(accuracy))
        
    print('Best validation:', best_validation)
    print('Validation scores:', validation_scores)
    print('Test scores:', test_scores)


if __name__ == '__main__':
    # Specify seed for deterministic behavior, then shuffle. Do not change seed for official submissions to edx
    np.random.seed(12321)  # for reproducibility
    torch.manual_seed(12321)  # for reproducibility
    main()
