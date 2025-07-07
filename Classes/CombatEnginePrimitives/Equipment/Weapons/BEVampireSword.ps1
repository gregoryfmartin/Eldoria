using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VAMPIRE SWORD
#
###############################################################################

Class BEVampireSword : BEWeapon {
	BEVampireSword() : base() {
		$this.Name          = 'Vampire Sword'
		$this.MapObjName    = 'vampiresword'
		$this.PurchasePrice = 950
		$this.SellPrice     = 475
		$this.TargetStats   = @{
			[StatId]::Attack      = 48
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that siphons health from enemies with each strike.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
