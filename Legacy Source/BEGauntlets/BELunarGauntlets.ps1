using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELUNARGAUNTLETS
#
###############################################################################

Class BELunarGauntlets : BEGauntlets {
	BELunarGauntlets() : base() {
		$this.Name               = 'Lunar Gauntlets'
		$this.MapObjName         = 'lunargauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 28
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that glow with soft moonlight, enhancing stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
