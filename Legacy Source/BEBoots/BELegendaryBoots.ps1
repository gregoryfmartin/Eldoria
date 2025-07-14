using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEGENDARYBOOTS
#
###############################################################################

Class BELegendaryBoots : BEBoots {
	BELegendaryBoots() : base() {
		$this.Name               = 'Legendary Boots'
		$this.MapObjName         = 'legendaryboots'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots spoken of in ancient tales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
