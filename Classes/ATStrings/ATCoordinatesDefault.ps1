using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# AT COORDINATES DEFAULT
#
# AN ABSTRACTION OF AT COORDINATES INTENDED TO IMPLY AN ANSI COORDINATE
# MODIFIER BE APPLIED TO THE PRECEEDING STRING LITERAL THAT MOVES THE CURSOR TO
# A "DEFAULT" LOCATION.
#
# INHERITS:
#   ATCOORDINATES
#
###############################################################################

Class ATCoordinatesDefault : ATCoordinates {
    ATCoordinatesDefault() : base(18, 2) {}
}
