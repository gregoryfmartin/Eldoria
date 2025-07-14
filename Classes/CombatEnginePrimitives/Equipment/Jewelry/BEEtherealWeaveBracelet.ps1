using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETHEREALWEAVEBRACELET
#
###############################################################################

Class BEEtherealWeaveBracelet : BEJewelry {
	BEEtherealWeaveBracelet() : base() {
		$this.Name               = 'Ethereal Weave Bracelet'
		$this.MapObjName         = 'etherealweavebracelet'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet woven from ethereal threads, making the wearer less corporeal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
