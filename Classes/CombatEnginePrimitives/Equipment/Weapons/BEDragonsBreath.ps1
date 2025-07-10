using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSBREATH
#
###############################################################################

Class BEDragonsBreath : BEWeapon {
	BEDragonsBreath() : base() {
		$this.Name          = 'Dragon''s Breath'
		$this.MapObjName    = 'dragonsbreath'
		$this.PurchasePrice = 980
		$this.SellPrice     = 490
		$this.TargetStats   = @{
			[StatId]::Attack      = 50
			[StatId]::MagicAttack = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A short, fiery weapon that can unleash a burst of flames.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
