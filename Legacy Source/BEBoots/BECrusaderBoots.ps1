using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRUSADERBOOTS
#
###############################################################################

Class BECrusaderBoots : BEBoots {
	BECrusaderBoots() : base() {
		$this.Name               = 'Crusader Boots'
		$this.MapObjName         = 'crusaderboots'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a holy warrior on a quest.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
