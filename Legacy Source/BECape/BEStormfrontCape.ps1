using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMFRONTCAPE
#
###############################################################################

Class BEStormfrontCape : BECape {
	BEStormfrontCape() : base() {
		$this.Name               = 'Stormfront Cape'
		$this.MapObjName         = 'stormfrontcape'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that crackles with faint static, hinting at elemental power.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
