using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMSHEADPIECE
#
###############################################################################

Class BEGolemsHeadpiece : BEHelmet {
	BEGolemsHeadpiece() : base() {
		$this.Name               = 'Golem''s Headpiece'
		$this.MapObjName         = 'golemsheadpiece'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy headpiece made from golem fragments, offering immense durability.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
