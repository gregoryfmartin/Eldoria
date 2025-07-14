using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEOFSPEEDHELM
#
###############################################################################

Class BERuneofSpeedHelm : BEHelmet {
	BERuneofSpeedHelm() : base() {
		$this.Name               = 'Rune of Speed Helm'
		$this.MapObjName         = 'runeofspeedhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of speed, increasing agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
