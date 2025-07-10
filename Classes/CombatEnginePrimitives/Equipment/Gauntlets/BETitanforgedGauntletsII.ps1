using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANFORGEDGAUNTLETSII
#
###############################################################################

Class BETitanforgedGauntletsII : BEGauntlets {
	BETitanforgedGauntletsII() : base() {
		$this.Name               = 'Titanforged Gauntlets II'
		$this.MapObjName         = 'titanforgedgauntletsii'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 120
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Even more massive Titanforged Gauntlets, immense and heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
