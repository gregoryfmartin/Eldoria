using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTINELPAULDRON
#
###############################################################################

Class BESentinelPauldron : BEPauldron {
	BESentinelPauldron() : base() {
		$this.Name               = 'Sentinel Pauldron'
		$this.MapObjName         = 'sentinelpauldron'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for vigilant guardians, offering superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
