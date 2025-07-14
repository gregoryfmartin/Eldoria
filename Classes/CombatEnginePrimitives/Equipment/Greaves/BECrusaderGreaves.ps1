using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRUSADERGREAVES
#
###############################################################################

Class BECrusaderGreaves : BEGreaves {
	BECrusaderGreaves() : base() {
		$this.Name               = 'Crusader Greaves'
		$this.MapObjName         = 'crusadergreaves'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a holy warrior on a quest.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
