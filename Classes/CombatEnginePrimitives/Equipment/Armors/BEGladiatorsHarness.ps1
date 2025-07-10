using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLADIATORSHARNESS
#
###############################################################################

Class BEGladiatorsHarness : BEArmor {
	BEGladiatorsHarness() : base() {
		$this.Name               = 'Gladiator''s Harness'
		$this.MapObjName         = 'gladiatorsharness'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A minimal but tough harness designed for arena combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
