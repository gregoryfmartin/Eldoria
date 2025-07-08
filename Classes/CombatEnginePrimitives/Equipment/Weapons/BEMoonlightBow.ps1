using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MOONLIGHT BOW
#
###############################################################################

Class BEMoonlightBow : BEWeapon {
	BEMoonlightBow() : base() {
		$this.Name          = 'Moonlight Bow'
		$this.MapObjName    = 'moonlightbow'
		$this.PurchasePrice = 1180
		$this.SellPrice     = 590
		$this.TargetStats   = @{
			[StatId]::Attack      = 60
			[StatId]::MagicAttack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that glows softly, guiding arrows even in darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
