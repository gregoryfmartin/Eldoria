using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECORRUPTEDGREAVES
#
###############################################################################

Class BECorruptedGreaves : BEGreaves {
	BECorruptedGreaves() : base() {
		$this.Name               = 'Corrupted Greaves'
		$this.MapObjName         = 'corruptedgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves twisted by dark forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
