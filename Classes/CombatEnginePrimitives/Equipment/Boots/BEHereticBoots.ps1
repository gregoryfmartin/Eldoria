using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHERETICBOOTS
#
###############################################################################

Class BEHereticBoots : BEBoots {
	BEHereticBoots() : base() {
		$this.Name               = 'Heretic Boots'
		$this.MapObjName         = 'hereticboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of those who defy dogma.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
