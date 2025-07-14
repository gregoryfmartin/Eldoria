using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUARRYMANBOOTS
#
###############################################################################

Class BEQuarrymanBoots : BEBoots {
	BEQuarrymanBoots() : base() {
		$this.Name               = 'Quarryman Boots'
		$this.MapObjName         = 'quarrymanboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for stone extraction.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
