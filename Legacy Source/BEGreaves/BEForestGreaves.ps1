using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORESTGREAVES
#
###############################################################################

Class BEForestGreaves : BEGreaves {
	BEForestGreaves() : base() {
		$this.Name               = 'Forest Greaves'
		$this.MapObjName         = 'forestgreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 15
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that blend with natural surroundings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
