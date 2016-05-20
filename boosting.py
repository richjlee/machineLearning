import numpy as np
import pandas as pd
from scipy.interpolate import UnivariateSpline
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor
from sklearn import tree
from sklearn.cross_validation import train_test_split

def boost(B, lam):
    """
    Gradient boosting function with one-dimensional spline as base function.
    Requires pandas data frames as training and test sets (train, test).
    User is then asked to input column index numbers of data frame to
    choose dependent and independent variables.

    B    Number of iterations (int)
    lam  Lambda - tuning parameter (float)

    Output: Prints training and test MSE
    """
    
    dep = int(input('Enter number for dependent variable: '))
    ind = int(input('Enter number for independent variable: '))

    #initial one-dimensional spline
    x = train.as_matrix(columns=[train.columns[ind]]) #convert to numpy array
    y = train.as_matrix(columns=[train.columns[dep]])
    test_x = test.as_matrix(columns=[test.columns[ind]])
    test_y = test.as_matrix(columns=[test.columns[dep]])
    s = UnivariateSpline(x, y, s=len(train.index) * y.var())
    fitted = s(x)
    r = y-s(x) #residuals

    #initialize
    t = tree.DecisionTreeRegressor()
    f_res = 0
    #fit regression tree to residuals and iterate
    for i in range(0, B):
        r = r-f_res #update residuals
        t.fit(x, r)
        f_res = t.predict(x).reshape(-1,1) #fitted residuals
        f_res[:] = [x*lam for x in f_res] #multiply fitted residuals by lambda
        fitted = fitted + f_res

    #calculate training MSE
    train_mse = ((fitted-y)*(fitted-y)).mean()
    #calculate test MSE
    test_fitted = t.predict(test_x).reshape(-1,1)
    test_mse = ((test_fitted-test_y)*(test_fitted-test_y)).mean()

    print('\nTraining MSE:', train_mse)
    print('Test MSE:', test_mse)
    print('Iterations:', B)
