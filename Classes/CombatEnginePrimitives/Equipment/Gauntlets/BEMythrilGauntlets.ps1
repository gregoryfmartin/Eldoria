using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYTHRILGAUNTLETS
#
###############################################################################

Class BEMythrilGauntlets : BEGauntlets {
	BEMythrilGauntlets() : base() {
		$this.Name               = 'Mythril Gauntlets'
		$this.MapObjName         = 'mythrilgauntlets'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of legendary mythril, light yet incredibly strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
