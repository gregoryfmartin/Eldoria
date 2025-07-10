using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOCEANSCEPTER
#
###############################################################################

Class BEOceanScepter : BEWeapon {
	BEOceanScepter() : base() {
		$this.Name          = 'Ocean Scepter'
		$this.MapObjName    = 'oceanscepter'
		$this.PurchasePrice = 900
		$this.SellPrice     = 450
		$this.TargetStats   = @{
			[StatId]::Attack      = 12
			[StatId]::MagicAttack = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter that can control water, summoning tidal waves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
