using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENAVIGATORSSEXTANTCHARM
#
###############################################################################

Class BENavigatorsSextantCharm : BEJewelry {
	BENavigatorsSextantCharm() : base() {
		$this.Name               = 'Navigator''s Sextant Charm'
		$this.MapObjName         = 'navigatorssextantcharm'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a miniature sextant, for guidance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
