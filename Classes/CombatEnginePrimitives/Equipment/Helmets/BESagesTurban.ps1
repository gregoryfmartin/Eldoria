using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAGESTURBAN
#
###############################################################################

Class BESagesTurban : BEHelmet {
	BESagesTurban() : base() {
		$this.Name               = 'Sage''s Turban'
		$this.MapObjName         = 'sagesturban'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wise turban worn by sages, imbued with ancient knowledge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
