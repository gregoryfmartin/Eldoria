using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDIANSGRIP
#
###############################################################################

Class BEGuardiansGrip : BEGauntlets {
	BEGuardiansGrip() : base() {
		$this.Name               = 'Guardian''s Grip'
		$this.MapObjName         = 'guardiansgrip'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 36
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A firm grip for protecting others.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
