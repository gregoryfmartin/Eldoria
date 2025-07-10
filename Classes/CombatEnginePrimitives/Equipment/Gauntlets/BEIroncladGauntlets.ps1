using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONCLADGAUNTLETS
#
###############################################################################

Class BEIroncladGauntlets : BEGauntlets {
	BEIroncladGauntlets() : base() {
		$this.Name               = 'Ironclad Gauntlets'
		$this.MapObjName         = 'ironcladgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Exceptionally sturdy gauntlets, heavy but impenetrable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
