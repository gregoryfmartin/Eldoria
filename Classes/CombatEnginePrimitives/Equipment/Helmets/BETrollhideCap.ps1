using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETROLLHIDECAP
#
###############################################################################

Class BETrollhideCap : BEHelmet {
	BETrollhideCap() : base() {
		$this.Name               = 'Trollhide Cap'
		$this.MapObjName         = 'trollhidecap'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick cap made from troll hide, offering good regeneration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
