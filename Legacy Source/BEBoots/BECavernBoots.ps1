using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECAVERNBOOTS
#
###############################################################################

Class BECavernBoots : BEBoots {
	BECavernBoots() : base() {
		$this.Name               = 'Cavern Boots'
		$this.MapObjName         = 'cavernboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for damp cave environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
