using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALCOMPASS
#
###############################################################################

Class BEAstralCompass : BEJewelry {
	BEAstralCompass() : base() {
		$this.Name               = 'Astral Compass'
		$this.MapObjName         = 'astralcompass'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A compass that points to different astral planes.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
