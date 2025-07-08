using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE HEARTWOOD STAFF
#
###############################################################################

Class BEHeartwoodStaff : BEWeapon {
	BEHeartwoodStaff() : base() {
		$this.Name          = 'Heartwood Staff'
		$this.MapObjName    = 'heartwoodstaff'
		$this.PurchasePrice = 6500
		$this.SellPrice     = 3250
		$this.TargetStats   = @{
			[StatId]::Attack      = 48
			[StatId]::MagicAttack = 185
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff carved from the heart of a living tree, deeply connected to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
