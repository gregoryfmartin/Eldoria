using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONGUARDGAUNTLETSII
#
###############################################################################

Class BECrimsonGuardGauntletsII : BEGauntlets {
	BECrimsonGuardGauntletsII() : base() {
		$this.Name               = 'Crimson Guard Gauntlets II'
		$this.MapObjName         = 'crimsonguardgauntletsii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Superior Crimson Guard Gauntlets, even more ferocious.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
