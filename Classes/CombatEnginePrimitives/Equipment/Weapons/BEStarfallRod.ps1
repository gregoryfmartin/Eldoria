using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STARFALL ROD
#
###############################################################################

Class BEStarfallRod : BEWeapon {
	BEStarfallRod() : base() {
		$this.Name          = 'Starfall Rod'
		$this.MapObjName    = 'starfallrod'
		$this.PurchasePrice = 4700
		$this.SellPrice     = 2350
		$this.TargetStats   = @{
			[StatId]::Attack      = 25
			[StatId]::MagicAttack = 130
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod that can call down meteors from the sky.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
