using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDSPLATE
#
###############################################################################

Class BEWarlordsPlate : BEArmor {
	BEWarlordsPlate() : base() {
		$this.Name               = 'Warlord''s Plate'
		$this.MapObjName         = 'warlordsplate'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The battle-hardened plate armor of a seasoned warlord.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
