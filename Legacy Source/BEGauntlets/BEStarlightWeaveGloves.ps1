using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARLIGHTWEAVEGLOVES
#
###############################################################################

Class BEStarlightWeaveGloves : BEGauntlets {
	BEStarlightWeaveGloves() : base() {
		$this.Name               = 'Starlight Weave Gloves'
		$this.MapObjName         = 'starlightweavegloves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from starlight, shimmering and ethereal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
