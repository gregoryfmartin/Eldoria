using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# AT STRING COMPOSITE
#
# AN AGGREGATE OF AT STRING INSTANCES IN A COLLECTION. THIS CLASS PERMITS FOR
# PRETTY COMPLEX DISPLAYS BY COMBINING MULTIPLE INDEPENDENT AT STRING INSTANCES
# INTO ONE.
#
# RELIES ON:
#   SYSTEM.COLLECTIONS.GENERIC.LIST
#   ATSTRING
#
#//////////////////////////////////////////////////////////////////////////////
Class ATStringComposite {
    [List[ATString]]$CompositeActual = [List[ATString]]::new()

    ATStringComposite() {
        If($null -EQ $this.CompositeActual) {
            $this.CompositeActual = [List[ATString]]::new()
        }

        $this.CompositeActual.Add([ATStringNone]::new()) | Out-Null
    }

    ATStringComposite(
        [ATString[]]$Components
    ) {
        If($null -EQ $this.CompositeActual) {
            $this.CompositeActual = [List[ATString]]::new()
        }

        Foreach($a in $Components) {
            $this.CompositeActual.Add($a) | Out-Null
        }
    }

    ATStringComposite(
        [List[ATString]]$Components
    ) {
        $this.CompositeActual = $Components
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        Foreach($b in $this.CompositeActual) {
            $a += $b.ToAnsiControlSequenceString()
        }

        Return $a
    }
}
