using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# FNL DOMAIN WARP TYPE
#
# AN ENUMERATION PEGGED TO THE FAST NOISE LITE IMPLEMENTATION.
#
# SPECIFIES THE TYPE OF DOMAIN WARP TO USE DURING EVALUATION.
#
###############################################################################

Enum FnlDomainWarpType {
    OpenSimplex2
    OpenSimplex2Reduced
    BasicGrid
}
