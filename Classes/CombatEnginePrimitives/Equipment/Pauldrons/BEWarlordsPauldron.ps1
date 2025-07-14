using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDSPAULDRON
#
###############################################################################

Class BEWarlordsPauldron : BEPauldron {
	BEWarlordsPauldron() : base() {
		$this.Name               = 'Warlord''s Pauldron'
		$this.MapObjName         = 'warlordspauldron'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and menacing, favored by fierce military leaders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
