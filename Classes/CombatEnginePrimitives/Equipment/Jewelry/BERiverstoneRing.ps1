using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERIVERSTONERING
#
###############################################################################

Class BERiverstoneRing : BEJewelry {
	BERiverstoneRing() : base() {
		$this.Name               = 'Riverstone Ring'
		$this.MapObjName         = 'riverstonering'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A smooth riverstone ring, providing calm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
