using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHERUBGREAVES
#
###############################################################################

Class BECherubGreaves : BEGreaves {
	BECherubGreaves() : base() {
		$this.Name               = 'Cherub Greaves'
		$this.MapObjName         = 'cherubgreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 40
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and protective greaves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
