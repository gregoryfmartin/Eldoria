using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONBOOTS
#
###############################################################################

Class BEIronBoots : BEBoots {
	BEIronBoots() : base() {
		$this.Name               = 'Iron Boots'
		$this.MapObjName         = 'ironboots'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Common iron boots, robust and reliable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
