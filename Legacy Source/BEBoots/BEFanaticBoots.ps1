using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFANATICBOOTS
#
###############################################################################

Class BEFanaticBoots : BEBoots {
	BEFanaticBoots() : base() {
		$this.Name               = 'Fanatic Boots'
		$this.MapObjName         = 'fanaticboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of extreme fervor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
