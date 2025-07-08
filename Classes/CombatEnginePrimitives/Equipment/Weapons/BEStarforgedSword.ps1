using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STARFORGED SWORD
#
###############################################################################

Class BEStarforgedSword : BEWeapon {
	BEStarforgedSword() : base() {
		$this.Name          = 'Starforged Sword'
		$this.MapObjName    = 'starforgedsword'
		$this.PurchasePrice = 6100
		$this.SellPrice     = 3050
		$this.TargetStats   = @{
			[StatId]::Attack      = 145
			[StatId]::MagicAttack = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword forged from a fallen star, shimmering with cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
