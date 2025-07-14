using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLADEMASTERGAUNTLETSII
#
###############################################################################

Class BEBlademasterGauntletsII : BEGauntlets {
	BEBlademasterGauntletsII() : base() {
		$this.Name               = 'Blademaster Gauntlets II'
		$this.MapObjName         = 'blademastergauntletsii'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 15
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhanced Blademaster Gauntlets, greater precision and offense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
