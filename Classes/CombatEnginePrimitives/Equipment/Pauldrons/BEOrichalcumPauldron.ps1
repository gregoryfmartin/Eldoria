using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORICHALCUMPAULDRON
#
###############################################################################

Class BEOrichalcumPauldron : BEPauldron {
	BEOrichalcumPauldron() : base() {
		$this.Name               = 'Orichalcum Pauldron'
		$this.MapObjName         = 'orichalcumpauldron'
		$this.PurchasePrice      = 6450
		$this.SellPrice          = 3225
		$this.TargetStats        = @{
			[StatId]::Defense = 129
			[StatId]::MagicDefense = 51
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mythical metal, offering incredible magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
