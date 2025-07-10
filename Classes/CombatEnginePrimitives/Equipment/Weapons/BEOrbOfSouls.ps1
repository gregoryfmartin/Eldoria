using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORBOFSOULS
#
###############################################################################

Class BEOrbofSouls : BEWeapon {
	BEOrbofSouls() : base() {
		$this.Name          = 'Orb of Souls'
		$this.MapObjName    = 'orbofsouls'
		$this.PurchasePrice = 3600
		$this.SellPrice     = 1800
		$this.TargetStats   = @{
			[StatId]::Attack      = 10
			[StatId]::MagicAttack = 90
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An orb that can summon spirits to aid in battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
