using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALTOUCHGLOVES
#
###############################################################################

Class BECelestialTouchGloves : BEGauntlets {
	BECelestialTouchGloves() : base() {
		$this.Name               = 'Celestial Touch Gloves'
		$this.MapObjName         = 'celestialtouchgloves'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that feel like a gentle touch from the heavens.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
