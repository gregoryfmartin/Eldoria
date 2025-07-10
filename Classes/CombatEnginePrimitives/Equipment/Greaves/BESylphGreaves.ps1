using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESYLPHGREAVES
#
###############################################################################

Class BESylphGreaves : BEGreaves {
	BESylphGreaves() : base() {
		$this.Name               = 'Sylph Greaves'
		$this.MapObjName         = 'sylphgreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 20
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light greaves of an air spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
