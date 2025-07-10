using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFANATICGREAVES
#
###############################################################################

Class BEFanaticGreaves : BEGreaves {
	BEFanaticGreaves() : base() {
		$this.Name               = 'Fanatic Greaves'
		$this.MapObjName         = 'fanaticgreaves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of extreme fervor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
