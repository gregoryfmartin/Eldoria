using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPEGASUSGREAVES
#
###############################################################################

Class BEPegasusGreaves : BEGreaves {
	BEPegasusGreaves() : base() {
		$this.Name               = 'Pegasus Greaves'
		$this.MapObjName         = 'pegasusgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 20
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that feel weightless.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
