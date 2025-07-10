using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIMPLEWAND
#
###############################################################################

Class BESimpleWand : BEWeapon {
	BESimpleWand() : base() {
		$this.Name          = 'Simple Wand'
		$this.MapObjName    = 'simplewand'
		$this.PurchasePrice = 150
		$this.SellPrice     = 75
		$this.TargetStats   = @{
			[StatId]::Attack      = 3
			[StatId]::MagicAttack = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic wand for casting simple spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
