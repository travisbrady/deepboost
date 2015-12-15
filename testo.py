import numpy as np
import deepboost
from sklearn.datasets import load_iris

def main():
    print 'python'
    iris = load_iris()
    X, y = iris.data, iris.target
    y = y.astype(np.int32)
    clf = deepboost.PyModel()
    print clf
    clf.fit(X, y)
    print clf


if __name__ == '__main__':
    main()
