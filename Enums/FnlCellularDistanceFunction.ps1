using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# FNL CELLULAR DISTANCE FUNCTION
#
# AN ENUMERATION PEGGED TO THE FAST NOISE LITE IMPLEMENTATION.
#
# SPECIFIES THE TYPE OF CELLULAR DISTANCE FUNCTION TO USE DURING EVALUATION.
#
#//////////////////////////////////////////////////////////////////////////////

Enum FnlCellularDistanceFunction {
    Euclidean
    EuclideanSq
    Manhattan
    Hybrid
}
