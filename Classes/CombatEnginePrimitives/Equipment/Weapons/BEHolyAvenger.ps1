using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE HOLY AVENGER
#
###############################################################################

Class BEHolyAvenger : BEWeapon {
	BEHolyAvenger() : base() {
		$this.Name          = 'Holy Avenger'
		$this.MapObjName    = 'holyavenger'
		$this.PurchasePrice = 4100
		$this.SellPrice     = 2050
		$this.TargetStats   = @{
			[StatId]::Attack      = 100
			[StatId]::MagicAttack = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that blazes with holy light, dealing extra damage to undead and demons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
