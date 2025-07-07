using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# AT DECORATION NONE
#
# AN ABSTRACTION OF AT DECORATION INTENDED TO IMPLY NO ANSI DECORATORS BE
# APPLIED TO THE PRECEEDING STRING LITERAL.
#
# INHERITS:
#   ATDECORATION
#
###############################################################################

Class ATDecorationNone : ATDecoration {
    ATDecorationNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
