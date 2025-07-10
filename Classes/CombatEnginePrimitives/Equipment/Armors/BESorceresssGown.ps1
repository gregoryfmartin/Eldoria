using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERESSSGOWN
#
###############################################################################

Class BESorceresssGown : BEArmor {
	BESorceresssGown() : base() {
		$this.Name               = 'Sorceress''s Gown'
		$this.MapObjName         = 'sorceresssgown'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A darkly elegant gown, enhancing destructive spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
