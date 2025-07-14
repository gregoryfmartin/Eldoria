using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORGEDSTEELGAUNTLETS
#
###############################################################################

Class BEForgedSteelGauntlets : BEGauntlets {
	BEForgedSteelGauntlets() : base() {
		$this.Name               = 'Forged Steel Gauntlets'
		$this.MapObjName         = 'forgedsteelgauntlets'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Expertly forged steel gauntlets, balanced for battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
