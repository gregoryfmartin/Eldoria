using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRONOMERSTELESCOPE
#
###############################################################################

Class BEAstronomersTelescope : BEJewelry {
	BEAstronomersTelescope() : base() {
		$this.Name               = 'Astronomer''s Telescope'
		$this.MapObjName         = 'astronomerstelescope'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny telescope that reveals distant stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
