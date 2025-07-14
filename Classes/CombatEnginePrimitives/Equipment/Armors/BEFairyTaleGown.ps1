using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFAIRYTALEGOWN
#
###############################################################################

Class BEFairyTaleGown : BEArmor {
	BEFairyTaleGown() : base() {
		$this.Name               = 'Fairy Tale Gown'
		$this.MapObjName         = 'fairytalegown'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whimsical gown that offers a slight magic boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
