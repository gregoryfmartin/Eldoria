using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBANDITSJERKIN
#
###############################################################################

Class BEBanditsJerkin : BEArmor {
	BEBanditsJerkin() : base() {
		$this.Name               = 'Bandit''s Jerkin'
		$this.MapObjName         = 'banditsjerkin'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A patched-up jerkin, good for mobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
