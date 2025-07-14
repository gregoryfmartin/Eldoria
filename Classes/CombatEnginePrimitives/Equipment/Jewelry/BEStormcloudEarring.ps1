using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMCLOUDEARRING
#
###############################################################################

Class BEStormcloudEarring : BEJewelry {
	BEStormcloudEarring() : base() {
		$this.Name               = 'Stormcloud Earring'
		$this.MapObjName         = 'stormcloudearring'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring that crackles with faint static electricity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
