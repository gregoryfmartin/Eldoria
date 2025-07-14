using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALSCEPTER
#
###############################################################################

Class BEAstralScepter : BEWeapon {
	BEAstralScepter() : base() {
		$this.Name          = 'Astral Scepter'
		$this.MapObjName    = 'astralscepter'
		$this.PurchasePrice = 6100
		$this.SellPrice     = 3050
		$this.TargetStats   = @{
			[StatId]::Attack      = 40
			[StatId]::MagicAttack = 170
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter that can project astral forms, distracting enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
