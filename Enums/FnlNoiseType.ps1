using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# FNL NOISE TYPE
#
# AN ENUMERATION PEGGED TO THE FAST NOISE LITE IMPLEMENTATION.
#
# DEFINES THE TYPE OF NOISE TO GENERATE. I'M NOT GOING TO CLAIM THAT I UNDERSTAND
# ALL OF THEM TO ANY SIGNIFICANT DEGREE.
#
#//////////////////////////////////////////////////////////////////////////////

Enum FnlNoiseType {
    OpenSimplex2
    OpenSimplex2S
    Cellular
    Perlin
    ValueCubic
    Value
}
