using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUBYRING
#
###############################################################################

Class BERubyRing : BEJewelry {
	BERubyRing() : base() {
		$this.Name               = 'Ruby Ring'
		$this.MapObjName         = 'rubyring'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gold ring set with a sparkling ruby.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
