using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMCATCHERSTAFF
#
###############################################################################

Class BEDreamcatcherStaff : BEWeapon {
	BEDreamcatcherStaff() : base() {
		$this.Name          = 'Dreamcatcher Staff'
		$this.MapObjName    = 'dreamcatcherstaff'
		$this.PurchasePrice = 3700
		$this.SellPrice     = 1850
		$this.TargetStats   = @{
			[StatId]::Attack      = 10
			[StatId]::MagicAttack = 85
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can put enemies into a deep sleep or manipulate their dreams.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
