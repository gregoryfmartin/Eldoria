#//////////////////////////////////////////////////////////////////////////////
#
# AT STRING PREFIX NONE
#
# AN ABSTRACTION OF AT STRING PREFIX INTENDED TO IMPLY NO ANSI MODIFIERS BE
# APPLIED TO A PRECEEDING STRING LITERAL.
#
#//////////////////////////////////////////////////////////////////////////////
Class ATStringPrefixNone : ATStringPrefix {
    ATStringPrefixNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
