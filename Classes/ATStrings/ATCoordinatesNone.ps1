#//////////////////////////////////////////////////////////////////////////////
#
# AT COORDINATES NONE
#
# AN ABSTRACTION OF AT COORDINATES INTENDED TO IMPLY NO ANSI COORDINATE
# MODIFIER BE APPLIED TO THE PRECEEDING STRING LITERAL.
#
#//////////////////////////////////////////////////////////////////////////////
Class ATCoordinatesNone : ATCoordinates {
    ATCoordinatesNone() : base(0, 0) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
