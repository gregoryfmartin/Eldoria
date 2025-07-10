using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARDENSVEST
#
###############################################################################

Class BEWardensVest : BEArmor {
	BEWardensVest() : base() {
		$this.Name               = 'Warden''s Vest'
		$this.MapObjName         = 'wardensvest'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robust vest for patrolling guards, with good defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
