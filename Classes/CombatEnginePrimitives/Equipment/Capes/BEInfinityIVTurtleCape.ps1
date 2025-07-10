using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYIVTURTLECAPE
#
###############################################################################

Class BEInfinityIVTurtleCape : BECape {
    BEInfinityIVTurtleCape() : base() {
		$this.Name               = 'Infinity IV Turtle Cape'
		$this.MapObjName         = 'infinityivturtlecape'
		$this.PurchasePrice      = 140000
		$this.SellPrice          = 0
		$this.TargetStats        = @{
            [StatId]::Luck = 250
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'I would give Cici a flower!'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
    }
}
