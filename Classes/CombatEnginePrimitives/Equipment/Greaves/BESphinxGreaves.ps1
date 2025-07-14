using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPHINXGREAVES
#
###############################################################################

Class BESphinxGreaves : BEGreaves {
	BESphinxGreaves() : base() {
		$this.Name               = 'Sphinx Greaves'
		$this.MapObjName         = 'sphinxgreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of ancient wisdom and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
