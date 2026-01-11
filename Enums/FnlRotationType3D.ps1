using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# FNL ROTATION TYPE 3D
#
# AN ENUMERATION PEGGED TO THE FAST NOISE LITE IMPLEMENTATION.
#
# DEFINES THE KINDS OF 3D ROTATIONS THAT CAN OCCUR DURING EVALUATION.
#
###############################################################################

Enum FnlRotationType3D {
    None
    ImproveXYPlanes
    ImproveXZPlanes
}
