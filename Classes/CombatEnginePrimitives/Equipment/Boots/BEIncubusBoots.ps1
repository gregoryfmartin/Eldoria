using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINCUBUSBOOTS
#
###############################################################################

Class BEIncubusBoots : BEBoots {
	BEIncubusBoots() : base() {
		$this.Name               = 'Incubus Boots'
		$this.MapObjName         = 'incubusboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a charming demon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
