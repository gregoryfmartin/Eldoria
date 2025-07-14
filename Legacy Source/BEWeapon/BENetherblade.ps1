using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENETHERBLADE
#
###############################################################################

Class BENetherblade : BEWeapon {
	BENetherblade() : base() {
		$this.Name          = 'Netherblade'
		$this.MapObjName    = 'netherblade'
		$this.PurchasePrice = 6700
		$this.SellPrice     = 3350
		$this.TargetStats   = @{
			[StatId]::Attack      = 160
			[StatId]::MagicAttack = 85
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword forged in the nether, dealing immense fire and shadow damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
