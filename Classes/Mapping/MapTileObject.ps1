using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# MAP TILE OBJECT
#
# DESPITE THE NAME, THIS REPRESENTS AN OBJECT THAT THE PLAYER CAN INTERACT WITH
# EITHER DIRECTLY ON THE MAP OR BY OWNING IT IN THEIR ITEM INVENTORY. THESE ARE
# ALSO THE ITEMS THAT ARE GIVEN TO THE PLAYER AS SPOILS WHEN DEFEATING CERTAIN
# ENEMIES.
#
# IT'S WORTH MENTIONING THE TARGETOFFILTER PROPERTY.
#
###############################################################################

Class MapTileObject {
    [String]$Name
    [String]$MapObjName
    [ScriptBlock]$Effect
    [Boolean]$CanAddToInventory
    [String]$ExamineString
    [List[String]]$TargetOfFilter
    [ScriptBlock]$BaseEffectCall
    [String]$PlayerEffectString
    [Boolean]$KeyItem

    MapTileObject() {
        $this.Name               = ''
        $this.MapObjName         = ''
        $this.Effect             = {}
        $this.CanAddToInventory  = $false
        $this.ExamineString      = ''
        $this.TargetOfFilter     = @()
        $this.PlayerEffectString = ''
        $this.KeyItem            = $false
        $this.BaseEffectCall     = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }
    }

    [Boolean]ValidateSourceInFilter([String]$SourceItemClass) {
        Return ($SourceItemClass -IN $this.TargetOfFilter)
    }
}
