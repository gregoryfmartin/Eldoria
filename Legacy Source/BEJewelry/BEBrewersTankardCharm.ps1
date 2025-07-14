using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBREWERSTANKARDCHARM
#
###############################################################################

Class BEBrewersTankardCharm : BEJewelry {
	BEBrewersTankardCharm() : base() {
		$this.Name               = 'Brewer''s Tankard Charm'
		$this.MapObjName         = 'brewerstankardcharm'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a miniature tankard, for hearty drinks.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}
