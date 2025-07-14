using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELVENGREAVES
#
###############################################################################

Class BEElvenGreaves : BEGreaves {
	BEElvenGreaves() : base() {
		$this.Name               = 'Elven Greaves'
		$this.MapObjName         = 'elvengreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 25
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Graceful greaves favored by elves, light and protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
