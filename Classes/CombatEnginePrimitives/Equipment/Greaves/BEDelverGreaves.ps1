using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDELVERGREAVES
#
###############################################################################

Class BEDelverGreaves : BEGreaves {
	BEDelverGreaves() : base() {
		$this.Name               = 'Delver Greaves'
		$this.MapObjName         = 'delvergreaves'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for exploring subterranean depths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
