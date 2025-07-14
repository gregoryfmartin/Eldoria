using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLACKHOLECORE
#
###############################################################################

Class BEBlackHoleCore : BEJewelry {
	BEBlackHoleCore() : base() {
		$this.Name               = 'Black Hole Core'
		$this.MapObjName         = 'blackholecore'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 5
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny, dense core that draws in surrounding energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
