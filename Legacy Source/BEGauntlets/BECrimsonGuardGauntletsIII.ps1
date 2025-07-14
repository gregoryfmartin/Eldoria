using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONGUARDGAUNTLETSIII
#
###############################################################################

Class BECrimsonGuardGauntletsIII : BEGauntlets {
	BECrimsonGuardGauntletsIII() : base() {
		$this.Name               = 'Crimson Guard Gauntlets III'
		$this.MapObjName         = 'crimsonguardgauntletsiii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crimson Guard Gauntlets of unparalleled ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
