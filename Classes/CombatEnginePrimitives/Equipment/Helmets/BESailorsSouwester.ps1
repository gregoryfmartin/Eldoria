using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SAILOR'S SOUWESTER
#
###############################################################################

Class BESailorsSouwester : BEHelmet {
	BESailorsSouwester() : base() {
		$this.Name               = 'Sailor''s Sou''wester'
		$this.MapObjName         = 'sailorssouwester'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A waterproof hat worn by sailors, protecting from spray and rain.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
