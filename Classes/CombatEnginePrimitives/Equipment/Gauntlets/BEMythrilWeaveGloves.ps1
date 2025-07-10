using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYTHRILWEAVEGLOVES
#
###############################################################################

Class BEMythrilWeaveGloves : BEGauntlets {
	BEMythrilWeaveGloves() : base() {
		$this.Name               = 'Mythril Weave Gloves'
		$this.MapObjName         = 'mythrilweavegloves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from fine mythril, light and extremely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
