using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONKINGGAUNTLETS
#
###############################################################################

Class BEDragonKingGauntlets : BEGauntlets {
	BEDragonKingGauntlets() : base() {
		$this.Name               = 'Dragon King Gauntlets'
		$this.MapObjName         = 'dragonkinggauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets fit for a true dragon king, absolute power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
