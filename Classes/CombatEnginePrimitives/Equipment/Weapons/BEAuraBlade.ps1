using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAURABLADE
#
###############################################################################

Class BEAuraBlade : BEWeapon {
	BEAuraBlade() : base() {
		$this.Name          = 'Aura Blade'
		$this.MapObjName    = 'aurablade'
		$this.PurchasePrice = 4400
		$this.SellPrice     = 2200
		$this.TargetStats   = @{
			[StatId]::Attack      = 108
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that projects a protective aura, reducing incoming damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
