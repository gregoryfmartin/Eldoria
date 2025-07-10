using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECABALGREAVES
#
###############################################################################

Class BECabalGreaves : BEGreaves {
	BECabalGreaves() : base() {
		$this.Name               = 'Cabal Greaves'
		$this.MapObjName         = 'cabalgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a secret magical society.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
