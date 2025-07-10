using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMHANDGUARDS
#
###############################################################################

Class BEGolemHandguards : BEGauntlets {
	BEGolemHandguards() : base() {
		$this.Name               = 'Golem Handguards'
		$this.MapObjName         = 'golemhandguards'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards of an ancient golem, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
