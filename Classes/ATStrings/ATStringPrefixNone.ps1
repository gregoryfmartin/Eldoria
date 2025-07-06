using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# AT STRING PREFIX NONE
#
# AN ABSTRACTION OF AT STRING PREFIX INTENDED TO IMPLY NO ANSI MODIFIERS BE
# APPLIED TO A PRECEEDING STRING LITERAL.
#
# INHERITS:
#   ATSTRINGPREFIX
#
#//////////////////////////////////////////////////////////////////////////////
Class ATStringPrefixNone : ATStringPrefix {
    ATStringPrefixNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
