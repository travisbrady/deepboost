from libcpp.vector cimport vector
from libcpp.pair cimport pair
import  numpy as np
cimport numpy as np

np.import_array()

cdef extern from "types.h":
    cdef cppclass Example:
        vector[float] values
        int label
        float weight

    cdef cppclass Node:
        vector[Example] examples
        int feature
        float value
        int left_child_id
        int right_child_id
        float positive_weight
        float negative_weight
        int leaf
        int depth

    ctypedef vector[Node] Tree
    
    #ctypedef vector[pair[float, Tree]] Model
    cdef enum LossType: DB_LOSS_EXPONENTIAL, DB_LOSS_LOGISTIC
    cdef struct Model:
        vector[pair[float, Tree]] model
        LossType loss_type


cdef extern from "boost.h":
    void AddTreeToModel(vector[Example] &examples, Model* model)
    void EvaluateModel(vector[Example] &examples,
            Model &model,
            float *error,
            float *avg_tree_size,
            int *num_trees)
    int ClassifyExample(Example& example, Model& model)


cdef class PyModel:
    cdef Model* _c_model

    def __cinit__(self):
        cdef Model cm
        self._c_model = &cm
        self._c_model.loss_type = DB_LOSS_EXPONENTIAL

    def predict(self,
            np.ndarray[np.float64_t, ndim=2, mode='c'] X):
        cdef int nrows = X.shape[0]
        cdef int nfeats = X.shape[1]
        cdef vector[float] values = vector[float](nfeats)
        cdef Example ex
        cdef np.ndarray ret = np.zeros(nrows, dtype=np.int)
        for i in range(nrows):
            for j in range(nfeats):
                values.push_back(X[i, j])
            print i
            ex.values = values
            ex.weight = 1.0
            y_pred = ClassifyExample(ex, self._c_model[0])
            ret[i] = y_pred
        return ret

    def fit(self,
            np.ndarray[np.float64_t, ndim=2, mode='c'] X,
            np.ndarray[np.int32_t, ndim=1, mode='c'] Y):
        cdef int nrows = X.shape[0]
        cdef int nfeats = X.shape[1]
        cdef vector[Example] examples = vector[Example](nrows)
        cdef vector[float] values = vector[float](nfeats)
        cdef Example ex
        cdef Model model
        model.loss_type = DB_LOSS_EXPONENTIAL
        cdef float error
        cdef float avg_tree_size
        cdef int num_trees
        for i in range(nrows):
            for j in range(nfeats):
                values.push_back(X[i, j])
            ex.values = values
            ex.label = Y[i]
            ex.weight = 1.0
            examples.push_back(ex)

        print "HELLO"
        for i in range(20):
            print i
            AddTreeToModel(examples, &model)
        return self

