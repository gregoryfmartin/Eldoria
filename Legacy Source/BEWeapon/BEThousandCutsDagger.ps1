using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHOUSANDCUTSDAGGER
#
###############################################################################

Class BEThousandCutsDagger : BEWeapon {
	BEThousandCutsDagger() : base() {
		$this.Name          = 'Thousand Cuts Dagger'
		$this.MapObjName    = 'thousandcutsdagger'
		$this.PurchasePrice = 5300
		$this.SellPrice     = 2650
		$this.TargetStats   = @{
			[StatId]::Attack      = 120
			[StatId]::MagicAttack = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger so sharp it feels like a thousand blades at once.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
