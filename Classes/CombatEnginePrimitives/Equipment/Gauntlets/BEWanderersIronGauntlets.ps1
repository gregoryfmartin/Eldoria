using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWANDERERSIRONGAUNTLETS
#
###############################################################################

Class BEWanderersIronGauntlets : BEGauntlets {
	BEWanderersIronGauntlets() : base() {
		$this.Name               = 'Wanderer''s Iron Gauntlets'
		$this.MapObjName         = 'wanderersirongauntlets'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Iron gauntlets for a seasoned wanderer, robust and practical.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
