using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELDRITCHBANDS
#
###############################################################################

Class BEEldritchBands : BEGauntlets {
	BEEldritchBands() : base() {
		$this.Name               = 'Eldritch Bands'
		$this.MapObjName         = 'eldritchbands'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands pulsing with otherworldly energy, dangerous yet powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
