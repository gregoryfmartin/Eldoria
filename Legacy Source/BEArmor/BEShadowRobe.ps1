using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWROBE
#
###############################################################################

Class BEShadowRobe : BEArmor {
	BEShadowRobe() : base() {
		$this.Name               = 'Shadow Robe'
		$this.MapObjName         = 'shadowrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that allows the wearer to blend into shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
