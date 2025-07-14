using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALSOULGAUNTLETS
#
###############################################################################

Class BECrystalSoulGauntlets : BEGauntlets {
	BECrystalSoulGauntlets() : base() {
		$this.Name               = 'Crystal Soul Gauntlets'
		$this.MapObjName         = 'crystalsoulgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with a small crystal, reflecting magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
