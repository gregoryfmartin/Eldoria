using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# CONTEXT
#
# THE ONE THING THAT YOU YOUNG WHIPPER SNAPPERS DON'T UNDERSTAND. GET FUCKED.
#
###############################################################################

Class Context {
    [Object[]]$References
    # [Hashtable]$References

    Context() {
        $this.References = @{}
    }

    Context(
        [Object[]]$References
    ) {
        $this.References = ($null -EQ $References) ? @() : $References
        
        # $this.References = @{}

        # If($null -NE $References) {
        #     Foreach($Item in $References) {
        #         $this.References[($Item.PSTypeNames[0]).ToString()] = $Item
        #     }
        # }
    }
}
