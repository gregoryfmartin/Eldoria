using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZOOLOGISTBOOTS
#
###############################################################################

Class BEZoologistBoots : BEBoots {
	BEZoologistBoots() : base() {
		$this.Name               = 'Zoologist Boots'
		$this.MapObjName         = 'zoologistboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for animal researchers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
