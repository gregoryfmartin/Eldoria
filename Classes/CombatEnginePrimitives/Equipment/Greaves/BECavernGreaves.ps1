using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECAVERNGREAVES
#
###############################################################################

Class BECavernGreaves : BEGreaves {
	BECavernGreaves() : base() {
		$this.Name               = 'Cavern Greaves'
		$this.MapObjName         = 'caverngreaves'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for damp cave environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
