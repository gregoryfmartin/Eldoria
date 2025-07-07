using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LEATHER GLOVES
#
###############################################################################

Class BELeatherGloves : BEWeapon {
	BELeatherGloves() : base() {
		$this.Name          = 'Leather Gloves'
		$this.MapObjName    = 'leathergloves'
		$this.PurchasePrice = 60
		$this.SellPrice     = 30
		$this.TargetStats   = @{
			[StatId]::Attack = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves reinforced with leather, can be used for fisticuffs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
