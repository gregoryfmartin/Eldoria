using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRONOMERGREAVES
#
###############################################################################

Class BEAstronomerGreaves : BEGreaves {
	BEAstronomerGreaves() : base() {
		$this.Name               = 'Astronomer Greaves'
		$this.MapObjName         = 'astronomergreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for star gazers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
