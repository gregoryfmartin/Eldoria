using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ABYSSAL BLADE
#
###############################################################################

Class BEAbyssalBlade : BEWeapon {
	BEAbyssalBlade() : base() {
		$this.Name          = 'Abyssal Blade'
		$this.MapObjName    = 'abyssalblade'
		$this.PurchasePrice = 4500
		$this.SellPrice     = 2250
		$this.TargetStats   = @{
			[StatId]::Attack      = 110
			[StatId]::MagicAttack = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword from the depths of the abyss, dealing dark damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
