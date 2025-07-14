using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUBTERRANEANGREAVES
#
###############################################################################

Class BESubterraneanGreaves : BEGreaves {
	BESubterraneanGreaves() : base() {
		$this.Name               = 'Subterranean Greaves'
		$this.MapObjName         = 'subterraneangreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for underground travel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
