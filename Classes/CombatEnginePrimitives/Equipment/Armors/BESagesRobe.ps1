using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAGESROBE
#
###############################################################################

Class BESagesRobe : BEArmor {
	BESagesRobe() : base() {
		$this.Name               = 'Sage''s Robe'
		$this.MapObjName         = 'sagesrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple yet powerful robe, worn by wise mystics.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
