using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDELVERBOOTS
#
###############################################################################

Class BEDelverBoots : BEBoots {
	BEDelverBoots() : base() {
		$this.Name               = 'Delver Boots'
		$this.MapObjName         = 'delverboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for exploring subterranean depths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
