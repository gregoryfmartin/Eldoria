using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDSOULGAUNTLETS
#
###############################################################################

Class BEEmeraldSoulGauntlets : BEGauntlets {
	BEEmeraldSoulGauntlets() : base() {
		$this.Name               = 'Emerald Soul Gauntlets'
		$this.MapObjName         = 'emeraldsoulgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets pulsating with emerald energy, enhancing vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
