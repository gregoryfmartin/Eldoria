using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE APPRENTICE WAND
#
###############################################################################

Class BEApprenticeWand : BEWeapon {
	BEApprenticeWand() : base() {
		$this.Name          = 'Apprentice Wand'
		$this.MapObjName    = 'apprenticewand'
		$this.PurchasePrice = 110
		$this.SellPrice     = 55
		$this.TargetStats   = @{
			[StatId]::Attack      = 2
			[StatId]::MagicAttack = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic wand for novice spellcasters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
