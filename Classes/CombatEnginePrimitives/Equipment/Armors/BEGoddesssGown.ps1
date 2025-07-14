using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGODDESSSGOWN
#
###############################################################################

Class BEGoddesssGown : BEArmor {
	BEGoddesssGown() : base() {
		$this.Name               = 'Goddess''s Gown'
		$this.MapObjName         = 'goddesssgown'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant gown said to be blessed by a deity, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
