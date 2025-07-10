using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLERICSDIVINESYMBOL
#
###############################################################################

Class BEClericsDivineSymbol : BEJewelry {
	BEClericsDivineSymbol() : base() {
		$this.Name               = 'Cleric''s Divine Symbol'
		$this.MapObjName         = 'clericsdivinesymbol'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, glowing divine symbol.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
