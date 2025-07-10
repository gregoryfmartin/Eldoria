using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBERSERKERBOOTS
#
###############################################################################

Class BEBerserkerBoots : BEBoots {
	BEBerserkerBoots() : base() {
		$this.Name               = 'Berserker Boots'
		$this.MapObjName         = 'berserkerboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who fight with unrestrained fury.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
