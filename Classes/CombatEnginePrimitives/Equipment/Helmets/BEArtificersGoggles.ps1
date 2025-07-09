using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ARTIFICER'S GOGGLES
#
###############################################################################

Class BEArtificersGoggles : BEHelmet {
	BEArtificersGoggles() : base() {
		$this.Name               = 'Artificer''s Goggles'
		$this.MapObjName         = 'artificersgoggles'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles designed for artificers, enhancing their crafting precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
