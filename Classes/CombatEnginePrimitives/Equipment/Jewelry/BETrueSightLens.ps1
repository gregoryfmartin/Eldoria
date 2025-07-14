using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRUESIGHTLENS
#
###############################################################################

Class BETrueSightLens : BEJewelry {
	BETrueSightLens() : base() {
		$this.Name               = 'True Sight Lens'
		$this.MapObjName         = 'truesightlens'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Accuracy = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A monocle that allows the wearer to see hidden things.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
