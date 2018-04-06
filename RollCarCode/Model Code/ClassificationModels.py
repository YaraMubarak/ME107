#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 14:08:30 2018

@author: ymubarak
"""

import numpy as np 

class LinearPoly():
    def __init__(self, Xtrain,Ytrain) : 
        self.X = Xtrain 
        self.Y = Ytrain 
    
    def train( self):
        w= np.linalg.lstsq(self.X, self.Y)
        self.w = w[0]
    def pred(self, X):
        return np.matmul(X,self.w)
    def perc_error(self,X,Y):
        ypred = self.pred(X)
        return sum((Y - ypred)**2)/float(len(Y)) 
    
class Poly2() : 
    def __init__(self, Xtrain,Ytrain) : 
        self.X = self.makeX(Xtrain) 
        self.Y = Ytrain 
    
    def makeX(self,x):
        D = 2 
        return assemble_feature(x,D)
    
    def train( self):
        w= np.linalg.lstsq(self.X, self.Y)
        self.w = w[0]
        
    def pred(self, X):
        return np.matmul(self.makeX(X),self.w)
    
    def perc_error(self,X,Y):
        ypred = self.pred(X)
        return sum((Y - ypred)**2)/float(len(Y)) 
    

def assemble_feature(x, D):
    flag = False 
    if len(x.shape)  == 1 : 
        x  = np.vstack([x,x])
        flag = True 
        
    n_feature = x.shape[1]
        
    Q = [(np.ones(x.shape[0]), 0, 0)]
    i = 0
    while Q[i][1] < D:
        cx, degree, last_index = Q[i]
        for j in range(last_index, n_feature):
            Q.append((cx * x[:, j], degree + 1, j))
        i += 1
        
    stack =  np.column_stack([q[0] for q in Q])
    
    if flag : 
        stack= stack[0,:]
        
    return stack 