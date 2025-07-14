using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEROICGREAVES
#
###############################################################################

Class BEHeroicGreaves : BEGreaves {
	BEHeroicGreaves() : base() {
		$this.Name               = 'Heroic Greaves'
		$this.MapObjName         = 'heroicgreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by legendary heroes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
