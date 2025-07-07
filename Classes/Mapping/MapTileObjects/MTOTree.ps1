using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO TREE
#
###############################################################################

Class MTOTree : MapTileObject {
    [Boolean]$HasRopeTied

    MTOTree() {
        $this.Name              = 'Tree'
        $this.MapObjName        = 'tree'
        $this.CanAddToInventory = $false
        $this.ExamineString     = 'It''s a tree. Looks like all the other ones.'
        $this.Effect = {
            <#
            Note the pattern here for the params. In order for state changes to work, the ScriptBlock will need to have two arguments:
            A reference to the object itself, and the source. AFAIK, this is because of how the ScriptBlock gets invoked. The $this reference
            doesn't work as it references the CommandWindow instance rather than the owning object (in this case, MTOTree). Because of this
            somewhat counterintuitive nature, the caller (in this case, the 'use' command) will invoke the ScriptBlock with two arguments that
            match the signature here. State changes can be inflicted upon Self (passed as a reference), and Source gets removed from the Player's
            Inventory.
            #>
            Param(
                [MTOTree]$Self,
                [Object]$Source
            )

            Switch($Source.PSTypeNames[0]) {
                'MTORope' {
                    $Script:TheMessageWindow.WriteTiedRopeToTreeMessage()

                    <#
                    It's important to note that this action *SHOULD* cause a state change with this object. To be more specific,
                    prior to running this action, it's assumed that the Tree did NOT have a Rope tied to it. After this action,
                    it does. So the questions now are (A) can you tie another Rope to the Tree, and (B) what can you do with the Tree
                    now that it has a Rope tied to it?

                    Also, the Rope should be removed from the Player's Inventory, but I don't yet have that functionality in place.

                    UPDATE: I have this functionality in place.
                    #>
                    $Self.HasRopeTied   = $true
                    $Self.ExamineString = 'A rope is tied to this tree. Wee.'
                    $Script:ThePlayer.RemoveInventoryItemByName($Source.Name)
                }
            }
        }
        $this.TargetOfFilter = @(
            'MTORope'
        )
        $this.HasRopeTied = $false
    }
}

