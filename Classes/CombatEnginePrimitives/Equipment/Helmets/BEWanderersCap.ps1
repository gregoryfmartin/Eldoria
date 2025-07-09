using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WANDERER'S CAP
#
###############################################################################

Class BEWanderersCap : BEHelmet {
	BEWanderersCap() : base() {
		$this.Name               = 'Wanderer''s Cap'
		$this.MapObjName         = 'wandererscap'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cap for a long journey, providing comfort and minor protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
