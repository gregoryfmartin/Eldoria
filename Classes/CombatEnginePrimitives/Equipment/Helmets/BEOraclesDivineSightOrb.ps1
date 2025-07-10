using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLESDIVINESIGHTORB
#
###############################################################################

Class BEOraclesDivineSightOrb : BEHelmet {
	BEOraclesDivineSightOrb() : base() {
		$this.Name               = 'Oracle''s Divine Sight Orb'
		$this.MapObjName         = 'oraclesdivinesightorb'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An orb integrated into a helm, granting omniscient vision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
