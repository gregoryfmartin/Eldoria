#//////////////////////////////////////////////////////////////////////////////
#
# AT BACKGROUND COLOR 24 NONE
#
# AN ABSTRACTION OF AT BACKGROUND COLOR 24 INTENDED TO BE USED TO IMPLY NO
# BACKGROUND COLOR IN THE PRECEEDING STRING LITERAL.
#
#//////////////////////////////////////////////////////////////////////////////
Class ATBackgroundColor24None : ATBackgroundColor24 {
    ATBackgroundColor24None() : base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
