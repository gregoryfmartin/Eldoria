using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHIMERAHIDEVEST
#
###############################################################################

Class BEChimeraHideVest : BEArmor {
	BEChimeraHideVest() : base() {
		$this.Name               = 'Chimera Hide Vest'
		$this.MapObjName         = 'chimerahidevest'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the hides of various monstrous creatures, granting varied resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
