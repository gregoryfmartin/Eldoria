using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLESCIRCLET
#
###############################################################################

Class BEOraclesCirclet : BEHelmet {
	BEOraclesCirclet() : base() {
		$this.Name               = 'Oracle''s Circlet'
		$this.MapObjName         = 'oraclescirclet'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering circlet worn by oracles, granting glimpses of the future.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
