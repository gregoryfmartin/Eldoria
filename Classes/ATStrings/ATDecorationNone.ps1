#//////////////////////////////////////////////////////////////////////////////
#
# AT DECORATION NONE
#
# AN ABSTRACTION OF AT DECORATION INTENDED TO IMPLY NO ANSI DECORATORS BE
# APPLIED TO THE PRECEEDING STRING LITERAL.
#
#//////////////////////////////////////////////////////////////////////////////
Class ATDecorationNone : ATDecoration {
    ATDecorationNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
