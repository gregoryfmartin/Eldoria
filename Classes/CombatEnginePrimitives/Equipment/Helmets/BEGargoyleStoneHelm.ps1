using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GARGOYLE STONE HELM
#
###############################################################################

Class BEGargoyleStoneHelm : BEHelmet {
	BEGargoyleStoneHelm() : base() {
		$this.Name               = 'Gargoyle Stone Helm'
		$this.MapObjName         = 'gargoylestonehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm carved from gargoyle stone, offering resistance to physical damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
