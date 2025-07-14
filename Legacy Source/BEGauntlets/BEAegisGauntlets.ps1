using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAEGISGAUNTLETS
#
###############################################################################

Class BEAegisGauntlets : BEGauntlets {
	BEAegisGauntlets() : base() {
		$this.Name               = 'Aegis Gauntlets'
		$this.MapObjName         = 'aegisgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with an invisible shield, deflecting attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
