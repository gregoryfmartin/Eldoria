using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPALADINSVOWRING
#
###############################################################################

Class BEPaladinsVowRing : BEJewelry {
	BEPaladinsVowRing() : base() {
		$this.Name               = 'Paladin''s Vow Ring'
		$this.MapObjName         = 'paladinsvowring'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that glows faintly, symbolizing a holy vow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
