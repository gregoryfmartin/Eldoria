using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEALERSANKH
#
###############################################################################

Class BEHealersAnkh : BEJewelry {
	BEHealersAnkh() : base() {
		$this.Name               = 'Healer''s Ankh'
		$this.MapObjName         = 'healersankh'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An ankh symbol, for rapid recovery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
