using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIALBLADE
#
###############################################################################

Class BEGlacialBlade : BEWeapon {
	BEGlacialBlade() : base() {
		$this.Name          = 'Glacial Blade'
		$this.MapObjName    = 'glacialblade'
		$this.PurchasePrice = 4100
		$this.SellPrice     = 2050
		$this.TargetStats   = @{
			[StatId]::Attack      = 100
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that emanates freezing cold, slowing and chilling enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
