using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTITEGAUNTLETS
#
###############################################################################

Class BEAdamantiteGauntlets : BEGauntlets {
	BEAdamantiteGauntlets() : base() {
		$this.Name               = 'Adamantite Gauntlets'
		$this.MapObjName         = 'adamantitegauntlets'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of the hardest known metal, virtually unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
