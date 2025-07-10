using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROSESILKROBE
#
###############################################################################

Class BERoseSilkRobe : BEArmor {
	BERoseSilkRobe() : base() {
		$this.Name               = 'Rose Silk Robe'
		$this.MapObjName         = 'rosesilkrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate pink silk robe, often worn by charming mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
