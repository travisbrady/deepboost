from libcpp.vector cimport vector
from libcpp.pair cimport pair

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
    
    ctypedef vector[pair[float, Tree]] Model

cdef extern from "boost.h":
    void AddTreeToModel(vector[Example] &examples, Model* model)
    void EvaluateModel(vector[Example] &examples,
            Model &model,
            float *error,
            float *avg_tree_size,
            int *num_trees)

