using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# AT STRING
#
# AN AGGREGATE THAT COMBINES AN AT STRING PREFIX, A TARGET STRING LITERAL TO
# APPLY THE ANSI MODIFIERS TO, AND AN OPTIONAL ANSI RESET MODIFIER TO APPEND
# TO THE RESULTANT STRING ENSURING THE MODIFIERS FROM THE PREFIX AREN'T CARRIED
# BEYOND THE LENGTH OF THE LITERAL.
#
# RELIES ON:
#   ATSTRINGPREFIX
#   ATSTRINGPREFIXNONE -> ATSTRINGPREFIX
#   ATCONTROLSEQUENCES
#
###############################################################################

Class ATString {
    [ValidateNotNull()][ATStringPrefix]$Prefix
    [ValidateNotNull()][String]$UserData
    [Boolean]$UseATReset

    ATString() {
        $this.Prefix     = [ATStringPrefixNone]::new()
        $this.UserData   = ''
        $this.UseATReset = $false
    }

    ATString(
        [ATStringPrefix]$Prefix,
        [String]$UserData,
        [Boolean]$UseATReset
    ) {
        $this.Prefix     = $Prefix
        $this.UserData   = $UserData
        $this.UseATReset = $UseATReset
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = "$($this.Prefix.ToAnsiControlSequenceString())$($this.UserData)"

        If($this.UseATReset -EQ $true) {
            $a += [ATControlSequences]::ModifierReset
        }

        Return $a
    }
}
