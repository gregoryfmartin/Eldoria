using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREBELGREAVES
#
###############################################################################

Class BERebelGreaves : BEGreaves {
	BERebelGreaves() : base() {
		$this.Name               = 'Rebel Greaves'
		$this.MapObjName         = 'rebelgreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 15
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of resistance fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
