using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRAVEKEEPERSLANTERNHELM
#
###############################################################################

Class BEGravekeepersLanternHelm : BEHelmet {
	BEGravekeepersLanternHelm() : base() {
		$this.Name               = 'Gravekeeper''s Lantern Helm'
		$this.MapObjName         = 'gravekeeperslanternhelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an integrated lantern, aiding gravekeepers at night.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
