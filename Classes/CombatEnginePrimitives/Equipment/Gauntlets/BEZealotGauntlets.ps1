using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTGAUNTLETS
#
###############################################################################

Class BEZealotGauntlets : BEGauntlets {
	BEZealotGauntlets() : base() {
		$this.Name               = 'Zealot Gauntlets'
		$this.MapObjName         = 'zealotgauntlets'
		$this.PurchasePrice      = 1020
		$this.SellPrice          = 510
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ornately decorated gauntlets, inspiring divine fury.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
