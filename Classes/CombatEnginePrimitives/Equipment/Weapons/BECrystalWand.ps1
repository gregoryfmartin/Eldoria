using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CRYSTAL WAND
#
###############################################################################

Class BECrystalWand : BEWeapon {
	BECrystalWand() : base() {
		$this.Name          = 'Crystal Wand'
		$this.MapObjName    = 'crystalwand'
		$this.PurchasePrice = 700
		$this.SellPrice     = 350
		$this.TargetStats   = @{
			[StatId]::Attack      = 10
			[StatId]::MagicAttack = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wand made of pure crystal, focusing magical energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
