using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE HAMMER OF THE ANCIENTS
#
###############################################################################

Class BEHammerOfTheAncients : BEWeapon {
	BEHammerOfTheAncients() : base() {
		$this.Name          = 'Hammer of the Ancients'
		$this.MapObjName    = 'hammeroftheancients'
		$this.PurchasePrice = 6700
		$this.SellPrice     = 3350
		$this.TargetStats   = @{
			[StatId]::Attack      = 175
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A prehistoric hammer of immense power, vibrating with ancient magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
