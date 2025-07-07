using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FROST AXE
#
###############################################################################

Class BEFrostAxe : BEWeapon {
	BEFrostAxe() : base() {
		$this.Name          = 'Frost Axe'
		$this.MapObjName    = 'frostaxe'
		$this.PurchasePrice = 900
		$this.SellPrice     = 450
		$this.TargetStats   = @{
			[StatId]::Attack      = 53
			[StatId]::MagicAttack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that emanates a chilling aura, slowing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
