using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAVENGERGREAVES
#
###############################################################################

Class BEAvengerGreaves : BEGreaves {
	BEAvengerGreaves() : base() {
		$this.Name               = 'Avenger Greaves'
		$this.MapObjName         = 'avengergreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of righteous vengeance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
