using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEONYXCLAWGAUNTLETS
#
###############################################################################

Class BEOnyxClawGauntlets : BEGauntlets {
	BEOnyxClawGauntlets() : base() {
		$this.Name               = 'Onyx Claw Gauntlets'
		$this.MapObjName         = 'onyxclawgauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with sharp onyx claws, for piercing attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
