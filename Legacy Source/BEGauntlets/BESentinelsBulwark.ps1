using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTINELSBULWARK
#
###############################################################################

Class BESentinelsBulwark : BEGauntlets {
	BESentinelsBulwark() : base() {
		$this.Name               = 'Sentinel''s Bulwark'
		$this.MapObjName         = 'sentinelsbulwark'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to project a defensive aura.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
