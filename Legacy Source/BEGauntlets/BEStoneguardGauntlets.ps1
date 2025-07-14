using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEGUARDGAUNTLETS
#
###############################################################################

Class BEStoneguardGauntlets : BEGauntlets {
	BEStoneguardGauntlets() : base() {
		$this.Name               = 'Stoneguard Gauntlets'
		$this.MapObjName         = 'stoneguardgauntlets'
		$this.PurchasePrice      = 670
		$this.SellPrice          = 335
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets reinforced with elemental earth, sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
