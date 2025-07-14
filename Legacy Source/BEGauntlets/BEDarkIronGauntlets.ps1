using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDARKIRONGAUNTLETS
#
###############################################################################

Class BEDarkIronGauntlets : BEGauntlets {
	BEDarkIronGauntlets() : base() {
		$this.Name               = 'Dark Iron Gauntlets'
		$this.MapObjName         = 'darkirongauntlets'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged from dark iron, ominous and powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
