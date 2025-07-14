using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTBITEAXE
#
###############################################################################

Class BEFrostbiteAxe : BEWeapon {
	BEFrostbiteAxe() : base() {
		$this.Name          = 'Frostbite Axe'
		$this.MapObjName    = 'frostbiteaxe'
		$this.PurchasePrice = 6400
		$this.SellPrice     = 3200
		$this.TargetStats   = @{
			[StatId]::Attack      = 153
			[StatId]::MagicAttack = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that inflicts severe frostbite, slowing enemies to a crawl.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
