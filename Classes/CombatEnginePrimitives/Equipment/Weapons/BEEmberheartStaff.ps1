using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE EMBERHEART STAFF
#
###############################################################################

Class BEEmberheartStaff : BEWeapon {
	BEEmberheartStaff() : base() {
		$this.Name          = 'Emberheart Staff'
		$this.MapObjName    = 'emberheartstaff'
		$this.PurchasePrice = 5600
		$this.SellPrice     = 2800
		$this.TargetStats   = @{
			[StatId]::Attack      = 30
			[StatId]::MagicAttack = 140
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff containing a burning ember, radiating warmth and minor fire magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
