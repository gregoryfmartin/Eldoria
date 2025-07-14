using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUBTERRANEANBOOTS
#
###############################################################################

Class BESubterraneanBoots : BEBoots {
	BESubterraneanBoots() : base() {
		$this.Name               = 'Subterranean Boots'
		$this.MapObjName         = 'subterraneanboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for underground travel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
