using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# AT COORDINATES NONE
#
# AN ABSTRACTION OF AT COORDINATES INTENDED TO IMPLY NO ANSI COORDINATE
# MODIFIER BE APPLIED TO THE PRECEEDING STRING LITERAL.
#
# INHERITS:
#   ATCOORDINATES
#
#//////////////////////////////////////////////////////////////////////////////
Class ATCoordinatesNone : ATCoordinates {
    ATCoordinatesNone() : base(0, 0) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
