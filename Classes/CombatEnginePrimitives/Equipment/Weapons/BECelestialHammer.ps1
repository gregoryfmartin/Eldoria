using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALHAMMER
#
###############################################################################

Class BECelestialHammer : BEWeapon {
	BECelestialHammer() : base() {
		$this.Name          = 'Celestial Hammer'
		$this.MapObjName    = 'celestialhammer'
		$this.PurchasePrice = 6600
		$this.SellPrice     = 3300
		$this.TargetStats   = @{
			[StatId]::Attack      = 160
			[StatId]::MagicAttack = 80
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hammer made from celestial ore, glowing with soft light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
