using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMFORGEDAXE
#
###############################################################################

Class BEStormforgedAxe : BEWeapon {
	BEStormforgedAxe() : base() {
		$this.Name          = 'Stormforged Axe'
		$this.MapObjName    = 'stormforgedaxe'
		$this.PurchasePrice = 6100
		$this.SellPrice     = 3050
		$this.TargetStats   = @{
			[StatId]::Attack      = 150
			[StatId]::MagicAttack = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe crackling with electricity, capable of calling down lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
