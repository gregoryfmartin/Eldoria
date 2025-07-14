using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONLORDGREAVES
#
###############################################################################

Class BEDragonlordGreaves : BEGreaves {
	BEDragonlordGreaves() : base() {
		$this.Name               = 'Dragonlord Greaves'
		$this.MapObjName         = 'dragonlordgreaves'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by a dragonlord.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
