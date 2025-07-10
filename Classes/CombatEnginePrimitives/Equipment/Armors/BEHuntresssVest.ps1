using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTRESSSVEST
#
###############################################################################

Class BEHuntresssVest : BEArmor {
	BEHuntresssVest() : base() {
		$this.Name               = 'Huntress''s Vest'
		$this.MapObjName         = 'huntresssvest'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged vest designed for female hunters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
