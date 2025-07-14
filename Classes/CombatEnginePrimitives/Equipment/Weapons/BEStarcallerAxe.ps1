using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARCALLERAXE
#
###############################################################################

Class BEStarcallerAxe : BEWeapon {
	BEStarcallerAxe() : base() {
		$this.Name          = 'Starcaller Axe'
		$this.MapObjName    = 'starcalleraxe'
		$this.PurchasePrice = 6300
		$this.SellPrice     = 3150
		$this.TargetStats   = @{
			[StatId]::Attack      = 150
			[StatId]::MagicAttack = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that when swung creates small, sparkling constellations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
