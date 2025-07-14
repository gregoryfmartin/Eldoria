using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONGUARDGAUNTLETS
#
###############################################################################

Class BECrimsonGuardGauntlets : BEGauntlets {
	BECrimsonGuardGauntlets() : base() {
		$this.Name               = 'Crimson Guard Gauntlets'
		$this.MapObjName         = 'crimsonguardgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a crimson guard, stained by many battles.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
