using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWRITERSINKWELLCHARM
#
###############################################################################

Class BEWritersInkwellCharm : BEJewelry {
	BEWritersInkwellCharm() : base() {
		$this.Name               = 'Writer''s Inkwell Charm'
		$this.MapObjName         = 'writersinkwellcharm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like an inkwell, for inspiration.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
