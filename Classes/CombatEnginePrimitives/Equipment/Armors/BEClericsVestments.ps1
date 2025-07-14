using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLERICSVESTMENTS
#
###############################################################################

Class BEClericsVestments : BEArmor {
	BEClericsVestments() : base() {
		$this.Name               = 'Cleric''s Vestments'
		$this.MapObjName         = 'clericsvestments'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed vestments providing spiritual protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
