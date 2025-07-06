#//////////////////////////////////////////////////////////////////////////////
#
# AT FOREGROUND COLOR 24 NONE
#
# AN ABSTRACTION OF AT FOREGROUND COLOR 24 INTENDED TO BE USED TO IMPLY NO
# FOREGROUND COLOR IN THE PRECEEDING STRING LITERAL.
#
#//////////////////////////////////////////////////////////////////////////////
Class ATForegroundColor24None : ATForegroundColor24 {
    ATForegroundColor24None() : base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
