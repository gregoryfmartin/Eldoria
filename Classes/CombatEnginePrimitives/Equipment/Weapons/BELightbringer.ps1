using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LIGHTBRINGER
#
###############################################################################

Class BELightbringer : BEWeapon {
	BELightbringer() : base() {
		$this.Name          = 'Lightbringer'
		$this.MapObjName    = 'lightbringer'
		$this.PurchasePrice = 1050
		$this.SellPrice     = 525
		$this.TargetStats   = @{
			[StatId]::Attack      = 55
			[StatId]::MagicAttack = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that glows with holy light, banishing darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
