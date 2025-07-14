using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEONYXCLAWGAUNTLETSII
#
###############################################################################

Class BEOnyxClawGauntletsII : BEGauntlets {
	BEOnyxClawGauntletsII() : base() {
		$this.Name               = 'Onyx Claw Gauntlets II'
		$this.MapObjName         = 'onyxclawgauntletsii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Onyx Claw Gauntlets, for deeper piercing attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
