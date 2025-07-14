using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITWALKERHANDGUARDS
#
###############################################################################

Class BESpiritwalkerHandguards : BEGauntlets {
	BESpiritwalkerHandguards() : base() {
		$this.Name               = 'Spiritwalker Handguards'
		$this.MapObjName         = 'spiritwalkerhandguards'
		$this.PurchasePrice      = 540
		$this.SellPrice          = 270
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards aiding those who commune with spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
