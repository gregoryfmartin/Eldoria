using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUNEBLADE
#
###############################################################################

Class BERuneblade : BEWeapon {
	BERuneblade() : base() {
		$this.Name          = 'Runeblade'
		$this.MapObjName    = 'runeblade'
		$this.PurchasePrice = 3800
		$this.SellPrice     = 1900
		$this.TargetStats   = @{
			[StatId]::Attack      = 90
			[StatId]::MagicAttack = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword inscribed with powerful runes, dealing elemental damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
