#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 14:02:28 2018

@author: ymubarak
"""

import numpy as np 
from ClassificationModels import *
## load Data : 
# now simulate 
X = np.random.rand(200,3)
Y = np.random.rand(200,4)

def LOOvalidation(X,Y,model) : 
    error = 0
    for i in range(len(X)):
        print('Removing Point ' + str(i))
        Xtest = X[i,:]
        Ytest = Y[i,:]
        
        boolean = np.array(list(range(len(X)))) != i 
        Xtrain = X[boolean,:]
        Ytrain = Y[boolean,:]
        
        m  = model(Xtrain,Ytrain)
        m.train() 

        error = error + np.average(m.perc_error(Xtest,Ytest))
    error = error/float(len(X)) 
    return error

# =============================================================================
# lp = lp(X,Y)
# lp.train() 
# preds = lp.pred(X) 
# error = lp.perc_error(X,Y)
# =============================================================================
e = LOOvalidation(X,Y,NN)
    
# =============================================================================
# lp = Poly2(X,Y)
# lp.train() 
# preds = lp.pred(X) 
# error = lp.perc_error(X[1,:],Y[1,:])
# =============================================================================
